//
//  FWLiveServiceController.h
//  FanweLive
//
//  Created by xfg on 16/11/23.
//  Copyright © 2016年 xfg. All rights reserved.
//  直播业务层

#import <UIKit/UIKit.h>
#import "FWLiveUIViewController.h"
#import "TCShowLiveView.h"
#import "CurrentLiveInfo.h"
#import "FinishLiveView.h"
#import "ManagerViewController.h"
#import "GifImageView.h"
#import "SLiveRedBagView.h"
#import "SLiveReportView.h"
#import "MessageView.h"
#import "Plane1Controller.h"
#import "Plane2Controller.h"
#import "FerrariController.h"
#import "LambohiniViewController.h"
#import "RocketViewController.h"
#import "AddFriendView.h"
#import "PasteView.h"
#import "SendGiftAnimateView.h"
#import "SendGiftAnimateView2.h"
#import "ContributionListViewController.h"
#import "PluginCenterView.h"
#import "AuctionTool.h"
#import "AuctionItemdetailsViewController.h"
#import "ConverDiamondsViewController.h"
#import "ShareModel.h"
#import "RechargeView.h"
#import "ExchangeView.h"
#import "OtherChangeView.h"
#import "OtherRoomBitGiftView.h"
#import "SHomePageVC.h"
#import "SLiveHeadInfoView.h"
#import "SLiveReportView.h"
#import "FWLiveServiceViewModel.h"

#import "SManageFriendVC.h"

typedef void (^FWLiveGetVideoCompletion)(CurrentLiveInfo *liveInfo);

typedef NS_ENUM(NSInteger, SmallGiftAnimateIndex)
{
    SmallGiftAnimateIndex_1     = 1,  // 底下的那个礼物动画视图（默认优先显示）
    SmallGiftAnimateIndex_2     = 2,  // 上面的那个礼物动画视图
};

@class FWLiveServiceController;

@protocol FWLiveServiceControllerDelegate <NSObject>
@required

/**
 关闭直播间

 @param isDirectCloseLive 该参数针对主播、观众，表示是否直播关闭直播，而不显示结束界面
 @param isHostShowAlert 该参数针对主播，表示主播是否需要弹出“您当前正在直播，是否退出直播？”，正常情况都需要弹出这个，不需要弹出的情况：1、当前直播被后台系统关闭了的情况 2、SDK结束了直播
 */
- (void)clickCloseLive:(BOOL)isDirectCloseLive isHostShowAlert:(BOOL)isHostShowAlert;

/**
 结束界面点击“返回首页”

 @param liveServiceController self
 */
- (void)finishViewClose:(FWLiveServiceController *)liveServiceController;

@optional

/**
 连麦、关闭连麦

 @param liveServiceController self
 */
- (void)openOrCloseMike:(FWLiveServiceController *)liveServiceController;

/**
 收到自定义C2C消息

 @param msg 实现AVIMMsgAble协议的msg
 */
- (void)recvCustomC2C:(id<AVIMMsgAble>)msg;

/**
 收到自定义的Group消息

 @param msg 实现AVIMMsgAble协议的msg
 */
- (void)recvCustomGroup:(id<AVIMMsgAble>)msg;

/**
 请求完接口后，刷新直播间相关信息

 @param liveItem 视频Item
 @param liveInfo get_video2接口获取下来的数据实体
 */
- (void)refreshCurrentLiveItem:(id<FWShowLiveRoomAble>)liveItem liveInfo:(CurrentLiveInfo *)liveInfo;

/**
 点击飞屏模式，切换直播间
 */
- (void)switchLiveRoom;

@end


@interface FWLiveServiceController : FWBaseViewController<FWIMMsgListener,TCShowLiveViewServiceDelegate,TCShowLiveTopViewDelegate,TCShowLiveMessageViewDelegate,SLiveHeadInfoViewDelegate,RedBagViewDelegate,liveReportViewDelegate,CustomMessageModelDelegate,GifImageViewDelegate,MessageViewDelegate,Plane1ControllerDelegate,Plane2ControllerDelegate,FerrariControllerDelegate,LambohiniViewControllerDelegate,RocketViewControllerDelegate,addFriendDelegate,PasteViewDelegate,PluginCenterViewDelegate,AuctionToolDelegate,RechargeViewDelegate,ExchangeViewDelegate,OtherChangeViewDelegate,FWLiveUIViewControllerServeiceDelegate>
{
    
@protected

    __weak id<FWShowLiveRoomAble>       _liveItem;          // 开启、观看直播传入的实体
    id<FWLiveControllerAble>            _liveController;    // 当前SDK控制类
    
    UIButton                    *_closeBtn;                 // 关闭按钮
    SLiveHeadInfoView           *_informationView;          // 用户详情页
    AddFriendView               *_addFView;                 // 加好友的View
    PasteView                   *_PView;
    
    NSTimer                     *_heartTimer;               // 主播心跳监听
    NSString                    *_privateShareString;
    NSString                    *_tipoffUserId;             // 被举报的用户ID
 
// 礼物相关
    __weak FWIMMsgHandler       *_iMMsgHandler;             // IM处理单例
    
    __weak AddGiftRunLoop       *_addGiftRunLoopRef;        // 添加礼物处理线程的引用
    __weak GetGiftRunLoop       *_getGiftRunLoopRef;        // 获取礼物处理线程的引用
    NSMutableArray              *_giftMessageMArray;        // 礼物队列
    NSMutableDictionary         *_giftMessageMDict;         // 礼物队列（主要用来删除和取当前需要显示的数量）
    NSMutableArray              *_giftMessageViewMArray;    // 礼物视图队列
    NSMutableArray              *_gifAnimateArray;          // gif动画队列
    NSTimer                     *_giftLoopTimer;            // 后台定时
    
    NSInteger                   _refreshIMMsgCount;
    NSInteger                   _currentBigGiftState;       // 当前大型礼物播放状态 1：播放中 0：闲置状态
 
    NSString                    *_privateKeyString;         // 私密的key
    
    CustomMessageModel          *_ohterRoomBitGiftModel;
}

@property (nonatomic, weak) id<FWLiveServiceControllerDelegate> delegate;

// 直播UI层
@property (nonatomic, strong) FWLiveUIViewController    *liveUIViewController;
// 当前直播实体
@property (nonatomic, strong) CurrentLiveInfo           *currentLiveInfo;
// 关闭按钮
@property (nonatomic, strong) UIButton                  *closeBtn;
// 主播离开提示
@property (nonatomic, strong) UILabel                   *anchorLeaveTipLabel;
// 当前主播的印票数
@property (nonatomic, assign) NSInteger                 voteNumber;
// 是否主播
@property (nonatomic, assign) BOOL                      isHost;
// 房间ID
@property (nonatomic, copy) NSString                    *roomIDStr;

// 底下的那个礼物动画视图（默认优先显示）
@property (nonatomic, strong) SendGiftAnimateView       *sendGiftAnimateView1;
// 上面的那个礼物动画视图
@property (nonatomic, strong) SendGiftAnimateView2      *sendGiftAnimateView2;

// 弹幕
// 弹幕消息视图队列
@property (nonatomic, strong) NSMutableArray            *barrageViewArray;
// 是否正在显示 弹幕（底下的弹幕）
@property (nonatomic, assign) BOOL                      barrageViewShowing1;
// 是否正在显示 弹幕（上面的弹幕）
@property (nonatomic, assign) BOOL                      barrageViewShowing2;
// 是否开启了录制
@property (nonatomic, assign) BOOL                      isRecord;

// 高级别观众进入
@property (nonatomic, strong) AudienceEnteringTipView   *aETView;
// 高级别观众进入视图队列
@property (nonatomic, strong) NSMutableArray            *aETViewArray;
// 是否正在显示 高级别观众进入视图
@property (nonatomic, assign) BOOL                      aETViewShowing;

// 是否关注了主播
@property (nonatomic, assign) BOOL                      isFollowAnchor;

// 举报界面
@property (nonatomic, strong) SLiveReportView           *liveReportV;

// 创建插件中心
@property (nonatomic, strong) PluginCenterView          *pluginCenterView;
// 插件中心透明背景
@property (nonatomic, strong) UIView                    *pluginCenterBgView;
// 游戏id(游戏轮数id)
@property (nonatomic, assign) NSInteger                 game_log_id;
// 根据功能插件个数判断高度(游戏或功能)
@property (nonatomic, assign) NSInteger                 gameOrFeatures;
// 直播间竞拍相关控制类
@property (nonatomic, strong) AuctionTool               *auctionTool;
// 直播间是否第一次加载视频
@property (nonatomic, assign) BOOL                      IsFirstLoadVedio;

// 充值页面
@property (nonatomic, strong) RechargeView              *rechargeView;
@property (nonatomic, strong) ExchangeView              *exchangeView;
@property (nonatomic, strong) OtherChangeView           *otherChangeView;

// 飞屏模式
// 其他房间发送的大型礼物动画队列
@property (nonatomic, strong) NSMutableArray            *otherRoomBitGiftArray;
// 其他房间大型礼物播放状态（飞屏模式）
@property (nonatomic, assign) NSInteger                 currentOtherRoomBigGiftState;
// 飞屏展示
@property (nonatomic, strong) OtherRoomBitGiftView      *otherRoomBitGiftView;

@property (nonatomic, strong) FinishLiveView            *finishLiveView;

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
 主播心跳监听
 */
- (void)startLiveTimer;

/**
 主播进入房间状态回调

 @param parmMDict 传入的参数
 */
- (void)getVideoState:(NSMutableDictionary *)parmMDict;

/**
 进入直播室成功后的相关业务：获得视频信息

 @param succ 成功回调
 @param failed 失败回调
 */
- (void)getVideo:(FWLiveGetVideoCompletion)succ failed:(FWErrorBlock)failed;

/**
 主播退出直播间

 @param succ 成功回调
 @param failed 失败回调
 */
- (void)hostExitLive:(FWVoidBlock)succ failed:(FWErrorBlock)failed;

/**
 显示主播结束界面

 @param audience 观看数量
 @param vote 获得的印票数量
 @param hasDel 是否有删除按钮（该参数针对主播）
 */
- (void)showHostFinishView:(NSString *)audience andVote:(NSString *)vote andHasDel:(BOOL)hasDel;

/**
 开始直播
 */
- (void)startLive;

/**
 暂停直播
 */
- (void)pauseLive;

/**
 重新开始直播
 */
- (void)resumeLive;

/**
 结束直播
 */
- (void)endLive;


@end
