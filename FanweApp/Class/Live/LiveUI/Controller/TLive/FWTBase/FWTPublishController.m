//
//  FWTPublishController.m
//  FanweApp
//
//  Created by xfg on 16/12/5.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "FWTPublishController.h"
#import <Foundation/Foundation.h>
#import <TXLiteAVSDK_Professional/TXLiveSDKTypeDef.h>
#import <TXLiteAVSDK_Professional/TXLiveBase.h>
#import <TXLiteAVSDK_Professional/COSClient.h>
#import <sys/types.h>
#import <sys/sysctl.h>
#import <UIKit/UIKit.h>
#import <mach/mach.h>

// 清晰度定义
#define    HD_LEVEL_720P       1  //  1280 * 720
#define    HD_LEVEL_540P       2  //  960 * 540
#define    HD_LEVEL_360P       3  //  640 * 360
#define    HD_LEVEL_360_PLUS   4  //  640 * 360 且开启码率自适应

#define kRePublishTime 3        // 断开后重新尝试的次数

@interface FWTPublishController ()<TXLivePushListener>

@end

@implementation FWTPublishController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)endLive
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(startRtmp) object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initConfig];
}

#pragma mark 初始化配置
- (void)initConfig
{
    [self.view setBackgroundColor:kBackGroundColor];
    
    _txLivePushonfig = [[TXLivePushConfig alloc] init];
    _txLivePushonfig.frontCamera                = YES;
    _txLivePushonfig.enableAEC                  = YES;
    _txLivePushonfig.enableHWAcceleration       = YES;
    _txLivePushonfig.enableAutoBitrate          = NO;
    _txLivePushonfig.audioChannels              = 1; // 单声道
    
    GlobalVariables *fanweApp = [GlobalVariables sharedInstance];
    // 0：标清(360*640) 1：高清(540*960) 2：超清(720*1280)
    if (fanweApp.appModel.video_resolution_type == 0)
    {
        _txLivePushonfig.videoResolution            = VIDEO_RESOLUTION_TYPE_360_640;
        _txLivePushonfig.videoBitratePIN            = 700;
    }
    else if (fanweApp.appModel.video_resolution_type == 1)
    {
        _txLivePushonfig.videoResolution            = VIDEO_RESOLUTION_TYPE_540_960;
        _txLivePushonfig.videoBitratePIN            = 1000;
    }
    else if (fanweApp.appModel.video_resolution_type == 2)
    {
        _txLivePushonfig.videoResolution            = VIDEO_RESOLUTION_TYPE_720_1280;
        _txLivePushonfig.videoBitratePIN            = 1500;
    }
    _txLivePushonfig.autoAdjustStrategy         = NO;
    
    _txLivePushonfig.videoFPS                   = 20;
    _txLivePushonfig.audioSampleRate            = AUDIO_SAMPLE_RATE_48000;  // 不要用其它的
    _txLivePushonfig.pauseFps                   = 10;
    _txLivePushonfig.pauseTime                  = 300;
    _txLivePushonfig.pauseImg                   = [UIImage imageNamed:@"lr_bg_leave.png"];
    _txLivePublisher = [[TXLivePush alloc] initWithConfig:_txLivePushonfig];
    
    // 设置日志级别
    [TXLiveBase setLogLevel:LOGLEVEL_NULL];
    
    // 初始化视频父视图
    _preViewContainer = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view insertSubview:_preViewContainer atIndex:0];
    _preViewContainer.center = self.view.center;
    
#if TARGET_IPHONE_SIMULATOR
    [self toastTip:@"iOS模拟器不支持推流和播放，请使用真机体验"];
#endif
    
    NSLog(@"==========腾讯SDK版本号：%@",[TXLiveBase getSDKVersionStr]);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
#if !TARGET_IPHONE_SIMULATOR
    //是否有摄像头权限
    AVAuthorizationStatus statusVideo = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (statusVideo == AVAuthorizationStatusDenied)
    {
        [FanweMessage alert:@"获取摄像头权限失败，请前往隐私-相机设置里面打开应用权限"];
        return;
    }
#endif
    
}

#pragma mark - ----------------------- 开始、停止推流 -----------------------
#pragma mark 开始推流
- (BOOL)startRtmp
{
    _startTime = [[NSDate date]timeIntervalSince1970]*1000;
    _lastTime = _startTime;
    
    NSString* rtmpUrl = self.pushUrlStr;
    if (rtmpUrl.length == 0)
    {
        rtmpUrl = @"获取推流地址失败";
    }
    
    if (!([rtmpUrl hasPrefix:@"rtmp://"] ))
    {
        [FanweMessage alert:@"推流地址不合法，目前支持rtmp推流!"];
        return NO;
    }
    
    //是否有摄像头权限
    AVAuthorizationStatus statusVideo = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (statusVideo == AVAuthorizationStatusDenied)
    {
        [FanweMessage alert:@"获取摄像头权限失败，请前往隐私-相机设置里面打开应用权限"];
        return NO;
    }
    
    //是否有麦克风权限
    AVAuthorizationStatus statusAudio = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if (statusAudio == AVAuthorizationStatusDenied)
    {
        [FanweMessage alert:@"获取麦克风权限失败，请前往隐私-麦克风设置里面打开应用权限"];
        return NO;
    }
    
    if(_txLivePublisher != nil)
    {
        _txLivePublisher.delegate = self;
        if (!_isPreviewing)
        {
            [_txLivePublisher startPreview:_preViewContainer];
            _isPreviewing = YES;
        }
        
        if ([_txLivePublisher startPush:rtmpUrl] != 0)
        {
            NSLog(@"推流器启动失败");
            return NO;
        }
    }
    
    return YES;
}

#pragma mark 停止推流
- (void)stopRtmp
{
    if(_txLivePublisher != nil)
    {
        _txLivePublisher.delegate = nil;
        [_txLivePublisher stopPreview];
        _isPreviewing = NO;
        [_txLivePublisher stopPush];
    }
}


#pragma mark - ----------------------- TXLivePushListener代理事件 -----------------------
- (void)onPushEvent:(int)EvtID withParam:(NSDictionary*)param;
{
    //    NSLog(@"==========PushEvtID1:%d",EvtID);
    dispatch_async(dispatch_get_main_queue(), ^{
        if (EvtID == PUSH_EVT_PUSH_BEGIN)
        {
            if (_delegate && [_delegate respondsToSelector:@selector(firstIFrame:)])
            {
                [_delegate firstIFrame:self];
                _rePublishTime = 0;
            }
        }
        else if (EvtID == PUSH_ERR_NET_DISCONNECT)
        {
            [self stopRtmp];
            
            _rePublishTime ++;
            [self performSelector:@selector(startRtmp) withObject:nil afterDelay:3];
        }
        else if(EvtID == PUSH_WARNING_HW_ACCELERATION_FAIL)
        {
            _txLivePublisher.config.enableHWAcceleration = false;
        }
    });
}

- (void)onNetStatus:(NSDictionary*)param
{
    NSDictionary* dict = param;
    _qualityDict = param;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        int vbitrate  = [(NSNumber*)[dict valueForKey:NET_STATUS_VIDEO_BITRATE] intValue];
        int settrate  = [(NSNumber*)[dict valueForKey:NET_STATUS_SET_VIDEO_BITRATE] intValue];
        
        _kbpsRecvStr = StringFromInt(vbitrate);
        _kbpsSendStr = StringFromInt(settrate);
    });
}

#pragma mark - ----------------------- 摄像头、闪光灯 -----------------------
#pragma mark 开、关闪光灯
- (void)clickTorch:(BOOL)isOpen
{
    if (_txLivePublisher)
    {
        if (![_txLivePublisher toggleTorch:isOpen])
        {
            [self toastTip:@"闪光灯启动失败"];
        }
    }
}

#pragma mark 前置后置摄像头切换
- (void)clickCamera:(UIButton*)btn
{
    [_txLivePublisher switchCamera];
}


#pragma mark - ----------------------- 定义清晰度 -----------------------
- (void)changeHD:(UIButton*)btn
{
    if ([btn.titleLabel.text isEqualToString:@"720p"] && NO == [self isSuitableMachine:7])
    {
        [FanweMessage alert:@"直播推流" message:@"iphone 6 及以上机型适合开启720p!" isHideTitle:NO destructiveAction:nil];
        return;
    }
    
    if ([btn.titleLabel.text isEqualToString:@"540p"] && NO == [self isSuitableMachine:5])
    {
        [FanweMessage alert:@"直播推流" message:@"iphone 5 及以上机型适合开启540p!" isHideTitle:NO destructiveAction:nil];
        return;
    }
    
    if (_txLivePublisher == nil) return;
    
    if ([btn.titleLabel.text isEqualToString:@"720p"])
    {
        TXLivePushConfig* _config = _txLivePublisher.config;
        _config.videoBitratePIN   = 1500;
        _config.videoResolution   = [self isSuitableMachine:7 ] ? VIDEO_RESOLUTION_TYPE_720_1280 : VIDEO_RESOLUTION_TYPE_540_960;
        _config.enableAutoBitrate = NO;
        [_txLivePublisher setConfig:_config];
    }
    else if ([btn.titleLabel.text isEqualToString:@"540p"])
    {
        TXLivePushConfig* _config = _txLivePublisher.config;
        _config.videoBitratePIN   = 1000;
        _config.videoResolution   = [self isSuitableMachine:5 ] ? VIDEO_RESOLUTION_TYPE_540_960 : VIDEO_RESOLUTION_TYPE_360_640;
        _config.enableAutoBitrate = NO;
        [_txLivePublisher setConfig:_config];
    }
    else if ([btn.titleLabel.text isEqualToString:@"360p"])
    {
        TXLivePushConfig* _config = _txLivePublisher.config;
        _config.videoBitratePIN   = 700;
        _config.videoResolution   = VIDEO_RESOLUTION_TYPE_360_640;
        _config.enableAutoBitrate = NO;
        [_txLivePublisher setConfig:_config];
        
    }
    else if ([btn.titleLabel.text isEqualToString:@"360+"])
    {
        TXLivePushConfig* _config = _txLivePublisher.config;
        _config.videoBitrateMin   = 500;
        _config.videoBitrateMax   = 1200;
        _config.enableAutoBitrate = YES;
        _config.videoResolution   = VIDEO_RESOLUTION_TYPE_360_640;
        [_txLivePublisher setConfig:_config]; // 此模式下设置bitrate无效
    }
}

// iphone 6 及以上机型适合开启720p, 否则20帧的帧率可能无法达到, 这种"流畅不足,清晰有余"的效果并不好
- (BOOL)isSuitableMachine:(int)targetPlatNum
{
    int mib[2] = {CTL_HW, HW_MACHINE};
    size_t len = 0;
    char* machine;
    
    sysctl(mib, 2, NULL, &len, NULL, 0);
    
    machine = (char*)malloc(len);
    sysctl(mib, 2, machine, &len, NULL, 0);
    
    NSString* platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    if ([platform length] > 6)
    {
        NSString * platNum = [NSString stringWithFormat:@"%C", [platform characterAtIndex: 6 ]];
        return ([platNum intValue] >= targetPlatNum);
    }
    else
    {
        return NO;
    }
}

#pragma mark - ----------------------- 自定义Toast -----------------------
/**
 @method 获取指定宽度width的字符串在UITextView上的高度
 @param textView 待计算的UITextView
 @param Width 限制字符串显示区域的宽度
 @result float 返回的高度
 */
- (float)heightForString:(UITextView *)textView andWidth:(float)width
{
    CGSize sizeToFit = [textView sizeThatFits:CGSizeMake(width, MAXFLOAT)];
    return sizeToFit.height;
}

- (void)toastTip:(NSString*)toastInfo
{
    NSLog(@"======publishtoastInfo:%@",toastInfo);
    
    CGRect frameRC = [[UIScreen mainScreen] bounds];
    frameRC.origin.y = frameRC.size.height - 110;
    frameRC.size.height -= 110;
    __block UITextView * toastView = [[UITextView alloc] init];
    
    toastView.editable = NO;
    toastView.selectable = NO;
    
    frameRC.size.height = [self heightForString:toastView andWidth:frameRC.size.width];
    
    toastView.frame = frameRC;
    
    toastView.text = toastInfo;
    toastView.backgroundColor = [UIColor whiteColor];
    toastView.alpha = 0.5;
    
    [self.view addSubview:toastView];
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC);
    
    dispatch_after(popTime, dispatch_get_main_queue(), ^(){
        [toastView removeFromSuperview];
        toastView = nil;
    });
}

@end
