//
//  FWTPublishController.h
//  FanweApp
//
//  Created by xfg on 16/12/5.
//  Copyright © 2016年 xfg. All rights reserved.
//  腾讯云直播的主播控制类

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <TXLiteAVSDK_Professional/TXLivePush.h>

@class FWTPublishController;

@protocol FWTPublishControllerDelegate <NSObject>
@required

// 首帧回调
- (void)firstIFrame:(FWTPublishController*)publishVC;

// 网络断连,且经多次重连抢救无效后退出app
- (void)exitPublishAndApp:(FWTPublishController*)publishVC;

@end

@interface FWTPublishController : UIViewController
{
    BOOL            _appIsInterrupt;
    UIView          *_preViewContainer;
    
    BOOL            _hardware_switch;
    int             _whitening_level;
    
    unsigned long long  _startTime;
    unsigned long long  _lastTime;
    
    NSString        *_testPath;
    BOOL            _isPreviewing;
    
    NSInteger       _rePublishTime;
}

@property (nonatomic, weak) id<FWTPublishControllerDelegate> delegate;

@property (nonatomic, strong) TXLivePush        *txLivePublisher;
@property (nonatomic, strong) TXLivePushConfig  *txLivePushonfig;

@property (nonatomic, copy) NSString        *pushUrlStr;        // 推流地址

@property (nonatomic, copy) NSString        *kbpsSendStr;       // 发送码率
@property (nonatomic, copy) NSString        *kbpsRecvStr;       // 接收码率
@property (nonatomic, strong) NSDictionary  *qualityDict;       // 直播质量相关参数

// 开始推流
- (BOOL)startRtmp;
// 停止推流
- (void)stopRtmp;
// 前置后置摄像头切换
- (void)clickCamera:(UIButton*) btn;
// 开、关闪光灯
- (void)clickTorch:(BOOL) isOpen;

- (void)toastTip:(NSString*)toastInfo;

// 结束直播
- (void)endLive;

@end
