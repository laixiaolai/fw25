//
//  FWTLinkMicPlayController.m
//  FanweApp
//
//  Created by xfg on 16/12/5.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FWTLinkMicPlayController.h"
#import <TXLiteAVSDK_Professional/TXLivePush.h>

@implementation TCLivePushListenerImpl

- (void)onPushEvent:(int)evtID withParam:(NSDictionary*)param
{
    if (self.delegate)
    {
        [self.delegate onLivePushEvent:self.pushUrl withEvtID:evtID andParam:param];
    }
}

- (void)onNetStatus:(NSDictionary*) param
{
    if (self.delegate)
    {
        [self.delegate onLivePushNetStatus:self.pushUrl withParam:param];
    }
}

@end


@interface FWTLinkMicPlayController()<ITCLivePushListener, ITCLivePlayListener>
{
    BOOL                    _isBeingLinkMic;        // 是否正在连麦中
    BOOL                    _isNeedLoading;         // 是否需要展示加载指示器
    
    UIView*                 _smallPlayVideoView;    // 小主播预览窗口
    UIView*                 _fullScreenVideoView;   // 大主播全屏窗口
    
    UIView*                 _loadingBackground;     // 加载中的背景
    UIImageView *           _loadingImageView;      // 加载中的背景图
    
    TCLivePushListenerImpl* _txLivePushListener;    // 小主播推流监听
    TXLivePushConfig *      _txLivePushConfig;      // 小主播推流配置
    TXLivePush *            _txLivePush;            // SDK推流类
    
    TCLivePlayListenerImpl* _txLivePlayListener;    // 拉流监听
    TXLivePlayConfig *      _txLivePlayConfig;      // 拉流配置
    TXLivePlayer *          _txLivePlayer;          // SDK拉流类
}

@end


@implementation FWTLinkMicPlayController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _isBeingLinkMic = false;
    _isWaitingResponse = false;
    _isNeedLoading = YES;
    
    _txLivePushListener = [[TCLivePushListenerImpl alloc] init];
    _txLivePushListener.delegate = self;
    _txLivePushConfig = [[TXLivePushConfig alloc] init];
    _txLivePushConfig.frontCamera = YES;
    _txLivePushConfig.enableAEC = YES;
    _txLivePushConfig.videoResolution       =  VIDEO_RESOLUTION_TYPE_320_480;
    _txLivePushConfig.videoBitratePIN       = 240;
    _txLivePushConfig.enableAutoBitrate     = NO;
    _txLivePushConfig.enableHWAcceleration  = YES;
    _txLivePushConfig.pauseFps              = 10;
    _txLivePushConfig.pauseTime             = 150;
    _txLivePushConfig.pauseImg = [UIImage imageNamed:@"lr_bg_leave"];
    _txLivePush = [[TXLivePush alloc] initWithConfig:_txLivePushConfig];
    _txLivePush.delegate = _txLivePushListener;
    
    _txLivePlayListener = [[TCLivePlayListenerImpl alloc] init];
    _txLivePlayListener.delegate = self;
    _txLivePlayConfig = [[TXLivePlayConfig alloc] init];
    _txLivePlayer = [[TXLivePlayer alloc] init];
    _txLivePlayer.delegate = _txLivePlayListener;
    [_txLivePlayer setConfig:_txLivePlayConfig];
    
    _playItemArray = [NSMutableArray array];
    _linkMemeberSet = [NSMutableSet set];

    [self addLinkMicPlayItem];
}

- (void)addLinkMicPlayItem
{
    for (int i = 0; i<2; i++)
    {
        FWTLinkMicPlayItem* playItem = [[FWTLinkMicPlayItem alloc] init];
        playItem.videoView = [[UIView alloc] init];
        [self.view addSubview:playItem.videoView];
        
        playItem.livePlayListener = [[TCLivePlayListenerImpl alloc] init];
        playItem.livePlayListener.delegate = self;
        TXLivePlayConfig * playConfig0 = [[TXLivePlayConfig alloc] init];
        playItem.livePlayer = [[TXLivePlayer alloc] init];
        playItem.livePlayer.delegate = playItem.livePlayListener;
        [playItem.livePlayer setConfig: playConfig0];
        [playItem.livePlayer setRenderMode:RENDER_MODE_FILL_EDGE];
        playItem.pending = false;
        playItem.itemIndex = i;
        [playItem emptyPlayInfo];
        
        [_playItemArray addObject:playItem];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (_smallPlayVideoView == nil)
    {
        _smallPlayVideoView = [[UIView alloc] init];
        [self.view addSubview:_smallPlayVideoView];
    }
    
    if (_fullScreenVideoView == nil)
    {
        _fullScreenVideoView = self.videoContrainerView;
    }
}


#pragma mark - ----------------------- 开始、停止连麦 -----------------------
#pragma mark 开始连麦
- (void)startLinkMic
{
    if (_isBeingLinkMic || _isWaitingResponse)
    {
        return;
    }
    
    if (!_isBeingLinkMic)
    {
        _isBeingLinkMic = YES;
        
        [self authorizationCheck];
        
        //结束从CDN拉流
        [self stopRtmp];
        
        //开始连麦，启动推流
        _txLivePushListener.pushUrl = _push_rtmp2;
        [_txLivePush startPreview:_smallPlayVideoView];
        [_txLivePush startPush:_push_rtmp2];
        
        //开始loading
        [self startLoading];
    }
}

#pragma mark 停止连麦
- (void)stopLinkMic
{
    _isNeedLoading = YES;
    
    if (_isBeingLinkMic)
    {
        //结束推流
        [_txLivePush stopPreview];
        [_txLivePush stopPush];
        
        //结束拉流
        [_txLivePlayer removeVideoWidget];
        [_txLivePlayer stopPlay];
        
        //结束连麦加载动画
        [self stopLoading];
        
        _isBeingLinkMic = NO;
        _isWaitingResponse = NO;
        
        if (_linkMicPlayDelegate && [_linkMicPlayDelegate respondsToSelector:@selector(pushMickResult:userID:)])
        {
            [_linkMicPlayDelegate pushMickResult:NO userID:[[IMAPlatform sharedInstance].host imUserId]];
        }
        
        for (FWTLinkMicPlayItem *playItem in _playItemArray)
        {
            [playItem stopPlay];
            [playItem stopLoading];
            [playItem emptyPlayInfo];
        }
        
        [_linkMemeberSet removeAllObjects];
    }
}

- (void)startLinkMic:(TLiveMickModel *)mickModel
{
    if (!_isBeingLinkMic)
    {
        _push_rtmp2 = mickModel.push_rtmp2;
        _play_rtmp_acc = mickModel.play_rtmp_acc;
        [self startLinkMic];
    }
}
#pragma mark 调整连麦窗口
- (void)adjustPlayItem:(TLiveMickListModel *)mickListModel
{
    @synchronized (_linkMemeberSet)
    {
        [_linkMemeberSet removeAllObjects];
        
        if (!_isBeingLinkMic)
        {
            for (FWTLinkMicPlayItem *playItem in _playItemArray)
            {
                [playItem stopPlay];
                [playItem stopLoading];
                [playItem emptyPlayInfo];
                
                return;
            }
        }
        
        for (TLiveMickModel *mickModel in mickListModel.list_lianmai)
        {
            //加入连麦成员列表
            [_linkMemeberSet addObject:mickModel.user_id];
            
            TLiveMickLayoutParamModel *paramModel = mickModel.layout_params;
            if ([[[IMAPlatform sharedInstance].host imUserId] isEqualToString:mickModel.user_id])
            {
                if (!_isClickedMickBtn)
                {
                    mickModel.play_rtmp_acc = mickListModel.play_rtmp_acc;
                    [self startLinkMic:mickModel];
                }
                
                _smallPlayVideoView.frame = CGRectMake(kScreenW * paramModel.location_x, kScreenH * paramModel.location_y, kScreenW * paramModel.image_width, kScreenH * paramModel.image_height);
                
                if (_isNeedLoading)
                {
                    _isNeedLoading = NO;
                    [self initLoadingView:_fullScreenVideoView];
                }
            }
            else
            {
                BOOL isHasPlayItem = NO;
                FWTLinkMicPlayItem *tmpPlayItem;
                int i = 0;
                
                for (FWTLinkMicPlayItem *playItem in _playItemArray)
                {
                    i ++;
                    
                    if ([playItem.userID isEqualToString:mickModel.user_id])
                    {
                        isHasPlayItem = YES;
                        
                        playItem.videoView.frame = CGRectMake(kScreenW * paramModel.location_x, kScreenH * paramModel.location_y, kScreenW * paramModel.image_width, kScreenH * paramModel.image_height);
                        
                        break;
                    }
                    
                    if (([FWUtils isBlankString:playItem.userID] || i == [_playItemArray count]) && !tmpPlayItem)
                    {
                        tmpPlayItem = playItem;
                    }
                }
                
                if (!isHasPlayItem)
                {
                    TLiveMickLayoutParamModel *paramModel = mickModel.layout_params;
                    tmpPlayItem.videoView.frame = CGRectMake(kScreenW * paramModel.location_x, kScreenH * paramModel.location_y, kScreenW * paramModel.image_width, kScreenH * paramModel.image_height);
                    
                    [tmpPlayItem stopPlay];
                    [tmpPlayItem emptyPlayInfo];
                    
                    tmpPlayItem.pending = YES;
                    tmpPlayItem.isWorking = YES;
                    tmpPlayItem.userID = mickModel.user_id;
                    [tmpPlayItem setLoadingText:@"等待观众推流···"];
                    [tmpPlayItem initLoadingView:tmpPlayItem.videoView];
                    [tmpPlayItem startLoading];
                    [tmpPlayItem startPlay:mickModel.play_rtmp2_acc];
                }
            }
        }
        
        for (FWTLinkMicPlayItem *playItem in _playItemArray)
        {
            if (!playItem.isWorking)
            {
                [playItem stopPlay];
                [playItem stopLoading];
                [playItem emptyPlayInfo];
            }
        }
    }
}

- (FWTLinkMicPlayItem*)getPlayItemByStreamUrl:(NSString*)streamUrl
{
    if (streamUrl)
    {
        for (FWTLinkMicPlayItem* playItem in _playItemArray)
        {
            if ([streamUrl isEqualToString:playItem.playUrl])
            {
                return playItem;
            }
        }
    }
    return nil;
}

#pragma mark 请求连麦超时
- (void)onWaitLinkMicResponseTimeOut
{
    if (_isWaitingResponse == YES)
    {
        _isWaitingResponse = NO;
        [self toastTip:@"连麦请求超时，主播没有做出回应"];
    }
}

#pragma mark 连麦过程出错处理
- (void)handleLinkMicFailed:(NSString*)message
{
    [self toastTip:message];
    //结束连麦
    [self stopLinkMic];
    
    [self startRtmp:self.create_type];
}

#pragma mark 权限检查
- (void)authorizationCheck
{
    //检查麦克风权限
    AVAuthorizationStatus statusAudio = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if (statusAudio == AVAuthorizationStatusDenied)
    {
        [self toastTip:@"获取麦克风权限失败，请前往隐私-麦克风设置里面打开应用权限"];
        return;
    }
    
    //是否有摄像头权限
    AVAuthorizationStatus statusVideo = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (statusVideo == AVAuthorizationStatusDenied)
    {
        [self toastTip:@"获取摄像头权限失败，请前往隐私-相机设置里面打开应用权限"];
        return;
    }
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0)
    {
        [self toastTip:@"系统不支持硬编码， 启动连麦失败"];
        return;
    }
}


#pragma mark - ----------------------- 代理事件 -----------------------
- (void)onReceiveMemberJoinNotify:(NSString*)userID withStreamID:(NSString*)streamID
{
    
}

- (void)onReceiveMemberExitNotify:(NSString*)userID
{
    
}

- (void)onLivePushEvent:(NSString*) pushUrl withEvtID:(int)event andParam:(NSDictionary*)param
{
    NSLog(@"==========PushEvtID2:%d",event);
    
    if (event == PUSH_EVT_PUSH_BEGIN)   // 开始推流事件通知
    {
        _isClickedMickBtn = YES;
        
        if (_linkMicPlayDelegate && [_linkMicPlayDelegate respondsToSelector:@selector(pushMickResult:userID:)])
        {
            [_linkMicPlayDelegate pushMickResult:YES userID:[[IMAPlatform sharedInstance].host imUserId]];
        }
        
        //1.拉取主播的低时延流
        _txLivePlayListener.playUrl = _play_rtmp_acc;
        [_txLivePlayer setupVideoWidget:CGRectMake(0, 0, 0, 0) containView: _fullScreenVideoView insertIndex:0];
        [_txLivePlayer setRenderMode:RENDER_MODE_FILL_SCREEN];
        [_txLivePlayer startPlay:_play_rtmp_acc type:PLAY_TYPE_LIVE_RTMP_ACC];
        
        //2.通知主播拉取自己的流
        //        [_tcLinkMicMgr sendMemberJoinNotify:_liveInfo.userid withJoinerID:profile.identifier andJoinerPlayUrl:_playUrl];
    }
    else if (event == PUSH_ERR_NET_DISCONNECT)
    {    //推流失败事件通知
        [self handleLinkMicFailed:@"推流失败，结束连麦"];
    }
    else if (event == PUSH_WARNING_HW_ACCELERATION_FAIL)
    {
        [self handleLinkMicFailed:@"启动硬编码失败，结束连麦"];
    }
}

- (void)onLivePushNetStatus:(NSString*)pushUrl withParam:(NSDictionary*) param
{
    [super onNetStatus:param];
}

- (void)onLivePlayEvent:(NSString*)playUrl withEvtID:(int)event andParam:(NSDictionary*)param
{
    FWTLinkMicPlayItem *playItem = [self getPlayItemByStreamUrl:playUrl];
    
    if (event == PLAY_EVT_PLAY_BEGIN)
    {
        if (playItem)
        {
            [playItem stopLoading];
        }
        else
        {
            [self stopLoading];
        }
    }
    else if (event == PLAY_EVT_PLAY_END)
    {
        if (playItem)
        {
            [playItem stopLoading];
        }
    }
    else if (event == PLAY_ERR_NET_DISCONNECT)
    {
        if (playItem)
        {
            [playItem stopPlay];
            [playItem stopLoading];
            [playItem emptyPlayInfo];
        }
    }
    else if (event == PLAY_WARNING_HW_ACCELERATION_FAIL)
    {
        if (playItem)
        {
            [playItem stopLoading];
        }
    }
    else if (event == PLAY_ERR_GET_RTMP_ACC_URL_FAIL)
    {
        [playItem reStartPlay];
    }
    
    [super onPlayEvent:event withParam:param];
}

- (void)onLivePlayNetStatus:(NSString*)playUrl withParam:(NSDictionary*)param
{
    
}

#pragma mark - ----------------------- 结束视频 -----------------------
- (void)endVideo
{
    [self stopLinkMic];
    
    [super stopRtmp];
}


#pragma mark - ----------------------- 加载动画 -----------------------
- (void)startLoading
{
    if (_loadingBackground)
    {
        _loadingBackground.hidden = NO;
    }
    
    if (_loadingImageView)
    {
        _loadingImageView.hidden = NO;
        [_loadingImageView startAnimating];
    }
}

- (void)stopLoading
{
    if (_loadingBackground)
    {
        _loadingBackground.hidden = YES;
        _loadingBackground = nil;
    }
    
    if (_loadingImageView)
    {
        _loadingImageView.hidden = YES;
        [_loadingImageView stopAnimating];
        _loadingImageView = nil;
    }
}

- (void)initLoadingView:(UIView*)view
{
    CGRect rect = view.frame;
    
    if (_loadingBackground == nil)
    {
        _loadingBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(rect), CGRectGetHeight(rect))];
        _loadingBackground.hidden = YES;
        _loadingBackground.backgroundColor = [UIColor blackColor];
        _loadingBackground.alpha  = 0.5;
        [view addSubview:_loadingBackground];
        
        UITextView * textView = [[UITextView alloc]init];
        textView.bounds = CGRectMake(0, 0, CGRectGetWidth(rect), 30);
        textView.center = CGPointMake(CGRectGetWidth(rect) / 2, CGRectGetHeight(rect) / 2 - 30);
        textView.textAlignment = NSTextAlignmentCenter;
        textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        textView.textColor = [UIColor blackColor];
        textView.text = @"连麦中···";
        textView.hidden = YES;
        [_loadingBackground addSubview:textView];
    }
    
    if (_loadingImageView == nil)
    {
        float width = 50;
        float height = 50;
        NSMutableArray *array = [[NSMutableArray alloc] initWithObjects:[UIImage imageNamed:@"loading_image0.png"],
                                 [UIImage imageNamed:@"loading_image1.png"],
                                 [UIImage imageNamed:@"loading_image2.png"],
                                 [UIImage imageNamed:@"loading_image3.png"],
                                 [UIImage imageNamed:@"loading_image4.png"],
                                 [UIImage imageNamed:@"loading_image5.png"],
                                 [UIImage imageNamed:@"loading_image6.png"],
                                 [UIImage imageNamed:@"loading_image7.png"],
                                 [UIImage imageNamed:@"loading_image8.png"],
                                 [UIImage imageNamed:@"loading_image9.png"],
                                 [UIImage imageNamed:@"loading_image10.png"],
                                 [UIImage imageNamed:@"loading_image11.png"],
                                 [UIImage imageNamed:@"loading_image12.png"],
                                 [UIImage imageNamed:@"loading_image13.png"],
                                 [UIImage imageNamed:@"loading_image14.png"],
                                 nil];
        _loadingImageView = [[UIImageView alloc] init];
        _loadingImageView.bounds = CGRectMake(0, 0, width, height);
        _loadingImageView.center = CGPointMake(CGRectGetWidth(rect) / 2, CGRectGetHeight(rect) / 2);
        _loadingImageView.animationImages = array;
        _loadingImageView.animationDuration = 1;
        _loadingImageView.hidden = YES;
        [view addSubview:_loadingImageView];
    }
}


#pragma mark - ----------------------- 进入前后台 -----------------------
#pragma mark app进入后台
- (void)onAppDidEnterBackGround
{
    [super onAppDidEnterBackGround];
    
    if (_isBeingLinkMic)
    {
        [_txLivePush pausePush];
    }
}

#pragma mark app将要进入前台
- (void)onAppWillEnterForeground
{
    [super onAppWillEnterForeground];
    
    if (_isBeingLinkMic)
    {
        [_txLivePush resumePush];
    }
}

@end
