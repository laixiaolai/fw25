//
//  FWKSYLinkMicStreamerController.m
//  FanweApp
//
//  Created by xfg on 2017/2/20.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "FWKSYLinkMicStreamerController.h"

@interface FWKSYLinkMicStreamerController ()

@end

@implementation FWKSYLinkMicStreamerController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 设置rtc参数
    [self setStreamerKitCfg];
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
    
    //特性2:圆角小窗口
//    _gPUStreamerKit.maskPicture = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"mask.png"]];
    
    //rtcClient的回调，（option）
    __weak typeof(self) ws = self;
    __weak KSYRTCStreamerKit *weak_kit = _gPUStreamerKit;
    
    // 接收注册结果的回调函数
    _gPUStreamerKit.rtcClient.onRegister= ^(int status){
        NSString * message = [NSString stringWithFormat:@"local sip account:%@",weak_kit.rtcClient.authUid];
        NSLog(@"message:%@",message);
        
        if (ws.linkMicPublishDelegate && [ws.linkMicPublishDelegate respondsToSelector:@selector(registerResult:registerUserId:)])
        {
            [ws.linkMicPublishDelegate registerResult:status registerUserId:weak_kit.rtcClient.authUid];
        }
    };
    
    // 接收反注册结果的回调函数
    _gPUStreamerKit.rtcClient.onUnRegister= ^(int status){
        NSLog(@"unregister callback");
        
        if (ws.linkMicPublishDelegate && [ws.linkMicPublishDelegate respondsToSelector:@selector(unRegisterResult:registerUserId:)])
        {
            [ws.linkMicPublishDelegate unRegisterResult:status registerUserId:ws.applicantId];
        }
    };
    
    // call coming的回调函数，返回远端的remoteURI
    _gPUStreamerKit.rtcClient.onCallInComing =^(char* remoteURI){
        int ret = [weak_kit.rtcClient answerCall];
        NSLog(@"有呼叫到来,用户ID:%s；呼叫状态码：%d",remoteURI,ret);
    };
    
    // start call的回调函数
    _gPUStreamerKit.onCallStart =^(int status){
        
        NSLog(@"oncallstart:%d",status);
        
        if(status == 200)   // 建立连接
        {
            if([UIApplication sharedApplication].applicationState !=UIApplicationStateBackground)
            {
                if (ws.linkMicPublishDelegate && [ws.linkMicPublishDelegate respondsToSelector:@selector(responderLinkMickResult:applicantId:)])
                {
                    [ws.linkMicPublishDelegate responderLinkMickResult:YES applicantId:ws.applicantId];
                }
            }
        }
        else if(status == 408)  // 对方无应答
        {
            if (ws.linkMicPublishDelegate && [ws.linkMicPublishDelegate respondsToSelector:@selector(responderLinkMickResult:applicantId:)])
            {
                [ws.linkMicPublishDelegate responderLinkMickResult:NO applicantId:ws.applicantId];
            }
        }
        else if(status == 404)  // 呼叫未注册号码,主动停止
        {
            if (ws.linkMicPublishDelegate && [ws.linkMicPublishDelegate respondsToSelector:@selector(responderLinkMickResult:applicantId:)])
            {
                [ws.linkMicPublishDelegate responderLinkMickResult:NO applicantId:ws.applicantId];
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
        
        [weak_kit.rtcClient unRegisterRTC];
        
        if (ws.linkMicPublishDelegate && [ws.linkMicPublishDelegate respondsToSelector:@selector(responderLinkMickResult:applicantId:)])
        {
            [ws.linkMicPublishDelegate responderLinkMickResult:NO applicantId:ws.applicantId];
        }
    };
    
    // sdk日志接口（option）
    _gPUStreamerKit.rtcClient.openRtcLog = NO;//是否打开rtc的日志
    _gPUStreamerKit.rtcClient.sdkLogBlock = ^(NSString * message){
        NSLog(@"=======主播端rtc的日志：%@",message);
    };
}

#pragma mark 开始鉴权
/*
 *  开始鉴权
 *  applicantId：申请连麦者ID
 */
- (void)startRegister:(NSString *)applicantId
{
    _applicantId = applicantId;
}

#pragma mark 断开连麦
/*
 *  断开连麦
 *  applicantId：申请连麦者ID
 */
- (void)breakLinkMick:(NSString *)applicantId
{
    [_gPUStreamerKit.rtcClient unRegisterRTC];
}

#pragma mark 停止推流
- (void)stopRtmp
{
    if (_gPUStreamerKit)
    {
        [_gPUStreamerKit.rtcClient unRegisterRTC];
    }
    [super stopRtmp];
}


@end
