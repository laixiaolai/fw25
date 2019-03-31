
#import <libksygpulive/KSYGPUPicOutput.h>
#import <libksygpulive/libksystreamerengine.h>
#import <libksygpulive/KSYGPUStreamerKit.h>
#import "KSYAgoraClient.h"
#import <GPUImage/GPUImage.h>
#import "KSYAgoraStreamerKit.h"


#if __arm__  || __arm64__
@interface KSYAgoraStreamerKit (){
}

@property KSYGPUPicOutput *     beautyOutput;
@property KSYGPUYUVInput  *     rtcYuvInput;
@property GPUImageUIElement *   uiElementInput;
#ifdef DEBUG
@property    FILE* audioRenderFile;
#endif
@end

@implementation KSYAgoraStreamerKit

/**
 @abstract 初始化方法
 @discussion 初始化，创建带有默认参数的 KSYStreamerBase
 
 @warning KSYStreamer只支持单实例推流，构造多个实例会出现异常
 */
- (instancetype) initWithDefaultCfg {
    self = [super initWithDefaultCfg];
    _agoraKit = [[KSYAgoraClient alloc] initWithAppId:AgoraAppId];
    _beautyOutput = nil;
    _callstarted = NO;
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height)];
    _contentView.backgroundColor = [UIColor clearColor];
    _curfilter = self.filter;
    
    __weak KSYAgoraStreamerKit * weak_kit = self;
    //加入channel成功回调,开始发送数据
    _agoraKit.joinChannelBlock = ^(NSString* channel, NSUInteger uid, NSInteger elapsed){
        if(channel)
        {
            if(!weak_kit.beautyOutput)
            {
                [weak_kit setupBeautyOutput];
                [weak_kit setupRtcFilter:weak_kit.curfilter];
            }
            
            if(weak_kit.onChannelJoin)
                weak_kit.onChannelJoin(200);
        }
    };
    
    //离开channel成功回调
    _agoraKit.leaveChannelBlock = ^(AgoraRtcStats* stat){
        weak_kit.callstarted = NO;
        [weak_kit stopRTCView];
        if(weak_kit.onCallStop)
            weak_kit.onCallStop(200);
    };
    
    //接收数据回调，放入yuvinput里面
    _agoraKit.videoDataCallback=^(CVPixelBufferRef buf){
        [weak_kit defaultRtcVideoCallback:buf];
    };
    
    //音频回调，放入amixer里面
    _agoraKit.audioDataCallback=^(void* buffer,int sampleRate,int len,int bytesPerSample,int channels)
    {
        if(weak_kit.callstarted)
        {
            [weak_kit defaultRtcVoiceCallback:buffer len:len pts:0 channel:channels sampleRate:sampleRate sampleBytes:bytesPerSample];
#ifdef DEBUG
            if(weak_kit.audioRenderFile)
            {
                fwrite(buffer, 1, len, weak_kit.audioRenderFile);
                fflush(weak_kit.audioRenderFile);
            }
#endif
        }
    };
    
    //注册进入后台的处理
    NSNotificationCenter* dc = [NSNotificationCenter defaultCenter];
    [dc addObserver:self
           selector:@selector(enterbg)
               name:UIApplicationDidEnterBackgroundNotification
             object:nil];
    
    [dc addObserver:self
           selector:@selector(becomeActive)
               name:UIApplicationDidBecomeActiveNotification
             object:nil];
    
    [dc addObserver:self
           selector:@selector(resignActive)
               name:UIApplicationWillResignActiveNotification
             object:nil];
    
    [dc addObserver:self
           selector:@selector(enterFg)
               name:UIApplicationWillEnterForegroundNotification
             object:nil];
    
    [dc addObserver:self
           selector:@selector(interruptHandler:)
               name:AVAudioSessionInterruptionNotification
             object:nil];
    
    
    return self;
}

- (void)interruptHandler:(NSNotification *)notification {
    UInt32 interruptionState = [notification.userInfo[AVAudioSessionInterruptionTypeKey] unsignedIntValue];
    if (interruptionState == kAudioSessionBeginInterruption){
        if(_callstarted)
            [self stopRTCView];
    }
    else if (interruptionState == kAudioSessionEndInterruption){
        if(_callstarted)
            [self startRtcView];
    }
}

- (instancetype)init {
    return [self initWithDefaultCfg];
}
- (void)dealloc {
    NSLog(@"kit dealloc ");
    if(_agoraKit){
        [_agoraKit leaveChannel];
        _agoraKit = nil;
    }
    
    if(_beautyOutput){
        _beautyOutput = nil;
    }
    
    if(_rtcYuvInput){
        _rtcYuvInput = nil;
    }
    
    if(_contentView)
    {
        _contentView = nil;
    }
    
    NSNotificationCenter* dc = [NSNotificationCenter defaultCenter];
    [dc removeObserver:self
                  name:UIApplicationDidEnterBackgroundNotification
                object:nil];
    [dc removeObserver:self
                  name:UIApplicationWillEnterForegroundNotification
                object:nil];
    [dc removeObserver:self
                  name:AVAudioSessionInterruptionNotification
                object:nil];
    [dc removeObserver:self
                  name:UIApplicationDidBecomeActiveNotification
                object:nil];
    [dc removeObserver:self
                  name:UIApplicationWillResignActiveNotification
                object:nil];
}


- (void) setupRtcFilter:(GPUImageOutput<GPUImageInput> *) filter {
    _curfilter = filter;
    if (self.vCapDev  == nil) {
        return;
    }
    // 采集的图像先经过前处理
    [self.capToGpu     removeAllTargets];
    GPUImageOutput* src = self.capToGpu;
    
    if(filter)
    {
        [self.filter removeAllTargets];
        [src addTarget:self.filter];
        src = self.filter;
    }
    
    if (filter) {
        [self.filter removeAllTargets];
        [src addTarget:filter];
        src = filter;
    }
    
    // 组装图层
    if(_rtcYuvInput)
    {
        if(!_selfInFront)
        {
            self.vPreviewMixer.masterLayer = self.cameraLayer;
            self.vStreamMixer.masterLayer = self.cameraLayer;
            [self addPic:src       ToMixerAt:self.cameraLayer];
            [self addPic:_rtcYuvInput ToMixerAt:_rtcLayer Rect:_winRect];
        }
        else{
            self.vPreviewMixer.masterLayer = self.rtcLayer;
            self.vStreamMixer.masterLayer = self.rtcLayer;
            [self addPic:_rtcYuvInput  ToMixerAt:self.cameraLayer];
            [self addPic:src ToMixerAt:_rtcLayer Rect:_winRect];
        }
    }else{
        [self.vPreviewMixer clearPicOfLayer:_rtcLayer];
        [self.vStreamMixer clearPicOfLayer:_rtcLayer];
        self.vPreviewMixer.masterLayer = self.cameraLayer;
        self.vStreamMixer.masterLayer = self.cameraLayer;
        [self addPic:src       ToMixerAt:self.cameraLayer];
    }
    
    //组装自定义view
    if(_uiElementInput)
    {
        __weak GPUImageUIElement *weakUIEle = self.uiElementInput;
        [src setFrameProcessingCompletionBlock:^(GPUImageOutput * f, CMTime fT){
            NSArray* subviews = [_contentView subviews];
            for(int i = 0;i<subviews.count;i++)
            {
                UIView* subview = (UIView*)[subviews objectAtIndex:i];
                if(subview)
                    subview.hidden = NO;
            }
            if(subviews.count > 0)
            {
                [weakUIEle update];
            }
        }];
        [self addPic:_uiElementInput ToMixerAt:_customViewLayer Rect:_customViewRect];
    }
    else{
        [self.vPreviewMixer clearPicOfLayer:_customViewLayer];
        [self.vStreamMixer clearPicOfLayer:_customViewLayer];
        [src setFrameProcessingCompletionBlock:nil];
    }
    //美颜后的图像，用于rtc发送
    if(_beautyOutput)
    {
        [src addTarget:_beautyOutput atTextureLocation:2];
        
    }
    
    // 混合后的图像输出到预览和推流
    [self.vPreviewMixer removeAllTargets];
    [self.vPreviewMixer addTarget:self.preview];
    
    [self.vStreamMixer  removeAllTargets];
    [self.vStreamMixer  addTarget:self.gpuToStr];
    // 设置镜像
    [self setPreviewMirrored:self.previewMirrored];
    [self setStreamerMirrored:self.streamerMirrored];
}

- (void) addPic:(GPUImageOutput*)pic ToMixerAt: (NSInteger)idx{
    if (pic == nil){
        return;
    }
    [pic removeAllTargets];
    KSYGPUPicMixer * vMixer[2] = {self.vPreviewMixer, self.vStreamMixer};
    for (int i = 0; i<2; ++i) {
        [vMixer[i]  clearPicOfLayer:idx];
        [pic addTarget:vMixer[i] atTextureLocation:idx];
    }
}

- (void) addPic:(GPUImageOutput*)pic
      ToMixerAt: (NSInteger)idx
           Rect:(CGRect)rect{
    if (pic == nil){
        return;
    }
    [pic removeAllTargets];
    KSYGPUPicMixer * vMixer[2] = {self.vPreviewMixer, self.vStreamMixer};
    for (int i = 0; i<2; ++i) {
        [vMixer[i]  clearPicOfLayer:idx];
        [pic addTarget:vMixer[i] atTextureLocation:idx];
        [vMixer[i] setPicRect:rect ofLayer:idx];
        [vMixer[i] setPicAlpha:1.0f ofLayer:idx];
    }
}

#pragma mark -rtc
- (void) defaultOnCallStartCallback
{
    [self startRtcView];
    _callstarted = YES;
#ifdef DEBUG
    NSString * docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    if(!_audioRenderFile)
    {
        NSString *filePath = [docPath stringByAppendingPathComponent:@"renderAudio.pcm"];
        remove([filePath cStringUsingEncoding:NSUTF8StringEncoding]);
        _audioRenderFile =fopen([filePath cStringUsingEncoding:NSUTF8StringEncoding], "wb");
    }
#endif
    if(_onCallStart)
    {
        _onCallStart(200);
    }
}

- (void)joinChannel:(NSString *)channelName
{
    [_agoraKit joinChannel:channelName];
}
- (void)leaveChannel
{
    [_agoraKit leaveChannel];
}

- (void)setupBeautyOutput
{
    __weak KSYAgoraStreamerKit * weak_kit = self;
    _beautyOutput  =  [[KSYGPUPicOutput alloc] init];
    _beautyOutput.bCustomOutputSize = YES;
    _beautyOutput.outputSize = CGSizeMake(640, 360);
    _beautyOutput.videoProcessingCallback = ^(CVPixelBufferRef pixelBuffer, CMTime timeInfo ){
        [weak_kit.agoraKit ProcessVideo:pixelBuffer timeInfo:timeInfo];
    };
}

- (void)startRtcView
{
    [self.aMixer setTrack:2 enable:YES];
    [self.aMixer setMixVolume:1 of:2];
    
    _rtcYuvInput =    [[KSYGPUYUVInput alloc] init];
    
    if(_contentView.subviews.count != 0)
        _uiElementInput = [[GPUImageUIElement alloc] initWithView:_contentView];
    
    if(!_beautyOutput)
    {
        [self setupBeautyOutput];
    }
    
    [self setupRtcFilter:_curfilter];
}

- (void)stopRTCView
{
    [self.aMixer setTrack:2 enable:NO];
    _rtcYuvInput = nil;
    _beautyOutput = nil;
    _uiElementInput = nil;
    [self setupRtcFilter:_curfilter];
}

- (void) defaultRtcVideoCallback:(CVPixelBufferRef)buf
{
    /*
     第一帧到来的时候，开始渲染，并设置标志位
     */
    if(!_callstarted)
    {
        [self defaultOnCallStartCallback];
    }
    [self.rtcYuvInput processPixelBuffer:buf time:CMTimeMake(2, 10)];
}
- (void) defaultRtcVoiceCallback:(uint8_t*)buf
                            len:(int)len
                            pts:(uint64_t)ptsvalue
                        channel:(uint32_t)channels
                     sampleRate:(uint32_t)sampleRate
                    sampleBytes:(uint32_t)bytesPerSample
{
    
    AudioStreamBasicDescription asbd;
    asbd.mSampleRate       = sampleRate;
    asbd.mFormatID         = kAudioFormatLinearPCM;
    asbd.mFormatFlags      = kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked;
    asbd.mBitsPerChannel   = 8 * bytesPerSample;
    asbd.mBytesPerFrame    = bytesPerSample;
    asbd.mBytesPerPacket   = bytesPerSample;
    asbd.mFramesPerPacket  = channels;
    asbd.mChannelsPerFrame = channels;
    
    CMTime pts;
    pts.value = ptsvalue;
    if([self.streamerBase isStreaming])
    {
        int buflen = [self.aMixer getBufLength:2];
        if (buflen < 8){
            [self.aMixer processAudioData:&buf nbSample:len/bytesPerSample withFormat:&asbd timeinfo:pts of:2];
        }
        else {
            NSLog(@"delay >300ms,we will discard some audio");
            [self.aMixer  processAudioData:NULL
                                  nbSample:0
                                withFormat:&asbd
                                  timeinfo:pts
                                        of:2];
        }
        
    }
}

- (void) setWinRect:(CGRect)rect
{
    _winRect = rect;
    [self setupRtcFilter:_curfilter];
}

- (void)setSelfInFront:(BOOL)selfInFront{
    _selfInFront = selfInFront;
    [self setupRtcFilter:_curfilter];
}

- (void)enterbg {
    if(_callstarted)
        [self stopRTCView];
}

- (void)enterFg{
    if(_callstarted)
        [self startRtcView];
}

- (void)becomeActive
{
    __weak KSYAgoraStreamerKit * weak_kit = self;
    _agoraKit.videoDataCallback=^(CVPixelBufferRef buf){
        [weak_kit defaultRtcVideoCallback:buf];
    };
    
    NSNotificationCenter* dc = [NSNotificationCenter defaultCenter];
    [dc addObserver:self
           selector:@selector(interruptHandler:)
               name:AVAudioSessionInterruptionNotification
             object:nil];
}

- (void)resignActive
{
    _agoraKit.videoDataCallback = nil;
    NSNotificationCenter* dc = [NSNotificationCenter defaultCenter];
    [dc removeObserver:self
                  name:AVAudioSessionInterruptionNotification
                object:nil];
}

@end
#else
@implementation KSYRTCStreamerKit

- (void)stopRTCView{
    
}

/**
 @abstract 设置美颜接口
 */
- (void) setupRtcFilter:(GPUImageOutput<GPUImageInput> *) filter;
{
    
}
@end
#endif
