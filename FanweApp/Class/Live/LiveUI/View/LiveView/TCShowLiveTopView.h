//
//  TCShowLiveTopView.h
//  TCShow
//
//  Created by AlexiChen on 16/4/14.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"
#import "AudienceEnteringTipView.h"

@interface TCShowLiveTimeView : UIView
{
@protected
    MenuButton          *_hostHeadBtn;
    UIImageView         *_hostVImgView;
    UILabel             *_liveTitle;
    UILabel             *_liveAudience;
    
    BOOL                _isHost;           // 是否主播
}

@property (nonatomic, readonly) MenuButton      *hostHeadBtn;      // 主播头像
@property (nonatomic, readonly) UIImageView     *hostVImgView;  // 主播认证图标
@property (nonatomic, readonly) UILabel         *liveTitle;      // 直播Live
@property (nonatomic, readonly) UILabel         *liveAudience;  // 观众数
@property (nonatomic, strong) UIButton          *liveFollow;    // 关注按钮
@property (nonatomic, assign) NSInteger         watchNumber;    // 观众数量

@property (nonatomic, weak) id<FWShowLiveRoomAble> liveItem;


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

- (void)onImUsersEnterLive;
- (void)onImUsersExitLive;

@end



//==========================================================

@class TCShowLiveTopView;

@protocol TCShowLiveTopViewDelegate <NSObject>

@optional
// 点击用户头像
- (void)onTopView:(TCShowLiveTopView *)topView userModel:(UserModel *)userModel;
// 点击关注按钮
- (void)followAchor:(TCShowLiveTopView *)topView;
// 进入印票排行榜
- (void)goToContributionList:(TCShowLiveTopView *)topView;
// 最新点击+ -跳转
- (void)onTopView:(TCShowLiveTopView *)topView andCount:(int)count;
// 进入竞拍商品详情
- (void)goToAuctionList:(TCShowLiveTopView *)topView;
// ykk 控制半VC退出
- (void)clickTopViewUserHeaderMustQuitAllHalfVC:(TCShowLiveTopView*)topView;

@end

@protocol TCShowLiveTopViewToSDKDelegate <NSObject>

@required

// 推拉流请求所的码率
- (void)refreshKBPS:(TCShowLiveTopView *)topView;

@end


@interface TCShowLiveTopView : UIView<UICollectionViewDataSource,UICollectionViewDelegate>
{
    
@protected
    
    TCShowLiveTimeView          *_timeView;
   	UICollectionView            *_collectionView;
    UILabel                     *_ticketNameLabel;
    UIImageView                 *_moreImgView;
    
    __weak id<FWShowLiveRoomAble>      _liveItem;           // 开启、观看直播传入的实体
    NetHttpsManager             *_httpManager;
    
    NSTimer                     *_liveRateTimer;            // 刷新当前推拉流请求所的码率定时器
    
    BOOL                        _isHost;                    // 是否主播
    NSString                    *_groupIdStr;               // 群聊ID
    
}

@property (nonatomic, readonly) TCShowLiveTimeView                  *timeView;
@property (nonatomic, strong) UICollectionView                      *collectionView;

@property (nonatomic, weak) id<TCShowLiveTopViewDelegate>           toServicedelegate;
@property (nonatomic, weak) id<TCShowLiveTopViewToSDKDelegate>      toSDKDelegate;

@property (nonatomic, copy) NSString            *is_private;            // 是否是私密
@property (nonatomic, strong) NSMutableArray    *userArray;             // 用户列表
@property (nonatomic, assign) int                has_admin;             // 通过这个成员变量来判断是否是管理员(判断是否有加减号)

@property (nonatomic, assign) BOOL              isShowFollowBtn;        // 是否显示关注按钮

// 账号
@property (nonatomic, strong) UILabel           *accountLabel;

// 印票
@property (nonatomic, strong) UIView            *otherContainerView;
@property (nonatomic, strong) UILabel           *ticketNumLabel;        // 印票数

// 推拉流码率
@property (nonatomic, strong) UIView            *kbpsContainerView;
@property (nonatomic, strong) UILabel           *kbpsRecvLabel;
@property (nonatomic, strong) UILabel           *kbpsSendLabel;

// 最高价（竞拍）
@property (nonatomic, strong) UILabel           *titleNameLabel;
@property (nonatomic, strong) UILabel           *priceLabel;
@property (nonatomic, strong) UIView            *priceView;
@property (nonatomic, strong) UIImageView       *otherMoreView;


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

// 观众进入直播间
- (void)onImUsersEnterLive:(UserModel *)userModel;
// 观众退出直播间
- (void)onImUsersExitLive:(UserModel *)userModel;

// 更新otherContainerView的frame
- (void)relayoutOtherContainerViewFrame;

/**
 首次获取观众列表

 @param responseJson get_video接口的数据
 */
- (void)refreshAudienceList:(NSDictionary *)responseJson;

/**
 初始化观众数量、列表

 @param watch_number 观众数量
 */
- (void)setupLiveAudience:(NSString *)watch_number;

/**
 刷新观众列表

 @param customMessageModel Model
 */
- (void)refreshLiveAudienceList:(CustomMessageModel *)customMessageModel;

/**
 刷新印票数量

 @param ticketCount 印票数量
 */
- (void)refreshTicketCount:(NSString *)ticketCount;

// 开始直播
- (void)startLive;
// 暂停直播
- (void)pauseLive;
// 重新开始直播
- (void)resumeLive;
// 结束直播
- (void)endLive;

@end
