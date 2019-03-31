//
//  FWLiveServiceController.m
//  FanweLive
//
//  Created by xfg on 16/11/23.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "FWLiveServiceController.h"
#import "FWMD5UTils.h"

#define MESSAGE_SURVIVAL_TIME           20
#define BARRAGE_VIEW_ANIMATE_TIME       10

@interface FWLiveServiceController ()

@end

@implementation FWLiveServiceController

#pragma mark ------------------------ 直播生命周期 -----------------------
- (void)releaseAll
{
    _liveController = nil;
    
    _addGiftRunLoopRef = nil;
    _getGiftRunLoopRef = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if (_giftLoopTimer)
    {
        [_giftLoopTimer invalidate];
        _giftLoopTimer = nil;
    }
    if (_heartTimer)
    {
        [_heartTimer invalidate];
        _heartTimer = nil;
    }
    
    // 关闭竞拍相关的定时器
    [self.auctionTool closeTimer];
    
    self.rechargeView.viewController = nil;
}

- (void)dealloc
{
    [self releaseAll];
}

#pragma mark 开始直播
- (void)startLive
{
    [_liveUIViewController startLive];
}

#pragma mark 暂停直播
- (void)pauseLive
{
    if (_heartTimer)
    {
        [_heartTimer invalidate];
        _heartTimer = nil;
    }
    
    if (_giftLoopTimer)
    {
        [_giftLoopTimer invalidate];
        _giftLoopTimer = nil;
    }
    
    [_liveUIViewController pauseLive];
}

#pragma mark 重新开始直播
- (void)resumeLive
{
    if (_isHost)
    {
        [self startLiveTimer];
    }
    [self biginGiftLoop];
    [_liveUIViewController resumeLive];
}

#pragma mark 重新加载直播间的游戏数据
- (void)reloadGame
{
    _liveUIViewController.liveView.shouldReloadGame = YES;
    _liveUIViewController.liveView.sureOnceGame = NO;
    [self reloadGameData];
}

#pragma mark 结束直播
- (void)endLive
{
    [self releaseAll];
    
    [_liveUIViewController endLive];
    [_liveUIViewController.view removeFromSuperview];
}

#pragma mark 初始化房间信息等
- (instancetype)initWith:(id<FWShowLiveRoomAble>)liveItem liveController:(id<FWLiveControllerAble>)liveController
{
    if (self = [super init])
    {
        _liveItem = liveItem;
        
        _roomIDStr = StringFromInt([_liveItem liveAVRoomId]);
        _isHost = [liveItem isHost];
        _liveController = liveController;
        
        _liveUIViewController = [[FWLiveUIViewController alloc] initWith:_liveItem liveController:liveController];
        _liveUIViewController.serviceDelegate = self;
        [self addChild:_liveUIViewController inRect:self.view.bounds];
        [self.view bringSubviewToFront:_closeBtn];
        
        _liveUIViewController.liveView.serveceDelegate = self;
        _liveUIViewController.liveView.topView.toServicedelegate = self;
        _liveUIViewController.liveView.msgView.delegate = self;
        
        _iMMsgHandler = [FWIMMsgHandler sharedInstance];
        _iMMsgHandler.iMMsgListener = self;
        
        // 创建插件中心
        if (_isHost)
        {
            [self creatPluginCenter];
        }
    }
    return self;
}

#pragma mark 请求完接口后，刷新直播间相关信息
- (void)refreshLiveItem:(id<FWShowLiveRoomAble>)liveItem liveInfo:(CurrentLiveInfo *)liveInfo
{
    _liveItem = liveItem;
    
    _roomIDStr = StringFromInt([_liveItem liveAVRoomId]);
    _isHost = [liveItem isHost];
    
    [_liveUIViewController refreshLiveItem:_liveItem liveInfo:liveInfo];
    
    [self setupFinishView:liveInfo];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = kClearColor;
}

#pragma mark 初始化变量
- (void)initFWVariables
{
    [super initFWVariables];
    
    // 礼物相关
    // 为了不影响视频，runloop线程优先级较低，可根据自身需要去调整
    _addGiftRunLoopRef = [AddGiftRunLoop sharedAddGiftRunLoop];
    _getGiftRunLoopRef = [GetGiftRunLoop sharedGetGiftRunLoop];
    
    _gifAnimateArray = [NSMutableArray array];
    _giftMessageMArray = [NSMutableArray array];
    _giftMessageMDict = [NSMutableDictionary dictionary];
    _giftMessageViewMArray = [NSMutableArray array];
    _otherRoomBitGiftArray = [NSMutableArray array];
    
    [self loadGiftView:[GiftListManager sharedInstance].giftMArray];
    [self performSelector:@selector(biginGiftLoop) onThread:_getGiftRunLoopRef.thread withObject:_giftMessageMArray waitUntilDone:NO];
    
    // 弹幕消息视图队列
    _barrageViewArray = [[NSMutableArray alloc] init];
    // 高级别观众进入视图队列
    _aETViewArray = [[NSMutableArray alloc] init];
}

#pragma mark UI创建
- (void)initFWUI
{
    [super initFWUI];
    
    _closeBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _closeBtn.frame = CGRectMake(kScreenW-kDefaultMargin-kLogoContainerViewHeight, kStatusBarHeight+kDefaultMargin/2, kLogoContainerViewHeight, kLogoContainerViewHeight);
    _closeBtn.backgroundColor = [UIColor clearColor];
    [_closeBtn setBackgroundImage:[UIImage imageNamed:@"lr_top_close"] forState:UIControlStateNormal];
    [_closeBtn addTarget:self action:@selector(onClickClose:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_closeBtn];
    
    _anchorLeaveTipLabel = [[UILabel alloc]initWithFrame:CGRectMake(kDefaultMargin, (kScreenH-35)/3, kScreenW-kDefaultMargin*2, 35)];
    _anchorLeaveTipLabel.textColor = [UIColor whiteColor];
    _anchorLeaveTipLabel.text = @"主播暂时离开下，马上回来！";
    _anchorLeaveTipLabel.font = [UIFont systemFontOfSize:15.0];
    _anchorLeaveTipLabel.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    _anchorLeaveTipLabel.shadowOffset = CGSizeMake(1, 1);
    _anchorLeaveTipLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_anchorLeaveTipLabel];
    _anchorLeaveTipLabel.hidden = YES;
    
    // 高级别观众进入提示动画页面
    _aETView = [[AudienceEnteringTipView alloc]initWithMyFrame:CGRectMake(-kScreenW, kAudienceEnteringTipViewHeight, kScreenW, 35)];
    [_liveUIViewController.liveView addSubview:_aETView];
    _aETView.hidden = YES;
}

#pragma mark 加载数据
- (void)initFWData
{
    [super initFWData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadGame) name:UIApplicationWillEnterForegroundNotification object:nil];
    // 是否显示关注
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(isShowFollow:) name:@"liveIsShowFollow" object:nil];
    // 今日任务完成关闭每日任务
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeEverydayTask) name:@"closeEverydayTask" object:nil];
}


#pragma mark - ----------------------- 非SDK业务逻辑 -----------------------
#pragma mark 开启主播心跳监听定时器
- (void)startLiveTimer
{
    if (_heartTimer)
    {
        [_heartTimer invalidate];
        _heartTimer = nil;
    }
    
    NSInteger monitorSecond = 0;
    if (self.fanweApp.appModel.monitor_second)
    {
        monitorSecond = self.fanweApp.appModel.monitor_second;
    }
    else
    {
        monitorSecond = 5;
    }
    _heartTimer = [NSTimer scheduledTimerWithTimeInterval:monitorSecond target:self selector:@selector(onPostHeartBeat) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_heartTimer forMode:NSRunLoopCommonModes];
}

#pragma mark 主播心跳监听
- (void)onPostHeartBeat
{
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    [mDict setObject:@"video" forKey:@"ctl"];
    [mDict setObject:@"monitor" forKey:@"act"];
    [mDict setObject:_roomIDStr forKey:@"room_id"];
    [mDict setObject:@"-1" forKey:@"watch_number"]; //观看人数
    [mDict setObject:[NSString stringWithFormat:@"%ld",(long)_voteNumber] forKey:@"vote_number"]; //主播当前印票
    
    if ([_liveItem liveType] == FW_LIVE_TYPE_HOST)
    {
        [mDict setObject:[_liveController getLiveQuality] forKey:@"live_quality"];
    }
    
    FWWeakify(self)
    [self.httpsManager POSTWithParameters:mDict SuccessBlock:^(NSDictionary *responseJson){
        FWStrongify(self)
        if ([responseJson toInt:@"status"] == 1)
        {
            if ([responseJson objectForKey:@"live"])
            {
                if (self.liveUIViewController.livePay.hostLeftPView.threeLabel)
                {
                   [self.liveUIViewController.livePay.hostLeftPView addThreeLabWithStr:[NSString stringWithFormat:@"直播间付费人数:%d",[[responseJson objectForKey:@"live"] toInt:@"live_viewer"]]];
                }else
                {
                    if (self.liveUIViewController.livePay.hostLeftPView.secondLabel)
                    {
                       [self.liveUIViewController.livePay.hostLeftPView addSecondLabWithStr:[NSString stringWithFormat:@"直播间付费人数:%d",[[responseJson objectForKey:@"live"] toInt:@"live_viewer"]]];
                    }
                }
                [self.liveUIViewController.liveView.topView refreshTicketCount:[NSString stringWithFormat:@"%d",[[responseJson objectForKey:@"live"] toInt:@"ticket"]]];
                
                if ([[responseJson objectForKey:@"live"] toInt:@"allow_mention"] == 1 || [[responseJson objectForKey:@"live"] toInt:@"allow_live_pay"] == 1)
                {
                    [self.liveUIViewController createPayLiveView:responseJson];
                }
            }
        }
        
    } FailureBlock:^(NSError *error) {
        
    }];
}

#pragma mark 主播进入房间状态回调
- (void)getVideoState:(NSMutableDictionary *)parmMDict
{
    [self.httpsManager POSTWithParameters:parmMDict SuccessBlock:^(NSDictionary *responseJson){
        
    } FailureBlock:^(NSError *error) {
        
    }];
}

#pragma mark 进入直播室成功后的相关业务：获得视频信息
- (void)getVideo:(FWLiveGetVideoCompletion)succ failed:(FWErrorBlock)failed
{
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    [mDict setObject:@"video" forKey:@"ctl"];
    [mDict setObject:@"get_video2" forKey:@"act"];
    NSString *MD5String = [NSString stringWithFormat:@"%@%@%@",TXYSdkAppId,[[IMAPlatform sharedInstance].host imUserId],_roomIDStr];
    if (![FWUtils isBlankString:MD5String])
    {
        [mDict setObject:[NSString stringWithFormat:@"%@",[FWMD5UTils getmd5WithString:MD5String]] forKey:@"sign"];
    }
    
    if ([_liveItem liveType] == FW_LIVE_TYPE_RELIVE)
    {
        [mDict setObject:@"1" forKey:@"is_vod"]; // 0:观看直播;1:点播
    }
    else
    {
        [mDict setObject:@"0" forKey:@"is_vod"]; // 0:观看直播;1:点播
    }
    if (!_privateKeyString.length)
    {
        if ([UIPasteboard generalPasteboard].string.length)
        {
            if ([[[UIPasteboard generalPasteboard].string componentsSeparatedByString:[GTMBase64 decodeBase64:@"8J+UkQ=="]] count] > 1)
            {
                _privateKeyString = [[[UIPasteboard generalPasteboard].string componentsSeparatedByString:[GTMBase64 decodeBase64:@"8J+UkQ=="]] objectAtIndex:1];
            }
        }
    }
    
    if (_privateKeyString.length)
    {
        [mDict setObject:_privateKeyString forKey:@"private_key"];
        [UIPasteboard generalPasteboard].string = @"";
    }
    
    if (![FWUtils isBlankString:_roomIDStr])
    {
        [mDict setObject:_roomIDStr forKey:@"room_id"];
        
        FWWeakify(self)
        [self.httpsManager POSTWithParameters:mDict SuccessBlock:^(NSDictionary *responseJson){
            FWStrongify(self)
            // status: status=1表示抗议正常进入直播间,status=0表示不能正常进入直播间,status=2表示关闭直播间
            if ([responseJson toInt:@"status"] == 1)
            {
                self.currentLiveInfo = [CurrentLiveInfo mj_objectWithKeyValues:responseJson];
                
                [self getVideoSuccess:responseJson];
                
                if (succ)
                {
                    succ(self.currentLiveInfo);
                }
            }
            else if ([responseJson toInt:@"status"] == 2)
            {
                NSString *audienceTotalStr = [responseJson toString:@"show_num"];
                
                if (_isHost)
                {
                    [self showHostFinishView:audienceTotalStr andVote:@"" andHasDel:NO];
                }
                else
                {
                    CustomMessageModel *cmm = [[CustomMessageModel alloc] init];
                    cmm.showNum = [audienceTotalStr intValue];
                    [self showAudienceFinishView:cmm];
                }
                
                if (failed)
                {
                    failed(FWCode_Biz_Error, @"");
                }
            }
            else if ([responseJson toInt:@"status"] == 0)
            {
                if ([responseJson toInt:@"is_live_pay"] == 1)
                {
                    if (succ)
                    {
                        [self.liveUIViewController beginEnterPayLive:responseJson closeBtn:self.closeBtn];
                        self.currentLiveInfo = [CurrentLiveInfo mj_objectWithKeyValues:responseJson];
                        succ(self.currentLiveInfo);
                    }
                }
                else if([self.fanweApp.appModel.open_vip intValue] == 1)
                {
                    if ([responseJson toInt:@"is_vip"] == 1)
                    {
                        if (succ)
                        {
                            [self.liveUIViewController beginEnterPayLive:responseJson closeBtn:self.closeBtn];
                            self.currentLiveInfo = [CurrentLiveInfo mj_objectWithKeyValues:responseJson];
                            succ(self.currentLiveInfo);
                        }
                    }
                    else
                    {
                        if (failed)
                        {
                            failed(FWCode_Vip_Cancel, [responseJson toString:@"error"]);
                        }
                    }
                }
                else
                {
                    if (failed)
                    {
                        failed(FWCode_Biz_Error, [responseJson toString:@"error"]);
                    }
                }
            }
        } FailureBlock:^(NSError *error) {
            if (failed)
            {
                failed(FWCode_Net_Error, @"网络加载失败");
            }
        }];
    }
}

#pragma mark 请求get_video2接口成功处理
- (void)getVideoSuccess:(NSDictionary *)responseJson
{
    // 获取观众列表
    [self.liveUIViewController.liveView.topView refreshAudienceList:responseJson];
    
    // 用来判断是否在直播间内
    LiveState *liveState = [[LiveState alloc] init];
    liveState.roomId = StringFromInt([_liveItem liveAVRoomId]);
    liveState.liveHostId = [[_liveItem liveHost] imUserId];
    if ([[[IMAPlatform sharedInstance].host imUserId] isEqualToString:[[_liveItem liveHost] imUserId]])
    {
        liveState.isLiveHost = YES;
    }
    else
    {
        liveState.isLiveHost = NO;
    }
    self.fanweApp.liveState = liveState;
    
    // 直播间整体刷新
    TCShowLiveListItem *liveRoom = (TCShowLiveListItem *)_liveItem;
    if (self.currentLiveInfo.podcast.user)
    {
        TCShowUser *showUser = [[TCShowUser alloc]init];
        showUser.uid = self.currentLiveInfo.podcast.user.user_id;
        showUser.username = self.currentLiveInfo.podcast.user.nick_name;
        showUser.avatar = self.currentLiveInfo.podcast.user.head_image;
        liveRoom.host = showUser;
        
        _liveItem = liveRoom;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(refreshCurrentLiveItem:liveInfo:)])
    {
        [self.delegate refreshCurrentLiveItem:_liveItem liveInfo:self.currentLiveInfo];
    }
    
    // 该观众在当前直播间的排序权重
    [IMAPlatform sharedInstance].host.sort_num = [responseJson toString:@"sort_num"];
    
    // 竞拍
    if(self.currentLiveInfo.pai_id && self.currentLiveInfo.live_in == FW_LIVE_STATE_ING)
    {
        self.liveUIViewController.liveView.topView.priceView.hidden = NO;
        self.auctionTool.paiId = self.currentLiveInfo.pai_id;
        [self.auctionTool loadTimeData];
        [self changePayView:self.liveUIViewController.liveView];
    }
    
    if (!_isHost)
    {
        if ([responseJson toInt:@"open_daily_task"] == 1)//观众打开
        {
            self.liveUIViewController.liveView.closeLiveBtn.hidden = NO;
        }
        
        if (_currentLiveInfo.online_status == 1)
        {
            _anchorLeaveTipLabel.hidden = YES;
        }
        else if([_liveItem liveType] != FW_LIVE_TYPE_RELIVE && _currentLiveInfo.online_status == 0)
        {
            _anchorLeaveTipLabel.hidden = NO;
        }
    }
    [self.liveUIViewController beginEnterPayLive:responseJson closeBtn:self.closeBtn];
    _voteNumber = [_currentLiveInfo.podcast.user.ticket integerValue];
    
    [self changePayView:self.liveUIViewController.liveView];
    
    if (!_isHost && _currentLiveInfo.podcast.has_focus == 0 && ![[[IMAPlatform sharedInstance].host imUserId] isEqualToString:[[_liveItem liveHost] imUserId]])
    {
        _isFollowAnchor = NO;
    }
    else
    {
        _isFollowAnchor = YES;
    }
    
    _privateShareString = [responseJson toString:@"private_share"];
    
    // 开启直播时如果有开启分享直播就在此处延时调用
    [self performSelector:@selector(hostShareLive) withObject:nil afterDelay:2];
}

#pragma mark 主播退出直播间
- (void)hostExitLive:(FWVoidBlock)succ failed:(FWErrorBlock)failed
{
    if (![FWUtils isBlankString:_roomIDStr])
    {
        //直播结束
        NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
        [mDict setObject:@"video" forKey:@"ctl"];
        [mDict setObject:@"end_video" forKey:@"act"];
        [mDict setObject:_roomIDStr forKey:@"room_id"];
        
        FWWeakify(self)
        [self.httpsManager POSTWithParameters:mDict SuccessBlock:^(NSDictionary *responseJson) {
            
            FWStrongify(self)
            if ([responseJson toInt:@"status"] == 1)
            {
                [self.liveUIViewController.liveView hideInputView];
                
                NSString *watch_number = [responseJson toString:@"watch_number"];
                if ([FWUtils isBlankString:watch_number])
                {
                    watch_number = @"0";
                }
                
                NSString *vote_number = [responseJson toString:@"vote_number"];
                if ([FWUtils isBlankString:vote_number])
                {
                    vote_number = @"0";
                }
                
                [self showHostFinishView:watch_number andVote:vote_number andHasDel:[responseJson toInt:@"has_delvideo"]];
                
                if (succ)
                {
                    succ();
                }
            }
            else
            {
                [self showHostFinishView:@"" andVote:@"" andHasDel:[responseJson toInt:@"has_delvideo"]];
                
                if (succ)
                {
                    succ();
                }
            }
            
        } FailureBlock:^(NSError *error) {
            if (failed)
            {
                failed(FWCode_Net_Error, @"网络加载失败");
            }
        }];
    }
    else
    {
        if (failed)
        {
            failed(FWCode_Normal_Error, @"");
        }
    }
}

#pragma mark 业务上的"关闭"统一都调用这个，统一一个出口，防止出错
- (void)closeCurrentLive:(BOOL)isDirectCloseLive isHostShowAlert:(BOOL)isHostShowAlert
{
    if(_delegate && [_delegate respondsToSelector:@selector(clickCloseLive:isHostShowAlert:)])
    {
        [_delegate clickCloseLive:isDirectCloseLive isHostShowAlert:isHostShowAlert];
    }
}

#pragma mark 关闭操作
- (void)onClickClose:(id)sender
{
    if (self.auctionTool.paiTime >0)
    {
        [self.auctionTool onClickClose];
        return;
    }
    
    BOOL isDirectCloseLive;
    if (_isHost)
    {
        isDirectCloseLive = NO;
    }
    else
    {
        isDirectCloseLive = YES;
    }
    
    DebugLog(@"=================：真正的点击了关闭按钮");
    BOOL showAlert = YES;
    [self closeCurrentLive:isDirectCloseLive isHostShowAlert:showAlert];
}

#pragma mark 有竞拍时点击关闭按钮
- (void)closeRoom
{
    BOOL isDirectCloseLive;
    if (_isHost)
    {
        isDirectCloseLive = NO;
    }
    else
    {
        isDirectCloseLive = YES;
    }
    
    DebugLog(@"=================：竞拍时真正的点击了关闭按钮");
    [self closeCurrentLive:isDirectCloseLive isHostShowAlert:YES];
}

#pragma mark 收到MSG_END_VIDEO 处理，该消息一般是观众会收到
- (void)receiveEndMsg:(CustomMessageModel *)customMessageModel
{
    if (!_isHost)
    {
        DebugLog(@"=================：收到MSG_END_VIDEO 处理，该消息一般是观众会收到");
        [self closeCurrentLive:NO isHostShowAlert:NO];
        [self showAudienceFinishView:customMessageModel];
        [self releaseAll];
    }
}

#pragma mark 收到MSG_SYSTEM_CLOSE_LIVE 处理，该消息一般是主播会收到
- (void)receiveSystemCloseMsg:(CustomMessageModel *)customMessageModel
{
    BOOL isDirectCloseLive;
    if (_isHost)
    {
        isDirectCloseLive = NO;
    }
    else
    {
        isDirectCloseLive = YES;
    }
    
    DebugLog(@"=================：收到MSG_SYSTEM_CLOSE_LIVE 处理，该消息一般是主播会收到");
    [self closeCurrentLive:isDirectCloseLive isHostShowAlert:NO];
}


#pragma mark - ----------------------- IM消息处理 -----------------------
#pragma mark 收到自定义C2C消息
- (void)onIMHandler:(FWIMMsgHandler *)receiver recvCustomC2C:(id<AVIMMsgAble>)msg
{
    if (![msg isKindOfClass:[CustomMessageModel class]])
    {
        return;
    }
    if (_delegate && [_delegate respondsToSelector:@selector(recvCustomC2C:)])
    {
        [_delegate recvCustomC2C:msg];
    }
    
    CustomMessageModel *customMessageModel = (CustomMessageModel *)msg;
    switch (customMessageModel.type) {
        case MSG_SYSTEM_CLOSE_LIVE: // 17 违规直播，立即关闭直播；私密直播被主播踢出直播间
        {
            [self receiveSystemCloseMsg:customMessageModel];
        }
            break;
        case MSG_BACKGROUND_MONITORING://41:后台会员监控
        {
            [FanweMessage alert:customMessageModel.desc];
        }
            break;
        default:
            break;
    }
}

#pragma mark 收到自定义的Group消息
- (void)onIMHandler:(FWIMMsgHandler *)receiver recvCustomGroup:(id<AVIMMsgAble>)msg
{
    if (![msg isKindOfClass:[CustomMessageModel class]])
    {
        return;
    }
    
    CustomMessageModel *customMessageModel = (CustomMessageModel *)msg;
    
    if (![customMessageModel.chatGroupID isEqualToString:[_liveItem liveIMChatRoomId]])
    {
        if (customMessageModel.type == MSG_REFRESH_AUDIENCE_LIST)
        {
            [[TIMGroupManager sharedInstance] quitGroup:customMessageModel.chatGroupID succ:^{
                NSLog(@"退出群:%@ 成功",customMessageModel.chatGroupID);
            } fail:^(int code, NSString *msg) {
                NSLog(@"退出群:%@ 失败，错误码：%d，错误原因：%@",customMessageModel.chatGroupID,code,msg);
            }];
        }
        return;
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(recvCustomGroup:)])
    {
        [_delegate recvCustomGroup:customMessageModel];
    }
    
    switch (customMessageModel.type)
    {
        case MSG_NONE: //-1：无操作
            
            break;
        case MSG_TEXT: //0：正常文字聊天消息
            
            break;
            
        case MSG_SEND_GIFT_SUCCESS: //1：收到发送礼物成功消息
        {
            if (customMessageModel.total_ticket>_voteNumber)
            {
                _voteNumber = customMessageModel.total_ticket; //印票总数
            }
            
            [_liveUIViewController.liveView.topView refreshTicketCount:[NSString stringWithFormat:@"%ld",(long)_voteNumber]];
            
            //0：普通动画  1：gif动画  2：真实动画
            if (customMessageModel.is_animated == 0)
            {
                [self performSelector:@selector(addGiftMessage:) onThread:_addGiftRunLoopRef.thread withObject:customMessageModel waitUntilDone:NO];
            }
            else if (customMessageModel.is_animated == 1)
            {
                [_gifAnimateArray addObject:customMessageModel];
            }
            else if (customMessageModel.is_animated == 2)
            {
                [_gifAnimateArray addObject:customMessageModel];
            }
        }
            break;
        case MSG_POP_MSG://2：收到弹幕消息
        {
            if (customMessageModel.total_ticket>_voteNumber)
            {
                _voteNumber = customMessageModel.total_ticket; //印票总数
            }
            [_liveUIViewController.liveView.topView refreshTicketCount:[NSString stringWithFormat:@"%ld",(long)_voteNumber]];
            
            [_liveUIViewController.liveView.msgView insertMsg:msg];
            [self addBarrageMessage:customMessageModel];
        }
            break;
        case MSG_CREATER_EXIT_ROOM://3：主播退出直播间，暂未用到
        {
            
        }
            break;
        case MSG_FORBID_SEND_MSG://4：禁言消息
            [_liveUIViewController.liveView.msgView insertMsg:msg];
            break;
        case MSG_VIEWER_JOIN: //5：观众进入直播间消息
        {
            UserModel *userModel = [[UserModel alloc]init];
            userModel.user_id = customMessageModel.sender.user_id;
            userModel.nick_name = customMessageModel.sender.nick_name;
            userModel.head_image = customMessageModel.sender.head_image;
            userModel.user_level = [NSString stringWithFormat:@"%ld",(long)customMessageModel.sender.user_level];
            userModel.sort_num = customMessageModel.sender.sort_num;
            
            [_liveUIViewController.liveView.topView onImUsersEnterLive:userModel];
            
            [self audienceEnterAnimate:userModel];
        }
            break;
        case MSG_VIEWER_QUIT: //6：观众退出直播间消息
        {
            UserModel *userModel = [[UserModel alloc]init];
            userModel.user_id = customMessageModel.sender.user_id;
            userModel.nick_name = customMessageModel.sender.nick_name;
            userModel.head_image = customMessageModel.sender.head_image;
            userModel.user_level = [NSString stringWithFormat:@"%ld",(long)customMessageModel.sender.user_level];
            userModel.sort_num = customMessageModel.sender.sort_num;
            
            [_liveUIViewController.liveView.topView onImUsersExitLive:userModel];
        }
            break;
        case MSG_END_VIDEO: //7：直播结束消息
        {
            [self receiveEndMsg:customMessageModel];
        }
            break;
        case MSG_RED_PACKET: //8：红包
        {
            [_liveUIViewController.liveView.msgView insertMsg:msg];
            customMessageModel.delegate = self;
            [self addRedBagView:customMessageModel];
        }
            break;
        case MSG_LIVING_MESSAGE: //9：直播消息
            [_liveUIViewController.liveView.msgView insertMsg:msg];
            break;
        case MSG_ANCHOR_LEAVE: //10：主播离开
        {
            _anchorLeaveTipLabel.hidden = NO;
            [_liveUIViewController.liveView.msgView insertMsg:msg];
        }
            break;
        case MSG_ANCHOR_BACK: //11：主播回来
        {
            _anchorLeaveTipLabel.hidden = YES;
            [_liveUIViewController.liveView.msgView insertMsg:msg];
        }
            break;
        case MSG_LIGHT: //12：点亮
        {
            if (customMessageModel.showMsg == 1)
            {
                [_liveUIViewController.liveView.msgView insertMsg:msg];
            }
            
            [_liveUIViewController.liveView onRecvLight:customMessageModel.imageName];
        }
            break;
        case MSG_PAI_SUCCESS: //25：拍卖成功
        {
            [_liveUIViewController.liveView.msgView insertMsg:msg];
            [self.auctionTool paiSuccessWithCustomModel:customMessageModel];
        }
            break;
            
        case MSG_PAI_PAY_TIP: //26：推送支付提醒
        {
            [_liveUIViewController.liveView.msgView insertMsg:msg];
            [self.auctionTool paiTipWithCustomModel:customMessageModel];
        }
            break;
            
        case MSG_PAI_FAULT: //27：流拍
        {
            
            [_liveUIViewController.liveView.msgView insertMsg:msg];
            [self.auctionTool paiFaultWithCustomModel:customMessageModel];
        }
            break;
        case MSG_ADD_PRICE: //28:加价推送
        {
            [_liveUIViewController.liveView.msgView insertMsg:msg];
            
            [self.auctionTool paiAddPriceWithCustomModel:customMessageModel];
            
            [self performSelector:@selector(addGiftMessage:) onThread:_addGiftRunLoopRef.thread withObject:customMessageModel waitUntilDone:NO];
            
        }
            break;
        case MSG_PAY_SUCCESS : //29:支付成功
        {
            [_liveUIViewController.liveView.msgView insertMsg:msg];
            [self.auctionTool paySuccessWithCustomModel:customMessageModel];
            
        }
            break;
        case MSG_RELEASE_SUCCESS: //30:主播发起竞拍成功
        {
            
            [_liveUIViewController.liveView.msgView insertMsg:msg];
            [self.auctionTool paiReleaseSuccessWithCustomModel:customMessageModel];
        }
            break;
        case  MSG_STARGOODS_SUCCESS: //31:主播发起商品推送成功
        {
            if ([_liveUIViewController.liveView.liveInputView isInputViewActive])
            {
                [_liveUIViewController.liveView.liveInputView resignFirstResponder];
            }
            [_liveUIViewController.liveView.msgView insertMsg:msg];
            [self.auctionTool starGoodsSuccessWithCustomModel:customMessageModel];
        }
            break;
        case MSG_PAYMONEY_SUCCESS: //32:主播发起付费直播成功(按时间)
        {
            if (!_isHost)
            {
                [FWUtils closeKeyboard];
                [self.liveUIViewController getVedioViewWithType:1 closeBtn:_closeBtn];
            }
        }
            break;
        case  MSG_GAME_OVER: //34,//游戏结束推送
        {
            [_liveUIViewController.liveView gameOverWithCustomMessageModel:customMessageModel];
            _game_log_id = 0;
        }
            break;
        case MSG_BUYGOODS_SUCCESS : //37.购买商品成功推送
        {
            [_liveUIViewController.liveView.msgView insertMsg:msg];
            [self.auctionTool buyGoodsSuccessWithCustomModel:customMessageModel];
        }
            break;
        case  MSG_GAME_ALL: //39.游戏总的推送
        {
            [_liveUIViewController.liveView gameAllMessageWithCustomMessageModel:customMessageModel];
        }
            break;
        case MSG_PAYMONEYSEASON_SUCCESS : //40.主播发起付费直播成功(按场次)
        {
            if (!_isHost)
            {
                [FWUtils closeKeyboard];
                [self.liveUIViewController getVedioViewWithType:40 closeBtn:_closeBtn];
            }
        }
            break;
        case MSG_REFRESH_AUDIENCE_LIST: // 42 刷新观众列表
        {
            [_liveUIViewController.liveView.topView refreshLiveAudienceList:customMessageModel];
        }
            break;
        case MSG_GAME_BANKER: // 43 游戏上庄相关推送
        {
            [_liveUIViewController.liveView gameBankerMessageWithCustomMessageModel:customMessageModel];
        }
            break;
        case MSG_BIG_GIFT_NOTICE_ALL: // 50 直播间飞屏模式(送大型礼物-全服飞屏通告)
        {
            if (!_isHost)
            {
                [_otherRoomBitGiftArray addObject:customMessageModel];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - ----------------------- 礼物处理 -----------------------

#pragma mark 开始循环小礼物队列
- (void)biginGiftLoop
{
    _giftLoopTimer = [NSTimer scheduledTimerWithTimeInterval:kLiveMessageRefreshTime target:self selector:@selector(looperWork) userInfo:nil repeats:YES];
}

#pragma mark 添加一条新的礼物信息
- (void)addGiftMessage:(CustomMessageModel *)newMsg
{
    @synchronized (_giftMessageMArray)
    {
        if (newMsg)
        {
            NSMutableDictionary *msgKey = [FWLiveServiceViewModel getGiftMsgKey:newMsg];
            CustomMessageModel *oldMsg = [_giftMessageMDict objectForKey:msgKey];
            
            int showNum = 1;
            if (oldMsg && newMsg.is_plus == 1)
            {
                showNum = oldMsg.showNum + oldMsg.num;
                if (oldMsg.isTaked)
                {
                    [_giftMessageMArray removeObject:oldMsg];
                }
            }
            newMsg.showNum = showNum;
            [_giftMessageMArray addObject:newMsg];
            [_giftMessageMDict setObject:newMsg forKey:msgKey];
        }
    }
}

#pragma mark 刷新IM消息
- (void)onUIRefreshIMMsg:(AVIMCache *)cache
{
    [_liveUIViewController.liveView.msgView insertCachedMsg:cache];
}

#pragma mark 刷新点赞消息
- (void)onUIRefreshPraise:(AVIMCache *)cache
{
    [_liveUIViewController.liveView onRecvPraise:cache];
}

- (void)refreshIMMsgTableView
{
    NSDictionary *dic = [_iMMsgHandler getMsgCache];
    AVIMCache *msgcache = dic[kRoomTableViewMsgKey];
    [self onUIRefreshIMMsg:msgcache];
    
    AVIMCache *praisecache = dic[@(MSG_LIGHT)];
    [self onUIRefreshPraise:praisecache];
}

#pragma mark 循环礼物队列
- (void)looperWork
{
    [_iMMsgHandler onHandleMyNewMessage:50];
    
    __weak typeof(self) ws = self;
    if (_refreshIMMsgCount % 2 == 0)
    {
        //在主线程播放送文字缩小动画
        dispatch_async(dispatch_get_main_queue(), ^{
            [ws refreshIMMsgTableView];
        });
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_currentBigGiftState == 0 && [_gifAnimateArray count])
        {
            _currentBigGiftState = 1;
            [self playNextGiftAnimation];
        }
        
        if (_currentOtherRoomBigGiftState == 0 && [_otherRoomBitGiftArray count])
        {
            _currentOtherRoomBigGiftState = 1;
            [self playNextOhterRoomBigGiftAnimation];
        }
    });
    
    _refreshIMMsgCount ++;
    
    @synchronized (_giftMessageMArray)
    {
        for (SendGiftAnimateView *view in _giftMessageViewMArray)
        {
            if (!view.isPlaying || (view.isPlaying && view.isPlayingDeplay))
            {
                for (CustomMessageModel* giftElem in _giftMessageMArray)
                {
                    if (!giftElem.isTaked)
                    {
                        //如果本条msg还没有被播放过，遍历view列表，寻找是否已经有包含本条msg的view
                        SendGiftAnimateView *currentGiftMsgView;
                        for (SendGiftAnimateView *otherView in _giftMessageViewMArray)
                        {
                            if ([giftElem isEquals:otherView.customMessageModel])
                            {
                                currentGiftMsgView = otherView;
                                break;
                            }
                        }
                        
                        _sendGiftAnimateView1.frame = CGRectMake(kDefaultMargin, [self obtainGiftAnimateViewY:SmallGiftAnimateIndex_1], SEND_GIFT_ANIMATE_VIEW_WIDTH, SEND_GIFT_ANIMATE_VIEW_HEIGHT);
                        _sendGiftAnimateView2.frame = CGRectMake(kDefaultMargin, [self obtainGiftAnimateViewY:SmallGiftAnimateIndex_2], SEND_GIFT_ANIMATE_VIEW_WIDTH, SEND_GIFT_ANIMATE_VIEW_HEIGHT);
                        
                        if (currentGiftMsgView)
                        {
                            //如果找到包含本条msg的view
                            if (view != currentGiftMsgView)
                            {
                                //这个view不是自己，跳过此条信息
                                continue;
                            }
                            else
                            {
                                //如果这个view是自己
                                if (view.isPlaying && view.isPlayingDeplay)
                                {
                                    //在主线程播放送文字缩小动画
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        if (view == _sendGiftAnimateView1)
                                        {
                                            [_sendGiftAnimateView1 setContent:giftElem];
                                            BOOL canTxtFontChanging = [_sendGiftAnimateView1 txtFontAgain];
                                            if (canTxtFontChanging) {
                                                giftElem.isTaked = YES;
                                            }
                                        }
                                        else
                                        {
                                            [_sendGiftAnimateView2 setContent:giftElem];
                                            BOOL canTxtFontChanging = [_sendGiftAnimateView2 txtFontAgain];
                                            if (canTxtFontChanging)
                                            {
                                                giftElem.isTaked = YES;
                                            }
                                        }
                                        
                                    });
                                    break;
                                }
                                else
                                {
                                    //在主线程播放送礼物动画
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        if (view == _sendGiftAnimateView1)
                                        {
                                            [_sendGiftAnimateView1 setContent:giftElem];
                                            BOOL canshowGiftAnimate = [_sendGiftAnimateView1 showGiftAnimate];
                                            if (canshowGiftAnimate)
                                            {
                                                giftElem.isTaked = YES;
                                            }
                                        }
                                        else
                                        {
                                            [_sendGiftAnimateView2 setContent:giftElem];
                                            BOOL canshowGiftAnimate = [_sendGiftAnimateView2 showGiftAnimate];
                                            if (canshowGiftAnimate)
                                            {
                                                giftElem.isTaked = YES;
                                            }
                                        }
                                    });
                                    break;
                                }
                            }
                        }
                        else
                        {
                            //如果没找到包含本条msg的view
                            if (!view.isPlaying)
                            {
                                giftElem.isTaked = YES;
                                //在主线程播放送礼物动画
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    if (view == _sendGiftAnimateView1)
                                    {
                                        [_sendGiftAnimateView1 setContent:giftElem];
                                        [_sendGiftAnimateView1 showGiftAnimate];
                                    }
                                    else
                                    {
                                        [_sendGiftAnimateView2 setContent:giftElem];
                                        [_sendGiftAnimateView2 showGiftAnimate];
                                    }
                                });
                                break;
                            }
                        }
                    }
                    else
                    {
                        continue;
                    }
                }
            }
        }
    }
}


#pragma mark - ----------------------- 小礼物 -----------------------
#pragma mark 获取小礼物视图的Y值
- (CGFloat)obtainGiftAnimateViewY:(SmallGiftAnimateIndex)smallGiftAnimateindex
{
    if (smallGiftAnimateindex == SmallGiftAnimateIndex_1)
    {
        if (_liveUIViewController.liveView.goldFlowerView && _liveUIViewController.liveView.goldViewCanNotSee == NO)
        {
            return SEND_GIFT_ANIMATE_VIEW_Y_1-_liveUIViewController.liveView.goldFlowerViewHeiht+20;
        }
        else if (_liveUIViewController.liveView.guessSizeView && _liveUIViewController.liveView.guessSizeViewCanNotSee == NO)
        {
            return SEND_GIFT_ANIMATE_VIEW_Y_1-kGuessSizeViewHeight+20;
        }
        else
        {
            return SEND_GIFT_ANIMATE_VIEW_Y_1;
        }
    }
    else
    {
        if (_liveUIViewController.liveView.goldFlowerView && _liveUIViewController.liveView.goldViewCanNotSee == NO)
        {
            return SEND_GIFT_ANIMATE_VIEW_Y_2-_liveUIViewController.liveView.goldFlowerViewHeiht+20;
        }
        else if (_liveUIViewController.liveView.guessSizeView && _liveUIViewController.liveView.guessSizeViewCanNotSee == NO)
        {
            return SEND_GIFT_ANIMATE_VIEW_Y_2-kGuessSizeViewHeight+20;
        }
        else
        {
            return SEND_GIFT_ANIMATE_VIEW_Y_2;
        }
    }
}

#pragma mark 创建礼物视图及礼物动画视图
- (void)loadGiftView:(NSArray *)list
{
    _sendGiftAnimateView1 = [[SendGiftAnimateView alloc]initWithFrame:CGRectMake(kDefaultMargin, [self obtainGiftAnimateViewY:SmallGiftAnimateIndex_1], SEND_GIFT_ANIMATE_VIEW_WIDTH, SEND_GIFT_ANIMATE_VIEW_HEIGHT)];
    [_liveUIViewController.liveView addSubview:_sendGiftAnimateView1];
    
    __weak typeof(self) ws = self;
    [_sendGiftAnimateView1.headImgView setClickAction:^(id<MenuAbleItem> menu) {
        CustomMessageModel *customMessageModel = ws.sendGiftAnimateView1.customMessageModel;
        UserModel *userModel = [[UserModel alloc]init];
        if(customMessageModel.type==1)
        {
            userModel.user_id = customMessageModel.sender.user_id;
            userModel.nick_name = customMessageModel.sender.nick_name;
            userModel.head_image = customMessageModel.sender.head_image;
            userModel.user_level = [NSString stringWithFormat:@"%ld",(long)customMessageModel.sender.user_level];
        }
        else if (customMessageModel.type==28)
        {
            userModel.user_id = customMessageModel.user.user_id;
            userModel.nick_name = customMessageModel.user.nick_name;
            userModel.head_image = customMessageModel.user.head_image;
            userModel.user_level = [NSString stringWithFormat:@"%ld",(long)customMessageModel.user.user_level];
        }
        
        [ws getUserInfo:userModel];
    }];
    
    _sendGiftAnimateView2 = [[SendGiftAnimateView2 alloc]initWithFrame:CGRectMake(kDefaultMargin, [self obtainGiftAnimateViewY:SmallGiftAnimateIndex_2], SEND_GIFT_ANIMATE_VIEW_WIDTH, SEND_GIFT_ANIMATE_VIEW_HEIGHT)];
    [_liveUIViewController.liveView addSubview:_sendGiftAnimateView2];
    
    [_sendGiftAnimateView2.headImgView setClickAction:^(id<MenuAbleItem> menu) {
        CustomMessageModel *customMessageModel = ws.sendGiftAnimateView2.customMessageModel;
        UserModel *userModel = [[UserModel alloc]init];
        if(customMessageModel.type==1)
        {
            userModel.user_id = customMessageModel.sender.user_id;
            userModel.nick_name = customMessageModel.sender.nick_name;
            userModel.head_image = customMessageModel.sender.head_image;
            userModel.user_level = [NSString stringWithFormat:@"%ld",(long)customMessageModel.sender.user_level];
        }
        else if (customMessageModel.type==28)
        {
            userModel.user_id = customMessageModel.user.user_id;
            userModel.nick_name = customMessageModel.user.nick_name;
            userModel.head_image = customMessageModel.user.head_image;
            userModel.user_level = [NSString stringWithFormat:@"%ld",(long)customMessageModel.user.user_level];
        }
        
        [ws getUserInfo:userModel];
    }];
    
    [_giftMessageViewMArray addObject:_sendGiftAnimateView1];
    [_giftMessageViewMArray addObject:_sendGiftAnimateView2];
}


#pragma mark - ----------------------- 大型礼物动画、GIF动画 -----------------------
#pragma mark 开始gif动画
- (void)beginGifAnimate:(CustomMessageModel *)customMessageModel andSenderName:(NSString *)senderName
{
    if (customMessageModel.anim_cfg)
    {
        if ([customMessageModel.anim_cfg count])
        {
            NSArray *gifArray = customMessageModel.anim_cfg;
            for (AnimateConfigModel *animateConfigModel in gifArray)
            {
                GifImageView *gifImageView = [[GifImageView alloc]initWithModel:animateConfigModel inView:_liveUIViewController.liveView andSenderName:senderName];
                gifImageView.delegate = self;
            }
        }
        else
        {
            [_gifAnimateArray removeObjectAtIndex:0];
            _currentBigGiftState = 0;
        }
    }
    else
    {
        _currentBigGiftState = 0;
    }
}

#pragma mark GifImageView代理（GifImageViewDelegate）
- (void)gifImageViewFinish:(AnimateConfigModel *)animateConfigModel andSenderName:(NSString *)senderName
{
    if ([_gifAnimateArray count])
    {
        CustomMessageModel *customMessageModel = [_gifAnimateArray firstObject];
        NSArray *firstArray = customMessageModel.anim_cfg;
        NSInteger index = [firstArray count];
        for (int i=0; i<[firstArray count]; i++)
        {
            AnimateConfigModel *model = [firstArray objectAtIndex:i];
            if (model.Id == animateConfigModel.Id)
            {
                model.isFinishAnimate = YES;
            }
            if (model.isFinishAnimate)
            {
                index--;
            }
        }
        if (index == 0)
        {
            [_gifAnimateArray removeObjectAtIndex:0];
            _currentBigGiftState = 0;
        }
    }
}

#pragma mark Plane1Controller代理（Plane1ControllerDelegate）
- (void)plane1AnimationFinished
{
    [self removePlayAnimate:kPlane1Tag];
}

#pragma mark Plane2Controller代理（Plane2ControllerDelegate）
- (void)plane2AnimationFinished
{
    [self removePlayAnimate:kPlane2Tag];
}

#pragma mark FerrariController代理（FerrariControllerDelegate）
- (void)ferrariAnimationFinished
{
    [self removePlayAnimate:kFerrariTag];
}

#pragma mark LambohiniViewController代理（LambohiniViewControllerDelegate）
- (void)lambohiniAnimationFinished
{
    [self removePlayAnimate:kLambohiniTag];
}

#pragma mark RocketViewController代理（RocketViewControllerDelegate）
- (void)rocketAnimationFinished
{
    [self removePlayAnimate:kRocket1Tag];
}

#pragma mark 移除当前播放动画视图，如果有下一条视图则对应继续播放
- (void)removePlayAnimate:(NSInteger)viewTag
{
    [_gifAnimateArray removeObjectAtIndex:0];
    _currentBigGiftState = 0;
}

#pragma mark 播放礼物下一个gif、真实动画
- (void)playNextGiftAnimation
{
    CustomMessageModel *customMessageModel = [_gifAnimateArray firstObject];
    //1：gif动画  2：真实动画
    if (customMessageModel.is_animated == 1)
    {
        [self beginGifAnimate:[_gifAnimateArray firstObject] andSenderName:customMessageModel.top_title];
    }
    else if (customMessageModel.is_animated == 2)
    {
        [self playAnimationWithTagStr:customMessageModel superView:_liveUIViewController.liveView];
    }
}

#pragma mark 播放对应标签的动画
- (void)playAnimationWithTagStr:(CustomMessageModel *)customMessageModel superView:(UIView *)superView
{
    if ([customMessageModel.anim_type isEqualToString:kPlane1TypeStr])
    {
        Plane1Controller *tmpController = [[Plane1Controller alloc]init];
        tmpController.senderNameStr = customMessageModel.top_title;
        tmpController.delegate = self;
        [superView addSubview:tmpController.view];
        tmpController.view.tag = kPlane1Tag;
        tmpController.view.frame = self.view.bounds;
        [superView sendSubviewToBack:tmpController.view];
    }
    else if ([customMessageModel.anim_type isEqualToString:kPlane2TypeStr])
    {
        Plane2Controller *tmpController = [[Plane2Controller alloc]init];
        tmpController.senderNameStr = customMessageModel.top_title;
        tmpController.delegate = self;
        [superView addSubview:tmpController.view];
        tmpController.view.tag = kPlane2Tag;
        tmpController.view.frame = self.view.bounds;
        [superView sendSubviewToBack:tmpController.view];
    }
    else if ([customMessageModel.anim_type isEqualToString:kFerrariTypeStr])
    {
        FerrariController *tmpController = [[FerrariController alloc]init];
        tmpController.senderNameStr1 = customMessageModel.top_title;
        tmpController.senderNameStr2 = customMessageModel.top_title;
        tmpController.delegate = self;
        [superView addSubview:tmpController.view];
        tmpController.view.tag = kFerrariTag;
        tmpController.view.frame = self.view.bounds;
        [superView sendSubviewToBack:tmpController.view];
    }
    else if ([customMessageModel.anim_type isEqualToString:kLambohiniTypeStr])
    {
        LambohiniViewController *tmpController = [[LambohiniViewController alloc]init];
        tmpController.senderNameStr = customMessageModel.top_title;
        tmpController.delegate = self;
        [superView addSubview:tmpController.view];
        tmpController.view.tag = kLambohiniTag;
        tmpController.view.frame = self.view.bounds;
        [superView sendSubviewToBack:tmpController.view];
    }
    else if ([customMessageModel.anim_type isEqualToString:kRocket1TypeStr])
    {
        RocketViewController *tmpController = [[RocketViewController alloc]init];
        tmpController.senderNameStr = customMessageModel.top_title;
        tmpController.delegate = self;
        [superView addSubview:tmpController.view];
        tmpController.view.tag = kRocket1Tag;
        tmpController.view.frame = self.view.bounds;
        [superView sendSubviewToBack:tmpController.view];
    }
}

#pragma mark - ----------------------- 飞屏模式 -----------------------
#pragma mark 播放下一个其他房间的大型礼物（飞屏模式）
- (void)playNextOhterRoomBigGiftAnimation
{
    _ohterRoomBitGiftModel = [_otherRoomBitGiftArray firstObject];
    [self.otherRoomBitGiftArray removeObjectAtIndex:0];
    
    if (![FWUtils isBlankString:_ohterRoomBitGiftModel.desc])
    {
        FWWeakify(self)
        [self.otherRoomBitGiftView judgeGiftViewWith:_ohterRoomBitGiftModel.desc finishBlock:^{
            
            FWStrongify(self)
            self.otherRoomBitGiftView.hidden = YES;
            self.currentOtherRoomBigGiftState = 0;
            
        }];
        _otherRoomBitGiftView.hidden = NO;
    }
}

- (OtherRoomBitGiftView *)otherRoomBitGiftView
{
    if (!_otherRoomBitGiftView)
    {
        _otherRoomBitGiftView = [[OtherRoomBitGiftView alloc] initWithFrame:CGRectMake(0, 100, kScreenW, 55)];
        [_liveUIViewController.liveView addSubview:_otherRoomBitGiftView];
        _otherRoomBitGiftView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goOtherLiveRoom)];
        tapRecognizer.numberOfTapsRequired = 1;
        tapRecognizer.numberOfTouchesRequired = 1;
        [_otherRoomBitGiftView addGestureRecognizer:tapRecognizer];
    }
    return _otherRoomBitGiftView;
}

- (void)goOtherLiveRoom
{
    if (!_isHost)
    {
        [FanweMessage alert:nil message:@"您确定需要前往该直播间吗？" destructiveAction:^{
            
            SUS_WINDOW.switchedRoomId = _ohterRoomBitGiftModel.room_id;
            
            [self closeCurrentLive:YES isHostShowAlert:NO];
            [self releaseAll];
            
        } cancelAction:^{
            
        }];
        
        /**
         _roomIDStr = _ohterRoomBitGiftModel.room_id;
         if (_delegate && [_delegate respondsToSelector:@selector(switchLiveRoom)])
         {
         [_delegate switchLiveRoom];
         }
         */
    }
}


#pragma mark - ----------------------- 弹幕消息 -----------------------
- (void)addBarrageMessage:(CustomMessageModel *)customMessageModel
{
    if(customMessageModel.desc.length == 0)
    {
        return;
    }
    MessageView* messageView = [[MessageView alloc] initWithView:_liveUIViewController.liveView customMessageModel:customMessageModel];
    messageView.delegate = self;
    if ([_barrageViewArray count])
    { //弹幕消息视图队列中有正在等待展示的弹幕信息
        [_barrageViewArray addObject:messageView];
    }
    else
    {
        if (_barrageViewShowing1 && !_barrageViewShowing2)
        { //正在展示底下的弹幕，上面的弹幕空闲状态
            messageView.frame = CGRectMake(messageView.frame.origin.x, [self showBarrageViewWithOriginY:BARRAGE_VIEW_Y_2], messageView.frame.size.width, messageView.frame.size.height);
            [self barrageViewAnimating2:messageView];
        }
        else if ((!_barrageViewShowing1 && _barrageViewShowing2) || (!_barrageViewShowing1 && !_barrageViewShowing2))
        { //正在展示上面的弹幕，底下的弹幕空闲状态 或者 两个弹幕都不在展示状态
            messageView.frame = CGRectMake(messageView.frame.origin.x, [self showBarrageViewWithOriginY:BARRAGE_VIEW_Y_1], messageView.frame.size.width, messageView.frame.size.height);
            [self barrageViewAnimating1:messageView];
        }
        else if (_barrageViewShowing1 && _barrageViewShowing2)
        { //两个弹幕都正在展示状态
            [_barrageViewArray addObject:messageView];
        }
    }
}

- (CGFloat)showBarrageViewWithOriginY:(CGFloat)originY
{
    if (_liveUIViewController.liveView.goldFlowerView && _liveUIViewController.liveView.goldViewCanNotSee == NO)
    {
        return originY-_liveUIViewController.liveView.goldFlowerViewHeiht;
    }
    else if (_liveUIViewController.liveView.guessSizeView && _liveUIViewController.liveView.guessSizeViewCanNotSee == NO)
    {
        return originY-kGuessSizeViewHeight;
    }
    else
    {
        return originY;
    }
}

#pragma mark 获取弹幕视图队列中的弹幕视图
- (void)getBarrageViewFromArray:(int)tag
{
    MessageView* messageView;
    
    if ([_barrageViewArray count])
    { //获取弹幕消息视图队列中的第一个弹幕信息
        messageView = [_barrageViewArray firstObject];
        [_barrageViewArray removeObjectAtIndex:0];
        if (tag == 1)
        {
            messageView.frame = CGRectMake(messageView.frame.origin.x, [self showBarrageViewWithOriginY:BARRAGE_VIEW_Y_1], messageView.frame.size.width, messageView.frame.size.height);
            [self barrageViewAnimating1:messageView];
        }
        else
        {
            messageView.frame = CGRectMake(messageView.frame.origin.x, [self showBarrageViewWithOriginY:BARRAGE_VIEW_Y_2], messageView.frame.size.width, messageView.frame.size.height);
            [self barrageViewAnimating2:messageView];
        }
    }
}

- (void)barrageViewAnimating1:(MessageView *)messageView
{
    double needTime = 0;
    if (messageView.frame.size.width<kScreenW)
    {
        needTime = BARRAGE_VIEW_ANIMATE_TIME;
    }
    else
    {
        needTime = BARRAGE_VIEW_ANIMATE_TIME+(messageView.frame.size.width-kScreenW)/kScreenW*BARRAGE_VIEW_ANIMATE_TIME;
    }
    
    _barrageViewShowing1 = YES;
    
    __weak MessageView *mv = messageView;
    
    FWWeakify(self)
    [UIView animateWithDuration:needTime animations:^{
        
        FWStrongify(self)
        mv.frame = CGRectMake(-mv.frame.size.width, [self showBarrageViewWithOriginY:BARRAGE_VIEW_Y_1], mv.frame.size.width, mv.frame.size.height);
    } completion:^(BOOL finished) {
        
        FWStrongify(self)
        self.barrageViewShowing1 = NO;
        [mv removeFromSuperview];
        if ([self.barrageViewArray count])
        {
            [self getBarrageViewFromArray:1];
        }
        
    }];
}

- (void)barrageViewAnimating2:(MessageView *)messageView
{
    double needTime = 0;
    if (messageView.frame.size.width<kScreenW)
    {
        needTime = BARRAGE_VIEW_ANIMATE_TIME;
    }
    else
    {
        needTime = BARRAGE_VIEW_ANIMATE_TIME+(messageView.frame.size.width-kScreenW)/kScreenW*BARRAGE_VIEW_ANIMATE_TIME;
    }
    
    _barrageViewShowing2 = YES;
    
    __weak MessageView *mv = messageView;
    
    FWWeakify(self)
    [UIView animateWithDuration:needTime animations:^{
        
        FWStrongify(self)
        mv.frame = CGRectMake(-mv.frame.size.width, [self showBarrageViewWithOriginY:BARRAGE_VIEW_Y_2], mv.frame.size.width, mv.frame.size.height);
    } completion:^(BOOL finished) {
        
        FWStrongify(self)
        self.barrageViewShowing2 = NO;
        [mv removeFromSuperview];
        if ([self.barrageViewArray count])
        {
            [self getBarrageViewFromArray:2];
        }
    }];
}

#pragma mark 点击弹幕头像
- (void)tapLogo:(MessageView *)messageView customMessageModel:(CustomMessageModel *)customMessageModel
{
    
}
//#pragma mark 关闭每日任务
//- (void)closeEverydayTask
//{
//    self.liveUIViewController.liveView.closeLiveBtn.hidden = YES;
//}


#pragma mark - ----------------------- 高级别用户进入动画 -----------------------
#pragma mark 查看客户是否高级用户，如果是的显示对应的高级用户进入动画
- (void)showCurrUserJoinAnimate
{
    if (!_isHost)
    {
        UserModel *userModel = [[UserModel alloc]init];
        userModel.user_id = [IMAPlatform sharedInstance].host.imUserId;
        userModel.nick_name = [IMAPlatform sharedInstance].host.imUserName;
        userModel.head_image = [IMAPlatform sharedInstance].host.imUserIconUrl;
        userModel.user_level = [NSString stringWithFormat:@"%ld",[[IMAPlatform sharedInstance].host getUserRank]];
        
        [self audienceEnterAnimate:userModel];
    }
}

#pragma mark 判断是否播放高级别用户进入动画
- (void)audienceEnterAnimate:(UserModel *)userModel
{
    if ([userModel.user_level integerValue] >= self.fanweApp.appModel.jr_user_level)
    {
        [_aETViewArray addObject:userModel];
        if ([_aETViewArray count] == 1 && !_aETViewShowing)
        {
            [self playAETViewAnimate:userModel];
        }
    }
}

#pragma mark 播放高级别观众进入的动画
- (void)playAETViewAnimate:(UserModel *) userModel
{
    _aETViewShowing = YES;
    [_aETView setContent:userModel];
    
    FWWeakify(self)
    [UIView animateWithDuration:1.2 animations:^{
        
        FWStrongify(self)
        self.aETView.hidden = NO;
        self.aETView.frame = CGRectMake(0, kAudienceEnteringTipViewHeight, kScreenW, 35);
        
    } completion:^(BOOL finished) {
        
        FWStrongify(self)
        [self performSelector:@selector(finishAETViewAnimate) withObject:nil afterDelay:2];
        
    }];
}

#pragma mark 结束高级用户进入动画
- (void)finishAETViewAnimate
{
    _aETView.hidden = YES;
    _aETViewShowing = NO;
    [_aETViewArray removeObjectAtIndex:0];
    _aETView.frame = CGRectMake(-kScreenW, _aETView.frame.origin.y, CGRectGetWidth(_aETView.frame), CGRectGetHeight(_aETView.frame));
    if ([_aETViewArray count])
    {
        UserModel *userModel = [_aETViewArray firstObject];
        [self playAETViewAnimate:userModel];
    }
}

#pragma mark - ----------------------- 红包 -----------------------
#pragma mark 展示红包
- (void)addRedBagView:(CustomMessageModel *) customMessageModel
{
    [customMessageModel startRedPackageTimer];
    
    SLiveRedBagView *redBagView = [[[NSBundle mainBundle]loadNibNamed:@"SLiveRedBagView" owner:self options:nil] objectAtIndex:0];
    redBagView.frame = CGRectMake(0,0,kScreenW,kScreenH);
    redBagView.rebBagDelegate = self;
    [redBagView creatRedWithModel:customMessageModel];
    [_liveUIViewController.liveView addSubview:redBagView];
}

#pragma mark RedBagViewDelegate
#pragma mark 点击打开红包
- (void)openRedbag:(SLiveRedBagView *)redBagView
{
    [redBagView.customMessageModel stopRedPackageTimer];
    
    _liveUIViewController.liveView.currentDiamonds = [[IMAPlatform sharedInstance].host getDiamonds];
    [_liveUIViewController.liveView.giftView setDiamondsLabelTxt:[NSString stringWithFormat:@"%ld",[[IMAPlatform sharedInstance].host getDiamonds]]];
}

#pragma mark CustomMessageModelDelegate
#pragma mark 红包消失
- (void)redPackageDisappear:(CustomMessageModel *)customMessageModel
{
    for (UIView *subView in _liveUIViewController.liveView.subviews)
    {
        if ([subView isKindOfClass:[SLiveRedBagView class]])
        {
            SLiveRedBagView *redBagView = (SLiveRedBagView *)subView;
            if ([redBagView.customMessageModel isEqual:customMessageModel])
            {
                [redBagView removeFromSuperview];
            }
        }
    }
}


#pragma mark - ----------------------- 结束界面 -----------------------
#pragma mark 结束界面
- (void)setupFinishView:(CurrentLiveInfo *)liveInfo
{
    if (!_finishLiveView)
    {
        _finishLiveView = [[FinishLiveView alloc] init];
    }
    [FWUtils downloadImage:liveInfo.podcast.user.head_image place:kDefaultPreloadHeadImg imageView:_finishLiveView.userHeadImgView];
    [FWUtils downloadImage:liveInfo.podcast.user.head_image place:kDefaultPreloadHeadImg imageView:_finishLiveView.bgImgView];
    
    _finishLiveView.userNameLabel.text = liveInfo.podcast.user.nick_name;
    
    if (_isHost)
    {
        _finishLiveView.audienceNameLabel.hidden = YES;
        _finishLiveView.audienceNumLabel2.hidden = YES;
    }
    else
    {
        _finishLiveView.audienTicketContrainerView.hidden = YES;
    }
    
    FWWeakify(self)
    _finishLiveView.shareFollowBlock = ^(){
        
        FWStrongify(self)
        // 主播此时是“分享”按钮，观众此时是“关注”按钮
        if (self.isHost)
        {
            [self shareWithModel:self.currentLiveInfo.share];
        }
        else
        {
            NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
            [mDict setObject:@"user" forKey:@"ctl"];
            [mDict setObject:@"follow" forKey:@"act"];
            if (![FWUtils isBlankString:self.currentLiveInfo.user_id])
            {
                [mDict setObject:self.currentLiveInfo.user_id forKey:@"to_user_id"];
                [self.httpsManager POSTWithParameters:mDict SuccessBlock:^(NSDictionary *responseJson) {
                    
                    if ([responseJson toInt:@"status"] == 1)
                    {
                        if ([responseJson toInt:@"has_focus"] == 1)
                        {
                            [self.finishLiveView.shareFollowBtn setTitle:@"已关注" forState:UIControlStateNormal];
                        }
                        else
                        {
                            [self.finishLiveView.shareFollowBtn setTitle:@"关注" forState:UIControlStateNormal];
                        }
                    }
                    
                } FailureBlock:^(NSError *error) {
                    
                }];
            }
        }
        
    };
    
    _finishLiveView.backHomeBlock = ^(){
        
        FWStrongify(self)
        [self clickedFinishLiveViewBackHomeBtn];
        
    };
    
    _finishLiveView.delLiveBlock = ^(){
        
        FWStrongify(self)
        NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
        [mDict setObject:@"video" forKey:@"ctl"];
        [mDict setObject:@"del_video" forKey:@"act"];
        [mDict setObject:self.roomIDStr forKey:@"room_id"];
        
        [self.httpsManager POSTWithParameters:mDict SuccessBlock:^(NSDictionary *responseJson){
            
            FWStrongify(self)
            [self clickedFinishLiveViewBackHomeBtn];
            
        } FailureBlock:^(NSError *error) {
            
            FWStrongify(self)
            [self clickedFinishLiveViewBackHomeBtn];
            
        }];
        
    };
}

- (void)clickedFinishLiveViewBackHomeBtn
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(finishViewClose:)])
    {
        [self.delegate finishViewClose:self];
    }
}

#pragma mark 显示主播结束界面
- (void)showHostFinishView:(NSString *)audience andVote:(NSString *)vote andHasDel:(BOOL)hasDel
{
    if (_isHost)
    {
        [FWUtils closeKeyboard];
        
        _finishLiveView.delLiveBtn.hidden = !hasDel;
        
        [self.view addSubview:_finishLiveView];
        [self.view bringSubviewToFront:_finishLiveView];
        
        if ([FWUtils isBlankString:audience] && [FWUtils isBlankString:vote])
        {
            [_finishLiveView.acIndicator startAnimating];
        }
        else
        {
            [_finishLiveView.acIndicator stopAnimating];
            _finishLiveView.acIndicator.hidden = YES;
            
            _finishLiveView.audienceNumLabel.text = audience;
            _finishLiveView.ticketLabel.text = vote;
        }
    }
}

#pragma mark 显示观众结束界面
- (void)showAudienceFinishView:(CustomMessageModel *)customMessageModel
{
    if (!_isHost)
    {
        
        [FWUtils closeKeyboard];
        
        NSString *audienceTotalStr = customMessageModel.show_num;
        if ([FWUtils isBlankString:audienceTotalStr])
        {
            [_finishLiveView.acIndicator startAnimating];
        }
        else
        {
            [_finishLiveView.acIndicator stopAnimating];
            _finishLiveView.acIndicator.hidden = YES;
            
            _finishLiveView.audienceNumLabel2.text = audienceTotalStr;
        }
        
        if (_isFollowAnchor)
        {
            [self.finishLiveView.shareFollowBtn setTitle:@"已关注" forState:UIControlStateNormal];
        }
        else
        {
            [self.finishLiveView.shareFollowBtn setTitle:@"关注" forState:UIControlStateNormal];
        }
        
        [self.view addSubview:_finishLiveView];
        [self.view bringSubviewToFront:_finishLiveView];
    }
}


#pragma mark - ----------------------- 其他代理方法 -----------------------

#pragma mark ========== FWLiveUIViewControllerServeiceDelegate ==========
- (void)showRechargeView:(FWLiveUIViewController *)liveUIViewController
{
    [self rechargeView:_liveUIViewController.liveView];
}

#pragma mark ========== TCShowLiveViewServiceDelegate ==========
#pragma mark 显示充值
- (void)rechargeView:(TCShowLiveView *)showLiveView
{
    self.rechargeView.hidden = NO;
    SUS_WINDOW.window_Tap_Ges.enabled = NO;
    SUS_WINDOW.window_Pan_Ges.enabled = NO;
    [self.rechargeView loadRechargeData];
    
    FWWeakify(self)
    [UIView animateWithDuration:0.5 animations:^{
        
        FWStrongify(self)
        self.rechargeView.transform = CGAffineTransformMakeTranslation(0, (kScreenH-kRechargeViewHeight)/2-kScreenH);
        
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark 连麦、关闭连麦
- (void)clickMikeBtn:(TCShowLiveView *)showLiveView
{
    [self canMike];
}

- (void)canMike
{
    if (_delegate && [_delegate respondsToSelector:@selector(openOrCloseMike:)])
    {
        [_delegate openOrCloseMike:self];
    }
}

#pragma mark IM私聊
- (void)clickIM:(TCShowLiveView *)showLiveView
{
    SUS_WINDOW.window_Tap_Ges.enabled = NO;
    SUS_WINDOW.window_Pan_Ges.enabled = NO;
    
    // 加载半VC;
    [_liveUIViewController addTwoSubVC];
}

#pragma mark 点击liveView的空白
- (void)clickBlank:(TCShowLiveView *)showLiveView
{
    // 后期通知要废掉
    self.liveUIViewController.panGestureRec.enabled = YES;
    for (UIViewController *one_VC in self.liveUIViewController.childViewControllers)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"imRemoveNeedUpdate" object:nil];
        
        FWWeakify(self)
        // chatVC存在
        if ([one_VC isKindOfClass:[FWConversationSegmentController class]])
        {
            FWConversationSegmentController *imChat_VC = (FWConversationSegmentController *)one_VC;
            __weak FWConversationSegmentController *imchat = imChat_VC;
            
            [UIView animateWithDuration:kHalfVCViewanimation animations:^{
                
                imchat.view.y = kScreenH;
                
            } completion:^(BOOL finished) {
                
                FWStrongify(self)
                if(finished)
                {
                    [imChat_VC.view removeFromSuperview];
                    [self.liveUIViewController removeChild:imChat_VC];
                    
                    self.liveUIViewController.isHaveHalfIMChatVC = NO;
                    self.liveUIViewController.isKeyboardTypeNum = 0;
                }
            }];
        }
        // 聊天退出
        if ([one_VC isKindOfClass:[FWConversationServiceController class]])
        {
            FWConversationSegmentController *imMsgChat_VC = (FWConversationSegmentController *)one_VC;
            __weak FWConversationSegmentController *imchat = imMsgChat_VC;
            
            [UIView animateWithDuration:kHalfVCViewanimation animations:^{
                
                imchat.view.y = kScreenH;
                
            } completion:^(BOOL finished) {
                
                FWStrongify(self)
                [imMsgChat_VC.view removeFromSuperview];
                [self.liveUIViewController removeChild:imMsgChat_VC];
                self.liveUIViewController.isHaveHalfIMMsgVC = NO;
                self.liveUIViewController.isKeyboardTypeNum = 0;
                
            }];
        }
    }
}


#pragma mark ========== TCShowLiveMessageViewDelegate ==========
- (void)getUserInfo:(UserModel *)userModel
{
    // 关闭键盘
    [FWUtils closeKeyboard];
    if (!_informationView)
    {
        _informationView = [[[NSBundle mainBundle]loadNibNamed:@"SLiveHeadInfoView" owner:self options:nil] objectAtIndex:0];
        _informationView.infoDelegate = self;
        _informationView.frame = CGRectMake(0,kScreenH,kScreenW, kScreenH);
        [_informationView updateUIWithModel:userModel withRoom:_liveItem];
        [_liveUIViewController.liveView addSubview:_informationView];
        
        [UIView animateWithDuration:0.6 delay:0 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
            CGRect rect = _informationView.frame;
            rect.origin.y = 0;
            _informationView.frame = rect;
            
        } completion:^(BOOL finished) {
            
        }];
    }else
    {
        [self removeInformationView];
    }
}



#pragma mark 点击消息列表中的用户名称
- (void)clickNameRange:(CustomMessageModel *) customMessageModel
{
    UserModel *userModel = [[UserModel alloc]init];
    userModel.user_id = customMessageModel.sender.user_id;
    userModel.nick_name = customMessageModel.sender.nick_name;
    userModel.head_image = customMessageModel.sender.head_image;
    userModel.user_level = [NSString stringWithFormat:@"%ld",(long)customMessageModel.sender.user_level];
    
    [self getUserInfo:userModel];
}

- (void)clickUserInfo:(cuserModel *)cuser
{
    UserModel *userModel = [[UserModel alloc]init];
    userModel.user_id = cuser.user_id;
    userModel.nick_name = cuser.nick_name;
    userModel.head_image = cuser.head_image;
    userModel.user_level = [NSString stringWithFormat:@"%ld",(long)cuser.user_level];
    
    [self getUserInfo:userModel];
}

#pragma mark 点击消息列表中的具体消息内容（目前会响应点击事件的是：红包）
- (void)clickMessageRange:(CustomMessageModel *) customMessageModel
{
    //防止当前页面中正在展示该红包
    for (UIView *view in _liveUIViewController.liveView.subviews)
    {
        if ([view isKindOfClass:[SLiveRedBagView class]])
        {
            SLiveRedBagView *redBagView = (SLiveRedBagView *)view;
            if ([redBagView.customMessageModel isEquals:customMessageModel])
            {
                return;
            }
        }
    }
    
    if (customMessageModel.type == MSG_RED_PACKET)
    {
        SLiveRedBagView *redBagView = [[[NSBundle mainBundle]loadNibNamed:@"SLiveRedBagView" owner:self options:nil] objectAtIndex:0];
        redBagView.frame = CGRectMake(0,0,kScreenW,kScreenH);
        redBagView.rebBagDelegate = self;
        [redBagView creatRedWithModel:customMessageModel];
        if (customMessageModel.isRedPackageTaked)
        {
            [redBagView changeRedPackageView];
        }
        [_liveUIViewController.liveView addSubview:redBagView];
    }
}

#pragma mark 点击消息列表中的商品推送信息
- (void)clickGoodsMessage:(CustomMessageModel *) customMessageModel
{
    if (customMessageModel.goods.url.length>0 && customMessageModel.goods.type == 1)
    {
        FWMainWebViewController *tmpController = [FWMainWebViewController webControlerWithUrlStr:customMessageModel.goods.url isShowIndicator:YES isShowNavBar:!kSupportH5Shopping isShowBackBtn:YES isShowCloseBtn:YES];
        [tmpController initRightBarBtnItemWithType:RightBarBtnItemBackLiveVC titleStr:@"直播"];
        
        //        if (kSupportH5Shopping || self.fanweApp.appModel.open_podcast_goods == 1)
        //        {
        //            tmpController.isSmallScreen = NO;
        //        }
        //        else
        //        {
        //            tmpController.isSmallScreen = YES;
        //        }
        tmpController.isSmallScreen = NO;
        tmpController.httpMethodStr = @"GET";
        [self toGoH5With:tmpController andShowSmallWindow:tmpController.isSmallScreen];
    }
    else
    {
        GoodsModel * model = [[GoodsModel alloc] init];
        model = customMessageModel.goods;
        NSString * hostId = [[_liveItem liveHost] imUserId];
        NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
        [mDict setObject:@"pai_user" forKey:@"ctl"];
        [mDict setObject:@"open_goods_detail" forKey:@"act"];
        [mDict setObject:hostId forKey:@"podcast_id"];
        [mDict setObject:@"shop" forKey:@"itype"];
        if(model.goods_id>0)
        {
            [mDict setObject:model.goods_id forKey:@"goods_id"];
        }
        FWWeakify(self)
        [self.httpsManager POSTWithParameters:mDict SuccessBlock:^(NSDictionary *responseJson) {
            
            FWStrongify(self)
            if ([responseJson toInt:@"status"] == 1)
            {
                FWMainWebViewController *tmpController = [FWMainWebViewController webControlerWithUrlStr:[responseJson toString:@"url"] isShowIndicator:YES isShowNavBar:!kSupportH5Shopping isShowBackBtn:YES isShowCloseBtn:YES];
                [tmpController initRightBarBtnItemWithType:RightBarBtnItemBackLiveVC titleStr:@"直播"];
                
                //                if (kSupportH5Shopping || self.fanweApp.appModel.open_podcast_goods == 1)
                //                {
                //                    tmpController.isSmallScreen = NO;
                //                }
                //                else
                //                {
                //                    tmpController.isSmallScreen = YES;
                //                }
                tmpController.isSmallScreen = NO;
                tmpController.httpMethodStr = @"GET";
                [self toGoH5With:tmpController andShowSmallWindow:tmpController.isSmallScreen];
            }
            
        } FailureBlock:^(NSError *error) {
            
        }];
    }
    if ([_liveUIViewController.liveView.liveInputView isInputViewActive])
    {
        [_liveUIViewController.liveView.liveInputView resignFirstResponder];
    }
}

#pragma mark ========== SLiveHeadInfoViewDelegate ==========

- (void)operationHeadView:(SLiveHeadInfoView *)headView andUserId:(NSString *)userId andNameStr:(NSString *)nameStr andUserImgUrl:(NSString *)userImgUrl andIs_robot:(BOOL)is_robot andViewType:(int)viewType
{
    [self removeInformationView];
    switch (viewType)
    {
        case 1:  //删除_informationView
        {
            //[self removeInformationView];
        }
            break;
        case 2:  //进入用户主页
        {
            SHomePageVC *tmpController= [[SHomePageVC alloc]init];
            tmpController.user_id = userId;
            tmpController.type = 0;
            [[AppDelegate sharedAppDelegate]pushViewController:tmpController];
        }
            break;
        case 3:  //进入管理员列表
        {
            ManagerViewController *tmpController = [[ManagerViewController alloc]init];
            [[AppDelegate sharedAppDelegate]pushViewController:tmpController];
        }
            break;
        case 4:  //@某个用户
        {
            if (_liveUIViewController.liveView.giftView.hidden == NO)
            {
                [_liveUIViewController.liveView hiddenGiftView];
            }
            
            [_liveUIViewController.liveView.liveInputView.textField becomeFirstResponder];
            _liveUIViewController.liveView.liveInputView.hidden = NO;
            _liveUIViewController.liveView.bottomView.hidden = YES;
            _liveUIViewController.liveView.liveInputView.textField.text = [NSString stringWithFormat:@"%@%@ ",@"@",nameStr];
            
        }
            break;
        case 5:  //举报
        {
            _tipoffUserId = userId;
            _liveReportV = [[SLiveReportView alloc]initWithFrame:CGRectMake(0,0,kScreenW,kScreenH)];
            _liveReportV.reportDelegate = self;
            [_liveUIViewController.liveView addSubview:_liveReportV];
            
        }
            break;
        case 6:  //进入IM消息
        {
            SFriendObj* chattag = [[SFriendObj alloc]initWithUserId:[userId intValue]];
            
            chattag.mNick_name = nameStr;
            chattag.mHead_image = userImgUrl;
            chattag.is_robot = is_robot;
            
            FWConversationServiceController* chatvc = [FWConversationServiceController makeChatVCWith:chattag];
            chatvc.mtoptitle.text = nameStr;
            FWNavigationController *nav = [[FWNavigationController alloc] initWithRootViewController:chatvc];
            nav.navigationBarHidden = YES;
            [self presentViewController:nav animated:YES completion:nil];
            
        }
            break;
            
        default:
            break;
    }
}

- (void)removeInformationView
{
    [_informationView removeFromSuperview];
    _informationView = nil;
}

//- (void)IMchatMsg:(int)userid userimgurl:(NSString*)userimgurl username:(NSString*)username is_robot:(BOOL)is_robot
//{
//    SFriendObj* chattag = [[SFriendObj alloc]initWithUserId:userid];
//
//    chattag.mNick_name = username;
//    chattag.mHead_image = userimgurl;
//    chattag.is_robot = is_robot;
//
//    FWConversationServiceController* chatvc = [FWConversationServiceController makeChatVCWith:chattag];
//    chatvc.mtoptitle.text = username;
//    FWNavigationController *nav = [[FWNavigationController alloc] initWithRootViewController:chatvc];
//    nav.navigationBarHidden = YES;
//    [self presentViewController:nav animated:YES completion:nil];
//}

#pragma mark ========== ReportViewDelegate ==========
- (void)clickWithReportId:(NSString *)reportId andBtnIndex:(int)btnIndex andView:(SLiveReportView *)reportView
{
    if (btnIndex == 1)
    {
        if (reportId.length < 1)
        {
            [FanweMessage alertTWMessage:@"请选择举报类型"];
            return;
        }
        NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
        [mDict setObject:@"user" forKey:@"ctl"];
        [mDict setObject:@"tipoff" forKey:@"act"];
        if (_tipoffUserId) {
            [mDict setObject:_tipoffUserId forKey:@"to_user_id"];
        }
        [mDict setObject:_roomIDStr forKey:@"room_id"];
        [mDict setObject:reportId forKey:@"type"];
        
        FWWeakify(self)
        [self.httpsManager POSTWithParameters:mDict SuccessBlock:^(NSDictionary *responseJson) {
            
            FWStrongify(self)
            [self.liveReportV removeFromSuperview];
            self.liveReportV = nil;
            if ([responseJson toInt:@"status"] == 1)
            {
                [FanweMessage alertHUD:@"已收到举报消息,我们将尽快落实处理"];
            }
            
        } FailureBlock:^(NSError *error) {
            
        }];
    }
    else
    {
        [_liveReportV removeFromSuperview];
        _liveReportV = nil;
    }
}

#pragma mark ========== TCShowLiveTopViewDelegate ==========
#pragma mark 点击用户头像
- (void)onTopView:(TCShowLiveTopView *)topView userModel:(UserModel *)userModel
{
    [self getUserInfo:userModel];
}

#pragma mark 点击关注按钮
- (void)followAchor:(TCShowLiveTopView *)topView
{
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    [mDict setObject:@"user" forKey:@"ctl"];
    [mDict setObject:@"follow" forKey:@"act"];
    [mDict setObject:_roomIDStr forKey:@"room_id"];
    if ([[_liveItem liveHost] imUserId])
    {
        [mDict setObject:[[_liveItem liveHost] imUserId] forKey:@"to_user_id"];
        
        FWWeakify(self)
        [self.httpsManager POSTWithParameters:mDict SuccessBlock:^(NSDictionary *responseJson){
            
            FWStrongify(self)
            if ([responseJson toInt:@"status"] == 1)
            {
                if ([responseJson toInt:@"has_focus"] == 1)
                {
                    self.liveUIViewController.liveView.topView.isShowFollowBtn = NO;
                    self.isFollowAnchor = YES;
                    [self.liveUIViewController.liveView.topView relayoutFrameOfSubViews];
                    
                    NSString *follow_msg = [responseJson toString:@"follow_msg"];
                    
                    if (![FWUtils isBlankString:[[IMAPlatform sharedInstance].host imUserName]] && ![FWUtils isBlankString:follow_msg])
                    {
                        [self sentMessageWithStr:follow_msg];
                    }
                }
                else
                {
                    self.isFollowAnchor = NO;
                }
            }
        } FailureBlock:^(NSError *error) {
            
        }];
    }
}

#pragma mark 点击关注按钮发送IM通知
- (void)sentMessageWithStr:(NSString *)msgStr
{
    SendCustomMsgModel *sendCustomMsgModel = [[SendCustomMsgModel alloc] init];
    sendCustomMsgModel.msgType = MSG_LIVING_MESSAGE;
    sendCustomMsgModel.msg = msgStr;
    sendCustomMsgModel.chatGroupID = [_liveItem liveIMChatRoomId];
    [_iMMsgHandler sendCustomGroupMsg:sendCustomMsgModel succ:nil fail:nil];
}

#pragma mark 进入印票排行榜
- (void)goToContributionList:(TCShowLiveTopView *)topView
{
    ContributionListViewController *VC = [[ContributionListViewController alloc]init];
    VC.user_id = [[_liveItem liveHost] imUserId];
    VC.liveHost_id = [[_liveItem liveHost] imUserId];
    VC.type = @"1";
    //    VC.fromType = @"1";
    VC.liveAVRoomId = _roomIDStr;
    [VC setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark 移除添加好友的View
- (void)removeAddFriendView
{
    [_addFView removeFromSuperview];
    _addFView = nil;
}

#pragma mark  PasteViewDelegate 微信qq添加好友跳转
- (void)sentPasteWithIndex:(int)index withShareIndex:(int)shareIndex
{
    UIPasteboard *pasteboard=[UIPasteboard generalPasteboard];
    pasteboard.string = _privateShareString;
    if (index == 0 || index == 1)
    {
        [_PView removeFromSuperview];
        _PView = nil;
    }
    else
    {
        if (shareIndex == 0)
        {
            NSString *str =@"weixin://qr/JnXv90fE6hqVrQOU9yA0";
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            [_PView removeFromSuperview];
            _PView = nil;
        }
        else
        {
            NSString *str =@"mqq://";
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            [_PView removeFromSuperview];
            _PView = nil;
        }
    }
}

#pragma mark PasteViewDelegate
- (void)deletePasteView
{
    if (_PView)
    {
        [_PView removeFromSuperview];
        _PView = nil;
    }
}

#pragma mark 添加好友跳转
- (void)addFriendWithIndex:(int)index
{
    if (index == 0 || index == 1)
    {
        [self removeAddFriendView];
        if (!_PView)
        {
            _PView = [[[NSBundle mainBundle]loadNibNamed:@"PasteView" owner:self options:nil] lastObject];
            _PView.frame = CGRectMake(0, 0, kScreenW, kScreenH);
            _PView.shareIndex = index;
            _PView.delegate = self;
            [self.view addSubview:_PView];
        }
    }
    else // 添加好友
    {
        [_addFView removeFromSuperview];
        _addFView = nil;
        SManageFriendVC *manageVC = [[SManageFriendVC alloc]init];
        manageVC.liveAVRoomId = _roomIDStr;
        manageVC.type         = 1;
        [[AppDelegate sharedAppDelegate]pushViewController:manageVC];
    }
}
#pragma mark 最新点击+ -跳转
- (void)onTopView:(TCShowLiveTopView *)topView andCount:(int)count
{
    if (count == 0)
    {
        if (!_addFView)
        {
            _addFView = [[[NSBundle mainBundle]loadNibNamed:@"AddFriendView" owner:self options:nil] lastObject];
            _addFView.delegate = self;
            _addFView.frame = CGRectMake(0, 0, kScreenW, kScreenH);
            [self.view addSubview:_addFView];
        }
        else
        {
            [self removeAddFriendView];
        }
    }
    else if (count == 1)
    {
        if (_addFView)
        {
            [self removeAddFriendView];
        }
        else
        {
            SManageFriendVC *manageVC = [[SManageFriendVC alloc]init];
            manageVC.liveAVRoomId = _roomIDStr;
            manageVC.chatAVRoomId = [_liveItem liveIMChatRoomId];
            manageVC.type         = 0;
            [[AppDelegate sharedAppDelegate]pushViewController:manageVC];
        }
    }
}

#pragma mark 添加好友点击空白的地方
- (void)deleteFriendView
{
    [self removeAddFriendView];
}

#pragma mark 进入竞拍详情
- (void)goToAuctionList:(TCShowLiveTopView *)topView
{
    AuctionItemdetailsViewController *AutionVc = [[AuctionItemdetailsViewController alloc]init];
    AutionVc.productId=[NSString stringWithFormat:@"%ld",(long)self.auctionTool.paiId];
    AutionVc.type = _isHost? 1:0;
    
    //    [[LiveCenterManager sharedInstance] showChangeAuctionLiveScreenSOfIsSmallScreen:YES nextViewController:AutionVc delegateWindowRCNameStr:nil complete:^(BOOL finished) {
    //
    //    }];
    [self.navigationController pushViewController:AutionVc animated:YES];
}

#pragma mark 控制半VC退出
- (void)clickTopViewUserHeaderMustQuitAllHalfVC:(TCShowLiveTopView*)topView
{
    if (_liveUIViewController.liveView)
    {
        [self clickBlank:_liveUIViewController.liveView];
    }
}


#pragma mark - ----------------------- 分享 -----------------------
#pragma mark 主播开始直播时点击的分享
- (void)hostShareLive
{
    if (![FWUtils isBlankString:_liveUIViewController.liveView.share_type] && _isHost)
    {
        [FWLiveServiceViewModel hostShareCurrentLive:_currentLiveInfo.share shareType:_liveUIViewController.liveView.share_type vc:self block:nil];
    }
}

#pragma mark 观众在直播间点击分享按钮
- (void)clickShareBtn:(TCShowLiveView *)showLiveView
{
    [self shareWithModel:_currentLiveInfo.share];
}

#pragma mark 分享
- (void)shareWithModel:(ShareModel *)model
{
    NSString *share_content;
    if (![model.share_content isEqualToString:@""])
    {
        share_content = model.share_content;
    }
    else
    {
        share_content = model.share_title;
    }
    
    model.isNotifiService = YES;
    model.roomIDStr = _roomIDStr;
    model.imChatIDStr = [_liveItem liveIMChatRoomId];
    [[FWUMengShareManager sharedInstance] showShareViewInControllr:self shareModel:model succ:nil failed:nil];
}

#pragma mark 是否显示关注通知的实现
- (void)isShowFollow:(NSNotification *)notification
{
    NSDictionary *interuptionDict = notification.object;
    if ([interuptionDict toString:@"userId"])
    {
        if ([[interuptionDict toString:@"userId"] isEqualToString:[[_liveItem liveHost] imUserId]])
        {
            if ([[interuptionDict objectForKey:@"isShowFollow"] intValue] == 0)
            {
                _liveUIViewController.liveView.topView.isShowFollowBtn = NO;
                if ([interuptionDict objectForKey:@"follow_msg"])
                {
                    [self sentMessageWithStr:[interuptionDict objectForKey:@"follow_msg"]];
                }
            }
            else
            {
                _liveUIViewController.liveView.topView.isShowFollowBtn = YES;
                
            }
            [_liveUIViewController.liveView.topView relayoutFrameOfSubViews];
        }
    }
}


#pragma mark - ----------------------- 插件中心 -----------------------
#pragma mark 创建插件中心
- (void)creatPluginCenter
{
    if (!_pluginCenterView)
    {
        _pluginCenterBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
        _pluginCenterBgView.backgroundColor = [UIColor clearColor];
        _pluginCenterBgView.hidden = YES;
        [_liveUIViewController.liveView addSubview:_pluginCenterBgView];
        UITapGestureRecognizer *pluginBgTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pluginBgViewClick)];
        [_pluginCenterBgView addGestureRecognizer:pluginBgTap];
        
        _pluginCenterView = [[PluginCenterView alloc]initWithFrame:CGRectMake(kDefaultMargin, kScreenH , kScreenW - kDefaultMargin*2, kPluginCenterHeight)];
        _pluginCenterView.delegate = self;
        _pluginCenterView.layer.masksToBounds = YES;
        _pluginCenterView.backgroundColor = [UIColor clearColor];
        [_liveUIViewController.liveView addSubview:_pluginCenterView];
    }
}

#pragma mark 收起插件中心
- (void)closeGameList
{
    [self closeGameListView];
}

#pragma mark 点击空白关闭插件中心
- (void)closeGamesView:(TCShowLiveView *)showLiveView
{
    [self closeGameListView];
}

- (void)pluginBgViewClick
{
    [self closeGameListView];
}

- (void)closeGameListView
{
    FWWeakify(self)
    [UIView animateWithDuration:0.3 animations:^{
        
        FWStrongify(self)
        self.pluginCenterBgView.hidden = YES;
        self.pluginCenterView.frame = CGRectMake(kDefaultMargin, kScreenH, kScreenW-kDefaultMargin*2, kPluginCenterHeight);
        
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark 点击插件中心列表
- (void)loadGoldFlowerView:(GameModel *)model withGameID:(NSString *)gameID
{
    if (_isHost)
    {
        if ([model.class_name isEqualToString:@"live_pay"]) // 按时付费
        {
            [self.liveUIViewController clickPluginPayItem:model closeBtn:_closeBtn];
        }
        else if ([model.class_name isEqualToString:@"live_pay_scene"]) // 按场付费
        {
            [self.liveUIViewController clickPluginPayItem:model closeBtn:_closeBtn];
        }
        else if ([model.class_name isEqualToString:@"pai"])
        {
            if ([model.is_active intValue] == 0)
            {
                [self.auctionTool addView]; // 点击竞拍按钮后出现实物竞拍和虚拟竞拍
            }
            else
            {
                [FanweMessage alertTWMessage:@"直播间已处于竞拍中"];
            }
        }
        else if ([model.class_name isEqualToString:@"shop"])
        {
            if ([model.is_active intValue] == 0)
            {
                [self.auctionTool clickStarShopWithIsOTOShop:NO];   // 主播点击星店后
            }
        }
        else if ([model.class_name isEqualToString:@"podcast_goods"])
        {
            if ([model.is_active intValue] == 0)
            {
                [self.auctionTool clickStarShopWithIsOTOShop:YES];  // 主播点击星店后
            }
        }
        else
        {
            if (self.pluginCenterView.game_id)
            {
                _liveUIViewController.liveView.gameId = [self.pluginCenterView.game_id integerValue];
                [_liveUIViewController.liveView beginGame];
            }
            [_liveUIViewController.liveView addGameView];
        }
    }
}

#pragma mark 获取功能插件个数
- (void)getCount:(NSMutableArray *)array
{
    self.gameOrFeatures = array.count;
}

- (void)clickGameBtn:(TCShowLiveView *)showLiveView
{
    // 进一步控制悬浮手势
    SUS_WINDOW.window_Tap_Ges.enabled = NO;
    SUS_WINDOW.window_Pan_Ges.enabled = NO;
    
    [_liveUIViewController.liveView bringSubviewToFront:self.pluginCenterView];
    [self.pluginCenterView initGamesForNetWorking];
    
    FWWeakify(self)
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:5 options: UIViewAnimationOptionCurveLinear  animations:^{
        
        FWStrongify(self)
        self.pluginCenterBgView.hidden = NO;
        if (self.gameOrFeatures != 0)
        {
            self.pluginCenterView.frame = CGRectMake(kDefaultMargin, kPluginCenterY , kScreenW-kDefaultMargin*2, kPluginCenterHeight);
        }
        else
        {
            self.pluginCenterView.frame = CGRectMake(kDefaultMargin, kScreenH - 160, kScreenW-kDefaultMargin*2, 250);
        }
        
    } completion:^(BOOL finished) {
        
    }];
}


#pragma mark - ----------------------- 竞拍、购物相关 -----------------------
- (AuctionTool *)auctionTool
{
    if (_auctionTool == nil)
    {
        _auctionTool = [[AuctionTool alloc] initWithLiveView:self.liveUIViewController.liveView andView:self.view andTCController:self andLiveItem:_liveItem];
        _auctionTool.delegate = self;
    }
    return _auctionTool;
}

#pragma mark 星店
- (void)clickStarShop:(TCShowLiveView *)showLiveView
{
    [self.auctionTool clickStarShopWithIsOTOShop:NO];
}

- (void)clickMyShop:(TCShowLiveView *)showLiveView
{
    [self.auctionTool clickStarShopWithIsOTOShop:YES];
}

#pragma mark 拍卖
- (void)clickAuction:(TCShowLiveView *)showLiveView
{
    [self.auctionTool addView];
}

- (void)toGoH5With:(UIViewController *)tmpController andShowSmallWindow:(BOOL)smallWindow
{
    if (smallWindow == YES)
    {
        [[LiveCenterManager sharedInstance] showChangeAuctionLiveScreenSOfIsSmallScreen:YES nextViewController:tmpController delegateWindowRCNameStr:nil complete:^(BOOL finished) {
            
        }];
    }
    else
    {
        [self.navigationController pushViewController:tmpController animated:YES];
    }
}

#pragma mark 点击空白处实现关闭星店弹窗，竞拍相关视图的方法
- (void)closeGoodsView:(TCShowLiveView *)showLiveView
{
    [self.auctionTool closeAuctionAboutView];
}

#pragma mark 去商品发布VC 注意 跳转方式
- (void)pushVC:(ReleaseViewController *)vc
{
    //    [[LiveCenterManager sharedInstance] showChangeAuctionLiveScreenSOfIsSmallScreen:YES nextViewController:vc delegateWindowRCNameStr:nil complete:^(BOOL finished) {
    //
    //    }];
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 到竞拍商品详情页面
 */
#pragma mark 到竞拍商品详情页面
- (void)pushAuctionDetailVC:(AuctionItemdetailsViewController *)vc
{
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)changePayView:(TCShowLiveView *)showLiveView
{
//    [self.liveUIViewController.livePay changeLeftViewFrameWithIsHost:_isHost andAuctionView:showLiveView.topView.priceView];
    [self.liveUIViewController.livePay changeLeftViewFrameWithIsHost:_isHost andAuctionView:showLiveView.topView.priceView andBankerView:showLiveView.gameBankerView];
}


#pragma mark - ----------------------- 游戏相关 -----------------------
#pragma mark 重新开始直播时判断之前是否有游戏视图
- (void)reloadGameData
{
    if (_liveUIViewController.liveView.goldFlowerView || _liveUIViewController.liveView.guessSizeView)
    {
        if (_liveUIViewController.liveView.goldFlowerView)
        {
            [_liveUIViewController.liveView disAboutClick];
            [_liveUIViewController.liveView.goldFlowerView removeFromSuperview];
            _liveUIViewController.liveView.goldFlowerView = nil;
        }
        else if(_liveUIViewController.liveView.guessSizeView)
        {
            [_liveUIViewController.liveView.guessSizeView disClockTime];
            [_liveUIViewController.liveView.guessSizeView removeFromSuperview];
            _liveUIViewController.liveView.guessSizeView = nil;
        }
        [_liveUIViewController.liveView relayoutFrameOfSubViews];
        _liveUIViewController.liveView.bottomView.hidden = YES;
        [_liveUIViewController.liveView.gameArray removeAllObjects];
        [_liveUIViewController.liveView.gameDataArray removeAllObjects];
        [_liveUIViewController.liveView.bankerDataArr removeAllObjects];
        [_liveUIViewController.liveView.bankerListArr removeAllObjects];
        
        // 如果是主播调用该方法获取到本局游戏的状态
        if (_isHost || [_liveItem liveType] == FW_LIVE_TYPE_HOST)
        {
            [_liveUIViewController.liveView loadGameData];
        }
    }
    else
    {
        // 如果前后台切换时直播间不存在游戏
        _liveUIViewController.liveView.shouldReloadGame = NO;
    }
    // 如果是观众
    if (!_isHost)
    {
        [self getVideo:nil failed:nil];
    }
}

- (void)exchangeCoin:(NSString *)diamond
{
    ConverDiamondsViewController *ConverDiamondsVC =[[ConverDiamondsViewController alloc]init];
    ConverDiamondsVC.whetherGame = YES;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        ConverDiamondsVC.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    }
    else
    {
        self.modalPresentationStyle=UIModalPresentationCurrentContext;
    }
    [self presentViewController:ConverDiamondsVC animated:YES completion:nil];
}


#pragma mark - ----------------------- 充值兑换界面相关 -----------------------
- (RechargeView *)rechargeView
{
    if (_rechargeView == nil)
    {
        _rechargeView = [[RechargeView alloc] initWithFrame:CGRectMake(kRechargeMargin, kScreenH, kScreenW-2*kRechargeMargin, kRechargeViewHeight) andUIViewController:self];
        _rechargeView.hidden = YES;
        _rechargeView.delegate = self;
        [self.view addSubview:_rechargeView];
    }
    return _rechargeView;
}

- (OtherChangeView *)otherChangeView
{
    if (_otherChangeView == nil)
    {
        _otherChangeView = [[OtherChangeView alloc] initWithFrame:CGRectMake(kRechargeMargin, kScreenH, kScreenW-2*kRechargeMargin, 300) andUIViewController:self];
        _otherChangeView.hidden = YES;
        _otherChangeView.delegate = self;
        [self.view addSubview:_otherChangeView];
    }
    return _otherChangeView;
}

- (ExchangeView *)exchangeView
{
    if (_exchangeView == nil)
    {
        _exchangeView = [[ExchangeView alloc] initWithFrame:CGRectMake(kRechargeMargin, kScreenH, kScreenW-2*kRechargeMargin, 260)];
        _exchangeView.hidden = YES;
        _exchangeView.delegate = self;
        [self.view addSubview:_exchangeView];
    }
    return _exchangeView;
}

- (void)choseRecharge:(BOOL)recharge orExchange:(BOOL)exchange
{
    [self.liveUIViewController.liveView closeGitfView];
    FWWeakify(self)
    if (recharge)
    {
        self.rechargeView.hidden = NO;
        
        [UIView animateWithDuration:0.5 animations:^{
            
            FWStrongify(self)
            self.rechargeView.transform = CGAffineTransformMakeTranslation(0, (kScreenH-kRechargeViewHeight)/2-kScreenH);
//            self.rechargeView.frame = CGRectMake(10, (kScreenH-kRechargeViewHeight)/2, kScreenW-20, kRechargeViewHeight);
            
        } completion:^(BOOL finished) {
            
        }];
    }
    else if(exchange)
    {
        self.exchangeView.hidden = NO;
        self.exchangeView.model = self.rechargeView.model;
        [UIView animateWithDuration:0.5 animations:^{
            
            FWStrongify(self)
            //self.exchangeView.frame = CGRectMake(10,  kScreenH-230-kNumberBoardHeight, kScreenW-20, 230);
            self.exchangeView.transform = CGAffineTransformMakeTranslation(0, -260-kNumberBoardHeight);
            
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)choseOtherRechargeWithRechargeView:(RechargeView *)rechargeView
{
    self.otherChangeView.hidden = NO;
    self.otherChangeView.selectIndex = rechargeView.indexPayWay;
    self.otherChangeView.model = rechargeView.model;
    self.otherChangeView.otherPayArr = rechargeView.model.pay_list;
    [self.liveUIViewController.liveView closeGitfView];
    
    FWWeakify(self)
    [UIView animateWithDuration:0.5 animations:^{
        
        FWStrongify(self)
        //self.otherChangeView.frame = CGRectMake(10, kScreenH-260-kNumberBoardHeight, kScreenW-20, 260);
        self.otherChangeView.transform = CGAffineTransformMakeTranslation(0, -300-kNumberBoardHeight);
        
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark 点击其它支付的确定按钮
- (void)clickOtherRechergeWithView:(OtherChangeView *)otherView
{
    PayMoneyModel * model = [[PayMoneyModel alloc] init];
    model.hasOtherPay = YES;
    self.rechargeView.money = otherView.textField.text;
    [self.rechargeView payRequestWithModel:model withPayWayIndex:otherView.selectIndex];
}

#pragma mark 点击其它支付的兑换按钮
- (void)clickExchangeWithView:(OtherChangeView *)otherView
{
    [self choseRecharge:NO orExchange:YES];
}

#pragma mark 充值成功后调用
- (void)rechargeSuccessWithRechargeView:(RechargeView *)rechargeView
{
    if (self.liveUIViewController.livePay)//通过这个判断充钱后是否可以看看付费直播的视频
    {
        if (self.liveUIViewController.livePay.isEnterPayLive == 1)
        {
            [self.liveUIViewController.livePay enterMoneyMode];
        }
    }
    
    FWWeakify(self)
    [[IMAPlatform sharedInstance].host getMyInfo:^(AppBlockModel *blockModel) {
        
        FWStrongify(self)
        
        self.liveUIViewController.liveView.currentDiamonds = [[IMAPlatform sharedInstance].host getDiamonds];
        
        // 更新游戏余额
        if (self.liveUIViewController.liveView.goldFlowerView)
        {
            if (self.fanweApp.appModel.open_diamond_game_module == 1)
            {
                self.liveUIViewController.liveView.goldFlowerView.coinView.gameRechargeView.accountLabel.text = [NSString stringWithFormat:@"%ld",[[IMAPlatform sharedInstance].host getDiamonds]];
                self.liveUIViewController.liveView.guessSizeView.gameRechargeView.accountLabel.text = [NSString stringWithFormat:@"%ld",[[IMAPlatform sharedInstance].host getDiamonds]];
            }
            else
            {
                self.liveUIViewController.liveView.goldFlowerView.coinView.gameRechargeView.accountLabel.text = [NSString stringWithFormat:@"%ld",[[IMAPlatform sharedInstance].host getUserCoin]];
                self.liveUIViewController.liveView.guessSizeView.gameRechargeView.accountLabel.text = [NSString stringWithFormat:@"%ld",[[IMAPlatform sharedInstance].host getUserCoin]];
            }
        }
        
        [self.liveUIViewController.liveView.giftView setDiamondsLabelTxt:[NSString stringWithFormat:@"%ld",[[IMAPlatform sharedInstance].host getDiamonds]]];
        self.rechargeView.model.diamonds = [[IMAPlatform sharedInstance].host getDiamonds];
        
        if (self.otherChangeView.hidden == NO)
        {
            [self.otherChangeView disChangeText];
        }
        
    }];
}

- (void)closeRechargeView:(TCShowLiveView *)showLiveView
{
    [self.view endEditing:YES];
    if (self.rechargeView.hidden == NO)
    {
        FWWeakify(self)
        [UIView animateWithDuration:0.5 animations:^{
            
            FWStrongify(self)
            //self.rechargeView.frame = CGRectMake(10, kScreenH, kScreenW-20, kRechargeViewHeight);
            self.rechargeView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            
            FWStrongify(self)
            self.exchangeView.hidden = YES;
            
        }];
    }
    if (self.exchangeView.hidden == NO)
    {
        [self.exchangeView cancleExchange];
    }
    if (self.otherChangeView.hidden == NO)
    {
        [self.otherChangeView disChangeText];
    }
}

@end
