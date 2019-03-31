//
//  TCShowLiveView.h
//  TCShow
//
//  Created by AlexiChen on 16/4/14.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//  左右滑动层

#import <UIKit/UIKit.h>
#import "GiftView.h"
#import "AddGiftRunLoop.h"
#import "GetGiftRunLoop.h"
#import "ShopGoodsUIView.h"
#import "TCShowLiveTopView.h"
#import "TCShowLiveMessageView.h"
#import "TCShowLiveBottomView.h"
#import "TCShowLiveInputView.h"
#import "GoldFlowView.h"
#import "LiveGameModel.h"
#import "GameDataModel.h"
#import "GameHistoryView.h"
#import "GameWinView.h"
#import "ApplyBankerView.h"
#import "GameBankerModel.h"
#import "GameBankerView.h"
#import "SelectBankerView.h"
#import "ExchangeCoinView.h"
#import "MoreToolsView.h"
#import "BMPopBaseView.h"
#import "GuessSizeView.h"

@class TCShowLiveView;

/**
 用来给SDK层的代理
 */
@protocol TCShowLiveViewForSDKDelegate <NSObject>

@optional

/**
 隐藏回放时的滚动条
 
 @param isHided 是否需要隐藏 YES：隐藏 NO：显示
 */
- (void)hideReLiveSlide:(BOOL)isHided;

/**
 主播点击屏幕时，判断是否点击了连麦窗口
 
 @param touch UITouch
 */
- (void)hostReceiveTouch:(UITouch *)touch;

/**
 PC直播或者PC回播，观众端的点击全屏事件
 */
- (void)clickFullScreen;

@end


/**
 给Service层的代理
 */
@protocol TCShowLiveViewServiceDelegate <NSObject>
@optional

// 观众在直播间点击分享按钮
- (void)clickShareBtn:(TCShowLiveView *)showLiveView;
// 显示充值
- (void)rechargeView:(TCShowLiveView *)showLiveView;
// 钻石兑换游戏币
- (void)exchangeCoin:(NSString *)diamond;
// 连麦
- (void)clickMikeBtn:(TCShowLiveView *)showLiveView;
// IM
- (void)clickIM:(TCShowLiveView *)showLiveView;
// 星店
- (void)clickStarShop:(TCShowLiveView *)showLiveView;
// 拍卖
- (void)clickAuction:(TCShowLiveView *)showLiveView;
// 点击空白
- (void)clickBlank:(TCShowLiveView *)showLiveView;

// 删除底部的微信，qq，映客好友
- (void)moveAddFriendView;
- (void)closeGoodsView:(TCShowLiveView *)showLiveView;
// 游戏
- (void)clickGameBtn:(TCShowLiveView *)showLiveView;
// 点击空白关闭插件中心列表
- (void)closeGamesView:(TCShowLiveView *)showLiveView;

// 我的小店
- (void)clickMyShop:(TCShowLiveView *)showLiveView;

// 观众点击更多按钮
- (void)clickMoreTools:(TCShowLiveView *)showLiveView;

- (void)closeRechargeView:(TCShowLiveView *)showLiveView;

@end


/**
 给UI层的代理
 */
@protocol TCShowLiveViewForUIDelegate <NSObject>

// 切换付费
- (void)clickChangePay:(TCShowLiveView *)showLiveView;
// 提档
- (void)clickMention:(TCShowLiveView *)showLiveView;

- (void)changePayViewFrame:(TCShowLiveView *)showLiveView;

@end


@interface TCShowLiveView : FWBaseView <TCShowLiveBottomViewDelegate, GiftViewDelegate,UIGestureRecognizerDelegate,GoldFlowViewDelegate,TCShowLiveInputViewDelegate,ApplyBankerViewDelegate,SelectBankerViewDelegate,ExchangeCoinViewDelegate,MoreToolsViewDelegate,GuessSizeViewDelegate,GameWinViewDelegate>
{
    
@protected
    TCShowLiveTopView           *_topView;
    
    TCShowLiveMessageView       *_msgView;
    TCShowLiveBottomView        *_bottomView;
    
    TCShowLiveInputView         *_liveInputView;

    UIView                      *_historyBgView;        // 游戏记录显示时的黑色背景
    UIView                      *_winBgView;            // 游戏获胜时的黑色背景
    UIView                      *_bankerBgView;         // 申请上庄视图背景
    GameHistoryView             *_gamehistoryView;      // 游戏记录视图
    GameWinView                 *_gameWinView;          // 押注获胜视图
    ExchangeCoinView            *_exchangeView;         // 兑换
    
    CGPoint                     _goldPoint;             // 押注获胜金额的点位置
    CGPoint                     _coinPoint;             // 余额金币的中心位置
    CGFloat                     _goldFlowerViewHeiht;   // 炸金花视图的高度
    BOOL                        _goldViewCanNotSee;
    
@protected
    __weak id<FWShowLiveRoomAble>   _liveItem;
    
    GiftView                        *_giftView;
    CGFloat                          _giftViewHeight;   // GiftView的高度
    
    ShopGoodsUIView                 *_shopGoodsView;    // 星店视图
    
    NSString                        *_roomIDStr;        // 房间ID
    
    id<FWLiveControllerAble>        _liveController;    // 当前SDK控制类
    
}

@property (nonatomic, weak) id<TCShowLiveViewForSDKDelegate>    sdkDelegate;
@property (nonatomic, weak) id<TCShowLiveViewServiceDelegate>   serveceDelegate;
@property (nonatomic, weak) id<TCShowLiveViewForUIDelegate>     uiDelegate;

@property (nonatomic, assign) BOOL                      isHost;                 // 是否主播
@property (nonatomic, assign) BOOL                      canApplyConnectMike;    // 是否还能够申请连麦

@property (nonatomic, strong) TCShowLiveInputView       *liveInputView;
@property (nonatomic, readonly) TCShowLiveTopView       *topView;
@property (nonatomic, readonly) TCShowLiveMessageView   *msgView;
@property (nonatomic, readonly) TCShowLiveBottomView    *bottomView;

@property (nonatomic, copy) NSString                    *share_type;            // 分享类型
@property (nonatomic, copy) NSString                    *private_share;         // 私人分享

@property (nonatomic, strong) GiftView                  *giftView;              // 礼物列表视图

@property (nonatomic, strong) ApplyBankerView           *bankerView;            // 申请上庄视图

@property (nonatomic, assign) BOOL                      canShowLightMessage;    // 是否能够显示点亮消息到直播间消息列表

@property (nonatomic, assign) NSInteger                 currentDiamonds;        // 当前账户钻石数量
@property (nonatomic, assign) NSInteger                 currentCoin;            // 当前账户游戏币数量
@property (nonatomic, assign) NSInteger                 live_in;                // 当前视频状态，对应的枚举为：FW_LIVE_STATE

@property (nonatomic, assign) BOOL                      hadClickStarShop;
@property (nonatomic, strong) MoreToolsView             *moreToolsView;
@property (nonatomic, copy)  NSString                   *toolsTitle;

@property (nonatomic, strong) CurrentLiveInfo           *currentLiveInfo;

@property (nonatomic, strong) MenuButton                *closeLiveBtn;          // 关闭推流按钮（不是关闭直播间按钮）
@property (nonatomic, strong) BMPopBaseView             *dailyTaskPop;          // 每日任务的view

/**
 *@pragma : 游戏相关
 **/
@property (nonatomic, strong) GoldFlowView              *goldFlowerView;        // 炸金花
@property (nonatomic, strong) UIView                    *historyBgView;         // 游戏记录显示时的黑色背景
@property (nonatomic, strong) UIView                    *winBgView;             // 游戏获胜时的黑色背景
@property (nonatomic, strong) UIView                    *bankerBgView;          // 申请上庄视图背景
@property (nonatomic, strong) GameHistoryView           *gamehistoryView;       // 游戏记录视图
@property (nonatomic, strong) GameWinView               *gameWinView;           // 押注获胜视图
@property (nonatomic, strong) ExchangeCoinView          *exchangeView;          // 兑换

@property (nonatomic, assign) CGFloat                   goldFlowerViewHeiht;    // 炸金花视图的高度
@property (nonatomic, assign) BOOL                      goldViewCanNotSee;
@property (nonatomic, assign) BOOL                      bankerViewCanSee;       // 能否出现上庄视图
@property (nonatomic, assign) NSInteger                 gameId;                 // 游戏ID
@property (nonatomic, strong) LiveGameModel             *liveGameModel;         // 直播间游戏实体
@property (nonatomic, strong) GameDataModel             *gameDataModel;         // 游戏数据
@property (nonatomic, assign) NSInteger                 game_log_id;            // 游戏id(游戏轮数id)
@property (nonatomic, strong) NSMutableArray            *gameDataArray;         // 在直播间接收到的一轮游戏推送信息
@property (nonatomic, strong) NSMutableArray            *coinImgArray;          // 金币下落的图片数组
@property (nonatomic, assign) BOOL                      shouldReloadGame;       // 前后台切换后需要重新加载游戏数据
@property (nonatomic, strong) NSMutableArray            *gameArray;             // 存放用户前后台切换过程中的推送数据
@property (nonatomic, assign) int                       coinWindowNumber;       // 展示金币弹窗次数
@property (nonatomic, assign) BOOL                      canNotLoadData;
@property (nonatomic, assign) BOOL                      sureOnceGame;           // 用于确保调用get_video之后返回的数据和由推送获取到的数据只执行其中之一
@property (nonatomic, assign) NSInteger                 banker_status;          // 上庄状态，0：未开启上庄，1：玩家申请上庄，2：玩家上庄
@property (nonatomic, assign) GameBankerModel           *gameBankerModel;
@property (nonatomic, strong) GameBankerView            *gameBankerView;
@property (nonatomic, strong) NSMutableArray            *bankerListArr;
@property (nonatomic, strong) SelectBankerView          *selectctBankerView;
@property (nonatomic, strong) NSArray                   *bankerSwitchArray;
@property (nonatomic, strong) NSMutableArray            *bankerDataArr;         // 用于进行前后台切换时存放切回前台时的上庄相关的消息

@property (nonatomic, assign) BOOL                      isArc;
@property (nonatomic, assign) int                       gameAction;
@property (nonatomic, assign) BOOL                      hadBeginNext;
@property (nonatomic, assign) double                    timestamp;              // 时间戳

@property (nonatomic, strong) GuessSizeView             *guessSizeView;         // 猜大小游戏视图
@property (nonatomic, assign) BOOL                      guessSizeViewCanNotSee;


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

- (void)addOwnViews;

- (void)hideInputView;

// 开始直播
- (void)startLive;
// 暂停直播
- (void)pauseLive;
// 重新开始直播
- (void)resumeLive;
// 结束直播
- (void)endLive;

- (void)onRecvLight:(NSString *)lightName;
#if kSupportIMMsgCache
- (void)onRecvPraise:(AVIMCache *)cache;
#endif

- (void)onTapBlank:(UITapGestureRecognizer *)tap;
// 隐藏giftView
- (void)hiddenGiftView;

/**
 *@pragma : 游戏相关
 **/
//异步请求直播间数据
- (void)loadGameData;
//主播调
- (void)addGameView;
//观众调
- (void)loadGoldFlowerViewWithBetArray:(NSArray *) betArray withGameID:(NSInteger)gameID;
//移除游戏历史和游戏获胜视图
- (void)removeGameHistoryAndGameWin;

- (void)gameOverWithCustomMessageModel:(CustomMessageModel *)customMessageModel;

- (void)gameAllMessageWithCustomMessageModel:(CustomMessageModel *)customMessageModel;

- (void)gameBankerMessageWithCustomMessageModel:(CustomMessageModel *)customMessageModel;

- (void)disAboutClick;

- (void)beginGame;

- (void)closeGitfView;

@end
