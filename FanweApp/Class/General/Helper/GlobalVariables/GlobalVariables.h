//
//  GlobalVariables.h
//  FanweApp
//
//  Created by xfg on 16/2/15.
//  Copyright © 2016年 xfg. All rights reserved.

#import <Foundation/Foundation.h>
#import "AppModel.h"
#import "LiveState.h"

@interface GlobalVariables : NSObject

@property (nonatomic, strong) NSMutableDictionary *config;

@property (nonatomic, strong) AppModel          *appModel;

@property (nonatomic, strong) NSArray           *doMainUrlArray;        // app域名列表（为什么不是单个域名呢？原因是我们有加了域名备份功能）
@property (nonatomic, copy) NSString            *currentDoMianUrlStr;   // app当前接口地址

@property (nonatomic, copy) NSString            *ios_down_url;          // ios升级路径
@property (nonatomic, copy) NSString            *deviceToken;           // 设备id
@property (nonatomic, assign) double            latitude;               // 用户当前位置纬度
@property (nonatomic, assign) double            longitude;              // 用户当前位置经度
@property (nonatomic, copy) NSString            *locationCity;          // 定位出来的城市
@property (nonatomic, copy) NSString            *province;              // 定位出来的省
@property (nonatomic, copy) NSString            *area;                  // 定位出来的行政区
@property (nonatomic, copy) NSString            *locateName;            // 定位出来的具体地址
@property (nonatomic, copy) NSString            *addressJsonStr;        // 用来存储js_position2的第三个参数（json格式）
@property (nonatomic, copy) NSString            *agreement_link ;       // 直播协议链接
@property (nonatomic, copy) NSString            *privateKeyString ;     // 私密的key
@property (nonatomic, assign) BOOL              isEnterHistoryLive;     // 是否进入回播;
@property (nonatomic, assign) BOOL              isHaveDelete;           // h5退出当前自己直播是否还有悬浮的x;
@property (nonatomic, strong) LiveState         *liveState;             // 记录当前app是否在某个直播间，为nil的时候表示退出了直播间

@property (nonatomic, assign)int                live_pay_count_down;    // 收费直播的倒计时
@property (nonatomic, assign)int                live_pay;               // 是否支持付费直播1支持0不支持
@property (nonatomic, assign)int                distribution;           // 是否支持分销1支持0不支持

@property (nonatomic, assign) NSTimeInterval    foreGroundTime;         // 进入前台时间(s)
@property (nonatomic, assign) NSTimeInterval    backGroundTime;         // 进入后台时间(s)
@property (nonatomic, assign) NSTimeInterval    refreshAudienceListTime;    // 推送观众列表的时间

@property (nonatomic, strong) NSMutableArray    *newestLivingMArray;    // 最新直播列表
@property (nonatomic, strong) NSMutableArray    *listMsgMArray;         // 观众第一次进入直播间默认显示的消息
    
@property (nonatomic, copy) NSString            *aesKeyStr;

@property (nonatomic, assign) CGFloat           appNavigationBarHeight; // 导航栏高度
@property (nonatomic, assign) CGFloat           appTabBarHeight;        // 状态栏高度

+ (GlobalVariables *)sharedInstance;

- (void)storageAppMainUrls:(NSArray *)mainUrlArray;

- (void)storageAppCurrentMainUrl:(NSString *)currentMainUrl;
    
- (void)storageAppAESKey:(NSString *)aesKeyStr;

@end
