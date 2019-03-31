//
//  FWTLiveController.m
//  FanweApp
//
//  Created by xfg on 16/12/5.
//  Copyright © 2016年 xfg. All rights reserved.
//  腾讯云直播，只处理与SDK有关的业务

#import "FWTLiveController.h"
#import "FWMD5UTils.h"
#import "TLiveMickListModel.h"
#import "YunMusicPlayVC.h"
#import "HostCheckMickAlertView.h"

#define kPlayContrainerHeight 30

@interface FWTLiveController ()

@end

@implementation FWTLiveController

#pragma mark - ----------------------- 添加UI -----------------------

- (void)addSubViews
{
    if (self.liveType == FW_LIVE_TYPE_HOST)
    {
        _beautyView = [[FWTLiveBeautyView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
        [self.liveServiceController.liveUIViewController.liveView addSubview:_beautyView];
        _beautyView.delegate = self;
        _beautyView.hidden = YES;
    }
    else if ([self.liveItem liveType] == FW_LIVE_TYPE_RELIVE)
    {
        _reLiveProgressView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenH-80, kScreenW, kPlayContrainerHeight)];
        _reLiveProgressView.backgroundColor = kClearColor;
        _reLiveProgressView.hidden = YES;
        
        _btnPlay = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnPlay.frame = CGRectMake(kDefaultMargin, 0, kPlayContrainerHeight, kPlayContrainerHeight);
        [_btnPlay setImage:[UIImage imageNamed:@"fw_relive_start"] forState:UIControlStateNormal];
        [_btnPlay addTarget:self action:@selector(onClickPlay) forControlEvents:UIControlEventTouchUpInside];
        [_reLiveProgressView addSubview:_btnPlay];
        
        _playStart = [[UILabel alloc]init];
        _playStart.frame = CGRectMake(kScreenW-75-kDefaultMargin, 0, 75, kPlayContrainerHeight);
        _playStart.font = kAppSmallTextFont;
        [_playStart setText:@"00:00"];
        [_playStart setTextColor:[UIColor whiteColor]];
        [_reLiveProgressView addSubview:_playStart];
        
        _playProgress = [[UISlider alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_btnPlay.frame)+kDefaultMargin, 5, kScreenW-CGRectGetWidth(_btnPlay.frame)-CGRectGetWidth(_playStart.frame)-kDefaultMargin*4, kPlayContrainerHeight-10)];
        [_playProgress setThumbImage:[UIImage imageNamed:@"fw_relive_slider_thumb"] forState:UIControlStateNormal];
        _playProgress.minimumTrackTintColor = kWhiteColor;
        _playProgress.maximumTrackTintColor = kAppGrayColor2;
        _playProgress.maximumValue = 0;
        _playProgress.minimumValue = 0;
        _playProgress.value = 0;
        _playProgress.continuous = NO;
        [_playProgress addTarget:self action:@selector(onSeek) forControlEvents:(UIControlEventValueChanged)];
        [_playProgress addTarget:self action:@selector(onSeekBegin) forControlEvents:(UIControlEventTouchDown)];
        [_playProgress addTarget:self action:@selector(onDrag) forControlEvents:UIControlEventTouchDragInside];
        [_playProgress addTarget:self action:@selector(dragSliderDidEnd:) forControlEvents:UIControlEventTouchUpInside];
        [_reLiveProgressView addSubview:_playProgress];
    }
    
    if (self.liveType == FW_LIVE_TYPE_RELIVE || self.liveType == FW_LIVE_TYPE_AUDIENCE)
    {
        self.backVerticalBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, 15, 35, 35)];
        [self.backVerticalBtn setImage:[UIImage imageNamed:@"com_arrow_vc_back_2"] forState:UIControlStateNormal];
        [self.backVerticalBtn addTarget:self action:@selector(goVerticalScreen) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.backVerticalBtn];
        self.backVerticalBtn.hidden = YES;
    }
}

#pragma mark 添加视频
- (void)initLive
{
    // 付费直播控制云直播声音
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(voiceNotice:) name:@"closeAndOpenVoice" object:nil];
    
    // 音量监听
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(volumeChanged:) name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
    
    // 屏幕旋转监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    if (self.liveType == FW_LIVE_TYPE_HOST)
    {
        _publishController = [[FWTLinkMicPublishController alloc] init];
        _publishController.delegate = self;
        _publishController.linkMicPublishDelegate = self;
        _publishController.roomIDStr = _roomIDStr;
        [self addChild:_publishController inRect:self.view.bounds];
        [self.view sendSubviewToBack:_publishController.view];
        [_publishController.txLivePublisher setMirror:NO];
    }
    else if (self.liveType == FW_LIVE_TYPE_RELIVE)
    {
        _playController = [[FWTPlayController alloc] init];
        _playController.liveType = [self.liveItem liveType];
        _playController.delegate = self;
        [self addChild:_playController inRect:self.view.bounds];
        [self.view sendSubviewToBack:_playController.view];
    }
    else if (self.liveType == FW_LIVE_TYPE_AUDIENCE)
    {
        _linkMicPlayController = [[FWTLinkMicPlayController alloc] init];
        _linkMicPlayController.liveType = [self.liveItem liveType];
        _linkMicPlayController.delegate = self;
        _linkMicPlayController.linkMicPlayDelegate = self;
        [self addChild:_linkMicPlayController inRect:self.view.bounds];
        [self.view sendSubviewToBack:_linkMicPlayController.view];
    }
}

#pragma mark 添加直播间逻辑、视图
- (void)addServiceController
{
    if (!_liveServiceController)
    {
        _liveServiceController = [[FWLiveServiceController alloc]initWith:self.liveItem liveController:self];
        _liveServiceController.delegate = self;
        _liveServiceController.pluginCenterView.toolsView.toSDKdelegate = self;
        _liveServiceController.liveUIViewController.liveView.sdkDelegate = self;
        _liveServiceController.liveUIViewController.liveView.topView.toSDKDelegate = self;
        [self addChild:_liveServiceController inRect:self.view.bounds];
    }
}


#pragma mark - ----------------------- 重写父方法 -----------------------
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (instancetype)initWith:(id<FWShowLiveRoomAble>)liveItem
{
    if (self = [super initWith:liveItem])
    {
        [self addServiceController];
        [self addSubViews];
    }
    return self;
}

- (void)refreshLiveItem:(id<FWShowLiveRoomAble>)liveItem liveInfo:(CurrentLiveInfo *)liveInfo
{
    [super refreshLiveItem:liveItem liveInfo:liveInfo];
    
    [_liveServiceController refreshLiveItem:liveItem liveInfo:liveInfo];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.fanweApp.appModel.mic_max_num >= 3 || self.fanweApp.appModel.mic_max_num == 0)
    {
        _micMaxNum = 3;
    }
    else
    {
        _micMaxNum = self.fanweApp.appModel.mic_max_num;
    }
    
    //初始化直播
    [self initLive];
}

#pragma mark 腾讯云直播开始进入直播间：根据是否传入了聊天组ID选择对应的进入直播间的方案
- (void)startEnterChatGroup:(NSString *)chatGroupID succ:(FWVoidBlock)succ failed:(FWErrorBlock)failed
{
    __weak typeof(self) ws = self;
    
    [_liveServiceController getVideo:^(CurrentLiveInfo *liveInfo) {
        
        if (liveInfo)
        {
            ws.liveInfo = liveInfo;
            ws.hasVideoControl = liveInfo.has_video_control ? YES : NO;
            
            if ([self.liveItem liveType] == FW_LIVE_TYPE_RELIVE && liveInfo.has_video_control)
            {
                _reLiveProgressView.hidden = NO;
            }
            else
            {
                _reLiveProgressView.hidden = YES;
            }
            
            ws.liveServiceController.liveUIViewController.livePay.payDelegate = self;
            
            if (![FWUtils isBlankString:liveInfo.push_rtmp] || ![FWUtils isBlankString:liveInfo.play_url])
            {
                [ws beginPlayVideo:liveInfo];
            }
            
            if (liveInfo.is_live_pay == 1 && liveInfo.is_pay_over == 0 && ![liveInfo.podcast.user.user_id isEqualToString:[[IMAPlatform sharedInstance].host imUserId]])
            {
                if (succ)
                {
                    succ();
                }
            }
            else
            {
                [super startEnterChatGroup:liveInfo.group_id succ:^{
                    
                    [ws getVideoState:1];
                    
                    if (succ)
                    {
                        succ();
                    }
                    
                } failed:^(int errId, NSString *errMsg) {
                    
                    [ws getVideoState:0];
                    
                    if (failed)
                    {
                        failed(errId, errMsg);
                    }
                }];
            }
        }
        else
        {
            [ws setGetVideoFailed:nil];
            
            if (failed)
            {
                failed(FWCode_Net_Error, @"获取到的liveInfo为空");
            }
        }
    } failed:^(int errId, NSString *errMsg) {
        
        [ws setGetVideoFailed:errMsg];
        
        if (failed)
        {
            failed(errId, errMsg);
        }
        
        DebugLog(@"=========加载get_video接口出错 code: %d , msg = %@", errId, errMsg);
        
    }];
}

#pragma mark 加入聊天组成功
- (void)enterChatGroupSucc:(CurrentLiveInfo *)liveInfo
{
    [super enterChatGroupSucc:liveInfo];
    
    if (!_isHost && (_liveInfo.join_room_prompt == 1 || [[IMAPlatform sharedInstance].host getUserRank] >= self.fanweApp.appModel.jr_user_level))
    {
        _liveServiceController.liveUIViewController.liveView.canShowLightMessage = YES;
    }
}

#pragma mark 重写父方法： 业务上退出直播：退出的时候分SDK退出和业务退出，减少退出等待时间
- (void)onServiceExitLive:(BOOL)isDirectCloseLive succ:(FWVoidBlock)succ failed:(FWErrorBlock)failed
{
    [_liveServiceController endLive];
    
    if (self.liveType == FW_LIVE_TYPE_HOST)  // 主播
    {
        [_publishController endLive];
        [_liveServiceController showHostFinishView:@"" andVote:@"" andHasDel:NO];
        
        __weak typeof(self) ws = self;
        
        [_liveServiceController hostExitLive:^{
            
            if(isDirectCloseLive)
            {
                [ws onExitLiveUI];
            }
            if (succ)
            {
                succ();
            }
        } failed:^(int errId, NSString *errMsg) {
            
            if(isDirectCloseLive)
            {
                [ws onExitLiveUI];
            }
            
            if (failed)
            {
                failed(errId, errMsg);
            }
            
        }];
        
        [_publishController stopRtmp];
    }
    else
    {
        if (self.liveType == FW_LIVE_TYPE_RELIVE)
        {
            [_playController stopRtmp];
        }
        else if (self.liveType == FW_LIVE_TYPE_AUDIENCE)
        {
            [_linkMicPlayController endVideo];
            [self cancelMickingAlert];
            
            if ([_linkMicPlayController.linkMemeberSet containsObject:[[IMAPlatform sharedInstance].host imUserId]])
            {
                [FWLiveSDKViewModel tLiveStopMick:_roomIDStr toUserId:@""];
            }
        }
        
        if(isDirectCloseLive)
        {
            [self onExitLiveUI];
        }
        
        if (succ)
        {
            succ();
        }
    }
}

#pragma mark 是否需要打断视频
- (void)interruptionLiveIng:(BOOL)interruptioning
{
    if (interruptioning)
    {
        [_liveServiceController pauseLive];
        
        if ([self.liveItem liveType] == FW_LIVE_TYPE_HOST)
        {
            [_publishController.txLivePublisher pausePush];
        }
        else if([self.liveItem liveType] == FW_LIVE_TYPE_RELIVE)
        {
            [_playController onAppDidEnterBackGround];
        }
        else if([self.liveItem liveType] == FW_LIVE_TYPE_AUDIENCE)
        {
            [_linkMicPlayController onAppDidEnterBackGround];
        }
    }
    else
    {
        [_liveServiceController resumeLive];
        
        if ([self.liveItem liveType] == FW_LIVE_TYPE_HOST) // 直播的主播
        {
            [_publishController.txLivePublisher resumePush];
        }
        else if([self.liveItem liveType] == FW_LIVE_TYPE_RELIVE)
        {
            [_playController onAppWillEnterForeground];
        }
        else if([self.liveItem liveType] == FW_LIVE_TYPE_AUDIENCE)
        {
            [_linkMicPlayController onAppWillEnterForeground];
        }
    }
}

#pragma mark 是否正在被电话打断
- (void)phoneInterruptioning:(BOOL)interruptioning
{
    [super phoneInterruptioning:interruptioning];
    
    [self interruptionLiveIng:interruptioning];
}

#pragma mark app进入前台
- (void)onAppEnterForeground
{
    [super onAppEnterForeground];
    
    if (_isHost)
    {
        [super onAppEnterForeground];
        [_publishController.txLivePublisher resumePush];
    }
    else
    {
        if (_isMickAudiencePushing)
        {
            _isMickAudiencePushing = NO;
            [_linkMicPlayController.txLivePush resumePush];
        }
    }
}

#pragma mark app进入后台
- (void)onAppEnterBackground
{
    [super onAppEnterBackground];
    
    if (_isHost)
    {
        [super onAppEnterBackground];
        [_publishController.txLivePublisher pausePush];
    }
    else
    {
        if (_linkMicPlayController.txLivePush.isPublishing)
        {
            _isMickAudiencePushing = YES;
            [_linkMicPlayController.txLivePush pausePush];
        }
    }
    
    if (_toolsView)
    {
        // 关闭LED
        [FWUtils turnOnFlash:NO];
        
        ToolsCollectionViewCell *cell = (ToolsCollectionViewCell *)[_toolsView.toolsCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
        if (cell)
        {
            cell.toolImgView.image = [UIImage imageNamed:@"lr_plugin_flash_unsel"];
        }
    }
}

#pragma mark 重写退出方法
- (void)onExitLiveUI
{
    [super onExitLiveUI];
    
    // 执行下 悬浮参数退出
    if (SUS_WINDOW.isSusWindow &&SUS_WINDOW.isDirectCloseLive == YES)
    {
        [[LiveCenterManager sharedInstance]resetSuswindowPramaComple:^(BOOL finished) {
        }];
    }
    
    [_liveServiceController endLive];
    [_liveServiceController.view removeFromSuperview];
    //    _liveServiceController = nil;
    if (_publishController)
    {
        _publishController = nil;
    }
    if (_playController)
    {
        _playController = nil;
    }
    if (_linkMicPlayController)
    {
        _linkMicPlayController = nil;
    }
    
    if (!SUS_WINDOW.isSusWindow)
    {
        self.navigationController.navigationBarHidden = NO;
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark 重写声音打断监听
- (void)onAudioInterruption:(NSNotification *)notification
{
    [super onAudioInterruption:notification];
    
    if(self.liveType == FW_LIVE_TYPE_RELIVE)
    {
        [_playController onAudioInterruption:notification];
    }
    else if(self.liveType == FW_LIVE_TYPE_AUDIENCE)
    {
        [_linkMicPlayController onAudioInterruption:notification];
    }
}

#pragma mark 监听耳机插入和拔出
- (void)audioRouteChangeListenerCallback:(NSNotification *)notification
{
    [super audioRouteChangeListenerCallback:notification];
    
    NSDictionary *interuptionDict = notification.userInfo;
    NSInteger routeChangeReason = [[interuptionDict valueForKey:AVAudioSessionRouteChangeReasonKey] integerValue];
    switch (routeChangeReason)
    {
        case AVAudioSessionRouteChangeReasonNewDeviceAvailable:     // 耳机插入
            
            // 开启耳返功能
            _publishController.txLivePushonfig.enableAudioPreview = YES;
            [_publishController.txLivePublisher setConfig:_publishController.txLivePushonfig];
            
            break;
        case AVAudioSessionRouteChangeReasonOldDeviceUnavailable:   // 耳机拔出，停止播放操作
            
            // 关闭耳返功能
            _publishController.txLivePushonfig.enableAudioPreview = NO;
            [_publishController.txLivePublisher setConfig:_publishController.txLivePushonfig];
            
            break;
        case AVAudioSessionRouteChangeReasonCategoryChange:
            // called at start - also when other audio wants to play
            NSLog(@"AVAudioSessionRouteChangeReasonCategoryChange");
            break;
    }
}

#pragma mark 重写弹出退出或直接退出
/**
 重写 弹出退出或直接退出
 
 @param isDirectCloseLive 该参数针对主播、观众，表示是否直播关闭直播，而不显示结束界面
 @param isHostShowAlert 该参数针对主播，表示主播是否需要弹出“您当前正在直播，是否退出直播？”，正常情况都需要弹出这个，不需要弹出的情况：1、当前直播被后台系统关闭了的情况 2、SDK结束了直播
 @param succ 成功回调
 @param failed 失败回调
 */
- (void)alertExitLive:(BOOL)isDirectCloseLive isHostShowAlert:(BOOL)isHostShowAlert succ:(FWVoidBlock)succ failed:(FWErrorBlock)failed
{
    //在后面退出 基础类需要 这个判断 需不需要 Finish界面
    self.isDirectCloseLive = isDirectCloseLive;
    
    LiveCenterManager *liveCenterManager = [LiveCenterManager sharedInstance];
    [liveCenterManager closeLiveOfPramaOfLiveViewController:self paiTimeNum:self.liveServiceController.auctionTool.paiTime alertExitLive:isDirectCloseLive isHostShowAlert:isHostShowAlert colseLivecomplete:^(BOOL finished) {
        
        if (finished)
        {
            if (succ)
            {
                succ();
            }
        }
        else
        {
            if (failed)
            {
                failed(FWCode_Normal_Error, @"");
            }
        }
    }];
}


#pragma mark - ----------------------- 部分业务逻辑 -----------------------
#pragma mark 请求get_video接口失败的情况
- (void)setGetVideoFailed:(NSString *)errMsg
{
    NSString *errStr = errMsg;
    
    if ([FWUtils isBlankString:errStr])
    {
        errStr = @"获取聊天室信息失败，请稍候尝试";
    }
    
    [self getVideoState:0];
    
    __weak typeof(self) ws = self;
    [FWHUDHelper alert:errStr action:^{
        [ws onExitLiveUI];
    }];
}

#pragma mark 真正开始播放
- (void)beginPlayVideo:(CurrentLiveInfo *)liveInfo
{
    _iMMsgHandler.isEnterRooming = NO;
    
    __weak typeof(self) ws = self;
    
    if (self.liveType == FW_LIVE_TYPE_HOST)
    {
        if (liveInfo.push_rtmp && ![liveInfo.push_rtmp isEqualToString:@""])
        {
            _publishController.pushUrlStr = liveInfo.push_rtmp;
            [_publishController startRtmp];
        }
        else
        {
            [FWHUDHelper alert:@"抱歉，推流地址为空，请稍后尝试" action:^{
                [ws alertExitLive:YES isHostShowAlert:NO succ:nil failed:nil];
            }];
        }
    }
    else if (self.liveType == FW_LIVE_TYPE_RELIVE)
    {
        if (liveInfo.has_video_control)
        {
            [_liveServiceController.liveUIViewController.liveView addSubview:_reLiveProgressView];
        }
        
        _playController.playProgress = _playProgress;
        _playController.playStart = _playStart;
        _playController.btnPlay = _btnPlay;
        
        if (liveInfo.play_url && ![liveInfo.play_url isEqualToString:@""])
        {
            _playController.playUrlStr = liveInfo.play_url;
            [_playController clickPlay:_btnPlay create_type:liveInfo.create_type];
        }
        else
        {
            [FWHUDHelper alert:@"视频已删除." action:^{
                [ws alertExitLive:YES isHostShowAlert:NO succ:nil failed:nil];
            }];
        }
    }
    else if (self.liveType == FW_LIVE_TYPE_AUDIENCE)
    {
        if (liveInfo.play_url && ![liveInfo.play_url isEqualToString:@""])
        {
            if (!([self.fanweApp.appModel.open_vip intValue] == 1 && liveInfo.is_vip == 0))
            {
                _linkMicPlayController.playUrlStr = liveInfo.play_url;
                [_linkMicPlayController startRtmp:liveInfo.create_type];
            }
        }
        else
        {
            [FWHUDHelper alert:@"抱歉，播放地址为空，请稍后尝试" action:^{
                [ws alertExitLive:YES isHostShowAlert:NO succ:nil failed:nil];
            }];
        }
    }
    
    if (_isHost)
    {
        [_liveServiceController startLiveTimer];
    }
}

#pragma mark 请求video_cstatus接口来获取直播间信息
- (void)getVideoState:(NSInteger)state
{
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    [mDict setObject:@"video" forKey:@"ctl"];
    [mDict setObject:@"video_cstatus" forKey:@"act"];
    [mDict setObject:[NSString stringWithFormat:@"%d",[self.liveItem liveAVRoomId]] forKey:@"room_id"];
    [mDict setObject:StringFromInteger(state) forKey:@"status"];
    if ([self.liveItem liveIMChatRoomId] && ![[self.liveItem liveIMChatRoomId] isEqualToString:@""])
    {
        [mDict setObject:[self.liveItem liveIMChatRoomId] forKey:@"group_id"];
    }
    
    [_liveServiceController getVideoState:mDict];
}


#pragma mark - ----------------------- 回放相关界面事件操作 -----------------------
#pragma mark 进度条事件
- (void)onClickPlay
{
    [_playController clickPlay:_btnPlay create_type:self.liveInfo.create_type];
}

- (void)onSeek
{
    [_playController onSeek:_playProgress];
}

- (void)onSeekBegin
{
    [_playController onSeekBegin:_playProgress];
}

- (void)onDrag
{
    [_playController onDrag:_playProgress];
}

- (void)dragSliderDidEnd:(UISlider *)slider
{
    [_playController dragSliderDidEnd:_playProgress];
}


#pragma mark - ----------------------- 连麦 -----------------------
#pragma mark 观众检查是否有连麦权限（主播不需要此操作）
- (void)audienceCheckMick
{
    //检查是否有连麦权限
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    [mDict setObject:@"video" forKey:@"ctl"];
    [mDict setObject:@"check_lianmai" forKey:@"act"];
    [mDict setObject:_roomIDStr forKey:@"room_id"];
    
    [SVProgressHUD show];
    
    [self.httpsManager POSTWithParameters:mDict SuccessBlock:^(NSDictionary *responseJson) {
        
        [SVProgressHUD dismiss];
        
        if ([responseJson toInt:@"status"] == 1)
        {
            __weak FWIMMsgHandler *wd = _iMMsgHandler;
            
            FWWeakify(self)
            [FanweMessage alert:nil message:@"是否请求与主播连麦？" destructiveAction:^{
                
                FWStrongify(self)
                SendCustomMsgModel *sendCustomMsgModel = [[SendCustomMsgModel alloc] init];
                sendCustomMsgModel.msgType = MSG_APPLY_MIKE;
                sendCustomMsgModel.msgReceiver = [self.liveItem liveHost];
                
                [wd sendCustomC2CMsg:sendCustomMsgModel succ:^{
                    [self performSelector:@selector(alertLinkMicking) withObject:nil afterDelay:0.2];
                } fail:^(int code, NSString *msg) {
                    [FanweMessage alertHUD:@"您的连麦申请发送失败"];
                }];
                
            } cancelAction:^{
                
            }];
        }
        
    } FailureBlock:^(NSError *error) {
        
    }];
}

#pragma mark 主播判断某个观众是否互动观众
- (BOOL)isInteractUser:(NSString *)userId
{
    if (userId)
    {
        for (NSString *tmpUserId in _linkMicPlayController.linkMemeberSet)
        {
            if ([userId isEqualToString:tmpUserId])
            {
                return YES;
            }
        }
    }
    return NO;
}

#pragma mark 观众发起连麦，关闭连麦
- (void)openOrCloseMike:(FWLiveServiceController *)liveServiceController
{
    if (_linkMicPlayController.isWaitingResponse)
    {
        [FanweMessage alertHUD:@"连麦申请中..."];
        return;
    }
    
    if ([self isInteractUser:[[IMAPlatform sharedInstance].host imUserId]])
    {
        FWWeakify(self)
        [FanweMessage alert:nil message:@"是否结束与主播的互动连麦？" destructiveAction:^{
            
            FWStrongify(self)
            [self.linkMicPlayController stopLinkMic];
            [self.linkMicPlayController startRtmp:self.liveInfo.create_type];
            
        } cancelAction:^{
            
        }];
    }
    else
    {
        [self audienceCheckMick];
    }
}

#pragma mark 申请连麦中，等待对方应答...
- (void)alertLinkMicking
{
    _isApplyMicking = YES;
    
    FWWeakify(self)
    _applyMickingAlert = [FanweMessage alert:@"提示" message:@"申请连麦中，等待对方应答..." isHideTitle:NO destructiveTitle:@"取消连麦" destructiveAction:^{
        
        FWStrongify(self)
        self.isApplyMicking = NO;
        [self performSelector:@selector(releaseMickingAlert) withObject:nil afterDelay:0.5];
        SendCustomMsgModel *sendCustomMsgModel = [[SendCustomMsgModel alloc] init];
        sendCustomMsgModel.msgType = MSG_BREAK_MIKE;
        sendCustomMsgModel.msgReceiver = [self.liveItem liveHost];
        [self.iMMsgHandler sendCustomC2CMsg:sendCustomMsgModel succ:nil fail:nil];
        
    }];
}

#pragma mark 关闭申请连麦中的提示
- (void)cancelMickingAlert
{
    if (_applyMickingAlert)
    {
        _isApplyMicking = NO;
        [_applyMickingAlert hide];
        
        [self performSelector:@selector(releaseMickingAlert) withObject:nil afterDelay:0.5];
    }
}

- (void)releaseMickingAlert
{
    if (_applyMickingAlert)
    {
        _applyMickingAlert = nil;
    }
}

- (void)releaseHostMickingAlert
{
    if (_hostMickingAlert)
    {
        _hostMickingAlert = nil;
    }
}

#pragma mark 主播获取连麦参数
- (void)getMickPara:(CustomMessageModel *)customMessageModel
{
    _isResponseMicking = YES;
    
    //检查是否有连麦权限
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    [mDict setObject:@"video" forKey:@"ctl"];
    [mDict setObject:@"start_lianmai" forKey:@"act"];
    [mDict setObject:_roomIDStr forKey:@"room_id"];
    [mDict setObject:customMessageModel.sender.user_id forKey:@"to_user_id"];
    
    __weak typeof(self) ws = self;
    __weak FWIMMsgHandler *wm = (FWIMMsgHandler *)_iMMsgHandler;
    
    [self.httpsManager POSTWithParameters:mDict SuccessBlock:^(NSDictionary *responseJson) {
        
        if ([responseJson toInt:@"status"] == 1)
        {
            NSString *push_rtmp2 = [responseJson toString:@"push_rtmp2"];
            NSString *play_rtmp_acc = [responseJson toString:@"play_rtmp_acc"];
            if (![FWUtils isBlankString:push_rtmp2] && ![FWUtils isBlankString:play_rtmp_acc])
            {
                SendCustomMsgModel *sendCustomMsgModel = [[SendCustomMsgModel alloc] init];
                sendCustomMsgModel.msgType = MSG_RECEIVE_MIKE;
                sendCustomMsgModel.push_rtmp2 = push_rtmp2;
                sendCustomMsgModel.play_rtmp_acc = play_rtmp_acc;
                sendCustomMsgModel.msgReceiver = customMessageModel.sender;
                [wm sendCustomC2CMsg:sendCustomMsgModel succ:nil fail:nil];
                
                [ws.publishController agreeLinkMick:[responseJson toString:@"play_rtmp2_acc"] applicant:customMessageModel.sender.user_id];
            }
            else
            {
                ws.isResponseMicking = NO;
                [FanweMessage alertHUD:@"获取连麦参数失败"];
            }
        }
        else
        {
            ws.isResponseMicking = NO;
        }
    } FailureBlock:^(NSError *error) {
        
        ws.isResponseMicking = NO;
        
    }];
}

#pragma mark 主播收到观众连麦请求
- (void)onRecvGuestApply:(CustomMessageModel *)customMessageModel
{
    SenderModel *sender = customMessageModel.sender;
    if ([_publishController.linkMemeberSet count] >= _micMaxNum || _hostMickingAlert || _isResponseMicking)
    {
        SendCustomMsgModel *sendCustomMsgModel = [[SendCustomMsgModel alloc] init];
        sendCustomMsgModel.msgType = MSG_REFUSE_MIKE;
        sendCustomMsgModel.msgReceiver = customMessageModel.sender;
        
        if (_hostMickingAlert || _isResponseMicking)
        {
            sendCustomMsgModel.msg = @"主播有未处理的连麦请求，请稍候再试";
            [_iMMsgHandler sendCustomC2CMsg:sendCustomMsgModel succ:nil fail:nil];
        }
        else
        {
            DebugLog(@"已达到请求上限，不能再请求");
            
            sendCustomMsgModel.msg = @"当前主播连麦数已上限，请稍后尝试";
            [_iMMsgHandler sendCustomC2CMsg:sendCustomMsgModel succ:nil fail:nil];
        }
    }
    else
    {
        __weak FWIMMsgHandler *wm = (FWIMMsgHandler *)_iMMsgHandler;
        NSString *text = [NSString stringWithFormat:@"观众(%@)申请参加您的互动直播", [sender imUserName]];
        
        FWWeakify(self)
        _hostMickingAlert = [FanweMessage alert:@"互动直播申请" message:text destructiveTitle:@"同意" destructiveAction:^{
            
            FWStrongify(self)
            //  同意
            [self getMickPara:customMessageModel];
            
            [self performSelector:@selector(releaseHostMickingAlert) withObject:nil afterDelay:0.2];
            
        } cancelTitle:@"拒绝" cancelAction:^{
            
            FWStrongify(self)
            //  拒绝
            SendCustomMsgModel *sendCustomMsgModel = [[SendCustomMsgModel alloc] init];
            sendCustomMsgModel.msgType = MSG_REFUSE_MIKE;
            sendCustomMsgModel.msgReceiver = customMessageModel.sender;
            [wm sendCustomC2CMsg:sendCustomMsgModel succ:nil fail:nil];
            
            [self performSelector:@selector(releaseHostMickingAlert) withObject:nil afterDelay:0.2];
            
        }];
    }
}

#pragma mark 主播未处理连麦申请时，kApplyMikeTime秒后关闭申请连麦弹出框
- (void)closeAlertView
{
    if (_hostMickingAlert)
    {
        [_hostMickingAlert hide];
        [self performSelector:@selector(releaseHostMickingAlert) withObject:nil afterDelay:0.2];
    }
}

- (void)showRefuseHud:(NSString *)refuseStr
{
    [FanweMessage alertTWMessage:refuseStr];
}

#pragma mark FWTLinkMicPlayControllerDelegate
/*
 *  观众端连麦结果
 *  isSucc：是否上麦
 *  userID：当前用户ID
 */
- (void)pushMickResult:(BOOL)isSucc userID:(NSString *)userID
{
    if (![FWUtils isBlankString:userID])
    {
        if (isSucc)
        {
            if ([[[IMAPlatform sharedInstance].host imUserId] isEqualToString:userID])
            {
                [FWLiveSDKViewModel tLiveMixStream:_roomIDStr toUserId:@""];
            }
        }
        else
        {
            if ([[[IMAPlatform sharedInstance].host imUserId] isEqualToString:userID])
            {
                [FWLiveSDKViewModel tLiveStopMick:_roomIDStr toUserId:@""];
            }
            
            SendCustomMsgModel *sendCustomMsgModel = [[SendCustomMsgModel alloc] init];
            sendCustomMsgModel.msgType = MSG_BREAK_MIKE;
            sendCustomMsgModel.msgReceiver = [self.liveItem liveHost];
            
            [_iMMsgHandler sendCustomC2CMsg:sendCustomMsgModel succ:nil fail:nil];
        }
    }
}

#pragma mark FWTLinkMicPublishControllerDelegate
/*
 *  主播端连麦结果
 *  isSucc：是否拉取观众连麦加速流成功
 *  userID：拉取的连麦观众对应的ID
 */
- (void)playMickResult:(BOOL)isSucc userID:(NSString *)userID
{
    _isResponseMicking = NO;
    
    if (![FWUtils isBlankString:userID])
    {
        if (isSucc)
        {
            [FWLiveSDKViewModel tLiveMixStream:_roomIDStr toUserId:userID];
        }
    }
}

#pragma mark 主播点击屏幕时，判断是否点击了连麦窗口
- (void)hostReceiveTouch:(UITouch *)touch
{
    if ([_publishController.linkMemeberSet count])
    {
        for (NSString *user in _publishController.linkMemeberSet)
        {
            FWTLinkMicPlayItem *playItem = [self.publishController getPlayItemByUserID:user];
            if (playItem)
            {
                if(CGRectContainsPoint(playItem.videoView.frame, [touch locationInView:self.publishController.view]))
                {
                    UserModel *userModel;
                    for (UserModel *tmpModel in _liveServiceController.liveUIViewController.liveView.topView.userArray)
                    {
                        if ([tmpModel.user_id isEqualToString:user])
                        {
                            userModel = tmpModel;
                            break;
                        }
                    }
                    if (!userModel)
                    {
                        userModel = [[UserModel alloc]init];
                        userModel.user_id = user;
                    }
                    
                    MMPopupCompletionBlock completeBlock = ^(MMPopupView *popupView, BOOL finished){
                        NSLog(@"animation complete");
                    };
                    
                    HostCheckMickAlertView *view = [[HostCheckMickAlertView alloc] initAlertView:userModel closeMickBlock:^(UserModel *userModel) {
                        
                        SendCustomMsgModel *sendCustomMsgModel = [[SendCustomMsgModel alloc] init];
                        sendCustomMsgModel.msgType = MSG_BREAK_MIKE;
                        sendCustomMsgModel.msgReceiver = userModel;
                        [[FWIMMsgHandler sharedInstance] sendCustomC2CMsg:sendCustomMsgModel succ:nil fail:nil];
                        [FWLiveSDKViewModel tLiveStopMick:_roomIDStr toUserId:userModel.user_id];
                        
                    }];
                    [view showWithBlock:completeBlock];
                }
            }
        }
    }
}


#pragma mark - ----------------------- 横竖屏 -----------------------
- (void)goVerticalScreen
{
    [self interfaceOrientation:UIInterfaceOrientationPortrait];
}

#pragma mark PC直播或者PC回播，观众端的点击全屏事件
- (void)clickFullScreen
{
    [self interfaceOrientation:UIInterfaceOrientationLandscapeRight];
}

- (void)interfaceOrientation:(UIInterfaceOrientation)orientation
{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)])
    {
        SEL selector             = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val                  = orientation;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

- (void)deviceOrientationDidChange
{
    if (self.liveInfo.create_type == 1)
    {
        NSLog(@"deviceOrientationDidChange:%ld",(long)[UIDevice currentDevice].orientation);
        if([UIDevice currentDevice].orientation == UIDeviceOrientationPortrait)
        {
            [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait];
            [self orientationChange:kDirectionTypeDefault];
        }
        else if ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft)
        {
            [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight];
            [self orientationChange:kDirectionTypeLeft];
        }
    }
}

- (void)orientationChange:(kDirectionType)landscape
{
    if (landscape == kDirectionTypeDefault)
    {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        _liveServiceController.liveUIViewController.liveView.hidden = NO;
        _liveServiceController.closeBtn.hidden = NO;
        
        [UIView animateWithDuration:0.2f animations:^{
            self.view.transform = CGAffineTransformMakeRotation(0);
            self.view.bounds = CGRectMake(0, 0, kScreenW, kScreenH);
            
            if (self.liveType == FW_LIVE_TYPE_RELIVE)
            {
                _playController.videoContrainerView.frame = CGRectMake(0, 0, kScreenW, kScreenH);
                self.backVerticalBtn.hidden = YES;
            }
            else if (self.liveType == FW_LIVE_TYPE_AUDIENCE)
            {
                _linkMicPlayController.videoContrainerView.frame = CGRectMake(0, 0, kScreenW, kScreenH);
                self.backVerticalBtn.hidden = YES;
            }
        }];
    }
    else if (landscape == kDirectionTypeLeft)
    {
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        _liveServiceController.liveUIViewController.liveView.hidden = YES;
        _liveServiceController.closeBtn.hidden = YES;
        
        [UIView animateWithDuration:0.2f animations:^{
            self.view.transform = CGAffineTransformMakeRotation(M_PI_2);
            self.view.bounds = CGRectMake(0, 0, kScreenW, kScreenH);
            
            if (self.liveType == FW_LIVE_TYPE_RELIVE)
            {
                _playController.videoContrainerView.frame = CGRectMake(0, 0, kScreenW, kScreenH);
                self.backVerticalBtn.hidden = NO;
            }
            else if (self.liveType == FW_LIVE_TYPE_AUDIENCE)
            {
                _linkMicPlayController.videoContrainerView.frame = CGRectMake(0, 0, kScreenW, kScreenH);
                self.backVerticalBtn.hidden = NO;
            }
        }];
    }
}


#pragma mark - ----------------------- 代理方法 -----------------------
#pragma mark FWLiveServiceControllerDelegate
#pragma mark 收到自定义C2C消息
- (void)recvCustomC2C:(id<AVIMMsgAble>)msg
{
    if (![msg isKindOfClass:[CustomMessageModel class]])
    {
        return;
    }
    CustomMessageModel *customMessageModel = (CustomMessageModel *)msg;
    switch (customMessageModel.type)
    {
        case MSG_APPLY_MIKE:    // 观众申请连麦（主播收到观众连麦请求消息）
        {
            // 关闭键盘
            [FWUtils closeKeyboard];
            
            _linkMicPlayController.isWaitingResponse = YES;
            [self onRecvGuestApply:customMessageModel];
        }
            break;
        case MSG_RECEIVE_MIKE:  // 主播接受连麦（观众收到主播接受连麦消息）
        {
            if (_isApplyMicking)
            {
                // 关闭键盘
                [FWUtils closeKeyboard];
                
                if (![FWUtils isBlankString:customMessageModel.push_rtmp2] && ![FWUtils isBlankString:customMessageModel.play_rtmp_acc])
                {
                    [_linkMicPlayController stopRtmp];
                    
                    //开始连麦，启动推流
                    _linkMicPlayController.push_rtmp2 = customMessageModel.push_rtmp2;
                    _linkMicPlayController.play_rtmp_acc = customMessageModel.play_rtmp_acc;
                    _linkMicPlayController.isWaitingResponse = NO;
                    [_linkMicPlayController startLinkMic];
                    
                    [self cancelMickingAlert];
                }
                else
                {
                    [FanweMessage alertHUD:@"获取连麦参数失败"];
                }
            }
        }
            break;
        case MSG_REFUSE_MIKE:   // 主播拒绝连麦（观众收到主播拒绝连麦消息）
        {
            [self cancelMickingAlert];
            
            _linkMicPlayController.isWaitingResponse = NO;
            
            NSString *refuseStr = @"主播拒绝了您的连麦请求";
            
            if (![FWUtils isBlankString:customMessageModel.msg])
            {
                refuseStr = customMessageModel.msg;
            }
            
            [self showRefuseHud:refuseStr];
        }
            break;
        case MSG_BREAK_MIKE:    // 断开连麦（观众收到主播断开连麦消息 或者 主播收到观众主动断开连麦消息）
        {
            if (_isHost) // 主播收到观众主动断开连麦消息
            {
                [self closeAlertView];
                [_publishController breakLinkMick:customMessageModel.sender.user_id];
            }
            else
            {
                [_linkMicPlayController stopLinkMic];
                [_linkMicPlayController startRtmp:self.liveInfo.create_type];
            }
        }
            break;
            
        default:
            break;
    }
}

#pragma mark 收到自定义的Group消息
- (void)recvCustomGroup:(id<AVIMMsgAble>)msg
{
    if (![msg isKindOfClass:[CustomMessageModel class]])
    {
        return;
    }
    CustomMessageModel *customMessageModel = (CustomMessageModel *)msg;
    switch (customMessageModel.type)
    {
        case MSG_REFRESH_AUDIENCE_LIST:    // 主播、所有连麦观众收到的定时连麦消息
        {
            // 当 data_type == 1，主播、所有连麦观众收到的定时连麦消息
            if (customMessageModel.data_type == 1)
            {
                TLiveMickListModel *mickListModel = [TLiveMickListModel mj_objectWithKeyValues:customMessageModel.data];
                
                if (self.liveType == FW_LIVE_TYPE_HOST)
                {
                    [_publishController adjustPlayItem:mickListModel];
                }
                else if(self.liveType == FW_LIVE_TYPE_AUDIENCE)
                {
                    [_linkMicPlayController adjustPlayItem:mickListModel];
                }
            }
        }
            break;
            
        default:
            break;
    }
}

#pragma mark 请求完接口后，刷新直播间相关信息
- (void)refreshCurrentLiveItem:(id<FWShowLiveRoomAble>)liveItem liveInfo:(CurrentLiveInfo *)liveInfo
{
    [self refreshLiveItem:liveItem liveInfo:liveInfo];
}

#pragma mark 点击飞屏模式，切换直播间（因切换房间涉及到比较多的逻辑，比如：付费、游戏，所以该方法暂时不用）
- (void)switchLiveRoom
{
    [self stopLiveRtmp];
    
    [self startEnterChatGroup:nil succ:^{
        NSLog(@"11111");
    } failed:^(int errId, NSString *errMsg) {
        NSLog(@"22222");
    }];
}

#pragma mark 关闭直播间代理事件
- (void)clickCloseLive:(BOOL)isDirectCloseLive isHostShowAlert:(BOOL)isHostShowAlert
{
    [self alertExitLive:isDirectCloseLive isHostShowAlert:isHostShowAlert succ:nil failed:nil];
}

#pragma mark 结束界面点击“返回首页”
- (void)finishViewClose:(FWLiveServiceController *)liveServiceController
{
    // 已经走到这里了 必然更改记录
    SUS_WINDOW.isDirectCloseLive = YES;
    [self onExitLiveUI];
}

#pragma mark PlayControllerDelegate 结束回播，用来判断是否还有下一段回播
- (void)stopReLive
{
    // 暂时不用做什么操作
}

#pragma mark ToolsViewDelegate
- (void)selectToolsItemWith:(ToolsView *)toolsView selectIndex:(NSInteger)index isSelected:(BOOL)isSelected
{
    _toolsView = toolsView;
    
    if (index == 0)
    { // 音乐
        [[[YunMusicPlayVC alloc] init] showYunMusicPlayInVC:self inview:self.liveServiceController.liveUIViewController.liveView showframe:CGRectMake(0,200, self.view.bounds.size.width,130) myPlayType:0];
    }
    else if (index == 1)
    { // 美颜
        _beautyView.hidden = NO;
    }
    else if (index == 2)
    { // 麦克风
        if (isSelected == YES)
        {
            _isMuted = NO;
            [FanweMessage alertTWMessage:@"已打开麦克风"];
        }
        else
        {
            _isMuted = YES;
            [FanweMessage alertTWMessage:@"已关闭麦克风"];
        }
        [_publishController.txLivePublisher setMute:!isSelected];
    }
    else if (index == 3)
    { // 切换摄像
        if (!_publishController.txLivePublisher.frontCamera)
        {
            // 关闭LED
            [FWUtils turnOnFlash:NO];
            [toolsView.toolsCollectionView deselectItemAtIndexPath:[NSIndexPath indexPathWithIndex:4] animated:NO];
        }
        [_publishController clickCamera:nil];
    }
    else if (index == 4)
    { // 关闭闪光
        if (_publishController.txLivePublisher.frontCamera)
        {
            [FanweMessage alertTWMessage:@"前置摄像头下暂时不能打开闪光灯"];
            return;
        }
        
        // 打开、关闭LED
        [_publishController clickTorch:isSelected];
    }
    else if (index == 5)
    {
        if (isSelected == YES)
        {
            [FanweMessage alertTWMessage:@"已打开镜像"];
        }
        else
        {
            [FanweMessage alertTWMessage:@"已关闭镜像"];
        }
        [_publishController.txLivePublisher setMirror:isSelected];
    }
}

#pragma mark TCShowLiveTopViewToSDKDelegate
#pragma mark 推拉流请求所的码率
- (void)refreshKBPS:(TCShowLiveTopView *)topView
{
    NSDictionary *tmpDict;
    if ([self.liveItem liveType] == 0)
    {
        tmpDict = _publishController.qualityDict;
    }
    else if ([self.liveItem liveType] == 1)
    {
        tmpDict = _playController.qualityDict;
    }
    else if ([self.liveItem liveType] == 2)
    {
        tmpDict = _linkMicPlayController.qualityDict;
    }
    
    int totalkb = ([tmpDict toInt:NET_STATUS_VIDEO_BITRATE] + [tmpDict toInt:NET_STATUS_AUDIO_BITRATE])/8;
    
    if (totalkb)
    {
        topView.kbpsSendLabel.hidden = NO;
        topView.kbpsRecvLabel.hidden = YES;
        
        CGRect newFrame = topView.kbpsSendLabel.frame;
        newFrame.origin.y = CGRectGetHeight(topView.kbpsContainerView.frame)/4;
        topView.kbpsSendLabel.frame = newFrame;
    }
    else
    {
        topView.kbpsSendLabel.hidden = YES;
        topView.kbpsRecvLabel.hidden = YES;
    }
    
    topView.kbpsSendLabel.text = [NSString stringWithFormat:@"%@%dk",[self.liveItem liveType] == 0 ? @"↑" : @"↓" ,totalkb];
}

#pragma mark FWTPublishControllerDelegate
#pragma mark 腾讯云直播的主播首帧回调
- (void)firstIFrame:(FWTPublishController*)publishVC
{
    if (!_hasShowVagueImg)
    {
        [self hideVagueImgView];
        
        // 设置默认美颜
        [self setCurrentBeautyValue:self.fanweApp.appModel.beauty_ios whiteValue:0];
        
        SUS_WINDOW.isPushStreamIng = YES;
    }
}

#pragma mark 推流时，网络断连,且经多次重连抢救无效后退出app
- (void)exitPublishAndApp:(FWTPublishController *)publishVC
{
    [self alertExitLive:NO isHostShowAlert:NO succ:nil failed:nil];
}

#pragma mark FWTPlayControllerDelegate
#pragma mark 腾讯云直播的观众、回播首帧回调
- (void)firstFrame:(FWTPlayController*)playVC
{
    [self hideVagueImgView];
}

#pragma mark 拉流时，网络断连,重连
- (void)playAgain:(FWTPlayController *)publishVC isHideLeaveTip:(BOOL)isHideLeaveTip
{
    if (self.liveType == FW_LIVE_TYPE_RELIVE)
    {
        [_playController clickPlay:_btnPlay create_type:self.liveInfo.create_type];
    }
    else if (self.liveType == FW_LIVE_TYPE_AUDIENCE)
    {
        [_linkMicPlayController startRtmp:self.liveInfo.create_type];
    }
    
    if (!_liveServiceController.anchorLeaveTipLabel.isHidden && isHideLeaveTip)
    {
        _liveServiceController.anchorLeaveTipLabel.hidden = YES;
    }
}

#pragma mark 拉流时，网络断连,且经多次重连抢救无效后退出app
- (void)exitPlayAndApp:(FWTPlayController *)publishVC
{
    [self alertExitLive:YES isHostShowAlert:NO succ:nil failed:nil];
}

#pragma mark livePayDelegate
#pragma mark 付费直播是否加载直播间视频的代理
- (void)livePayLoadVedioIsComfirm:(BOOL)isComfirm
{
    if (isComfirm)
    {
        if (!self.hasEnterChatGroup)
        {
            [self.linkMicPlayController stopRtmp];
            if (self.liveType == FW_LIVE_TYPE_RELIVE)
            {
                [self.publishController.txLivePublisher setMute:NO];
            }
            else if (self.liveType == FW_LIVE_TYPE_AUDIENCE)
            {
                [self.linkMicPlayController.txLivePlayer setMute:NO];
            }
            [self.liveServiceController.liveUIViewController dealLivepayTComfirm];
            FWWeakify(self)
            [self.liveServiceController getVideo:^(CurrentLiveInfo *liveInfo) {
                FWStrongify(self)
                self.liveInfo = liveInfo;
                [self beginPlayVideo:liveInfo];
                self.hasVideoControl = liveInfo.has_video_control ? YES : NO;
                
                [super startEnterChatGroup:_liveInfo.group_id succ:nil failed:nil];
                
            } failed:^(int errId, NSString *errMsg){
                
            }];
        }
    }
    else
    {
        [self alertExitLive:YES isHostShowAlert:NO succ:nil failed:nil];
    }
}

#pragma mark 付费直播关闭直播间的声音
- (void)voiceNotice:(NSNotification*)notification
{
    NSMutableDictionary *dictM = [notification object];
    if ([dictM toInt:@"type"] == 0)//关闭声音
    {
        [self setSDKMute:YES];
    }
    else if ([dictM toInt:@"type"] == 1)//打开声音
    {
        [self setSDKMute:NO];
    }
}


#pragma mark  ------------------------ 实现FWLiveControllerAble协议 -----------------------
#pragma mark 开始推流、拉流
- (void)startLiveRtmp:(NSString *)playUrlStr
{
    if (![FWUtils isBlankString:playUrlStr])
    {
        if ([self.liveItem liveType] == FW_LIVE_TYPE_HOST)
        {
            _publishController.pushUrlStr = playUrlStr;
            [_publishController startRtmp];
        }
        else if ([self.liveItem liveType] == FW_LIVE_TYPE_RELIVE)
        {
            _playController.playUrlStr = playUrlStr;
            [_playController clickPlay:_btnPlay create_type:self.liveInfo.create_type];
            _playController.play_switch = NO;
        }
        else if ([self.liveItem liveType] == FW_LIVE_TYPE_AUDIENCE)
        {
            _linkMicPlayController.playUrlStr = playUrlStr;
            [_linkMicPlayController startRtmp:self.liveInfo.create_type];
        }
    }
}

#pragma mark 结束推流、拉流
- (void)stopLiveRtmp
{
    if ([self.liveItem liveType] == FW_LIVE_TYPE_HOST)
    {
        [_publishController stopRtmp];
    }
    else if ([self.liveItem liveType] == FW_LIVE_TYPE_RELIVE)
    {
        [_playController stopRtmp];
    }
    else if ([self.liveItem liveType] == FW_LIVE_TYPE_AUDIENCE)
    {
        [_linkMicPlayController stopRtmp];
    }
}

//#pragma mark 按时付费剩余时间的倒计时
//- (void)livePayLeftTimeGo
//{
//    _liveServiceController.liveUIViewController.livePayLeftCount --;
//    if (_liveServiceController.liveUIViewController.livePayLeftCount == 0)
//    {
//        [_liveServiceController.liveUIViewController.livePayLeftTimer invalidate];
//        _liveServiceController.liveUIViewController.livePayLeftTimer =nil;
//    }else
//    {
//        _liveServiceController.liveUIViewController.livePayLabel.text = [NSString stringWithFormat:@"亲,大约%d秒后进入直播间",_liveServiceController.liveUIViewController.livePayLeftCount];
//    }
//}

#pragma mark TCShowLiveViewToSDKDelegate
- (void)hideReLiveSlide:(BOOL)isHided
{
    if (isHided)
    {
        _reLiveProgressView.hidden = YES;
    }
    else
    {
        if (self.hasVideoControl)
        {
            _reLiveProgressView.hidden = NO;
        }
    }
}

#pragma mark  - ----------------------- 美颜 -----------------------
#pragma mark 设置美颜类型（FWTLiveBeautyViewDelegate）
- (void)setBeauty:(FWTLiveBeautyView *)beautyView withBeautyName:(NSString *)beautyName
{
    if (_publishController.txLivePublisher)
    {
        if (![FWUtils isBlankString:beautyName])
        {
            NSString * path = [[NSBundle mainBundle] pathForResource:@"FilterResource" ofType:@"bundle"];
            if(path && ![beautyName isEqualToString:@"普通美颜"])
            {
                path = [path stringByAppendingPathComponent:beautyName];
                UIImage *image = [UIImage imageWithContentsOfFile:path];
                [_publishController.txLivePublisher setFilter:image];
            }
            else if ([beautyName isEqualToString:@"普通美颜"])
            {
                [_publishController.txLivePublisher setFilter:nil];
            }
        }
        else
        {
            [_publishController.txLivePublisher setFilter:nil];
            
            [self setCurrentBeautyValue:0 whiteValue:0];
        }
    }
}

#pragma mark 设置美颜的值
- (void)setBeautyValue:(FWTLiveBeautyView *)beautyView
{
    if (_publishController.txLivePublisher)
    {
        [_publishController.txLivePublisher setBeautyStyle:0 beautyLevel:beautyView.filterParam1.slider.value/10 whitenessLevel:beautyView.filterParam2.slider.value/10 ruddinessLevel:0];
    }
}

- (void)setCurrentBeautyValue:(float)beautyDepth whiteValue:(float)whiteDepth
{
    _beautyView.filterParam1.slider.value = beautyDepth;
    _beautyView.filterParam2.slider.value = whiteDepth;
    [_beautyView.filterParam1 updateValue];
    [_beautyView.filterParam2 updateValue];
    
    [self setBeautyValue:_beautyView];
}

#pragma mark  - ----------------------- 其他 -----------------------
#pragma mark 获取当前直播质量
- (NSString *)getLiveQuality
{
    NSDictionary *tmpDict;
    if ([self.liveItem liveType] == 0)
    {
        tmpDict = _publishController.qualityDict;
    }
    else
    {
        tmpDict = _playController.qualityDict;
    }
    
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    
    // 设备类型
    [mDict setObject:@"Ios" forKey:@"device"];
    // app占用CPU
    if ([tmpDict toFloat:NET_STATUS_CPU_USAGE_D])
    {
        [mDict setObject:[NSString stringWithFormat:@"%f",[tmpDict toFloat:NET_STATUS_CPU_USAGE_D]*100] forKey:@"appCPURate"];
    }
    // 系统占用CPU
    if ([tmpDict toFloat:NET_STATUS_CPU_USAGE])
    {
        [mDict setObject:[NSString stringWithFormat:@"%f",[tmpDict toFloat:NET_STATUS_CPU_USAGE]*100] forKey:@"sysCPURate"];
    }
    // 画面帧率，如：25
    if ([tmpDict toString:NET_STATUS_VIDEO_FPS])
    {
        [mDict setObject:[tmpDict toString:NET_STATUS_VIDEO_FPS] forKey:@"fps"];
    }
    
    // 发送、接收码率（每秒钟发送、接收的数据量）
    int totalkbps = [tmpDict toInt:NET_STATUS_VIDEO_BITRATE] + [tmpDict toInt:NET_STATUS_AUDIO_BITRATE];
    int totalkb = totalkbps/8;
    if (totalkb)
    {
        if ([self.liveItem liveType] == 0)
        {
            [mDict setObject:StringFromInt(totalkb) forKey:@"sendKBps"];
        }
        else
        {
            [mDict setObject:StringFromInt(totalkb) forKey:@"recvKBps"];
        }
    }
    
    // 显示网络差的提示
    int netSpeed = [tmpDict toInt:NET_STATUS_NET_SPEED];
    
    float loss_rate_send = (netSpeed-totalkbps)/netSpeed;
    
    if ([self.liveItem liveType] == 0)
    {
        [mDict setObject:[NSString stringWithFormat:@"%f",loss_rate_send] forKey:@"sendLossRate"];
    }
    else
    {
        [mDict setObject:[NSString stringWithFormat:@"%f",loss_rate_send] forKey:@"recvLossRate"];
    }
    
    if (loss_rate_send <= 0.2)
    {
        _lossRateSendTipLabel.hidden = YES;
    }
    else if(loss_rate_send > 0.2 && loss_rate_send < 0.3)
    {
        _lossRateSendTipLabel.hidden = NO;
        _lossRateSendTipLabel.text = kHostNetLowTip1;
        _lossRateSendTipLabel.textColor = kYellowColor;
    }
    else
    {
        _lossRateSendTipLabel.hidden = NO;
        _lossRateSendTipLabel.text = kHostNetLowTip2;
        _lossRateSendTipLabel.textColor = kRedColor;
    }
    
    NSString *sendMessage = [FWUtils dataTOjsonString:mDict];
    
    if (sendMessage)
    {
        return sendMessage;
    }
    else
    {
        return @"";
    }
}

#pragma mark 获取当前视频容器视图的父视图
- (UIView *)getPlayViewBottomView
{
    if ([self.liveItem liveType] == FW_LIVE_TYPE_HOST)
    {
        return _publishController.view;
    }
    else if ([self.liveItem liveType] == FW_LIVE_TYPE_RELIVE)
    {
        return _playController.view;
    }
    else if ([self.liveItem liveType] == FW_LIVE_TYPE_AUDIENCE)
    {
        return _linkMicPlayController.view;
    }
    return nil;
}

#pragma mark 设置静音 YES：设置为静音
- (void)setSDKMute:(BOOL)bEnable
{
    if (bEnable) // 关闭声音
    {
        if ([self.liveItem liveType] == FW_LIVE_TYPE_RELIVE)
        {
            [self.playController.txLivePlayer setMute:YES];
        }
        else if ([self.liveItem liveType] == FW_LIVE_TYPE_AUDIENCE)
        {
            [self.linkMicPlayController.txLivePlayer setMute:YES];
        }
    }
    else // 打开声音
    {
        if ([self.liveItem liveType] == FW_LIVE_TYPE_RELIVE)
        {
            [self.playController.txLivePlayer setMute:NO];
        }
        else if ([self.liveItem liveType] == FW_LIVE_TYPE_AUDIENCE)
        {
            [self.linkMicPlayController.txLivePlayer setMute:NO];
        }
    }
}


#pragma mark  - ----------------------- 其他 -----------------------
#pragma mark 解决不能调为最小音量问题
- (void)volumeChanged:(NSNotification *)noti
{
    NSDictionary *tmpDict = noti.userInfo;
    if (tmpDict && [tmpDict isKindOfClass:[NSDictionary class]])
    {
        if ([[tmpDict toString:@"AVSystemController_AudioVolumeChangeReasonNotificationParameter"] isEqualToString:@"ExplicitVolumeChange"] && !_isMuted)
        {
            float volume = [[tmpDict objectForKey:@"AVSystemController_AudioVolumeNotificationParameter"] floatValue];
            
            if (volume <= 0.062500)
            {
                [_publishController.txLivePublisher setMute:YES];
            }
            else
            {
                [_publishController.txLivePublisher setMute:NO];
            }
        }
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
