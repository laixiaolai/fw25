//
//  FWKSYLinkMicPlayerController.m
//  FanweApp
//
//  Created by xfg on 2017/2/13.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "FWKSYLinkMicPlayerController.h"

#define kCfgTimes   0.25   // 连麦参数相对于推流参数的倍数

@interface FWKSYLinkMicPlayerController ()
{
    GlobalVariables         *_fanweApp;
    NSMutableDictionary     *_obsDict;
}

@end

@implementation FWKSYLinkMicPlayerController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark 开始鉴权
/*
 *  开始鉴权
 *  applicantId：申请连麦者ID
 */
- (void)startRegister:(NSString *)applicantId
{
    _applicantId = applicantId;
    
    _fanweApp = [GlobalVariables sharedInstance];
    
    _gPUStreamerKit = [[KSYRTCStreamerKit alloc] initWithDefaultCfg];
    
    // 采集相关设置初始化
    [self setCaptureCfg];
    // 推流相关设置初始化
    [self setStreamerCfg];
    // 设置rtc参数
    [self setStreamerKitCfg];
    
    // 添加监听
    [self initObservers];
    [self addObservers];
}

#pragma mark 开始连麦
/*
 *  开始连麦
 *  applicantId：申请连麦者ID
 *  responderId：接收连麦者ID
 */
- (void)startLinkMic:(NSString *)applicantId andResponderId:(NSString *)responderId
{
    [self.moviePlayer pause];
    int ret = [_gPUStreamerKit.rtcClient startCall:responderId];
    NSLog(@"%d",ret);
    if (_gPUStreamerKit)
    {
        self.videoContrainerView.hidden = YES;
        [_gPUStreamerKit startPreview:self.view];
    }
}

#pragma mark 停止连麦
/*
 *  停止连麦
 *  applicantId：申请连麦者ID
 */
- (void)stopLinkMic:(NSString *)applicantId
{
    if (_gPUStreamerKit)
    {
        if (_gPUStreamerKit.callstarted)
        {
            [_gPUStreamerKit.rtcClient stopCall];
        }
        else
        {
            [_gPUStreamerKit.rtcClient unRegisterRTC];
            [_gPUStreamerKit stopPreview];
            _gPUStreamerKit = nil;
        }
    }
    
    self.videoContrainerView.hidden = NO;
    [self.moviePlayer play];
    
    if (_linkMicPlayDelegate && [_linkMicPlayDelegate respondsToSelector:@selector(applicantLinkMickResult:applicantId:)])
    {
        [_linkMicPlayDelegate applicantLinkMickResult:NO applicantId:_applicantId];
    }
}

#pragma mark 结束播放
- (void)stopPlay
{
    [super stopPlay];
    [self stopLinkMic:_applicantId];
}

#pragma mark - ----------------------- 配置 -----------------------
#pragma mark 采集相关设置初始化
- (void)setCaptureCfg
{
    _gPUStreamerKit.videoOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    //配置profile 0：标清(360*640) 1：高清(540*960) 2：超清(720*1280)
    if (_fanweApp.appModel.video_resolution_type == 0)
    {
        [_gPUStreamerKit setStreamerProfile:KSYStreamerProfile_360p_auto];
    }
    else if (_fanweApp.appModel.video_resolution_type == 1)
    {
        [_gPUStreamerKit setStreamerProfile:KSYStreamerProfile_540p_auto];
    }
    else if (_fanweApp.appModel.video_resolution_type == 2)
    {
        [_gPUStreamerKit setStreamerProfile:KSYStreamerProfile_720p_auto];
    }
    // 视频帧率 默认:15
    _gPUStreamerKit.videoFPS = 15;
    
    // 摄像头位置  (仅在开始采集前设置有效)
    _gPUStreamerKit.cameraPosition = AVCaptureDevicePositionFront;
    // gpu output pixel format (默认:kCVPixelFormatType_32BGRA) (仅在开始采集前设置有效)
    _gPUStreamerKit.gpuOutputPixelFormat = kCVPixelFormatType_32BGRA;
    
    // 视频处理回调接口
    _gPUStreamerKit.videoProcessingCallback = ^(CMSampleBufferRef buf){
        // 在此处添加自定义图像处理, 直接修改buf中的图像数据会传递到观众端
        // 或复制图像数据之后再做其他处理, 则观众端仍然看到处理前的图像
    };
    
    // 采集模块输出的像素格式 (默认:kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange) (仅在开始采集前设置有效)
    //    _gPUStreamerKit.capturePixelFormat   = kCVPixelFormatType_32BGRA;
    
    // 音频处理回调接口
    //    _gPUStreamerKit.audioProcessingCallback = ^(CMSampleBufferRef buf){
    //        // 在此处添加自定义音频处理, 直接修改buf中的pcm数据会传递到观众端
    //        // 或复制音频数据之后再做其他处理, 则观众端仍然听到原始声音
    //    };
    //
    //    // 摄像头采集被打断的消息通知
    //    _gPUStreamerKit.interruptCallback = ^(BOOL bInterrupt){
    //        // 在此处添加自定义图像采集被打断的处理 (比如接听电话等)
    //    };
}

#pragma mark 推流相关设置初始化
- (void)setStreamerCfg
{
    if (_gPUStreamerKit.streamerBase == nil)
    {
        return;
    }
    
    // must set after capture
    // stream default settings
    // 视频编码器 默认为 自动选择
    _gPUStreamerKit.streamerBase.videoCodec = KSYVideoCodec_AUTO;
    
    if (_fanweApp.appModel.video_resolution_type == 0)
    {
        // 视频编码起始码率（单位:kbps, 默认:500）
        _gPUStreamerKit.streamerBase.videoInitBitrate =  400 * kCfgTimes;
        // 视频编码最高码率（单位:kbps, 默认:800）
        _gPUStreamerKit.streamerBase.videoMaxBitrate  =  800 * kCfgTimes;
        // 视频编码最低码率（单位:kbps, 默认:200）
        _gPUStreamerKit.streamerBase.videoMinBitrate  =  200 * kCfgTimes;
    }
    else if (_fanweApp.appModel.video_resolution_type == 1)
    {
        // 视频编码起始码率（单位:kbps, 默认:500）
        _gPUStreamerKit.streamerBase.videoInitBitrate =  600 * kCfgTimes;
        // 视频编码最高码率（单位:kbps, 默认:800）
        _gPUStreamerKit.streamerBase.videoMaxBitrate  =  1000 * kCfgTimes;
        // 视频编码最低码率（单位:kbps, 默认:200）
        _gPUStreamerKit.streamerBase.videoMinBitrate  =  200 * kCfgTimes;
    }
    else if (_fanweApp.appModel.video_resolution_type == 2)
    {
        // 视频编码起始码率（单位:kbps, 默认:500）
        _gPUStreamerKit.streamerBase.videoInitBitrate =  800 * kCfgTimes;
        // 视频编码最高码率（单位:kbps, 默认:800）
        _gPUStreamerKit.streamerBase.videoMaxBitrate  =  1000 * kCfgTimes;
        // 视频编码最低码率（单位:kbps, 默认:200）
        _gPUStreamerKit.streamerBase.videoMinBitrate  =  200 * kCfgTimes;
    }
    
    // 音频编码码率（单位:kbps）
    _gPUStreamerKit.streamerBase.audiokBPS        =   48;
    // 收集网络相关状态的日志，默认开启
    _gPUStreamerKit.streamerBase.shouldEnableKSYStatModule = NO;
    // 获取Streamer中与网络相关的日志
    _gPUStreamerKit.streamerBase.logBlock = ^(NSString* str){
        // NSLog(@"%@", str);
    };
    
    //    // 直播场景 (KSY内部会根据场景的特征进行参数调优)
    //    _gPUStreamerKit.streamerBase.liveScene       =  KSYLiveScene_Showself;
    //    // 视频编码性能档次 (视频质量 和 设备资源之间的权衡)
    //    _gPUStreamerKit.streamerBase.videoEncodePerf =  KSYVideoEncodePer_Balance;
    //    // 是否处理视频的图像数据 (默认YES)
    //    _gPUStreamerKit.streamerBase.bWithVideo      = YES;
    //    //是否冻结图像(主动提供重复图像) 比如:视频采集被打断时, bAutoRepeat为NO,则停止提供图像; 为YES, 则主动提供最后一帧图像
    //    _gPUStreamerKit.gpuToStr.bAutoRepeat         = YES;
    //    // 自动重连次数 关闭(0), 开启(>0), 默认为0
    //    _gPUStreamerKit.maxAutoRetry = 3;
}

- (UIView *)createUIView
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    view.layer.borderWidth = 10;
    view.layer.borderColor = [kClearColor CGColor];
    return view;
}

#pragma mark 设置rtc参数
- (void)setStreamerKitCfg
{
    //设置鉴权信息
    _gPUStreamerKit.rtcClient.authString = nil;//设置ak/sk鉴权信息,本demo从testAppServer取，客户请从自己的appserver获取。
    //设置音频属性
    _gPUStreamerKit.rtcClient.sampleRate = 44100;//设置音频采样率，暂时不支持调节
    //设置视频属性
    _gPUStreamerKit.rtcClient.videoFPS = 15; //设置视频帧率
    _gPUStreamerKit.rtcClient.videoWidth = 360;//设置视频的宽高，和当前分辨率相关,注意一定要保持16:9
    _gPUStreamerKit.rtcClient.videoHeight = 640;
    _gPUStreamerKit.rtcClient.MaxBps = 256000;//设置rtc传输的最大码率,如果推流卡顿，可以设置该参数
    //设置小窗口属性
    _gPUStreamerKit.winRect = CGRectMake(kLinkMickXRate, kLinkMickYRate, kLinkMickWRate, kLinkMickHRate);//设置小窗口属性
    _gPUStreamerKit.rtcLayer = 4;//设置小窗口图层，因为主版本占用了1~3，建议设置为4
    
    //特性1：悬浮图层，用户可以在小窗口叠加自己的view，注意customViewLayer >rtcLayer,（option）
//    _gPUStreamerKit.customViewRect = CGRectMake(0.6, 0.6, 0.3, 0.3);
//    _gPUStreamerKit.customViewLayer = 5;
//    
//    UIView * customView = [self createUIView];
//    [_gPUStreamerKit.contentView addSubview:customView];
    
    //特性2:圆角小窗口
    //    _gPUStreamerKit.maskPicture = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"mask.png"]];
    
    //rtcClient的回调，（option）
    __weak typeof(self) ws = self;
    
    // 接收注册结果的回调函数
    _gPUStreamerKit.rtcClient.onRegister= ^(int status){
        NSLog(@"======接收注册结果的回调函数，状态码:%d",status);
        
        if (ws.linkMicPlayDelegate && [ws.linkMicPlayDelegate respondsToSelector:@selector(registerResult2:registerUserId:)])
        {
            [ws.linkMicPlayDelegate registerResult2:status registerUserId:ws.applicantId];
        }
    };
    
    // 接收反注册结果的回调函数
    _gPUStreamerKit.rtcClient.onUnRegister= ^(int status){
        NSLog(@"unregister callback");
        
        if (ws.linkMicPlayDelegate && [ws.linkMicPlayDelegate respondsToSelector:@selector(unRegisterResult2:registerUserId:)])
        {
            [ws.linkMicPlayDelegate unRegisterResult2:status registerUserId:ws.applicantId];
        }
    };
    
    // start call的回调函数
    _gPUStreamerKit.onCallStart =^(int status){
        
        NSLog(@"oncallstart:%d",status);
        
        if(status == 200)   // 建立连接
        {
            if([UIApplication sharedApplication].applicationState != UIApplicationStateBackground)
            {
                if (ws.linkMicPlayDelegate && [ws.linkMicPlayDelegate respondsToSelector:@selector(applicantLinkMickResult:applicantId:)])
                {
                    [ws.linkMicPlayDelegate applicantLinkMickResult:YES applicantId:ws.applicantId];
                }
            }
        }
        else if(status == 408)  // 对方无应答
        {
            [ws stopLinkMic:ws.applicantId];
            
            if (ws.linkMicPlayDelegate && [ws.linkMicPlayDelegate respondsToSelector:@selector(applicantLinkMickResult:applicantId:)])
            {
                [ws.linkMicPlayDelegate applicantLinkMickResult:NO applicantId:ws.applicantId];
            }
        }
        else if(status == 404)  // 呼叫未注册号码,主动停止
        {
            [ws stopLinkMic:ws.applicantId];
            
            if (ws.linkMicPlayDelegate && [ws.linkMicPlayDelegate respondsToSelector:@selector(applicantLinkMickResult:applicantId:)])
            {
                [ws.linkMicPlayDelegate applicantLinkMickResult:NO applicantId:ws.applicantId];
            }
        }
    };
    
    // stop call的回调函数
    _gPUStreamerKit.onCallStop = ^(int status){
        
        NSLog(@"oncallstop:%d",status);
        
        if(status == 200)
        {
            if([UIApplication sharedApplication].applicationState != UIApplicationStateBackground)
            {
                NSLog(@"断开连接");
            }
        }
        else if(status == 408)
        {
            NSLog(@"408超时");
        }
        
        [ws stopLinkMic:ws.applicantId];
        
        if (ws.linkMicPlayDelegate && [ws.linkMicPlayDelegate respondsToSelector:@selector(applicantLinkMickResult:applicantId:)])
        {
            [ws.linkMicPlayDelegate applicantLinkMickResult:NO applicantId:ws.applicantId];
        }
    };
    
    //sdk日志接口（option）
    _gPUStreamerKit.rtcClient.openRtcLog = NO;//是否打开rtc的日志
    _gPUStreamerKit.rtcClient.sdkLogBlock = ^(NSString * message){
        NSLog(@"=======辅播端rtc的日志：%@",message);
    };
}

#pragma mark - ----------------------- 监听 -----------------------
- (void)initObservers
{
    _obsDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                SEL_VALUE(onCaptureStateChange:) ,  KSYCaptureStateDidChangeNotification,
                SEL_VALUE(onStreamStateChange:) ,   KSYStreamStateDidChangeNotification,
                SEL_VALUE(onBgmPlayerStateChange:) ,KSYAudioStateDidChangeNotification,
                nil];
}

- (void)addObservers
{
    //KSYStreamer state changes
    NSNotificationCenter* dc = [NSNotificationCenter defaultCenter];
    for (NSString* key in _obsDict)
    {
        SEL aSel = [[_obsDict objectForKey:key] pointerValue];
        [dc addObserver:self
               selector:aSel
                   name:key
                 object:nil];
    }
}

- (void)setInFront
{
    _gPUStreamerKit.selfInFront = YES;
}

#pragma mark state change
- (void)onCaptureStateChange:(NSNotification *)notification
{
    if (_gPUStreamerKit.captureState == KSYCaptureStateIdle)
    {
        self.view.backgroundColor = [UIColor darkGrayColor];
    }
    else if(_gPUStreamerKit.captureState == KSYCaptureStateCapturing)
    {
        self.view.backgroundColor = [UIColor lightGrayColor];
        [self performSelector:@selector(setInFront) withObject:nil afterDelay:3];
    }
}

#pragma mark 推流状态监听
- (void)onStreamStateChange:(NSNotification *)notification
{
    if (_gPUStreamerKit.streamerBase)
    {
        NSLog(@"stream State %@", [_gPUStreamerKit.streamerBase getCurStreamStateName]);
    }
    
    if(_gPUStreamerKit.streamerBase.streamState == KSYStreamStateError)
    {
        [self onStreamError:_gPUStreamerKit.streamerBase.streamErrorCode];
    }
    else if (_gPUStreamerKit.streamerBase.streamState == KSYStreamStateConnecting)
    {
        
    }
    else if (_gPUStreamerKit.streamerBase.streamState == KSYStreamStateConnected)
    {
        self.view.backgroundColor = [UIColor lightGrayColor];
        
    }
    else if (_gPUStreamerKit.streamerBase.streamState == KSYStreamStateIdle)
    {
        self.view.backgroundColor = [UIColor darkGrayColor];
    }
}

#pragma mark 推流错误处理
- (void)onStreamError:(KSYStreamErrorCode) errCode
{
    if (errCode == KSYStreamErrorCode_CONNECT_BREAK)
    {
        [self tryReconnect];
    }
    else if (errCode == KSYStreamErrorCode_AV_SYNC_ERROR)
    {
        NSLog(@"audio video is not synced, please check timestamp");
        [self tryReconnect];
    }
    else if (errCode == KSYStreamErrorCode_CODEC_OPEN_FAILED)
    {
        NSLog(@"video codec open failed, try software codec");
        _gPUStreamerKit.streamerBase.videoCodec = KSYVideoCodec_X264;
        [self tryReconnect];
    }
}

- (void)onBgmPlayerStateChange:(NSNotification *)notification
{
    NSString *st = [_gPUStreamerKit.bgmPlayer getCurBgmStateName];
    NSLog(@"=====bgmStatus:%@",[st substringFromIndex:17]);
}

#pragma mark 尝试重连
- (void)tryReconnect
{
    //    if (_gPUStreamerKit.maxAutoRetry > 0)
    //    {
    //        return;
    //    }
    dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC));
    dispatch_after(delay, dispatch_get_main_queue(), ^{
        [_gPUStreamerKit.streamerBase startStream:self.pushUrl];
    });
}


@end
