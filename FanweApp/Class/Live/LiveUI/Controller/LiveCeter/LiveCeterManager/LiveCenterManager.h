//
//  LiveCenterManager.h
//  FanweApp
//
//  Created by 岳克奎 on 16/12/13.
//  Copyright © 2016年 xfg. All rights reserved.
//  是对悬浮 非悬浮 主播 主播启动 直播间的单例类

#import <Foundation/Foundation.h>
#import "STSuspensionWindow.h"

#pragma mark - window type
typedef NS_ENUM(NSUInteger,LiveWindowType)
{
    LiveWindowTypeDefault              = 0,       // 未设置window类型
    LiveWindowTypeOfNormolOfFullSize   = 1,       // 非悬浮 满屏幕
    liveWindowTypeOfSusOfFullSize      = 2,       // 悬浮 满屏幕
    LiveWindowTypeOfNormolSmallSize    = 3,       // 非悬浮 小屏幕
    LiveWindowTypeOfSusSmallSize       = 4,       // 悬浮 小屏幕
} ;

typedef NS_ENUM(NSUInteger,UIAlertCState)
{
    UIAlertCdefault                    = 0,
    UIAlertCNeed                       = 1,
    UIAlertCNeedNO                     = 2,
};

typedef NS_ENUM(NSUInteger,LiveFinishViewState)
{
    LiveFinishViewDefault              = 0,
    LiveFinishViewNeed                 = 1,
    LiveFinishViewNoNeed               = 2,
};

@protocol LiveCenterManagerDelegate <NSObject>

@optional
- (void)showCloseLiveComplete:(FWIsFinishedBlock)block;

@end


@interface LiveCenterManager : NSObject

// 单例模式
FanweSingletonH(Instance);

@property (nonatomic, assign) LiveWindowType                liveWindowType;
@property (nonatomic, assign) FW_LIVE_TYPE                  liveType;
@property (nonatomic, assign) FW_LIVESDK_TYPE               liveSDKType;

// 控制加载、显示、手势交互
@property (nonatomic, strong) STSuspensionWindow            *stSuspensionWindow;
// 记录创建的直播间ViewC
@property (nonatomic, strong) UIViewController              *recordLiveViewC;

// 直播退出，前需要设置
@property (nonatomic, assign) UIAlertCState                 uIAlertCState;
@property (nonatomic, assign) LiveFinishViewState           liveFinishViewState;
@property (nonatomic, weak) id<LiveCenterManagerDelegate>   delegate;

- (void)showCloseLiveComplete:(FWIsFinishedBlock)block;
// 判断是否需要悬浮Window
- (BOOL)judgeIsSusWindow;
// 判断是否需要悬浮小Window
- (BOOL)judgeIsSmallSusWindow;


#pragma mark ------------------------------------------- 直播间开启部分  -------------------------------------------
#pragma mark - 主播自己开直播

/**
 主播自己开直播 （考虑UI效果不佳，不建议用）

 @param dic 参数
 @param isSusWindow 是否需要悬浮Window
 @param isSmallScreen 是否需要悬浮小Window
 @param block 回调
 */
- (void)showLiveOfAPIPramaDic:(NSMutableDictionary *)dic isSusWindow:(BOOL)isSusWindow  isSmallScreen:(BOOL)isSmallScreen block:(FWIsFinishedBlock)block;

/**
 主播自己开直播（建议用），主要是指 主播自己开直播 不包含列表中包含主播视频，再次进入，这样的把主播当成观众

 @param responseJson 参数
 @param isSusWindow 是否需要悬浮Window
 @param isSmallScreen 是否需要悬浮小Window
 @param block 回调
 */
- (void)showLiveOfAPIResponseJson:(NSMutableDictionary *)responseJson isSusWindow:(BOOL)isSusWindow isSmallScreen:(BOOL)isSmallScreen block:(FWIsFinishedBlock)block;


#pragma mark - 进入直播
/**
 进入直播

 @param liveListItem 进入直播间实体
 @param liveWindowType LiveWindowType
 @param liveType 视频类型
 @param liveSDKType SDK类型
 @param block 回调
 */
- (void)showLiveOfTCShowLiveListItem:(TCShowLiveListItem *)liveListItem andLiveWindowType:(LiveWindowType)liveWindowType andLiveType:(FW_LIVE_TYPE)liveType andLiveSDKType:(FW_LIVESDK_TYPE)liveSDKType andCompleteBlock:(FWIsFinishedBlock)block;

/**
 观众进直播

 @param dic 参数
 @param isSusWindow 是否需要悬浮Window
 @param isSmallScreen 是否需要悬浮小Window
 @param block 回调
 */
- (void)showLiveOfAudienceLiveofPramaDic:(NSMutableDictionary *)dic isSusWindow:(BOOL)isSusWindow isSmallScreen:(BOOL)isSmallScreen block:(FWIsFinishedBlock)block;

/**
 观众进直播

 @param item 进入直播间实体
 @param isSusWindow 是否需要悬浮Window
 @param isSmallScreen 是否需要悬浮小Window
 @param block 回调
 */
- (void)showLiveOfAudienceLiveofTCShowLiveListItem:(TCShowLiveListItem *)item isSusWindow:(BOOL)isSusWindow isSmallScreen:(BOOL)isSmallScreen block:(FWIsFinishedBlock)block;


#pragma mark ------------------------------------------- 直播间关闭 部分  -------------------------------------------
/**
 直播关闭

 @param liveViewController 需要关闭的vc
 @param paiTimeNum 竞拍倒计时
 @param isDirectCloseLive 是否直接关闭直播而不弹出结束界面
 @param isHostShowAlert 是否弹出对话框
 @param block 回调
 */
- (void)closeLiveOfPramaOfLiveViewController:(UIViewController *)liveViewController paiTimeNum:(int)paiTimeNum alertExitLive:(BOOL)isDirectCloseLive isHostShowAlert:(BOOL)isHostShowAlert colseLivecomplete:(FWIsFinishedBlock)block;

/**
 悬浮参数处理，紧跟直播关闭后代码

 @param block 回调
 */
- (void)resetSuswindowPramaComple:(FWIsFinishedBlock)block;

/**
 屏幕大小缩放处理，使用前提：需要悬浮挂起或挂起小屏幕后再恢复满屏幕

 @param isSmallScreen 是否悬浮小Window
 @param block 回调
 */
- (void)showChangeLiveScreenSOfIsSmallScreen:(BOOL)isSmallScreen complete:(FWIsFinishedBlock)block;


#pragma mark ----------------------------------------- 竞拍区域 ------------------------------------------------------
/**
 竞拍屏幕处理大小处理，使用前提：竞拍开启直播后，需要悬浮挂起或挂起小屏幕后再恢复满屏幕

 @param isSmallScreen 是否悬浮小Window
 @param nextViewController 你回到满屏，可为nil
 @param delegateWindowRCNameStr 当你去下个VC，可为nil
 @param block 回调
 */
- (void)showChangeAuctionLiveScreenSOfIsSmallScreen:(BOOL)isSmallScreen nextViewController:(UIViewController *)nextViewController delegateWindowRCNameStr:(NSString *)delegateWindowRCNameStr complete:(FWIsFinishedBlock)block;


#pragma mark ---------------------------------------- 踢下线通知 -------------------------------------------------------
/**
 踢下线通知

 @param imAPlatform 里监听到有互踢消息执行对应的方法，这个方法主要解决先视频的退出问题
 @param block 回调
 */
- (void)showOffLineWarningwithIMAPlatform:(IMAPlatform *)imAPlatform complete:(FWIsFinishedBlock)block;

@end
