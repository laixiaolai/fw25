//
//  FWBusinessMacro.h
//  FanweApp
//  Created by xfg on 16/8/3.
//  Copyright © 2016年 xfg. All rights reserved.
//  业务宏

#ifndef FWBusinessMacro_h
#define FWBusinessMacro_h

// 以下为大众宏（可能整个app都有用到）

// SDK类型
typedef NS_ENUM(NSInteger, FW_LIVESDK_TYPE)
{
    FW_LIVESDK_TYPE_TXY             = 0,  // 腾讯云直播
    FW_LIVESDK_TYPE_KSY             = 1,  // 金山云直播
};

// 视频类型
typedef NS_ENUM(NSInteger, FW_LIVE_TYPE)
{
    FW_LIVE_TYPE_HOST               = 0,  // 直播的主播（推流）
    FW_LIVE_TYPE_RELIVE             = 1,  // 点播（回播、回看）
    FW_LIVE_TYPE_AUDIENCE           = 2,  // 直播的观众（拉流）
    FW_LIVE_TYPE_HDLIVE             = 3,  // 腾讯云互动直播（已废弃）
    FW_LIVE_TYPE_RECORD             = 4,  // 录制短视频
};

// 连麦类型
typedef NS_ENUM(NSInteger, FW_MICK_TYPE)
{
    FW_MICK_TYPE_KSY                = 1,  // 金山云连麦
    FW_MICK_TYPE_AGORA              = 2,  // 声网连麦
};

// 当前视频状态
typedef NS_ENUM(NSInteger, FW_LIVE_STATE)
{
    FW_LIVE_STATE_OVER              = 0,  // 已结束
    FW_LIVE_STATE_ING               = 1,  // 正在直播
    FW_LIVE_STATE_BEGINING          = 2,  // 创建中
    FW_LIVE_STATE_RELIVE            = 3,  // 回看
};


#define kWebViewTimeoutInterval                 15                              //  webview超时时间
#define kIMALoginParamUserKey                   @"kIMALoginParamUserKey"        //  用户信息的key
#define kIMAPlatform_AutoLogin_Key              @"kIMAPlatform_AutoLogin_Key"   //  自动登录key
#define kMyCookies                              @"mycookies"
#define kAppDoMainUrlListKey                    @"AppDoMainUrlListKey"          //  存储app备用域名key
#define kAppCurrentMainUrlKey                   @"AppCurrentMainUrlKey"         //  存储app当前使用的域名key
#define kAppVersionTimeKey                      @"AppVersionTimeKey"            //  存储app时间版本号的key
#define kFWAESKey                               @"kFWAESKey"                    //  存储app当前使用的AES加密key


//==================================================================================

// 以下为小众宏（可能单纯某个类用到）

// 直播间宏
#define kFollowBtnWidth                         40          // followBtn的宽度
#define kLiveStatusViewWidth                    50          // LiveStatusView的宽度
#define kLogoContainerViewHeight                30          // 主播头像容器视图的高度
#define kSendGiftContrainerHeight               45          // 发送礼物按钮视图的容器视图高度
#define COMMENT_TABLEVIEW_WIDTH                 kScreenW*0.8         // 普通消息容器视图宽度
#define COMMENT_TABLEVIEW_HEIGHT                150         // 普通消息容器视图高度
#define SEND_GIFT_ANIMATE_VIEW_WIDTH            235         // 礼物的动画视图的高度
#define SEND_GIFT_ANIMATE_VIEW_HEIGHT           52          // 礼物的动画视图的高度
#define kShoppingHeight                         kScreenH-1.5*0.4*kScreenW  //直播购物视图高度
#define BARRAGE_VIEW_Y_1                        kScreenH-kSendGiftContrainerHeight-COMMENT_TABLEVIEW_HEIGHT-15-35   //弹幕视图1(底下的)的Y值
#define BARRAGE_VIEW_Y_2                        BARRAGE_VIEW_Y_1 - 36                                               //弹幕视图2(上面的)的Y值
#define SEND_GIFT_ANIMATE_VIEW_Y_1              BARRAGE_VIEW_Y_2 - SEND_GIFT_ANIMATE_VIEW_HEIGHT-5                  //礼物的动画视图1(底下的)的Y值
#define SEND_GIFT_ANIMATE_VIEW_Y_2              SEND_GIFT_ANIMATE_VIEW_Y_1-SEND_GIFT_ANIMATE_VIEW_HEIGHT            //礼物的动画视图2(上面的)的Y值
#define kAudienceEnteringTipViewHeight          kScreenH-kSendGiftContrainerHeight-COMMENT_TABLEVIEW_HEIGHT-15-35   //观众进入提示视图的Y值·

#define kLiveMessageRefreshTime                 0.4         // 直播间刷新消息列表的定时器间隔时间
#define kGiftViewSendedDescTime                 5           // 礼物连发倒计时
#define kGoodsViewDescTime                      0.35        // 直播购物弹窗出现时间

#define kLiveInputViewLimitLength               64          // 直播间普通、弹幕消息输入的最大长度
#define kViconWidthOrHeight                     13          // 认证图标的大小
#define kViconWidthOrHeight2                    16          // 认证图标的大小
#define kViconWidthOrHeight3                    20          // 认证图标的大小
#define kViconWidthOrHeight4                    22          // 认证图标的大小

#define kFirstComeRoomRefreshTime               4           // 直播间主播刷新观众列表时间（刚进来的时候）
#define kPrivateRoomRefreshTime                 10          // 私密直播刷新观众列表时间
#define kHostRefreshTime                        20          // 直播间主播刷新观众列表时间
#define kMaxWaitFirstFrameSec                   1000000     // 直播间请求画面的最多次数

#define kApplyMikeTime                          30          // 连麦超时时间

// 金山连麦
#define kLinkMickXRate                          0.69        // 金山连麦小窗口X坐标相对手机宽度的比例
#define kLinkMickYRate                          0.12        // 金山连麦小窗口Y坐标相对手机高度的比例
#define kLinkMickWRate                          0.28        // 金山连麦小窗口宽度相对手机宽度的比例
#define kLinkMickHRate                          0.28        // 金山连麦小窗口高度相对手机高度的比例

// 直播间消息列表TCShowLiveMessageView的宏
#define kRoomTableViewMsgKey                    @"kRoomTableViewMsgKey"
#define kMaxMsgCount                            60          // 最多显示kMaxMsgCount条消息
#define kLiveMessageContentOffsetTime           4           // 当查看直播间消息列表时停留的时间

// 自定义表情图片宏
#define LIVE_USER_RANK_TAG                      @"/:rank"   // 消息列表用户等级的标识
#define LIVE_MSG_TAG                            @"/:zdy"    // 消息列表中末尾图片的标识（目前是表情）
#define LIVE_MSG_TAG2                           @"/:zdyimg" // 消息列表中末尾图片的标识（暂时用到的是点亮）

// 礼物动画页面的tag
// 飞机1
#define kPlane1Tag                  1001
#define kPlane1TypeStr              @"plane1"

// 飞机2
#define kPlane2Tag                  1002
#define kPlane2TypeStr              @"plane2"

// 法拉利
#define kFerrariTag                 1003
#define kFerrariTypeStr             @"ferrari"

// 兰博基尼
#define kLambohiniTag               1004
#define kLambohiniTypeStr           @"lamborghini"

// 火箭
#define kRocket1Tag                 1005
#define kRocket1TypeStr             @"rocket1"


// 连麦相关
#define kTCShowMultiViewHeight                  (kScreenH-kLogoContainerViewHeight-25-20-50-kDefaultMargin)     //CShowMultiView总的高度 = 屏幕高度减去TCShowLiveTopView的最大Y值，再减去TCShowLiveBottomView高度和kDefaultMargin
#define kTCShowMultiSubViewScale                0.7                                                         //TCShowMultiSubView的宽、高比
#define kTCShowMultiSubViewHeight               (kTCShowMultiViewHeight-kDefaultMargin*2)/3                     //TCShowMultiSubView的高度
#define kTCShowMultiSubViewSize                 CGSizeMake(kTCShowMultiSubViewHeight/kTCShowMultiSubViewScale, kTCShowMultiSubViewHeight)


// 游戏相关
#define pokerW              ([UIScreen mainScreen].bounds.size.width - 4 * 10) / 3
#define kTexasSmallWidth    kTexasPokerWidth*5.0/3.0
#define KtexasBigWidth      kTexasPokerWidth*11.0/3.0
#define kGuessSizeViewHeight      kScreenW/375.0*199.0
#define kGuessSizeButtomHeight   kGuessSizeViewHeight*78.0/427.0
#define kPokerW             PokerW()  // 炸金花扑克视图宽度
static __inline__ CGFloat PokerW()
{
    CGFloat width = pokerW/(2.0/3.0+2.0/3.0+1);
    
    return width;
}

#define kPokerH                PokerH()             // 炸金花扑克视图高度
static __inline__ CGFloat PokerH()
{
    CGFloat width = pokerW/(2.0/3.0+2.0/3.0+1);
    CGFloat  pokHeight = width*209/160;
    return pokHeight;
}

#define kBullPokerW                BullPokerW()     // 斗牛扑克视图宽度
static __inline__ CGFloat BullPokerW()
{
    CGFloat width = pokerW/(4*1.0/3.0+1);
    
    return width;
}

#define kBullPokerH                BullPokerH()     // 斗牛扑克视图宽度
static __inline__ CGFloat BullPokerH()
{
    CGFloat height = kBullPokerW * 209/160;
    
    return height;
}

#define kTexasPokerW               TexasPokerW()    // 斗牛扑克视图宽度
static __inline__ CGFloat TexasPoker()
{
    CGFloat width = pokerW/(4*1.0/3.0+1);
    
    return width;
}

#define kTexasPokerH                TexasPokerH()   // 斗牛扑克视图宽度
static __inline__ CGFloat TexasPokerH()
{
    CGFloat height = kBullPokerW * 209/160;
    
    return height;
}

#define kTexasPokerWidth                TexasPokerWidth()  // 炸金花扑克视图宽度
static __inline__ CGFloat TexasPokerWidth()
{
    CGFloat width = ([UIScreen mainScreen].bounds.size.width - 4 * 10)/7.0-1;
    
    return width;
}
  //=============================枚举=========================================
#pragma mark 个人中心
typedef NS_ENUM(NSInteger, MPersonCenterSections)
{
    MPCAcountSection,                  //账户
    MPCIncomeSection,                  //收益
    MPCVIPSection,                     //VIP会员
    MPCexchangeCoinsSection,           //兑换游戏币
    MPCSZJLSection,                    //直播间收支记录
    MPCOutPutSection,                  //送出
    
    MPCGradeSection,                   //等级
    MPCRenZhenSection,                 //认证
    MPCContributeSection,              //贡献榜
    
    MPCShareISection,                  //分享收益
    MPCGameSISection,                  //游戏分享收益
    
    MPCGoodsMSection,                  //商品管理
    MPCMyOrderSection,                 //我的订单
    MPCOrderMSection,                  //订单管理
    MPCShopCartSection,                //我的购物车
    
    MPCMyAutionSection,                //我的竞拍
    MPCAutionMSection,                 //竞拍管理
    
    MPCMyLitteShopSection,             //我的小店
    
    MPCFamilySection,                  //我的家族
    MPCTradeSection,                   //我的公会
    
    MPCSetSection,                     //设置
    
    MPPTableCCount
    
};


#endif /* FWBusinessMacro_h */
