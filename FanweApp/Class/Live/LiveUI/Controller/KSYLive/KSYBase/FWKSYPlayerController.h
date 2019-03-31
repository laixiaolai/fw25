//
//  FWKSYPlayerController.h
//  FanweApp
//
//  Created by xfg on 2017/2/10.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FWKSYPlayerController;

@protocol FWKSYPlayerControllerDelegate <NSObject>
@required

// 首帧回调
- (void)firstFrame:(FWKSYPlayerController*)playVC;
// 网络断连,且经多次重连抢救无效后退出app
- (void)exitPlayAndApp:(FWKSYPlayerController*)publishVC;
// 网络断连,重连
- (void)playAgain:(FWKSYPlayerController*)publishVC isHideLeaveTip:(BOOL)isHideLeaveTip;

@end


@interface FWKSYPlayerController : UIViewController

@property (nonatomic, weak) id<FWKSYPlayerControllerDelegate> delegate;

@property (nonatomic, assign) NSInteger                 liveType;               // 视频类型，对应枚举FW_LIVE_TYPE
@property (nonatomic, strong) NSURL                     *playUrl;               // 拉流地址
@property (strong, nonatomic) KSYMoviePlayerController  *moviePlayer;           // 视频播放类
@property (nonatomic, strong) UIView                    *videoContrainerView;   // 视频容器视图
@property (nonatomic, strong) FWReLiveProgressView      *reLiveProgressView;    // 回播进度条
@property (nonatomic, assign) long                      speedK;

// 初始化视频播放类
- (void)initPlayerWithUrl:(NSURL *)playUrl createType:(NSInteger)createType;

// 暂停播放
- (void)pausePlay;
// 继续播放
- (void)resumePlay;
// 重新播放
- (void)reloadPlay;
// 结束播放
- (void)stopPlay;

@end
