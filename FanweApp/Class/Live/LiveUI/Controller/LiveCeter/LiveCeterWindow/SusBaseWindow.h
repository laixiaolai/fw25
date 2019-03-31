//
//  SusBaseWindow.h
//  FanweApp
//
//  Created by 岳克奎 on 16/9/24.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FWTLiveController;
@class FWKSYLiveController;

/**
 * @brief： 设置 window 等级较高，用于悬浮窗口
 *
 * @prama close_Window_Btn            设置了一个关闭按钮（执行直播vc里的关闭按钮方法）
 * @prama window_Tap_Ges              tap（点击悬浮小widnow－－>满屏widnow，取消tap）
 * @prama window_Pan_Ges              pan（与liveView上的pan冲突。KVO解决）---->KVO 不走
 * @prama
 * @prama isSusWindow                 悬浮widnow
 * @prama isSmallSusWindow            当前是否是 悬浮  小window  YES：小 NO 大
 * @prama susBaseWindowBtnClickBlock  btn block
 * @prama susBaseWindowTapGesBlock    tap block
 * @prama susBaseWindowPanGesBlock    pan block
 *
 *
 */
typedef void (^SusBaseWindowBtnClickBlock)();
typedef void (^SusBaseWindowTapGesBlock)();
typedef void (^SusBaseWindowPanGesBlock)();

@interface   SusBaseWindow : UIWindow

@property (nonatomic, strong) UITapGestureRecognizer    *window_Tap_Ges;
@property (nonatomic, strong) UIPanGestureRecognizer    *window_Pan_Ges;

@property (nonatomic, copy) SusBaseWindowTapGesBlock    susBaseWindowTapGesBlock;       // tap blcok
@property (nonatomic, copy) SusBaseWindowPanGesBlock    susBaseWindowPanGesBlock;       // pan blcok

@property (nonatomic, assign) int                       sdkType;                        // SDK类型，对应的枚举：FW_LIVESDK_TYPE
@property (nonatomic, assign) int                       liveType;                       // 视频类型，对应的枚举：FW_LIVE_TYPE

@property (nonatomic, assign) BOOL                      isSusWindow;                    // 是不是 悬浮 window
@property (nonatomic, assign) BOOL                      isSmallSusWindow;               // 是不是 小悬浮widnow
@property (nonatomic, assign) BOOL                      isDirectCloseLive;              // 关闭前，记录需不需要 finishVC
@property (nonatomic, assign) BOOL                      isHostShowAlert;                // 关闭前，记录需不需要 判断（有的直播间关闭直接退出了）
@property (nonatomic, assign) BOOL                      isHost;                         // 是否主播
@property (nonatomic, assign) BOOL                      reccordSusWidnowSale;           // 是否需要记录悬浮窗的大小
@property (nonatomic, assign) BOOL                      isPushStreamIng;                // 主播是否正在推流中

@property (nonatomic, assign) BOOL                      isShowLivePay;                  // 是否显示付费按钮(yes 显示)
@property (nonatomic, assign) BOOL                      isShowMention;                  // 是否显示提档(yes 显示)

@property (nonatomic, copy) NSString                    *switchedRoomId;                // 需要切换到的房间ID，switchedRoomId不为空时表示需要切换房间

@property (nonatomic, strong) NSString                  *recordRooTViewControllerName;  // 在竞拍悬浮中，当小屏幕时候，底层Window 已经转变ROOTVC  当满屏幕恢复需要 回到小悬浮前的ROOTVC（这是个容器）

@property (nonatomic, strong) FWTLiveController         *recordFWTLiveController;       // 如果开启了 腾讯云直播 记录云直播VC
@property (nonatomic, strong) FWKSYLiveController       *threeFWKSYLiveController;      // 如果开启了 金山云直播 记录云直播VC

- (id)initWithFrame:(CGRect)frame;

@end
