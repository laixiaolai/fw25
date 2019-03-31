//
//  TCShowLiveBottomView.h
//  TCShow
//
//  Created by AlexiChen on 16/4/14.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSBadgeView.h"

typedef NS_ENUM(NSInteger, TCShowLiveFunctionType)
{
    EFunc_GIFT                  = 3,        // 礼物 
    EFunc_CONNECT_MIKE          = 4,        // 连麦
    EFunc_SHARE                 = 5,        // 分享 ==》待定
    
    EFunc_CHART                 = 6,        // 私信
    EFunc_INPUT                 = 7,        // 显示消息输入
    EFunc_STARSHOP              = 8,        // 星店按钮 ==》主播放里面，观众放外面
    EFunc_AUCTION               = 9,        // 竞拍按钮 ==》主播放里面，观众放外面
    EFunc_SALES_SUSWINDOW       = 10,       // 缩放 悬浮 window btn
    
    EFunc_GAMES                 = 11,       // 游戏按钮
    EFunc_BEGINGAMES            = 12,       // 发牌
    EFunc_LIVEPAY               = 13,       // 付费
    EFunc_MENTION               = 14,       // 提档
    EFunc_SWITCHGAMEVIEW        = 15,       // 游戏视图显示或隐藏
    EFunc_SWITCH_BANNER         = 16,       // 上庄下庄控制按钮
    EFunc_GRAB_BANNER           = 17,       // 玩家抢庄
    EFunc_MYSHOP                = 18,       // 我的小店按钮
    EFunc_MORETOOLS             = 19,       // 更多功能
    
    EFunc_FULL_SCREEN           = 20,       // 全屏
};

@class TCShowLiveBottomView;

@protocol TCShowLiveBottomViewDelegate <NSObject>
@optional

- (void)onBottomViewClickMenus:(TCShowLiveBottomView *)bottomView fromButton:(UIButton *)button;

@end


@protocol TCShowLiveBottomViewMultiDelegate <NSObject>

- (void)onBottomView:(TCShowLiveBottomView *)bottomView operateCameraOf:(id<AVMultiUserAble>)user fromButton:(UIButton *)button;
- (void)onBottomView:(TCShowLiveBottomView *)bottomView operateMicOf:(id<AVMultiUserAble>)user fromButton:(UIButton *)button;
- (void)onBottomView:(TCShowLiveBottomView *)bottomView switchToMain:(id<AVMultiUserAble>)user fromButton:(UIButton *)button;
- (void)onBottomView:(TCShowLiveBottomView *)bottomView cancelInteractWith:(id<AVMultiUserAble>)user fromButton:(UIButton *)button;

@end

@interface TCShowLiveBottomView : FWBaseView
{
@protected
    
    id<AVMultiUserAble>     _showUser;          // 多人互动时才会用到
    
    NSMutableArray          *_showFuncs;
    CGFloat                 _lastFloatBeauty;   // 主要为界面上重新条开时一致
    
    CGRect                  _heartRect;
    
    MenuButton              *_msgMenuBtn;       // 发送消息按钮
    MenuButton              *_starShopBtn;      // 星店按钮
    MenuButton              *_gamesBtn;         // 插件中心按钮
    
    CurrentLiveInfo         *_liveInfo;
}

@property (nonatomic, weak) id<TCShowLiveBottomViewDelegate> delegate;
@property (nonatomic, weak) id<TCShowLiveBottomViewMultiDelegate> multiDelegate;


@property (nonatomic, assign) CGRect        heartRect;              // 点亮起始位置、大小
@property (nonatomic, copy) NSString        *heartImgViewName;      // 点亮图片名字

@property (nonatomic, assign) BOOL          isHost;                 // 是否主播
@property (nonatomic, assign) BOOL          canSendLightMsg;        // 当前是否能够发送点赞
@property (nonatomic, assign) NSInteger     lightCount;             // 点亮数量
@property (nonatomic, strong) UIView        *menusBottomView;       // 用来放菜单的视图

@property (nonatomic, strong) MenuButton    *beginGameBtn;          // 开始游戏按钮
@property (nonatomic, strong) MenuButton    *auctionBtn;            // 竞拍按钮
@property (nonatomic, strong) MenuButton    *switchGameViewBtn;     // 游戏视图开关
@property (nonatomic, strong) MenuButton    *switchBankerBtn;       // 开启上庄,下庄
@property (nonatomic, strong) MenuButton    *grabBankerBtn;         // 抢庄
@property (nonatomic, strong) MenuButton    *moreToolsBtn;          // 更多功能

@property (nonatomic, strong) JSBadgeView   *jsbadge;               // 私聊的消息角标
@property (nonatomic, strong) JSBadgeView   *bjsbadge;              // 上庄、下庄的消息角标
@property (nonatomic, assign) NSInteger     bankMessage;            // 上庄、下庄的消息数量

#if kSupportIMMsgCache
@property (nonatomic, strong) NSMutableArray    *praiseImageCache;
@property (nonatomic, strong) NSMutableArray    *praiseAnimationCache;
#endif


/**
 请求完接口后，刷新直播间相关信息
 
 @param liveItem 视频Item
 @param liveInfo get_video2接口获取下来的数据实体
 */
- (void)refreshLiveItem:(id<FWShowLiveRoomAble>)liveItem liveInfo:(CurrentLiveInfo *)liveInfo;

- (void)addLiveFunc:(NSInteger)liveType;    // 视频类型，对应的枚举：FW_LIVE_TYPE

- (void)showLight;                          //显示点亮

- (void)showLikeHeart;

#if kSupportIMMsgCache
- (void)showLikeHeart:(AVIMCache *)cache;
#endif

- (void)updateShowFunc;

// 开始直播
- (void)startLive;
// 暂停直播
- (void)pauseLive;
// 重新开始直播
- (void)resumeLive;
// 结束直播
- (void)endLive;

@end
