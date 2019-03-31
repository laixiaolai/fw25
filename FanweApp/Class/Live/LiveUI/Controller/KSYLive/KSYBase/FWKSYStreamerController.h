//
//  FWKSYStreamerController.h
//  FanweLive
//
//  Created by yiqian on 10/15/15.
//  Copyright (c) 2015 qyvideo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GPUImage/GPUImage.h>
#import <libksygpulive/KSYGPUStreamerKit.h>
#import "KSYRTCStreamerKit.h"


#define SEL_VALUE(SEL_NAME) [NSValue valueWithPointer:@selector(SEL_NAME)]

@class FWKSYStreamerController;

@protocol FWKSYStreamerControllerDelegate <NSObject>
@required

// 首帧回调
- (void)firstIFrame:(FWKSYStreamerController *)publishVC;

// 网络断连,且经多次重连抢救无效后退出app
- (void)exitPublishAndApp:(FWKSYStreamerController *)publishVC;

@end


@interface FWKSYStreamerController : UIViewController
{
    KSYRTCStreamerKit     *_gPUStreamerKit;    // 直播推流工具类
}

@property (nonatomic, weak) id<FWKSYStreamerControllerDelegate> delegate;

@property (nonatomic, assign) NSInteger liveType;

@property (nonatomic, strong) KSYRTCStreamerKit     *gPUStreamerKit;        // 直播推流工具类
@property (nonatomic, strong) UIView                *videoContrainerView;   // 视频容器视图
@property (nonatomic, strong) NSURL                 *pushUrl;               // 推流地址

// 开始推流
- (void)startRtmp;
// 停止推流
- (void)stopRtmp;


@end
