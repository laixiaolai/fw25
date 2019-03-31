//
//  FWKSYStreamerController.m
//  FanweLive
//
//  Created by yiqian on 10/15/15.
//  Copyright (c) 2015 ksyun. All rights reserved.
//

#import "FWKSYStreamerController.h"

// 为防止将手机存储写满,限制录像时长为30s
#define REC_MAX_TIME 30 //录制视频的最大时间，单位s

@interface FWKSYStreamerController ()
{
    CGFloat         _currentPinchZoomFactor;     // 当前触摸缩放因子
    UIImageView     *_foucsCursorImgView;       // 对焦框
    
    GlobalVariables         *_fanweApp;
    NSMutableDictionary     *_obsDict;
}
@end

@implementation FWKSYStreamerController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 添加视频容器视图
    _videoContrainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    _videoContrainerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_videoContrainerView];
    
    _fanweApp = [GlobalVariables sharedInstance];
    
    _gPUStreamerKit = [[KSYRTCStreamerKit alloc] initWithDefaultCfg];
    NSLog(@"=====当前金山SDK版本号：%@",[_gPUStreamerKit.streamerBase getKSYVersion]);
    
    // 采集相关设置初始化
    [self setCaptureCfg];
    // 推流相关设置初始化
    [self setStreamerCfg];
    
    if (_gPUStreamerKit)
    {
        _gPUStreamerKit.videoOrientation = [[UIApplication sharedApplication] statusBarOrientation];
        [_gPUStreamerKit startPreview:_videoContrainerView];
    }
    
    // 添加对焦框
    [self addfoucsCursorImgView];
    
    // 添加手势
    [self addPinchGestureRecognizer];
    
    // 添加监听
    [self initObservers];
    [self addObservers];
}

#pragma mark 对焦框
- (void)addfoucsCursorImgView
{
    _foucsCursorImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"lr_camera_focus_red"]];
    _foucsCursorImgView.frame = CGRectMake(80, 80, 80, 80);
    [self.view addSubview:_foucsCursorImgView];
    _foucsCursorImgView.alpha = 0;
}

#pragma mark - ----------------------- 推流 -----------------------
#pragma mark 开始推流
- (void)startRtmp
{
    dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC));
    dispatch_after(delay, dispatch_get_main_queue(), ^{
        [_gPUStreamerKit.streamerBase startStream:self.pushUrl];
    });
}

#pragma mark 停止推流
- (void)stopRtmp
{
    if (_gPUStreamerKit)
    {
        [_gPUStreamerKit.streamerBase stopStream];
        [_gPUStreamerKit stopPreview];
        _gPUStreamerKit = nil;
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark 尝试重连
- (void)tryReconnect
{
    if (_gPUStreamerKit.maxAutoRetry > 0)
    {
        return;
    }
    [self startRtmp];
}


#pragma mark - ----------------------- 配置 -----------------------
#pragma mark 采集相关设置初始化
- (void)setCaptureCfg
{
    // 采集分辨率 (仅在开始采集前设置有效)
    _gPUStreamerKit.capPreset = AVCaptureSessionPreset640x480;
    _gPUStreamerKit.previewDimension = CGSizeMake(640, 480);
    _gPUStreamerKit.streamDimension = CGSizeMake(640, 480);
    
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
    _gPUStreamerKit.capturePixelFormat   = kCVPixelFormatType_32BGRA;
    
    // 音频处理回调接口
    _gPUStreamerKit.audioProcessingCallback = ^(CMSampleBufferRef buf){
        // 在此处添加自定义音频处理, 直接修改buf中的pcm数据会传递到观众端
        // 或复制音频数据之后再做其他处理, 则观众端仍然听到原始声音
    };
    
    // 摄像头采集被打断的消息通知
    _gPUStreamerKit.interruptCallback = ^(BOOL bInterrupt){
        // 在此处添加自定义图像采集被打断的处理 (比如接听电话等)
    };
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
        _gPUStreamerKit.streamerBase.videoInitBitrate =  400;
        // 视频编码最高码率（单位:kbps, 默认:800）
        _gPUStreamerKit.streamerBase.videoMaxBitrate  =  800;
        // 视频编码最低码率（单位:kbps, 默认:200）
        _gPUStreamerKit.streamerBase.videoMinBitrate  =  200;
    }
    else if (_fanweApp.appModel.video_resolution_type == 1)
    {
        // 视频编码起始码率（单位:kbps, 默认:500）
        _gPUStreamerKit.streamerBase.videoInitBitrate =  600;
        // 视频编码最高码率（单位:kbps, 默认:800）
        _gPUStreamerKit.streamerBase.videoMaxBitrate  =  1000;
        // 视频编码最低码率（单位:kbps, 默认:200）
        _gPUStreamerKit.streamerBase.videoMinBitrate  =  200;
    }
    else if (_fanweApp.appModel.video_resolution_type == 2)
    {
        // 视频编码起始码率（单位:kbps, 默认:500）
        _gPUStreamerKit.streamerBase.videoInitBitrate =  800;
        // 视频编码最高码率（单位:kbps, 默认:800）
        _gPUStreamerKit.streamerBase.videoMaxBitrate  =  1000;
        // 视频编码最低码率（单位:kbps, 默认:200）
        _gPUStreamerKit.streamerBase.videoMinBitrate  =  200;
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
        if (_delegate && [_delegate respondsToSelector:@selector(firstFrame:)])
        {
            [_delegate firstIFrame:self];
        }
    }
    else if (_gPUStreamerKit.streamerBase.streamState == KSYStreamStateIdle)
    {
        self.view.backgroundColor = [UIColor darkGrayColor];
    }
    //状态为KSYStreamStateIdle且_bRecord为ture时，录制视频
    if (_gPUStreamerKit.streamerBase.streamState == KSYStreamStateIdle && _liveType == FW_LIVE_TYPE_RECORD)
    {
        //        [self saveVideoToAlbum:[_presetCfgView hostUrl]];
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


#pragma mark - ----------------------- 手势 -----------------------
#pragma mark 将UI的坐标转换成相机坐标
- (CGPoint)convertToPointOfInterestFromViewCoordinates:(CGPoint)viewCoordinates
{
    CGPoint pointOfInterest = CGPointMake(.5f, .5f);
    CGSize frameSize = self.view.frame.size;
    CGSize apertureSize = [_gPUStreamerKit captureDimension];
    CGPoint point = viewCoordinates;
    CGFloat apertureRatio = apertureSize.height / apertureSize.width;
    CGFloat viewRatio = frameSize.width / frameSize.height;
    CGFloat xc = .5f;
    CGFloat yc = .5f;
    
    if (viewRatio > apertureRatio)
    {
        CGFloat y2 = frameSize.height;
        CGFloat x2 = frameSize.height * apertureRatio;
        CGFloat x1 = frameSize.width;
        CGFloat blackBar = (x1 - x2) / 2;
        if (point.x >= blackBar && point.x <= blackBar + x2)
        {
            xc = point.y / y2;
            yc = 1.f - ((point.x - blackBar) / x2);
        }
    }
    else
    {
        CGFloat y2 = frameSize.width / apertureRatio;
        CGFloat y1 = frameSize.height;
        CGFloat x2 = frameSize.width;
        CGFloat blackBar = (y1 - y2) / 2;
        if (point.y >= blackBar && point.y <= blackBar + y2)
        {
            xc = ((point.y - blackBar) / y2);
            yc = 1.f - (point.x / x2);
        }
    }
    
    pointOfInterest = CGPointMake(xc, yc);
    return pointOfInterest;
}

//设置摄像头对焦位置
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint current = [touch locationInView:self.view];
    CGPoint point = [self convertToPointOfInterestFromViewCoordinates:current];
    [_gPUStreamerKit exposureAtPoint:point];
    [_gPUStreamerKit focusAtPoint:point];
    _foucsCursorImgView.center = current;
    _foucsCursorImgView.transform = CGAffineTransformMakeScale(1.5, 1.5);
    _foucsCursorImgView.alpha=1.0;
    [UIView animateWithDuration:1.0 animations:^{
        _foucsCursorImgView.transform=CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        _foucsCursorImgView.alpha=0;
    }];
}

#pragma mark 添加缩放手势，缩放时镜头放大或缩小
- (void)addPinchGestureRecognizer
{
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinchDetected:)];
    [self.view addGestureRecognizer:pinch];
}

- (void)pinchDetected:(UIPinchGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan)
    {
        _currentPinchZoomFactor = _gPUStreamerKit.pinchZoomFactor;
    }
    CGFloat zoomFactor = _currentPinchZoomFactor * recognizer.scale;//当前触摸缩放因子*坐标比例
    [_gPUStreamerKit setPinchZoomFactor:zoomFactor];
}


@end
