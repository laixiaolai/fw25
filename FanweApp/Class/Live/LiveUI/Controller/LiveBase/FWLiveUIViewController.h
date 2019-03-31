//
//  FWLiveUIViewController.h
//  FanweLive
//
//  Created by xfg on 16/11/23.
//  Copyright © 2016年 xfg. All rights reserved.
//  直播UI层

#import "AuctionTool.h"
#import "FWConversationSegmentController.h"
#import "FWConversationServiceController.h"
#import "FWLivePayManager.h"
#import "SHomePageVC.h"
#import "TCShowLiveView.h"
#import <UIKit/UIKit.h>
#import "GameModel.h"

@class FWLiveUIViewController;

@protocol FWLiveUIViewControllerServeiceDelegate <NSObject>
@required

/**
 显示充值界面

 @param liveUIViewController self
 */
- (void)showRechargeView:(FWLiveUIViewController *)liveUIViewController;

/**
 关闭当前直播

 @param isDirectCloseLive 是否直接关闭
 @param isHostShowAlert 主播是否弹出Alert
 */
- (void)closeCurrentLive:(BOOL)isDirectCloseLive isHostShowAlert:(BOOL)isHostShowAlert;

@end

@interface FWLiveUIViewController : FWBaseViewController<FWChatVCDelegate, UIGestureRecognizerDelegate, TCShowLiveViewForUIDelegate>
{
    __weak id<FWShowLiveRoomAble>       _liveItem;              // 开启、观看直播传入的实体
    id<FWLiveControllerAble>            _liveController;        // 当前SDK控制类
    
    BOOL                _showingRight;                          // 判断是否正在显示LivingView
    BOOL                _isFromeLeft;                           // 判断是否从左往右滑动
    BOOL                _isFromeTop;                            // 判断是否从上往下滑动
    BOOL                _isLeftOrRightPan;                      // 判断是否左右方向滑动的幅度大于上线方向
    BOOL                _isHost;                                // 是否主播
}

@property (nonatomic, weak) id<FWLiveUIViewControllerServeiceDelegate> serviceDelegate;
// 左右滑动层
@property (nonatomic, strong) TCShowLiveView *liveView;
// 记录 是否加载半屏幕 VC
@property (nonatomic, assign) BOOL isHaveHalfIMChatVC;
// 记录 是否加载半屏幕 VC
@property (nonatomic, assign) BOOL isHaveHalfIMMsgVC;
// 记录 是否加载半屏幕 VC 键盘类型 1文本  2表情  3更多
@property (nonatomic, assign) int isKeyboardTypeNum;
// 半屏幕 VC背景
@property (nonatomic, strong) UIView *imChatVCBgView;
// 滑动手势
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRec;
// 付费直播的控制类
@property (nonatomic, strong) FWLivePayManager *livePay;
// 付费直播心跳返回的字典
@property (nonatomic, strong) NSDictionary              *currentMonitorDict;
// 付费直播显示看视频的倒计时的label
@property (nonatomic, strong) UILabel                   *livePayLabel;
// 付费直播倒计时的time
@property (nonatomic, strong) NSTimer                   *livePayTimer;
// 按时付费直播倒计时剩余时间的定时器
@property (nonatomic, strong) NSTimer                   *livePayLeftTimer;
// 按时付费直播倒计时剩余时间的时间
@property (nonatomic, assign) int                       livePayLeftCount;
// 付费直播的类型0按时1按场
@property (nonatomic, assign) int                       payLiveType;
// 可免费观看的时长
@property (nonatomic, assign) int                       livePayCount;

/**
 初始化房间信息等
 
 @param liveItem 房间信息
 @param liveController 直播VC
 @return self
 */
- (instancetype)initWith:(id<FWShowLiveRoomAble>)liveItem liveController:(id<FWLiveControllerAble>)liveController;

/**
 请求完接口后，刷新直播间相关信息
 
 @param liveItem 视频Item
 @param liveInfo get_video2接口获取下来的数据实体
 */
- (void)refreshLiveItem:(id<FWShowLiveRoomAble>)liveItem liveInfo:(CurrentLiveInfo *)liveInfo;

/**
 进入付费直播

 @param responseJson get_video2接口返回的数据
 @parma closeBtn 关闭按钮
 */
- (void)beginEnterPayLive:(NSDictionary *)responseJson closeBtn:(UIButton *)closeBtn;

/**
 收到IM消息，调起付费

 @param type 付费类型
 @param closeBtn 关闭按钮
 */
- (void)getVedioViewWithType:(int)type closeBtn:(UIButton *)closeBtn;

/**
 心跳唤起付费界面

 @param responseJson 心跳接口返回数据
 */
- (void)createPayLiveView:(NSDictionary *)responseJson;

/**
 插件中心点击付费

 @param model Model
 */
- (void)clickPluginPayItem:(GameModel *)model closeBtn:(UIButton *)closeBtn;

/**
 显示按时付费在倒计时的页面
 */
- (void)dealLivepayTComfirm;

- (void)addTwoSubVC;

// 移除滑动手势
- (void)removePanGestureRec;

// 设置当前是否能够使用滑动手势
- (void)setPanGesture:(BOOL)isEnabled;

// 开始直播
- (void)startLive;
// 暂停直播
- (void)pauseLive;
// 重新开始直播
- (void)resumeLive;
// 结束直播
- (void)endLive;

@end
