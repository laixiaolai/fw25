//
//  FWLiveBaseController.m
//  FanweLive
//
//  Created by xfg on 16/11/23.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "FWLiveBaseController.h"
#import "CountDownView.h"
#import "MusicCenterManager.h"

@interface FWLiveBaseController ()

@end

@implementation FWLiveBaseController

- (void)dealloc
{
    [self releaseAll];
}

- (void)releaseAll
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    AVAudioSession *aSession = [AVAudioSession sharedInstance];
    [aSession setMode:_audioSesstionMode error:nil];
}

- (void)initCurrentLiveItem:(id<FWShowLiveRoomAble>)liveItem
{
    CurrentLiveInfo *tmpLiveItem;
    if ([liveItem isKindOfClass:[CurrentLiveInfo class]])
    {
        tmpLiveItem = (CurrentLiveInfo *)liveItem;
    }
    
    IMAHost *host = [IMAPlatform sharedInstance].host;
    NSString *loginId = [host imUserId];
    // NSString *loginId = [[ILiveLoginManager getInstance] getLoginId];
    
    // 判断是否主播掉线后重新连接上来的
    if (liveItem.liveType == FW_LIVE_TYPE_AUDIENCE && [loginId isEqualToString:[[liveItem liveHost] imUserId]])
    {
        _isReEnterChatGroup = YES;
        
        [self performSelector:@selector(hostBackTip) withObject:nil afterDelay:4];
    }
    
    _roomIDStr = StringFromInt([liveItem liveAVRoomId]);
    
    // 不管是观看自己的回播还是别人的回播都以观众的身份进入
    if ([liveItem liveType] == FW_LIVE_TYPE_RELIVE)
    {
        _isHost = NO;
    }
    else
    {
        _isHost = [loginId isEqualToString:[[liveItem liveHost] imUserId]];
        if (_isHost)
        {
            liveItem.liveType = FW_LIVE_TYPE_HOST;
        }
    }
    
    if (tmpLiveItem.live_in)
    {
        if (tmpLiveItem.live_in == FW_LIVE_STATE_ING)
        {
            _liveType = FW_LIVE_TYPE_AUDIENCE;
        }
        else if (tmpLiveItem.live_in == FW_LIVE_STATE_RELIVE)
        {
            _liveType = FW_LIVE_TYPE_RELIVE;
        }
        else
        {
            _liveType = liveItem.liveType;
        }
    }
    else
    {
        _liveType = liveItem.liveType;
    }
    
    _sdkType = liveItem.sdkType;
    //    _mickType = liveItem.mickType;
    _mickType = FW_MICK_TYPE_AGORA;
    
    self.liveItem = liveItem;
    [self.liveItem setIsHost:_isHost];
    
    SUS_WINDOW.isHost = _isHost;
    SUS_WINDOW.liveType = (int)_liveType;
}

- (void)hostBackTip
{
    SendCustomMsgModel *sendCustomMsgModel = [[SendCustomMsgModel alloc] init];
    sendCustomMsgModel.msgType = MSG_ANCHOR_BACK;
    sendCustomMsgModel.msg = @"主播回来啦，视频即将恢复";
    sendCustomMsgModel.chatGroupID = [self.liveItem liveIMChatRoomId];
    [_iMMsgHandler sendCustomGroupMsg:sendCustomMsgModel succ:nil fail:nil];
}

- (instancetype)initWith:(id<FWShowLiveRoomAble>)liveItem
{
    if (self = [super init])
    {
        _isAtForeground = YES;
        
        _vagueImgUrl = [liveItem vagueImgUrl];
        
        _iMMsgHandler = [FWIMMsgHandler sharedInstance];
        
        _enterChatGroupTimes = 3;
        
        [self initCurrentLiveItem:liveItem];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.navigationController.navigationBar.tintColor = kClearColor;
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self vagueBackGround];
    
    [self checkNetWorkBeforeLive];
    
    _lossRateSendTipLabel = [[UILabel alloc]initWithFrame:CGRectMake(kDefaultMargin, 135, kScreenW-kDefaultMargin*2, 35)];
    _lossRateSendTipLabel.textColor = [UIColor whiteColor];
    _lossRateSendTipLabel.font = [UIFont systemFontOfSize:15.0];
    [self.view addSubview:_lossRateSendTipLabel];
    _lossRateSendTipLabel.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    _lossRateSendTipLabel.shadowOffset = CGSizeMake(1, 1);
    _lossRateSendTipLabel.hidden = YES;
}

#pragma mark - ----------------------- 添加相关监听 -----------------------
- (void)addAVSDKObservers
{
    NSError *error = nil;
    AVAudioSession *aSession = [AVAudioSession sharedInstance];
    
    _audioSesstionCategory = [aSession category];
    _audioSesstionMode = [aSession mode];
    
    [aSession setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionAllowBluetooth error:&error];
    [aSession setMode:AVAudioSessionModeDefault error:&error];
    [aSession setActive:YES error: &error];
    
    // 监听声音打断
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAudioInterruption:)  name:AVAudioSessionInterruptionNotification object:nil];
    
    // 监听耳机插入和拔出
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioRouteChangeListenerCallback:) name:AVAudioSessionRouteChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppWillTeminal:) name:UIApplicationWillTerminateNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (BOOL)isOtherAudioPlaying
{
    UInt32 otherAudioIsPlaying;
    UInt32 propertySize = sizeof (otherAudioIsPlaying);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    AudioSessionGetProperty(kAudioSessionProperty_OtherAudioIsPlaying, &propertySize, &otherAudioIsPlaying);
#pragma clang diagnostic pop
    return otherAudioIsPlaying;
}

- (void)onAppBecomeActive:(NSNotification *)notification
{
    if (![self isOtherAudioPlaying])
    {
        [[AVAudioSession sharedInstance] setActive:YES error: nil];
    }
}

#pragma mark app将要销毁
- (void)onAppWillTeminal:(NSNotification*)notification
{
    //    _isDirectCloseLive = YES;
    //    [self realExitLive:nil failed:nil];
}

#pragma mark - ----------------------- 进入、退出直播 -----------------------
#pragma mark 弹出退出或直接退出
- (void)alertExitLive:(BOOL)isDirectCloseLive isHostShowAlert:(BOOL)isHostShowAlert succ:(FWVoidBlock)succ failed:(FWErrorBlock)failed
{
    [FWUtils closeKeyboard];
    
    if (_iMMsgHandler.isExitRooming)
    {
        if (failed)
        {
            failed(FWCode_Normal_Error, @"正在退出直播中");
        }
        return;
    }
    
    MUSIC_CENTER_MANAGER.musicPlayingState = NO;
    
    _isDirectCloseLive = isDirectCloseLive;
    
    if (_isHost && _liveType == FW_LIVE_TYPE_HOST && isHostShowAlert)
    {
        FWWeakify(self)
        [FanweMessage alert:nil message:@"您当前正在直播，是否退出直播？" destructiveAction:^{
            
            FWStrongify(self)
            
            [self realExitLive:succ failed:failed];
            
        } cancelAction:^{
            
            // 音乐恢复 判断有局限性
            MUSIC_CENTER_MANAGER.musicPlayingState = YES;
            
        }];
    }
    else
    {
        [self realExitLive:succ failed:failed];
    }
}

#pragma mark 判断对应类型然后做对应的退出操作
- (void)realExitLive:(FWVoidBlock)succ failed:(FWErrorBlock)failed
{
    _iMMsgHandler.isExitRooming = YES;
    
    // 直接退出聊天组
    [self exitChatGroup];
    
    // 释放电话监听
    [self removePhoneListener];
    
    // 业务上退出直播：退出的时候分SDK退出和业务退出，减少退出等待时间
    [self onServiceExitLive:_isDirectCloseLive succ:succ failed:failed];
}

- (void)realExitLiveChatGroup
{
    __weak FWIMMsgHandler *im = _iMMsgHandler;
    [[IMAPlatform sharedInstance] asyncExitAVChatRoom:self.liveItem succ:^{
        [im removeGroupChatListener];
        NSLog(@"直播间退出群:%@ 成功1",[self.liveItem liveIMChatRoomId]);
    } fail:^(int code, NSString *msg) {
        [im removeGroupChatListener];
        NSLog(@"直播间退出群:%@ 失败1，错误码：%d，错误原因：%@",[self.liveItem liveIMChatRoomId],code,msg);
    }];
}

#pragma mark 退出聊天组：观众退出聊天组前先发退出消息、主播直接退出（主播不用解散聊天组，服务端会做该操作）
- (void)exitChatGroup
{
    __weak typeof(self) ws = self;
    if (!_isHost)
    {
        SendCustomMsgModel *sendCustomMsgModel = [[SendCustomMsgModel alloc] init];
        sendCustomMsgModel.msgType = MSG_VIEWER_QUIT;
        sendCustomMsgModel.chatGroupID = [self.liveItem liveIMChatRoomId];
        [_iMMsgHandler sendCustomGroupMsg:sendCustomMsgModel succ:^{
            
            [ws realExitLiveChatGroup];
            
        } fail:^(int code, NSString *msg) {
            
            [ws realExitLiveChatGroup];
            
        }];
    }
    else
    {
        [ws realExitLiveChatGroup];
    }
}

#pragma mark - ----------------------- 模糊背景 -----------------------
#pragma mark 进入直播间时的显示模糊背景
- (void)vagueBackGround
{
    _vagueImgView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    if (_vagueImgUrl && ![_vagueImgUrl isEqualToString:@""])
    {
        [_vagueImgView sd_setImageWithURL:[NSURL URLWithString:_vagueImgUrl]];
    }
    else
    {
        [_vagueImgView setImage:[UIImage imageNamed:@"wel"]];
    }
    [self.view addSubview:_vagueImgView];
    [self.view bringSubviewToFront:_vagueImgView];
    
    UIBlurEffect *beffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    
    UIVisualEffectView *view = [[UIVisualEffectView alloc]initWithEffect:beffect];
    
    view.frame = self.view.bounds;
    
    [_vagueImgView addSubview:view];
}

#pragma mark 视频第一帧加载出来后隐藏模糊背景
- (void)hideVagueImgView
{
    FWWeakify(self)
    [UIView animateWithDuration:0.2f animations:^{
        FWStrongify(self)
        self.vagueImgView.transform = CGAffineTransformMakeScale(0.5f, 0.5f);
        self.vagueImgView.alpha = 0.f;
    } completion:^(BOOL finished) {
        FWStrongify(self)
        self.vagueImgView.hidden = YES;
    }];
    
    if (_isHost)
    {
        // 加载倒计时效果
        [CountDownView showCountDownViewInLiveVCwithFrame:CGRectMake(0, 0, 250, 250) inViewController:self block:nil];
        _hasShowVagueImg = YES;
    }
}

@end


#pragma mark - FWLiveBaseController (ProtectedMethod) 供子类重写
@implementation FWLiveBaseController (ProtectedMethod)

#pragma mark 请求完接口后，刷新直播间相关信息
- (void)refreshLiveItem:(id<FWShowLiveRoomAble>)liveItem liveInfo:(CurrentLiveInfo *)liveInfo
{
    [self initCurrentLiveItem:liveItem];
}

#pragma mark - ----------------------- 进入、退出直播 -----------------------

#pragma mark 加入聊天组成功
- (void)enterChatGroupSucc:(CurrentLiveInfo *)liveInfo
{
    [_iMMsgHandler setGroupChatListener:self.liveItem];
    
    TCShowLiveListItem *liveRoom = (TCShowLiveListItem *)self.liveItem;
    
    if (![FWUtils isBlankString:liveInfo.group_id])
    {
        liveRoom.chatRoomId = liveInfo.group_id;
    }
    
    if ([FWUtils isBlankString:liveRoom.host.uid])
    {
        liveRoom.host.uid = liveInfo.podcast.user.user_id;
    }
    liveRoom.host.username = liveInfo.podcast.user.nick_name;
    liveRoom.host.avatar = liveInfo.podcast.user.head_image;
    
    self.liveItem = liveRoom;
    
    // 发送加入直播间消息
    if (!_isHost && (liveInfo.join_room_prompt == 1 || [[IMAPlatform sharedInstance].host getUserRank] >= self.fanweApp.appModel.jr_user_level))
    {
        SendCustomMsgModel *sendCustomMsgModel = [[SendCustomMsgModel alloc] init];
        sendCustomMsgModel.msgType = MSG_VIEWER_JOIN;
        sendCustomMsgModel.chatGroupID = [self.liveItem liveIMChatRoomId];
        [_iMMsgHandler sendCustomGroupMsg:sendCustomMsgModel succ:nil fail:nil];
    }
}

#pragma mark 加入聊天组：为了防止加入聊天组出错的几率，所以这边做进入聊天失败的_enterChatGroupTimes次加入尝试
- (void)startEnterChatGroup:(NSString *)chatGroupID succ:(FWVoidBlock)succ failed:(FWErrorBlock)failed
{
    _hasEnterChatGroup = YES;
    
    if (![FWUtils isBlankString:chatGroupID])
    {
        [self.liveItem setLiveIMChatRoomId:chatGroupID];
    }
    
    if ([FWUtils isBlankString:[self.liveItem liveIMChatRoomId]])
    {
        return;
    }
    
    FWWeakify(self)
    [[IMAPlatform sharedInstance] asyncEnterAVChatRoom:self.liveItem isHost:_isReEnterChatGroup ? NO : _isHost succ:^(id<AVRoomAble> room) {
        
        FWStrongify(self)
        if (self.liveInfo)
        {
            [self enterChatGroupSucc:self.liveInfo];
        }
        
        [self.liveItem setLiveIMChatRoomId:[room liveIMChatRoomId]];
        
        [self addPhoneListener];
        [self performSelector:@selector(addNetListener) withObject:nil afterDelay:3];
        
        if (succ)
        {
            succ();
        }
        
    } fail:^(int code, NSString *msg) {
        
        FWStrongify(self)
        self.enterChatGroupTimes --;
        
        if (self.enterChatGroupTimes)
        {
            [self startEnterChatGroup:@"" succ:succ failed:failed];
        }
        else
        {
            if (failed)
            {
                failed(code, msg);
            }
            [FWHUDHelper alert:@"加入聊天室失败，请稍候尝试" action:^{
                [self onExitLiveUI];
            }];
            
            DebugLog(@"=========加入直播聊天室失败 code: %d , msg = %@", code, msg);
        }
    }];
}

#pragma mark 业务上退出直播：退出的时候分SDK退出和业务退出，减少退出等待时间
- (void)onServiceExitLive:(BOOL)isDirectCloseLive succ:(FWVoidBlock)succ failed:(FWErrorBlock)failed
{
    // 供子类重写
}

#pragma mark 退出直播界面
- (void)onExitLiveUI
{
    _iMMsgHandler.isExitRooming = NO;
    _iMMsgHandler.isEnterRooming = NO;
    
    self.fanweApp.liveState = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    AVAudioSession *aSession = [AVAudioSession sharedInstance];
    [aSession setMode:_audioSesstionMode error:nil];
    
    // 用于控制自动锁屏
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    
    // 参数也处理
    [SuspenionWindow resetSusWindowPramaWhenLiveClosedComplete:nil];
}


#pragma mark - ----------------------- 网络、电话、进入前后台监听 -----------------------
#pragma mark 加入直播前先判断网络环境
- (void)checkNetWorkBeforeLive
{
    __weak typeof(self) ws = self;
    __weak FWIMMsgHandler *msgHandler = _iMMsgHandler;
    
    switch ([AppDelegate sharedAppDelegate].reachabilityStatus)
    {
        case AFNetworkReachabilityStatusReachableViaWWAN:
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                
                NSString *ac = _isHost ? @"创建" : @"加入";
                NSString *tip = [NSString stringWithFormat:@"当前是移动网络，是否继续%@直播？", ac];
                
                FWWeakify(self)
                [FanweMessage alert:@"网络提示" message:tip destructiveAction:^{
                    
                    FWStrongify(self)
                    
                    [self addAVSDKObservers];
                    
#if TARGET_IPHONE_SIMULATOR
#else
                    msgHandler.isEnterRooming = YES;
                    [ws startEnterChatGroup:@"" succ:nil failed:nil];
#endif
                    
                } cancelAction:^{
                    
                    FWStrongify(self)
                    
                    [self tipMessage:@"退出成功" delay:2 completion:^{
                        [ws onExitLiveUI];
                    }];

                }];
            });
        }
            break;
        case AFNetworkReachabilityStatusReachableViaWiFi:
        {
            [self addAVSDKObservers];
            
#if TARGET_IPHONE_SIMULATOR
#else
            msgHandler.isEnterRooming = YES;
            [ws startEnterChatGroup:@"" succ:nil failed:nil];
#endif
        }
            break;
        case AFNetworkReachabilityStatusUnknown:
        case AFNetworkReachabilityStatusNotReachable:
            
        default:
        {
            // 当前无网络
            NSString *tip = [NSString stringWithFormat:@"当前无网络，无法%@直播", _isHost ? @"创建" : @"加入"];
            [self tipMessage:tip delay:2 completion:^{
                [self onExitLiveUI];
            }];
        }
            break;
    }
}

#pragma mark 监听网络
- (void)addNetListener
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(ReachabilityDidChange:) name:AFNetworkingReachabilityDidChangeNotification object:nil];
}

- (void)ReachabilityDidChange:(NSNotification *)not
{
    __weak typeof(self) ws = self;
    
    NSDictionary *userInfo = not.userInfo;
    AFNetworkReachabilityStatus reachabilityStatus = [userInfo[AFNetworkingReachabilityNotificationStatusItem] integerValue];
    switch (reachabilityStatus)
    {
        case AFNetworkReachabilityStatusReachableViaWWAN:
        {
            if (_isHost)
            {
                // 变成移动网络
                
                FWWeakify(self)
                [FanweMessage alert:nil message:@"当前是移动网络，是否继续直播？" destructiveAction:^{
                    
                } cancelAction:^{
                    
                    FWStrongify(self)
                    
                    [self alertExitLive:NO isHostShowAlert:NO succ:nil failed:nil];
                    
                }];
            }
            else
            {
                // 网络变差
                FWWeakify(self)
                [FanweMessage alert:nil message:@"当前是移动网络，是否继续观看直播？" destructiveAction:^{
                    
                } cancelAction:^{
                    
                    FWStrongify(self)
                    
                    [self alertExitLive:NO isHostShowAlert:NO succ:nil failed:nil];
                    
                }];
            }
        }
            break;
        case AFNetworkReachabilityStatusReachableViaWiFi:
        {
            // 网络变好，不处理
        }
            break;
        case AFNetworkReachabilityStatusUnknown:
        case AFNetworkReachabilityStatusNotReachable:
            
        default:
        {
            // 网络不可用
            [FanweMessage alert:[NSString stringWithFormat:@"当前无网络，无法继续%@直播！", _isHost ? @"" : @"观看"]];
        }
            break;
    }
}

#pragma mark 添加电话监听: 进入直播成功后监听
- (void)addPhoneListener
{
    if (!_callCenter)
    {
        _callCenter = [[CTCallCenter alloc] init];
        __weak FWLiveBaseController *ws = self;
        _callCenter.callEventHandler = ^(CTCall *call) {
            // 需要在主线程执行
            [ws performSelectorOnMainThread:@selector(handlePhostEvent:) withObject:call waitUntilDone:YES];
        };
    }
}

#pragma mark 移除电话监听：退出直播后监听
- (void)removePhoneListener
{
    _callCenter.callEventHandler = nil;
    _callCenter = nil;
}

- (void)handlePhostEvent:(CTCall *)call
{
    DebugLog(@"电话中断处理：电话状态为call.callState = %@", call.callState);
    if ([call.callState isEqualToString:CTCallStateDisconnected])
    {
        // 电话已结束
        if (_hasHandleCall)
        {
            // 说明在前的时候接通过电话
            DebugLog(@"电话中断处理：在前如的时候处理的电话，挂断后，立即回到前台");
            [self phoneInterruptioning:NO];
        }
        else
        {
            DebugLog(@"电话中断处理：退到后台接话：不处理");
        }
    }
    else
    {
        if (!_isPhoneInterupt && _isAtForeground)
        {
            DebugLog(@"电话中断处理：退到后台接话：不处理");
            // 首次收到，并且在前台
            _isPhoneInterupt = YES;
            _hasHandleCall = YES;
            [self phoneInterruptioning:YES];
        }
        else
        {
            DebugLog(@"电话中断处理：已在后台接电话话：不处理");
        }
    }
}

#pragma mark 视频是否需要中断
- (void)isInterruptioning:(BOOL)interruptioning
{
    if (interruptioning)
    {
        [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        }];
        
        if (_isAtForeground)
        {
            _isAtForeground = NO;
            
            _backGroundTime = [[NSDate date] timeIntervalSince1970];
            
            if (_liveType == FW_LIVE_TYPE_HOST) // 主播
            {
                SendCustomMsgModel *sendCustomMsgModel = [[SendCustomMsgModel alloc] init];
                sendCustomMsgModel.msgType = MSG_ANCHOR_LEAVE;
                sendCustomMsgModel.msg = @"主播离开一下，精彩不中断，不要走开哦";
                sendCustomMsgModel.chatGroupID = [self.liveItem liveIMChatRoomId];
                [_iMMsgHandler sendCustomGroupMsg:sendCustomMsgModel succ:nil fail:nil];
            }
        }
    }
    else
    {
        if (!_isAtForeground)
        {
            _isAtForeground = YES;
            
            _foreGroundTime = [[NSDate date] timeIntervalSince1970];
            
            if (_liveType == FW_LIVE_TYPE_HOST) // 主播
            {
                [self hostBackTip];
            }
        }
    }
}

#pragma mark app进入前台
- (void)onAppEnterForeground
{
    [self isInterruptioning:NO];
}

#pragma mark app进入后台
- (void)onAppEnterBackground
{
    [self isInterruptioning:YES];
}

#pragma mark 是否正在被电话打断
- (void)phoneInterruptioning:(BOOL)interruptioning
{
    [self isInterruptioning:interruptioning];
    
    if (!interruptioning)
    {
        _hasHandleCall = NO;
        _isPhoneInterupt = NO;
    }
}

#pragma mark 声音打断监听
- (void)onAudioInterruption:(NSNotification *)notification
{
    NSDictionary *interuptionDict = notification.userInfo;
    NSNumber* interuptionType = [interuptionDict valueForKey:AVAudioSessionInterruptionTypeKey];
    if(interuptionType.intValue == AVAudioSessionInterruptionTypeBegan)
    {
        DebugLog(@"初中断");
    }
    else if (interuptionType.intValue == AVAudioSessionInterruptionTypeEnded)
    {
        // siri输入
        [[AVAudioSession sharedInstance] setActive:YES error: nil];
    }
}

#pragma mark  关注和取消关注要做UI处理以及关注做IM发通知
- (void)isShowFollow:(NSNotification *)notification
{

}

#pragma mark 监听耳机插入和拔出
- (void)audioRouteChangeListenerCallback:(NSNotification*)notification
{
    // 供子类重写
}

- (void)tipMessage:(NSString *)msg delay:(CGFloat)seconds completion:(void (^)())completion
{
    [[FWHUDHelper sharedInstance] tipMessage:msg delay:seconds completion:completion];
}

@end
