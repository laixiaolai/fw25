//
//  FWKSYLiveController.m
//  FanweApp
//
//  Created by xfg on 2017/2/10.
//  Copyright © 2017年 xfg. All rights reserved.
//  金山云直播，只处理与SDK有关的业务

#import "FWKSYLiveController.h"
#import "HostCheckMickAlertView.h"

#define kPlayContrainerHeight 30

@interface FWKSYLiveController ()

@end

@implementation FWKSYLiveController

#pragma mark - ----------------------- 添加UI -----------------------
#pragma mark - UI respond : gpu filters
- (void)onFilterChange:(id)sender
{
    if (self.mickType == FW_MICK_TYPE_KSY)
    {
        [_ksyLinkMicStreamerController.gPUStreamerKit setupRtcFilter:_beautyView.curFilter];
    }
    else if(self.mickType == FW_MICK_TYPE_AGORA)
    {
        [_agoraLinkMicStreamerController.gPUStreamerKit setupRtcFilter:_beautyView.curFilter];
    }
}

- (void)addSubViews
{
    if (self.liveType == FW_LIVE_TYPE_HOST)
    {
        _beautyView = [[FWSettingBeautyView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
        [self.liveServiceController.liveUIViewController.liveView addSubview:_beautyView];
        __weak typeof(self) ws = self;
        _beautyView.onBtnBlock = ^(id sender) {
            [ws onFilterChange:sender];
        };
        _beautyView.hidden = YES;
    }
    else if (self.liveType == FW_LIVE_TYPE_RELIVE)
    {
        _reLiveProgressView = [[FWReLiveProgressView alloc]init];
        _reLiveProgressView.frame = CGRectMake(0, kScreenH-80, kScreenW, kPlayContrainerHeight);
        _reLiveProgressView.hidden = YES;
        
        __weak typeof(self) ws = self;
        _reLiveProgressView.playBtnCallback = ^(){
            if (ws.ksyPlayerController.moviePlayer.playbackState == MPMoviePlaybackStatePlaying)
            {
                [ws.ksyPlayerController pausePlay];
            }
            else if (ws.ksyPlayerController.moviePlayer.playbackState == MPMoviePlaybackStatePaused)
            {
                [ws.ksyPlayerController resumePlay];
            }
            else if (ws.ksyPlayerController.moviePlayer.playbackState == MPMoviePlaybackStateStopped)
            {
                [ws.ksyPlayerController reloadPlay];
            }
        };
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
        if (self.mickType == FW_MICK_TYPE_KSY)
        {
            _ksyLinkMicStreamerController = [[FWKSYLinkMicStreamerController alloc] init];
            _ksyLinkMicStreamerController.delegate = self;
            _ksyLinkMicStreamerController.linkMicPublishDelegate = self;
            [self addChild:_ksyLinkMicStreamerController inRect:self.view.bounds];
            [self.view sendSubviewToBack:_ksyLinkMicStreamerController.view];
        }
        else if(self.mickType == FW_MICK_TYPE_AGORA)
        {
            _agoraLinkMicStreamerController = [[FWKSYAgoraLinkMicStreamerController alloc] init];
            _agoraLinkMicStreamerController.liveType = self.liveType;
            _agoraLinkMicStreamerController.delegate = self;
            [self addChild:_agoraLinkMicStreamerController inRect:self.view.bounds];
            [self.view sendSubviewToBack:_agoraLinkMicStreamerController.view];
        }
    }
    else if (self.liveType == FW_LIVE_TYPE_RELIVE)
    {
        _ksyPlayerController = [[FWKSYPlayerController alloc] init];
        _ksyPlayerController.delegate = self;
        [self addChild:_ksyPlayerController inRect:self.view.bounds];
        [self.view sendSubviewToBack:_ksyPlayerController.view];
    }
    else if (self.liveType == FW_LIVE_TYPE_AUDIENCE)
    {
        if (self.mickType == FW_MICK_TYPE_KSY)
        {
            _ksyLinkMicPlayerController = [[FWKSYLinkMicPlayerController alloc] init];
            _ksyLinkMicPlayerController.liveType = self.liveType;
            _ksyLinkMicPlayerController.delegate = self;
            _ksyLinkMicPlayerController.linkMicPlayDelegate = self;
            [self addChild:_ksyLinkMicPlayerController inRect:self.view.bounds];
            [self.view sendSubviewToBack:_ksyLinkMicPlayerController.view];
        }
        else if(self.mickType == FW_MICK_TYPE_AGORA)
        {
            _agoraLinkMicPlayerController = [[FWKSYAgoraLinkMicPlayerController alloc] init];
            _agoraLinkMicPlayerController.liveType = self.liveType;
            _agoraLinkMicPlayerController.delegate = self;
            [self addChild:_agoraLinkMicPlayerController inRect:self.view.bounds];
            [self.view sendSubviewToBack:_agoraLinkMicPlayerController.view];
        }
    }
    
    [self setSDKMirror:NO];     //默认关闭镜像
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
        [LIVE_CENTER_MANAGER.stSuspensionWindow setDelegate:self ];
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
    
    _mickUserMArray = [NSMutableArray array];
    _registerMickUserMArray = [NSMutableArray array];
    
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
    FWWeakify(self)
    [_liveServiceController getVideo:^(CurrentLiveInfo *liveInfo) {
        
        FWStrongify(self)
        if (liveInfo)
        {
            self.liveInfo = liveInfo;
            self.hasVideoControl = liveInfo.has_video_control ? YES : NO;
            
            if ([self.liveItem liveType] == FW_LIVE_TYPE_RELIVE && liveInfo.has_video_control)
            {
                self.reLiveProgressView.hidden = NO;
            }
            else
            {
                self.reLiveProgressView.hidden = YES;
            }
            
            self.liveServiceController.liveUIViewController.livePay.payDelegate = self;
            
            if (![FWUtils isBlankString:liveInfo.push_rtmp] || ![FWUtils isBlankString:liveInfo.play_url])
            {
                [self beginPlayVideo:liveInfo];
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
                    
                    [self getVideoState:1];
                    
                    if (succ)
                    {
                        succ();
                    }
                    
                } failed:^(int errId, NSString *errMsg) {
                    
                    [self getVideoState:0];
                    
                    if (failed)
                    {
                        failed(errId, errMsg);
                    }
                }];
            }
        }
        else
        {
            [self setGetVideoFailed:nil];
            
            if (failed)
            {
                failed(FWCode_Net_Error, @"获取到的liveInfo为空");
            }
        }
    } failed:^(int errId, NSString *errMsg) {
        
        FWStrongify(self)
        [self setGetVideoFailed:errMsg];
        
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
    
    if (SUS_WINDOW.liveType == FW_LIVE_TYPE_HOST)  // 主播
    {
        [_liveServiceController showHostFinishView:@"" andVote:@"" andHasDel:NO];
        
        FWWeakify(self)
        [_liveServiceController hostExitLive:^{
            
            FWStrongify(self)
            if(isDirectCloseLive)
            {
                [self onExitLiveUI];
            }
            if (succ)
            {
                succ();
            }
        } failed:^(int errId, NSString *errMsg) {
            
            if(isDirectCloseLive)
            {
                [self onExitLiveUI];
            }
            
            if (failed)
            {
                failed(errId, errMsg);
            }
            
        }];
        
        if (self.mickType == FW_MICK_TYPE_KSY)
        {
            [_ksyLinkMicStreamerController stopRtmp];
        }
        else if(self.mickType == FW_MICK_TYPE_AGORA)
        {
            [_agoraLinkMicStreamerController stopRtmp];
        }
    }
    else
    {
        if (SUS_WINDOW.liveType == FW_LIVE_TYPE_RELIVE)
        {
            [_ksyPlayerController stopPlay];
        }
        else if (SUS_WINDOW.liveType == FW_LIVE_TYPE_AUDIENCE)
        {
            if (self.mickType == FW_MICK_TYPE_KSY)
            {
                [_ksyLinkMicPlayerController stopPlay];
            }
            else if(self.mickType == FW_MICK_TYPE_AGORA)
            {
                [_agoraLinkMicPlayerController stopPlay];
            }
            [self cancelMickingAlert];
        }
        
        if(isDirectCloseLive)
        {
            [self onExitLiveUI];
            
            if (succ)
            {
                succ();
            }
        }
    }
}

#pragma mark 是否需要打断视频
- (void)interruptionLiveIng:(BOOL)interruptioning
{
    if (interruptioning)
    {
        [_liveServiceController pauseLive];
        
        if (self.liveType == FW_LIVE_TYPE_HOST)
        {
            [_ksyLinkMicStreamerController.gPUStreamerKit appEnterBackground];
        }
        else if(self.liveType == FW_LIVE_TYPE_RELIVE)
        {
            [_ksyPlayerController pausePlay];
        }
        else if(self.liveType == FW_LIVE_TYPE_AUDIENCE)
        {
            if (self.mickType == FW_MICK_TYPE_KSY)
            {
                [_ksyLinkMicPlayerController pausePlay];
            }
            else if(self.mickType == FW_MICK_TYPE_AGORA)
            {
                [_agoraLinkMicPlayerController pausePlay];
            }
        }
    }
    else
    {
        [_liveServiceController resumeLive];
        
        if (self.liveType == FW_LIVE_TYPE_HOST)
        {
            [_ksyLinkMicStreamerController.gPUStreamerKit appBecomeActive];
        }
        else if(self.liveType == FW_LIVE_TYPE_RELIVE)
        {
            [_ksyPlayerController resumePlay];
        }
        else if(self.liveType == FW_LIVE_TYPE_AUDIENCE)
        {
            if (self.mickType == FW_MICK_TYPE_KSY)
            {
                [_ksyLinkMicPlayerController resumePlay];
            }
            else if(self.mickType == FW_MICK_TYPE_AGORA)
            {
                [_agoraLinkMicPlayerController resumePlay];
            }
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
    if (_isHost)
    {
        [super onAppEnterForeground];
    }
    
    [self interruptionLiveIng:NO];
}

#pragma mark app进入后台
- (void)onAppEnterBackground
{
    if (_isHost)
    {
        [super onAppEnterBackground];
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
    
    [self interruptionLiveIng:YES];
}

#pragma mark 重写退出方法
- (void)onExitLiveUI
{
    [super onExitLiveUI];
    
    // 执行下 悬浮参数退出
    if (SUS_WINDOW.isSusWindow && SUS_WINDOW.isDirectCloseLive)
    {
        [[LiveCenterManager sharedInstance] resetSuswindowPramaComple:^(BOOL finished) {
        }];
    }
    
    [_liveServiceController endLive];
    _liveServiceController = nil;
    if (_ksyLinkMicStreamerController)
    {
        _ksyLinkMicStreamerController = nil;
    }
    if (_agoraLinkMicStreamerController)
    {
        _agoraLinkMicStreamerController = nil;
    }
    if (_ksyPlayerController)
    {
        _ksyPlayerController = nil;
    }
    if (_ksyLinkMicPlayerController)
    {
        _ksyLinkMicPlayerController = nil;
    }
    if (_agoraLinkMicPlayerController)
    {
        _agoraLinkMicPlayerController = nil;
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
        //        [_ksyPlayerController onAudioInterruption:notification];
    }
    else if(self.liveType == FW_LIVE_TYPE_AUDIENCE)
    {
        //        [_ksyLinkMicPlayerController onAudioInterruption:notification];
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
            
            if (self.mickType == FW_MICK_TYPE_KSY)
            {
                // 开启耳返功能
                _ksyLinkMicStreamerController.gPUStreamerKit.aCapDev.bPlayCapturedAudio = YES;
                _ksyLinkMicStreamerController.gPUStreamerKit.aCapDev.micVolume = 0.8;
                // 混响类型
                _ksyLinkMicStreamerController.gPUStreamerKit.aCapDev.reverbType = 2;
            }
            else if(self.mickType == FW_MICK_TYPE_AGORA)
            {
                // 开启耳返功能
                _agoraLinkMicStreamerController.gPUStreamerKit.aCapDev.bPlayCapturedAudio = YES;
                _agoraLinkMicStreamerController.gPUStreamerKit.aCapDev.micVolume = 0.8;
                // 混响类型
                _agoraLinkMicStreamerController.gPUStreamerKit.aCapDev.reverbType = 2;
            }
            
            break;
        case AVAudioSessionRouteChangeReasonOldDeviceUnavailable:   // 耳机拔出，停止播放操作
            
            if (self.mickType == FW_MICK_TYPE_KSY)
            {
                // 关闭耳返功能
                _ksyLinkMicStreamerController.gPUStreamerKit.aCapDev.bPlayCapturedAudio = NO;
                // 混响类型
                _ksyLinkMicStreamerController.gPUStreamerKit.aCapDev.reverbType = 0;
            }
            else if(self.mickType == FW_MICK_TYPE_AGORA)
            {
                // 关闭耳返功能
                _agoraLinkMicStreamerController.gPUStreamerKit.aCapDev.bPlayCapturedAudio = NO;
                // 混响类型
                _agoraLinkMicStreamerController.gPUStreamerKit.aCapDev.reverbType = 0;
            }
            
            break;
        case AVAudioSessionRouteChangeReasonCategoryChange:
            // called at start - also when other audio wants to play
            NSLog(@"AVAudioSessionRouteChangeReasonCategoryChange");
            break;
    }
}

#pragma mark 重写弹出退出或直接退出
/**
 *  @brief: 重写 弹出退出或直接退出
 *
 * @prama: isDirectCloseLive
 * @prama: isHostShowAlert
 * @prama: succ
 * @prama: failed
 *
 * @discussion:1.FWLiveBaseController 重写里面的  弹出退出或直接退出 因为
 *
 */
- (void)alertExitLive:(BOOL)isDirectCloseLive isHostShowAlert:(BOOL)isHostShowAlert succ:(FWVoidBlock)succ failed:(FWErrorBlock)failed
{
    //在后面退出 基础类需要 这个判断 需不需要 Finish界面
    self.isDirectCloseLive = isDirectCloseLive;
    // isHostShowAlert 暂时没处理
    [[LiveCenterManager sharedInstance] closeLiveOfPramaOfLiveViewController:self paiTimeNum:self.liveServiceController.auctionTool.paiTime alertExitLive:isDirectCloseLive isHostShowAlert:isHostShowAlert colseLivecomplete:^(BOOL finished) {
        
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
            if (self.mickType == FW_MICK_TYPE_KSY)
            {
                _ksyLinkMicStreamerController.pushUrl = [NSURL URLWithString:liveInfo.push_rtmp];
                [_ksyLinkMicStreamerController.gPUStreamerKit setupFilter:_beautyView.curFilter];
                [_ksyLinkMicStreamerController startRtmp];
            }
            else if(self.mickType == FW_MICK_TYPE_AGORA)
            {
                _agoraLinkMicStreamerController.pushUrl = [NSURL URLWithString:liveInfo.push_rtmp];
                [_agoraLinkMicStreamerController.gPUStreamerKit setupFilter:_beautyView.curFilter];
                [_agoraLinkMicStreamerController startRtmp];
            }
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
        if (liveInfo.play_url && ![liveInfo.play_url isEqualToString:@""])
        {
            if (liveInfo.has_video_control)
            {
                [_liveServiceController.liveUIViewController.liveView addSubview:_reLiveProgressView];
                _ksyPlayerController.reLiveProgressView = _reLiveProgressView;
            }
            
            [_ksyPlayerController initPlayerWithUrl:[NSURL URLWithString:liveInfo.play_url] createType:liveInfo.create_type];
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
                if (self.mickType == FW_MICK_TYPE_KSY)
                {
                    [_ksyLinkMicPlayerController initPlayerWithUrl:[NSURL URLWithString:liveInfo.play_url] createType:liveInfo.create_type];
                }
                else if(self.mickType == FW_MICK_TYPE_AGORA)
                {
                    [_agoraLinkMicPlayerController initPlayerWithUrl:[NSURL URLWithString:liveInfo.play_url] createType:liveInfo.create_type];
                }
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

#pragma mark - ----------------------- 金山云连麦独有模块 -----------------------

#pragma mark 处理鉴权回调
/*
 *  主播端鉴权回调
 *  status：鉴权回调码
 *  responderId：接收连麦者ID
 */
- (void)registerResult:(int)status registerUserId:(NSString *)responderId
{
    if (_customApplicantModel && status == 200)
    {
        SendCustomMsgModel *sendCustomMsgModel = [[SendCustomMsgModel alloc] init];
        sendCustomMsgModel.msgType = MSG_RECEIVE_MIKE;
        sendCustomMsgModel.msgReceiver = _customApplicantModel.sender;
        [_iMMsgHandler sendCustomC2CMsg:sendCustomMsgModel succ:nil fail:nil];
        
        [_registerMickUserMArray addObject:responderId];
        
        [_ksyLinkMicStreamerController startRegister:_customApplicantModel.sender.user_id];
    }
}

#pragma mark 处理反鉴权回调
/*
 *  主播端反鉴权回调
 *  status：反鉴权回调码
 *  responderId：接收连麦者ID
 */
- (void)unRegisterResult:(int)status registerUserId:(NSString *)responderId
{
    if ([_registerMickUserMArray containsObject:responderId])
    {
        [_registerMickUserMArray removeObject:responderId];
    }
}

#pragma mark 处理鉴权回调
/*
 *  辅播端（即连麦观众）鉴权回调
 *  status：鉴权回调码
 *  applicantId：申请连麦者ID
 */
- (void)registerResult2:(int)status registerUserId:(NSString *)applicantId
{
    if (applicantId && _customResponderModel.sender.user_id && status == 200)
    {
        [_ksyLinkMicPlayerController startLinkMic:applicantId andResponderId:_customResponderModel.sender.user_id];
    }
}

#pragma mark 处理反鉴权回调
/*
 *  辅播端（即连麦观众）反鉴权回调
 *  status：反鉴权回调码
 *  applicantId：申请连麦者ID
 */
- (void)unRegisterResult2:(int)status registerUserId:(NSString *)applicantId
{
    if ([_registerMickUserMArray containsObject:applicantId])
    {
        [_registerMickUserMArray removeObject:applicantId];
    }
}

- (void)doMyUnregisterRTC
{
    if ([_registerMickUserMArray count])
    {
        if (_isHost)
        {
            [_ksyLinkMicStreamerController.gPUStreamerKit.rtcClient unRegisterRTC];
        }
        else
        {
            [_ksyLinkMicPlayerController.gPUStreamerKit.rtcClient unRegisterRTC];
        }
    }
}

#pragma mark 获取鉴权串
- (void)getRegisterIdStr:(CustomMessageModel *)customMessageModel
{
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    [mDict setObject:@"video" forKey:@"ctl"];
    [mDict setObject:@"ks_auth" forKey:@"act"];
    
    FWWeakify(self)
    [self.httpsManager POSTWithParameters:mDict SuccessBlock:^(NSDictionary *responseJson) {
        
        FWStrongify(self)
        if ([responseJson toInt:@"status"] == 1)
        {
            [self doMyUnregisterRTC];
            
            if (self.isHost)
            {
                self.ksyLinkMicStreamerController.gPUStreamerKit.rtcClient.authString = [NSString stringWithFormat:@"https://rtc.vcloud.ks-live.com:6001/auth?%@",[responseJson toString:@"auth_string"]];
                self.ksyLinkMicStreamerController.gPUStreamerKit.rtcClient.localId = [responseJson toString:@"uid"];
                [self.ksyLinkMicStreamerController.gPUStreamerKit.rtcClient registerRTC];
            }
            else
            {
                self.ksyLinkMicPlayerController.gPUStreamerKit.rtcClient.authString = [NSString stringWithFormat:@"https://rtc.vcloud.ks-live.com:6001/auth?%@",[responseJson toString:@"auth_string"]];
                self.ksyLinkMicPlayerController.gPUStreamerKit.rtcClient.localId = [responseJson toString:@"uid"];
                [self.ksyLinkMicPlayerController.gPUStreamerKit.rtcClient registerRTC];
            }
        }
        
    } FailureBlock:^(NSError *error) {
        
    }];
}


#pragma mark - ----------------------- 连麦 -----------------------

#pragma mark 观众检查是否有连麦权限（主播不需要此操作）
- (void)startLianmai:(CustomMessageModel *)customMessageModel
{
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    [mDict setObject:@"video" forKey:@"ctl"];
    [mDict setObject:@"start_lianmai" forKey:@"act"];
    [mDict setObject:_roomIDStr forKey:@"room_id"];
    [mDict setObject:customMessageModel.sender.user_id forKey:@"to_user_id"];
    
    FWWeakify(self)
    [self.httpsManager POSTWithParameters:mDict SuccessBlock:^(NSDictionary *responseJson) {
        
        FWStrongify(self)
        if ([responseJson toInt:@"status"] == 1)
        {
            if (self.mickType == FW_MICK_TYPE_KSY)
            {
                [self getRegisterIdStr:customMessageModel];
            }
            else if (self.mickType == FW_MICK_TYPE_AGORA)
            {
                self.agoraLinkMicPlayerController.linkMicBaseController.delegate = self;
                [self.agoraLinkMicPlayerController startLinkMic:[[IMAPlatform sharedInstance].host imUserId] andResponderId:self.customResponderModel.sender.user_id roomId:self.roomIDStr];
            }
        }
        
    } FailureBlock:^(NSError *error) {
        
    }];
}

#pragma mark 主播收到观众连麦请求
- (void)onRecvGuestApply:(CustomMessageModel *)customMessageModel
{
    SenderModel *sender = customMessageModel.sender;
    if (_mikeCount >= _micMaxNum || _hostMickingAlert)
    {
        SendCustomMsgModel *sendCustomMsgModel = [[SendCustomMsgModel alloc] init];
        sendCustomMsgModel.msgType = MSG_REFUSE_MIKE;
        sendCustomMsgModel.msgReceiver = customMessageModel.sender;
        
        if (_hostMickingAlert)
        {
            sendCustomMsgModel.msg = @"主播有未处理的连麦请求，请稍候再试";
            [_iMMsgHandler sendCustomC2CMsg:sendCustomMsgModel succ:nil fail:nil];
        }
        else
        {
            DebugLog(@"已达到请求上限，不能再请求");
            
            sendCustomMsgModel.msg = @"当前主播主播连麦数已上限，请稍后尝试";
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
            if (self.mickType == FW_MICK_TYPE_KSY)
            {
                [self getRegisterIdStr:customMessageModel];
            }
            else if (self.mickType == FW_MICK_TYPE_AGORA)
            {
                SendCustomMsgModel *sendCustomMsgModel = [[SendCustomMsgModel alloc] init];
                sendCustomMsgModel.msgType = MSG_RECEIVE_MIKE;
                sendCustomMsgModel.msgReceiver = _customApplicantModel.sender;
                [wm sendCustomC2CMsg:sendCustomMsgModel succ:nil fail:nil];
                
                [self.agoraLinkMicStreamerController startLinkMic:self.customApplicantModel.sender.user_id andResponderId:[[IMAPlatform sharedInstance].host imUserId] roomId:self.roomIDStr];
            }
            
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

#pragma mark 判断是否互动观众
- (BOOL)isInteractUser:(NSString *)userId
{
    if (userId)
    {
        for (NSString *tmpUserId in _mickUserMArray)
        {
            if ([userId isEqualToString:tmpUserId])
            {
                return YES;
            }
        }
    }
    return NO;
}

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

#pragma mark 主播点击屏幕时，判断是否点击了连麦窗口
- (void)hostReceiveTouch:(UITouch *)touch
{
    if ([self.mickUserMArray count])
    {
        for (NSString *user in self.mickUserMArray)
        {
            CGRect mickUserRect = CGRectMake(kScreenW * kLinkMickXRate, kScreenH * kLinkMickYRate, kScreenW * kLinkMickWRate, kScreenH * kLinkMickHRate);
            
            if(CGRectContainsPoint(mickUserRect, [touch locationInView:self.view]))
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
                    if (self.mickType == FW_MICK_TYPE_AGORA)
                    {
                        [_agoraLinkMicStreamerController stopLinkMic:[[IMAPlatform sharedInstance].host imUserId]];
                    }
                    
                }];
                [view showWithBlock:completeBlock];
            }
        }
    }
}

#pragma mark 观众发起连麦，关闭连麦
- (void)openOrCloseMike:(FWLiveServiceController *)liveServiceController
{
    if (_ksyLinkMicPlayerController.isWaitingResponse)
    {
        [FanweMessage alertHUD:@"连麦申请中..."];
        return;
    }
    
    __weak typeof(self) ws = self;
    
    if ([self isInteractUser:[[IMAPlatform sharedInstance].host imUserId]])
    {
        [FanweMessage alert:nil message:@"是否结束与主播的互动直播？" destructiveAction:^{
            
            if (self.mickType == FW_MICK_TYPE_KSY)
            {
                [ws.ksyLinkMicPlayerController stopLinkMic:[[IMAPlatform sharedInstance].host imUserId]];
            }
            else if (self.mickType == FW_MICK_TYPE_AGORA)
            {
                [ws.agoraLinkMicPlayerController stopLinkMic:[[IMAPlatform sharedInstance].host imUserId]];
                
                SendCustomMsgModel *sendCustomMsgModel = [[SendCustomMsgModel alloc] init];
                sendCustomMsgModel.msgType = MSG_BREAK_MIKE;
                sendCustomMsgModel.msgReceiver = [ws.liveItem liveHost];
                [[FWIMMsgHandler sharedInstance] sendCustomC2CMsg:sendCustomMsgModel succ:nil fail:nil];
            }
            
        } cancelAction:^{
            
        }];
    }
    else
    {
        __weak FWIMMsgHandler *wd = _iMMsgHandler;
        
        [FanweMessage alert:nil message:@"是否请求与主播连麦？" destructiveAction:^{
            
            SendCustomMsgModel *sendCustomMsgModel = [[SendCustomMsgModel alloc] init];
            sendCustomMsgModel.msgType = MSG_APPLY_MIKE;
            sendCustomMsgModel.msgReceiver = [ws.liveItem liveHost];
            
            [wd sendCustomC2CMsg:sendCustomMsgModel succ:^{
                [ws performSelector:@selector(alertLinkMicking) withObject:nil afterDelay:0.2];
            } fail:^(int code, NSString *msg) {
                [FanweMessage alertHUD:@"您的连麦申请发送失败"];
            }];
            
        } cancelAction:^{
            
        }];
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

- (void)showRefuseHud:(NSString *)refuseStr
{
    if (![FWUtils isBlankString:refuseStr])
    {
        [FanweMessage alertTWMessage:refuseStr];
    }
}

#pragma mark 观众端连麦结果
/*
 *  观众端连麦结果
 *  isSucc：是否上麦
 *  applicantId：申请连麦者ID
 */
- (void)applicantLinkMickResult:(BOOL)isSucc applicantId:(NSString *)applicantId
{
    if (![FWUtils isBlankString:applicantId])
    {
        if (isSucc)
        {
            [_mickUserMArray addObject:applicantId];
        }
        else
        {
            if ([_mickUserMArray containsObject:applicantId])
            {
                [_mickUserMArray removeObject:applicantId];
                
                SendCustomMsgModel *sendCustomMsgModel = [[SendCustomMsgModel alloc] init];
                sendCustomMsgModel.msgType = MSG_BREAK_MIKE;
                sendCustomMsgModel.msgReceiver = [self.liveItem liveHost];
                
                [_iMMsgHandler sendCustomC2CMsg:sendCustomMsgModel succ:nil fail:nil];
            }
            if ([_registerMickUserMArray containsObject:applicantId])
            {
                [_registerMickUserMArray removeObject:applicantId];
            }
        }
    }
}

#pragma mark 主播端连麦结果
/*
 *  主播端连麦结果
 *  isSucc：YES：连麦 NO：断开连麦
 *  applicantId：申请连麦者ID
 */
- (void)responderLinkMickResult:(BOOL)isSucc applicantId:(NSString *)applicantId
{
    if (![FWUtils isBlankString:applicantId])
    {
        if (isSucc)
        {
            [_mickUserMArray addObject:applicantId];
        }
        else
        {
            if ([_mickUserMArray containsObject:applicantId])
            {
                [_mickUserMArray removeObject:applicantId];
            }
            if ([_registerMickUserMArray containsObject:applicantId])
            {
                [_registerMickUserMArray removeObject:applicantId];
            }
        }
    }
}

#pragma mark 声网连麦/断开连麦
/*
 *  声网连麦/断开连麦
 *  isLinked：YES：连麦  NO：断开连麦
 *  applicantId：申请连麦者ID
 */
- (void)linkOrBreakMick:(BOOL)isLinked applicantId:(NSString *)applicantId
{
    if (isLinked)
    {
        [_mickUserMArray addObject:applicantId];
    }
    else
    {
        if ([_mickUserMArray containsObject:applicantId])
        {
            [_mickUserMArray removeObject:applicantId];
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
                _ksyPlayerController.videoContrainerView.frame = CGRectMake(0, 0, kScreenW, kScreenH);
                _ksyPlayerController.moviePlayer.scalingMode = MPMovieScalingModeAspectFit;
                self.backVerticalBtn.hidden = YES;
            }
            else if (self.liveType == FW_LIVE_TYPE_AUDIENCE)
            {
                if (self.mickType == FW_MICK_TYPE_KSY)
                {
                    _ksyLinkMicPlayerController.videoContrainerView.frame = CGRectMake(0, 0, kScreenW, kScreenH);
                    _ksyLinkMicPlayerController.moviePlayer.scalingMode = MPMovieScalingModeAspectFit;
                    self.backVerticalBtn.hidden = YES;
                }
                else if(self.mickType == FW_MICK_TYPE_AGORA)
                {
                    _agoraLinkMicPlayerController.videoContrainerView.frame = CGRectMake(0, 0, kScreenW, kScreenH);
                    _agoraLinkMicPlayerController.moviePlayer.scalingMode = MPMovieScalingModeAspectFit;
                    self.backVerticalBtn.hidden = YES;
                }
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
                _ksyPlayerController.videoContrainerView.frame = CGRectMake(0, 0, kScreenW, kScreenH);
                _ksyPlayerController.moviePlayer.scalingMode = MPMovieScalingModeFill;
                self.backVerticalBtn.hidden = NO;
            }
            else if (self.liveType == FW_LIVE_TYPE_AUDIENCE)
            {
                if (self.mickType == FW_MICK_TYPE_KSY)
                {
                    _ksyLinkMicPlayerController.videoContrainerView.frame = CGRectMake(0, 0, kScreenW, kScreenH);
                    _ksyLinkMicPlayerController.moviePlayer.scalingMode = MPMovieScalingModeFill;
                    self.backVerticalBtn.hidden = NO;
                }
                else if(self.mickType == FW_MICK_TYPE_AGORA)
                {
                    _agoraLinkMicPlayerController.videoContrainerView.frame = CGRectMake(0, 0, kScreenW, kScreenH);
                    _agoraLinkMicPlayerController.moviePlayer.scalingMode = MPMovieScalingModeFill;
                    self.backVerticalBtn.hidden = NO;
                }
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
            _customApplicantModel = customMessageModel;
            // 关闭键盘
            [FWUtils closeKeyboard];
            
            _ksyLinkMicPlayerController.isWaitingResponse = YES;
            
            [self onRecvGuestApply:customMessageModel];
        }
            break;
        case MSG_RECEIVE_MIKE:  // 主播接受连麦（观众收到主播接受连麦消息）
        {
            if (_isApplyMicking)
            {
                _customResponderModel = customMessageModel;
                // 关闭键盘
                [FWUtils closeKeyboard];
                // 关闭Alert窗口
                [self cancelMickingAlert];
                
                if (self.mickType == FW_MICK_TYPE_KSY)
                {
                    [_ksyLinkMicPlayerController startRegister:[[IMAPlatform sharedInstance].host imUserId]];
                    [self getRegisterIdStr:customMessageModel];
                }
                else if (self.mickType == FW_MICK_TYPE_AGORA)
                {
                    [self startLianmai:customMessageModel];
                }
            }
        }
            break;
        case MSG_REFUSE_MIKE:   // 主播拒绝连麦（观众收到主播拒绝连麦消息）
        {
            [self cancelMickingAlert];
            
            _ksyLinkMicPlayerController.isWaitingResponse = NO;
            
            NSString *refuseStr = @"主播拒绝了您的连麦请求";
            
            if (![FWUtils isBlankString:customMessageModel.msg])
            {
                refuseStr = customMessageModel.msg;
            }
            
            [self performSelector:@selector(showRefuseHud:) withObject:refuseStr afterDelay:0.8];
        }
            break;
        case MSG_BREAK_MIKE:    // 断开连麦（观众收到主播断开连麦消息 或者 主播收到观众主动断开连麦消息）
        {
            if (self.mickType == FW_MICK_TYPE_KSY)
            {
                [_ksyLinkMicPlayerController stopLinkMic:[[IMAPlatform sharedInstance].host imUserId]];
            }
            else if (self.mickType == FW_MICK_TYPE_AGORA)
            {
                if (_isHost)
                {
                    [_agoraLinkMicStreamerController stopLinkMic:[[IMAPlatform sharedInstance].host imUserId]];
                }
                else
                {
                    [_agoraLinkMicPlayerController stopLinkMic:[[IMAPlatform sharedInstance].host imUserId]];
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
        [FanweMessage alertTWMessage:@"亲，音乐模块后期开放，敬请期待..."];
        
        //        [choseMuiscVC showMuisChoseVCOnSuperVC:self frame:CGRectMake(0, 0,kScreenW,kScreenH) completion:^(BOOL finished) {
        //
        //        }];
    }
    else if (index == 1)
    { // 美颜
        _beautyView.hidden = NO;
    }
    else if (index == 2)
    { // 麦克风
        if (isSelected == YES)
        {
            [FanweMessage alertTWMessage:@"已打开麦克风"];
            _isMuted = NO;
            [self setSDKMute:YES];
        }
        else
        {
            [FanweMessage alertTWMessage:@"已关闭麦克风"];
            _isMuted = YES;
            [self setSDKMute:NO];
        }
    }
    else if (index == 3)
    { // 切换摄像
        if (self.mickType == FW_MICK_TYPE_KSY)
        {
            if (_ksyLinkMicStreamerController.gPUStreamerKit.cameraPosition == AVCaptureDevicePositionBack)
            {
                // 关闭LED
                [FWUtils turnOnFlash:NO];
                [toolsView.toolsCollectionView deselectItemAtIndexPath:[NSIndexPath indexPathWithIndex:4] animated:NO];
            }
            [_ksyLinkMicStreamerController.gPUStreamerKit switchCamera];
        }
        else if(self.mickType == FW_MICK_TYPE_AGORA)
        {
            if (_agoraLinkMicStreamerController.gPUStreamerKit.cameraPosition == AVCaptureDevicePositionBack)
            {
                // 关闭LED
                [FWUtils turnOnFlash:NO];
                [toolsView.toolsCollectionView deselectItemAtIndexPath:[NSIndexPath indexPathWithIndex:4] animated:NO];
            }
            [_agoraLinkMicStreamerController.gPUStreamerKit switchCamera];
        }
    }
    else if (index == 4)
    { // 关闭闪光
        
        if (self.mickType == FW_MICK_TYPE_KSY)
        {
            if (_ksyLinkMicStreamerController.gPUStreamerKit.cameraPosition == AVCaptureDevicePositionFront)
            {
                [FanweMessage alertTWMessage:@"前置摄像头下暂时不能打开闪光灯"];
                return;
            }
            
            // 打开、关闭LED
            [_ksyLinkMicStreamerController.gPUStreamerKit toggleTorch];
        }
        else if(self.mickType == FW_MICK_TYPE_AGORA)
        {
            if (_agoraLinkMicStreamerController.gPUStreamerKit.cameraPosition == AVCaptureDevicePositionFront)
            {
                [FanweMessage alertTWMessage:@"前置摄像头下暂时不能打开闪光灯"];
                return;
            }
            
            // 打开、关闭LED
            [_agoraLinkMicStreamerController.gPUStreamerKit toggleTorch];
        }
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

        [self setSDKMirror:isSelected];
    }
}

#pragma mark TCShowLiveViewOfBeautyDelegate
#pragma mark -美颜美白
- (void)onBeautySetSkinOfCarevalue:(CGFloat)buffingOfCarevalue skinOfCarevalue:(CGFloat)skinOfCarevalue skinOfWhiteValue:(CGFloat)skinOfWhiteValue
{
    KSYBeautifyProFilter *proFilter =[[KSYBeautifyProFilter alloc]init];
    // 磨皮
    proFilter.grindRatio = buffingOfCarevalue;
    // 美白
    proFilter.whitenRatio = skinOfCarevalue;
    // 红润
    proFilter.ruddyRatio = skinOfWhiteValue;
    
    [self.ksyLinkMicStreamerController.gPUStreamerKit setupFilter:proFilter];
}

#pragma mark FWKSYAgoraStreamerBaseControllerDelegate
#pragma mark 首帧回调
- (void)firstAgoraFrame:(FWKSYAgoraStreamerBaseController *)publishVC
{
    if (!_hasShowVagueImg)
    {
        [self hideVagueImgView];
        SUS_WINDOW.isPushStreamIng = YES;
    }
}

#pragma mark 网络断连,且经多次重连抢救无效后退出直播
- (void)exitAgoraPublish:(FWKSYAgoraStreamerBaseController *)publishVC
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
        [_ksyPlayerController resumePlay];
    }
    else if (self.liveType == FW_LIVE_TYPE_AUDIENCE)
    {
        if (self.mickType == FW_MICK_TYPE_KSY)
        {
            [_ksyLinkMicPlayerController reloadPlay];
        }
        else if(self.mickType == FW_MICK_TYPE_AGORA)
        {
            [_agoraLinkMicPlayerController reloadPlay];
        }
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

#pragma mark 首帧回调
- (void)firstIFrame:(FWKSYStreamerController *)publishVC
{
    [self hideVagueImgView];
    SUS_WINDOW.isPushStreamIng = YES;
}

#pragma mark 网络断连,且经多次重连抢救无效后退出app
- (void)exitPublishAndApp:(FWKSYStreamerController *)publishVC
{
    [self alertExitLive:NO isHostShowAlert:NO succ:nil failed:nil];
}

#pragma mark livePayDelegate
#pragma mark 付费直播是否加载直播间视频的代理
- (void)livePayLoadVedioIsComfirm:(BOOL)isComfirm
{
    if (isComfirm)
    {
        if (!self.hasEnterChatGroup)
        {
                [self.ksyLinkMicPlayerController stopPlay];
                [self.liveServiceController.liveUIViewController dealLivepayTComfirm];
                FWWeakify(self)
                [self.liveServiceController getVideo:^(CurrentLiveInfo *liveInfo) {
                    FWStrongify(self)
                    self.liveInfo = liveInfo;
                    [self beginPlayVideo:liveInfo];
                    self.hasVideoControl = liveInfo.has_video_control ? YES : NO;
                    [super startEnterChatGroup:_liveInfo.group_id succ:nil failed:nil];
                    
                } failed:^(int errId, NSString *errMsg) {
                    
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


#pragma mark  - ----------------------- 实现FWLiveControllerAble协议 -----------------------
#pragma mark 开始推流、拉流
- (void)startLiveRtmp:(NSString *)playUrlStr
{
    if (![FWUtils isBlankString:playUrlStr])
    {
        if (self.liveType == FW_LIVE_TYPE_HOST)
        {
            if (self.mickType == FW_MICK_TYPE_KSY)
            {
                _ksyLinkMicStreamerController.pushUrl = [NSURL URLWithString:playUrlStr];
                [_ksyLinkMicStreamerController startRtmp];
            }
            else if(self.mickType == FW_MICK_TYPE_AGORA)
            {
                _agoraLinkMicStreamerController.pushUrl = [NSURL URLWithString:playUrlStr];
                [_agoraLinkMicStreamerController startRtmp];
            }
        }
        else if (self.liveType == FW_LIVE_TYPE_RELIVE)
        {
            if (self.liveInfo.has_video_control)
            {
                [_liveServiceController.liveUIViewController.liveView addSubview:_reLiveProgressView];
                _ksyPlayerController.reLiveProgressView = _reLiveProgressView;
            }
            [_ksyPlayerController initPlayerWithUrl:[NSURL URLWithString:playUrlStr] createType:_liveInfo.create_type];
        }
        else if (self.liveType == FW_LIVE_TYPE_AUDIENCE)
        {
            if (self.mickType == FW_MICK_TYPE_KSY)
            {
                [_ksyLinkMicPlayerController initPlayerWithUrl:[NSURL URLWithString:playUrlStr] createType:_liveInfo.create_type];
            }
            else if(self.mickType == FW_MICK_TYPE_AGORA)
            {
                [_agoraLinkMicPlayerController initPlayerWithUrl:[NSURL URLWithString:playUrlStr] createType:_liveInfo.create_type];
            }
        }
    }
}

#pragma mark 结束推流、拉流
- (void)stopLiveRtmp
{
    if (self.liveType == FW_LIVE_TYPE_HOST)
    {
        if (self.mickType == FW_MICK_TYPE_KSY)
        {
            [_ksyLinkMicStreamerController stopRtmp];
        }
        else if(self.mickType == FW_MICK_TYPE_AGORA)
        {
            [_agoraLinkMicStreamerController stopRtmp];
        }
    }
    else if (self.liveType == FW_LIVE_TYPE_RELIVE)
    {
        [_ksyPlayerController stopPlay];
    }
    else if (self.liveType == FW_LIVE_TYPE_AUDIENCE)
    {
        if (self.mickType == FW_MICK_TYPE_KSY)
        {
            [_ksyLinkMicPlayerController stopPlay];
        }
        else if(self.mickType == FW_MICK_TYPE_AGORA)
        {
            [_agoraLinkMicPlayerController stopPlay];
        }
    }
}

#pragma mark 获取当前视频容器视图的父视图
- (UIView *)getPlayViewBottomView
{
    if (self.liveType == FW_LIVE_TYPE_HOST)
    {
        if (self.mickType == FW_MICK_TYPE_KSY)
        {
            return _ksyLinkMicStreamerController.view;
        }
        else if(self.mickType == FW_MICK_TYPE_AGORA)
        {
            return _agoraLinkMicStreamerController.view;
        }
    }
    else if (self.liveType == FW_LIVE_TYPE_RELIVE)
    {
        return _ksyPlayerController.view;
    }
    else if (self.liveType == FW_LIVE_TYPE_AUDIENCE)
    {
        if (self.mickType == FW_MICK_TYPE_KSY)
        {
            return _ksyLinkMicPlayerController.view;
        }
        else if(self.mickType == FW_MICK_TYPE_AGORA)
        {
            return _agoraLinkMicPlayerController.view;
        }
    }
    return nil;
}

#pragma mark 设置静音 YES：设置为静音
- (void)setSDKMute:(BOOL)bEnable
{
    if (self.liveType == FW_LIVE_TYPE_HOST)
    {
        if (bEnable)
        {
            if (self.mickType == FW_MICK_TYPE_KSY)
            {
                _ksyLinkMicStreamerController.gPUStreamerKit.aCapDev.micVolume = 1;
                //                [[_ksyLinkMicStreamerController.gPUStreamerKit aCapDev] resumeCapture];
            }
            else if(self.mickType == FW_MICK_TYPE_AGORA)
            {
                _agoraLinkMicStreamerController.gPUStreamerKit.aCapDev.micVolume = 1;
                //                [[_agoraLinkMicStreamerController.gPUStreamerKit aCapDev] resumeCapture];
            }
        }
        else
        {
            if (self.mickType == FW_MICK_TYPE_KSY)
            {
                _ksyLinkMicStreamerController.gPUStreamerKit.aCapDev.micVolume = 0;
                //                [[_ksyLinkMicStreamerController.gPUStreamerKit aCapDev] pauseWithMuteData];
            }
            else if(self.mickType == FW_MICK_TYPE_AGORA)
            {
                _agoraLinkMicStreamerController.gPUStreamerKit.aCapDev.micVolume = 0;
                //                [[_agoraLinkMicStreamerController.gPUStreamerKit aCapDev] pauseWithMuteData];
            }
        }
    }
    else if (self.liveType == FW_LIVE_TYPE_RELIVE)
    {
        [_ksyPlayerController.moviePlayer setShouldMute:bEnable];
    }
    else if (self.liveType == FW_LIVE_TYPE_AUDIENCE)
    {
        if (self.mickType == FW_MICK_TYPE_KSY)
        {
            [_ksyLinkMicPlayerController.moviePlayer setShouldMute:bEnable];
        }
        else if(self.mickType == FW_MICK_TYPE_AGORA)
        {
            [_agoraLinkMicPlayerController.moviePlayer setShouldMute:bEnable];
        }
    }
}

#pragma mark    设置镜像
- (void)setSDKMirror:(BOOL)bEnable
{
    if (self.mickType == FW_MICK_TYPE_KSY)
    {
        _ksyLinkMicStreamerController.gPUStreamerKit.streamerMirrored = bEnable;
    }
    else if(self.mickType == FW_MICK_TYPE_AGORA)
    {
        _agoraLinkMicStreamerController.gPUStreamerKit.streamerMirrored = bEnable;
    }
}

#pragma mark 获取当前直播质量
- (NSString *)getLiveQuality
{
    KSYQosInfo *qosInfo;
    
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    
    // 设备类型
    [mDict setObject:@"Ios" forKey:@"device"];
    
    // app占用CPU
    [mDict setObject:[NSString stringWithFormat:@"%f",[FWUtils getAppCpuUsage]] forKey:@"appCPURate"];
    
    //    // 系统占用CPU
    //    if ([tmpDict toFloat:NET_STATUS_CPU_USAGE])
    //    {
    //        [mDict setObject:[NSString stringWithFormat:@"%f",[tmpDict toFloat:NET_STATUS_CPU_USAGE]*100] forKey:@"sysCPURate"];
    //    }
    
    if (self.liveType == FW_LIVE_TYPE_HOST)
    {
        // 实时帧率
        double encFps      = _deltaS.encodedFrames / _deltaS.timeSecond;
        [mDict setObject:[NSString stringWithFormat:@"%f",encFps] forKey:@"fps"];
        
        // 发送码率（每秒钟发送、接收的数据量）
        double realTKbps   = _deltaS.uploadKByte*8 / _deltaS.timeSecond;
        [mDict setObject:[NSString stringWithFormat:@"%f",realTKbps] forKey:@"sendKBps"];
        
        // 视频丢帧百分率
        double dropPercent = _deltaS.droppedVFrames * 100.0 /MAX(_curState.encodedFrames, 1);
        [mDict setObject:[NSString stringWithFormat:@"%f",dropPercent] forKey:@"sendLossRate"];
    }
    else if (self.liveType == FW_LIVE_TYPE_RELIVE)
    {
        qosInfo = _ksyPlayerController.moviePlayer.qosInfo;
        // 画面帧率，如：25
        if (qosInfo.videoRefreshFPS)
        {
            [mDict setObject:[NSString stringWithFormat:@"%f",qosInfo.videoRefreshFPS] forKey:@"fps"];
        }
        
        // 接收码率（每秒钟发送、接收的数据量）
        //    [mDict setObject:StringFromInt(totalkb) forKey:@"recvKBps"];
        // 视频丢帧百分率
        //    [mDict setObject:[NSString stringWithFormat:@"%f",loss_rate_send] forKey:@"recvLossRate"];
    }
    else if (self.liveType == FW_LIVE_TYPE_AUDIENCE)
    {
        if (self.mickType == FW_MICK_TYPE_KSY)
        {
            qosInfo = _ksyLinkMicPlayerController.moviePlayer.qosInfo;
        }
        else if(self.mickType == FW_MICK_TYPE_AGORA)
        {
            qosInfo = _agoraLinkMicPlayerController.moviePlayer.qosInfo;
        }
        
        // 画面帧率，如：25
        if (qosInfo.videoRefreshFPS)
        {
            [mDict setObject:[NSString stringWithFormat:@"%f",qosInfo.videoRefreshFPS] forKey:@"fps"];
        }
        
        // 接收码率（每秒钟发送、接收的数据量）
        //    [mDict setObject:StringFromInt(totalkb) forKey:@"recvKBps"];
        // 视频丢帧百分率
        //    [mDict setObject:[NSString stringWithFormat:@"%f",loss_rate_send] forKey:@"recvLossRate"];
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
    return @"";
}


#pragma mark  - ----------------------- sdk实时参数 -----------------------
#pragma mark 获取sdk相关试试参数
- (void)getStreamState
{
    KSYStreamerBase *streamerBase;
    
    if (self.mickType == FW_MICK_TYPE_KSY)
    {
        streamerBase = _ksyLinkMicStreamerController.gPUStreamerKit.streamerBase;
    }
    else if(self.mickType == FW_MICK_TYPE_AGORA)
    {
        streamerBase = _agoraLinkMicStreamerController.gPUStreamerKit.streamerBase;
    }
    
    StreamState curState = {0};
    curState.timeSecond     = [[NSDate date]timeIntervalSince1970];
    curState.uploadKByte    = [streamerBase uploadedKByte];
    curState.encodedFrames  = [streamerBase encodedFrames];
    curState.droppedVFrames = [streamerBase droppedVideoFrames];
    _curState = curState;
    
    StreamState deltaS  = {0};
    deltaS.timeSecond    = curState.timeSecond    -_lastStD.timeSecond    ;
    deltaS.uploadKByte   = curState.uploadKByte   -_lastStD.uploadKByte   ;
    deltaS.encodedFrames = curState.encodedFrames -_lastStD.encodedFrames ;
    deltaS.droppedVFrames= curState.droppedVFrames-_lastStD.droppedVFrames;
    _deltaS = deltaS;
    
    _lastStD = curState;
}

#pragma mark TCShowLiveTopViewToSDKDelegate
#pragma mark 推拉流请求所的码率
- (void)refreshKBPS:(TCShowLiveTopView *)topView
{
    [self getStreamState];
    
    double speedK = 0;
    if (self.liveType == FW_LIVE_TYPE_HOST)
    {
        speedK = _deltaS.uploadKByte * 8;
        
        // 视频丢帧百分率
        double dropPercent = _deltaS.droppedVFrames * 100.0 /MAX(_curState.encodedFrames, 1);
        if (dropPercent <= 0.2)
        {
            _lossRateSendTipLabel.hidden = YES;
        }
        else if(dropPercent > 0.2 && dropPercent < 0.3)
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
    }
    else if (self.liveType == FW_LIVE_TYPE_RELIVE)
    {
        speedK = [_ksyPlayerController speedK];
    }
    else if (self.liveType == FW_LIVE_TYPE_AUDIENCE)
    {
        if (self.mickType == FW_MICK_TYPE_KSY)
        {
            speedK = [_ksyLinkMicPlayerController speedK];
        }
        else if(self.mickType == FW_MICK_TYPE_AGORA)
        {
            speedK = [_agoraLinkMicPlayerController speedK];
        }
    }
    
    long totalkb = speedK / 8;
    
    if (totalkb)
    {
        topView.kbpsSendLabel.hidden = NO;
        topView.kbpsRecvLabel.hidden = YES;
        
        CGRect newFrame = topView.kbpsSendLabel.frame;
        newFrame.origin.y = CGRectGetHeight(topView.kbpsContainerView.frame)/4;
        topView.kbpsSendLabel.frame = newFrame;
        
        topView.kbpsSendLabel.text = [NSString stringWithFormat:@"%@%ldk",self.liveType == 0 ? @"↑" : @"↓" ,totalkb];
    }
    else
    {
        topView.kbpsSendLabel.hidden = YES;
        topView.kbpsRecvLabel.hidden = YES;
    }
}


#pragma mark  - ----------------------- 其他 -----------------------
#pragma mark 悬浮window相关delegate
+ (UIViewController *)showLiveViewCwith:(TCShowLiveListItem *)liveListItem
{
    if (!liveListItem)
    {
        return nil;
    }
    else
    {
        return [[FWKSYLiveController alloc]initWith:liveListItem];
    }
}

#pragma mark 满屏处理完毕
- (void)showFullScreenFinished:(void (^)(BOOL))block{
    
}

- (void)showAnimationComplete:(void (^)(BOOL))block{
    BOOL  isSmallScreen;
    // 小屏幕->满屏幕
    if(LIVE_CENTER_MANAGER.liveWindowType == liveWindowTypeOfSusOfFullSize)
    {
        isSmallScreen = NO;
    }
    // 慢屏幕->小屏幕
    else if( LIVE_CENTER_MANAGER.liveWindowType == LiveWindowTypeOfSusSmallSize)
    {
        isSmallScreen = YES;
    }
    else
    {
        // 非悬浮或扩展其他悬浮  下一步代码，当前不支持，请核对代码
        isSmallScreen = NO;
        if (block)
        {
            block(NO);
        }
        return;
    }
    // 公有特性
    _liveServiceController.liveUIViewController.panGestureRec.enabled = isSmallScreen;
    _liveServiceController.liveUIViewController.liveView.hidden = isSmallScreen;
    if (block)
    {
        block(YES);
    }
}

#pragma mark------------------------------------- 直播退出 私有方法
- (void)showCloseLiveSDKInFullScreenComplete:(void (^)(BOOL finished))block{
    
    [self alertExitLive:YES isHostShowAlert:YES succ:^{
        // 退出后直播管理层
        NSLog(@"退出后直播管理层");
    } failed:^(int errId, NSString *errMsg) {
        // 退出失败
    }];
}

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
                if (self.liveType == FW_LIVE_TYPE_HOST)
                {
                    
                }
                else if (self.liveType == FW_LIVE_TYPE_RELIVE)
                {
                    
                }
                else if (self.liveType == FW_LIVE_TYPE_AUDIENCE)
                {
                    if (self.mickType == FW_MICK_TYPE_KSY)
                    {
                        
                    }
                    else if(self.mickType == FW_MICK_TYPE_AGORA)
                    {
                        
                    }
                }
            }
            else
            {
                if (self.liveType == FW_LIVE_TYPE_HOST)
                {
                    
                }
                else if (self.liveType == FW_LIVE_TYPE_RELIVE)
                {
                    
                }
                else if (self.liveType == FW_LIVE_TYPE_AUDIENCE)
                {
                    if (self.mickType == FW_MICK_TYPE_KSY)
                    {
                        
                    }
                    else if(self.mickType == FW_MICK_TYPE_AGORA)
                    {
                        
                    }
                }
            }
        }
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
