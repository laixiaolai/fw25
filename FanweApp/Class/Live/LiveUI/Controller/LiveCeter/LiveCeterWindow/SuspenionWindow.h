//
//  SuspenionWindow.h
//  FanweApp
//
//  Created by 岳克奎 on 16/9/24.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "SusBaseWindow.h"
@class AVRoomAble;
@class IMHostAble;

@interface SuspenionWindow : SusBaseWindow

#pragma mark - 悬浮直播加载／处理 说明
#pragma mark - 开启一个小window
/**
 * @brief: 开启新的悬浮直播widnow
 */
+ (void)initSmallSusWindow:(BOOL)isSmallScreen WithItem:(id)item withRoomHost:(id)host withVagueImgeUrlStr:(NSString *)urlStr withModelRoomIdStr:(NSString *)roomIdStr;//模糊背景图片url

/**
 * @brief: 悬浮window 大／小 控制
 *
 */
- (void)setSmallLiveScreen:(BOOL)isSmallView vc:(UIViewController *)liveVC block:(void(^)(BOOL finished))block;

#pragma mark - 直播悬浮时候btn 退出widnow处理
/**
 * 悬浮或直播功能的退出，发通知走cloaseBtn的方法，完整退出
 */
+ (void)exitSuswindowBlock:(void(^)(BOOL finished))block;

#pragma mark - 任何 退出widnow 的参数 处理
/**
 *  统一处理suswidnow 的参数   (暂时未启动)
 */
+ (void)detailSuswidnowPramaBlock:(void(^)(BOOL finished))block;


#pragma mark---------------------------  直播（主播自己）部分 --------
#pragma mark - 去下个VC，当前直播 悬浮挂起
/**
 *  当前自己开的直播 push效果去下个VC，当前直播 悬浮挂起
 */
+ (void)goNextVCWithSetSmallScreen:(BOOL)smallScreen withLiveVC:(UIViewController *)currentLiveVC withNextVC:(UIViewController *)nextVC withOtherPrama:(id)otherPrama finishedBlock:(void(^)(BOOL finished))block;

#pragma mark - nextVC pop 回到 满屏widnow直播，nextVC自动退出
/**
 pop 回到 满屏widnow直播，nextVC自动退出

 @param navController UINavigationController
 */
+ (void)popNextVCGoBackFullScreenWidnowLiveWithSelfNavController:(UINavigationController *)navController;

#pragma mark - Geature Of Suswindow
/**
 手势处理
 */
+ (void)showLoadGeatureOfSusWindow;

#pragma mark - Animation of SusWindow Size
/**
 悬浮动画

 @param block 注意既然代码能走到这里 必定悬浮啦。VC可以delegate找！
 */
+ (void)showAnimationOfSusWindowSizeBlock:(void(^)(BOOL finished))block;

#pragma mark - 夹心层的退出
/**
 竞拍层的退出

 @param nextRootVCStr 竞拍层退出的时候，悬浮widnow需要动画恢复满屏幕。底层widnwo需要将RootVC 由竞拍层恢复到主页上
 @param block block回调
 */
+ (void)closeSanwichLayerOfNetRootVCStr:(NSString *)nextRootVCStr complete:(void(^)(BOOL finished))block;


#pragma mark ---------------------------------------- 直播间关闭 部分 ---------------------------------------
/**
 直播间关闭 部分

 @param block 1.小屏幕  先放大回来 2.夹心层
 */
+ (void)closeSuswindowUIComplete:(void(^)(BOOL finished))block;

#pragma mark - 悬浮层真正退出后悬浮参数处理
/**
 悬浮层真正退出后悬浮参数处理

 @param block 直播间退出的时候
 */
+ (void)resetSusWindowPramaWhenLiveClosedComplete:(void(^)(BOOL finished))block;

@end


