//
//  AppModel.h
//  ZCTest
//
//  Created by xfg on 16/2/17.
//  Copyright © 2016年 guoms. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VersionModel.h"
#import "AppUrlModel.h"

@interface VideoClassifiedModel : NSObject

@property (nonatomic, copy) NSString * title;
@property (nonatomic, assign) NSInteger classified_id;
@property (nonatomic, assign) BOOL isSelected;

@end

@interface AppModel : NSObject

@property (nonatomic, assign) long         init_version;            // 初始化接口的版本号

@property (nonatomic, copy) NSString        *site_url;              // 程序主链接
@property (nonatomic, copy) NSString        *statusbar_color;       // 状态栏颜色
@property (nonatomic, copy) NSString        *topnav_color;          // 导航栏颜色
@property (nonatomic, assign) NSInteger     sina_app_api;           // 是否新浪分享
@property (nonatomic, assign) NSInteger     qq_app_api;             // 是否qq分享
@property (nonatomic, assign) NSInteger     wx_app_api;             // 是否微信分享
@property (nonatomic, assign) NSInteger     statusbar_hide;         // 0:显示状态栏;1隐藏状态栏
@property (nonatomic, assign) NSInteger     ad_open;                // 点击广告内容打开方式：0:在第一个webveiw中打开;1:新建一个webview打开连接
@property (nonatomic, assign) NSInteger     reload_time;            // 重新加载程序时间

@property (nonatomic, assign) NSInteger     has_qq_login;           // 是否可以qq登录
@property (nonatomic, assign) NSInteger     has_sina_login;         // 是否可以新浪登录
@property (nonatomic, assign) NSInteger     has_wx_login;           // 是否可以微信登录
@property (nonatomic, assign) NSInteger     has_mobile_login;       // 是否可以手机登录

@property (nonatomic, copy) NSString        *agreement_link;        // 协议链接
@property (nonatomic, copy) NSString        *privacy_link;          // privacy链接
@property (nonatomic, copy) NSString        *city;                  // 服务器地址名
@property (nonatomic, copy) NSDictionary    *ip_info;               // 服务器地址名
@property (nonatomic, strong) NSMutableArray *api_link;             // 服务端下传的动态链接地址
@property (nonatomic, strong) AppUrlModel   *h5_url;                // app用到的h5链接地址

@property (nonatomic, strong) VersionModel  *version;               // 版本更新提示

@property (nonatomic, copy) NSString        *short_name ;           // app称呼
@property (nonatomic, copy) NSString        *ticket_name ;          // app票据的称呼
@property (nonatomic, copy) NSString        *account_name ;         // app账号的称呼
@property (nonatomic, copy) NSString        *app_name;              // app名称  方维直播

@property (nonatomic, copy) NSString        *spear_live ;           // 主播
@property (nonatomic, copy) NSString        *spear_normal ;         // 观众
@property (nonatomic, copy) NSString        *spear_interact ;       // 连麦

@property (nonatomic, copy) NSString        *ios_check_version;     // 苹果审核版本号
@property (nonatomic, copy) NSString        *region_versions ;      // 版本的存储

@property (nonatomic, copy) NSString        *first_login;           // 是否是每日首次登录
@property (nonatomic, copy) NSString        *login_send_score;      // 登陆赠送积分值;

@property (nonatomic, copy) NSString        *is_enable;             // 是否有插件
@property (nonatomic, assign) float         beauty_ios;             // IOS美颜度，默认值

@property (nonatomic, copy) NSString        *full_group_id;         // 全员广播大群ID
@property (nonatomic, copy) NSString        *on_line_group_id;      // 在线用户大群ID

@property (nonatomic, copy) NSString        *open_pai_module;       // 是否支持竞拍;
@property (nonatomic, copy) NSString        *pai_real_btn;          // 支持什么竞拍
@property (nonatomic, copy) NSString        *pai_virtual_btn;
@property (nonatomic, copy) NSString        *shopping_goods;        // 是否支持购物
@property (nonatomic, copy) NSString        *shop_shopping_cart;    // 是否显示购物车


@property (nonatomic, copy) NSString        *open_family_module;    // 是否打开家族功能
@property (nonatomic, copy) NSString        *family_join;           // 0关闭，1开启

@property (nonatomic, copy) NSString        *open_ranking_list;     // 是否打开总排行榜

@property (nonatomic, copy) NSString        *distribution_module;   //设置中是否显示推荐人这一栏

@property (nonatomic, assign) NSInteger     mic_max_num;            // 连麦的最大数量（本地写死最多3个，后才再加一个最大数量限制）
@property (nonatomic, assign) NSInteger     open_upgrade_prompt;
@property (nonatomic, assign) NSInteger     new_level;              // 新的等级，大于0为新的等级，等于0未没有升级
@property (nonatomic, assign) NSInteger     has_dirty_words;        // 是否支持脏字库 1：支持 0：不支持
@property (nonatomic, assign) NSInteger     auto_login;             // 1:自动创建帐户登陆;苹果审核跟云测试时使用
@property (nonatomic, assign) NSInteger     has_save_video;         // 保存视频（可用于回播）
@property (nonatomic, assign) NSInteger     beauty_close;           // 客户端是否允许自义美颜度 0:开; 1:关; 当beauty_close=1时,美颜功能只有 开/关；美颜值直接取：服务端返回的值
@property (nonatomic, assign) NSInteger     monitor_second;         // 主播心跳监听，每隔monitor_second秒监听一次;监听数据：时间点，印票数，房间人数
@property (nonatomic, assign) NSInteger     bullet_screen_diamond;  // 弹幕一次消费的金币
@property (nonatomic, assign) NSInteger     jr_user_level;          // 加入房间时,如果用户等级超过或等于jr_user_level时，有用户进入房间提醒操作

@property (nonatomic, assign) int           live_pay_count_down;    // 收费直播的倒计时
@property (nonatomic, assign) int           live_pay_time;          // 是否支持按时付费直播1支持0不支持
@property (nonatomic, assign) int           live_pay;               // 是否支持付费直播1支持0不支持
@property (nonatomic, assign) int           live_pay_scene;         // 是否支持按场付费直播1支持0不支持
@property (nonatomic, assign) int           distribution;           // 是否支持分销1支持0不支持
@property (nonatomic, assign) NSInteger     live_pay_max;           // 按时付费最高钻石
@property (nonatomic, assign) NSInteger     live_pay_min;           // 按时付费最低钻石
@property (nonatomic, assign) NSInteger     live_pay_scene_max;     // 按场付费最高钻石
@property (nonatomic, assign) NSInteger     live_pay_scene_min;     // 按场付费最低钻石

@property (nonatomic, copy) NSString        *open_vip;              // 1:开启VIP会员 0:不开启
@property (nonatomic, assign) BOOL          isInitSucceed;          // init初始化是否成功
@property (nonatomic, assign) int           open_sts;               // 1代表使用oss上传图像，否则不用oss上传头像
@property (nonatomic, copy) NSString        *open_society_module;   // 是否打开公会功能
@property (nonatomic, copy) NSString        *society_list_name;     // 公会名称

@property (nonatomic, assign) NSInteger     open_game_module;       // 是否开启游戏
@property (nonatomic, assign) NSInteger     open_send_coins_module; // 是否展示赠送游戏币按钮
@property (nonatomic, assign) NSInteger     open_banker_module;     // 是否展示上庄按钮
@property (nonatomic, assign) NSInteger     open_diamond_game_module;//表示是否使用钻石作为游戏币，1表示是

@property (nonatomic, assign) NSInteger     video_resolution_type;  // 腾讯云直播的清晰度    0：标清(360*640) 1：高清(540*960) 2：超清(720*1280)
@property (nonatomic, assign) NSInteger     open_podcast_goods;     // 是否开启源生的我的星店，对商品进行相应的操作
@property (nonatomic, assign) NSInteger     game_distribution;      // 游戏分销收益
@property (nonatomic, assign) NSInteger     open_send_diamonds_module; //是否展示赠送钻石按钮

@property (nonatomic, assign) NSInteger     has_visitors_login;     // 是否有游客登录方式

@property (nonatomic, assign) NSInteger     send_msg_lv;            // 直播间发言等f级限制，用户等级 >= send_msg_lv 时才可以发言
@property (nonatomic, assign) NSInteger     has_private_chat;       // 是否允许私信    1表示 允许 0 不允许
@property (nonatomic, assign) NSInteger     private_letter_lv;      // 私信等级限制，用户等级 >= private_letter_lv 时才可以发送私信
@property (nonatomic, copy) NSString        *itype;                 // 初始化接口下发，用于底层控制类型
@property (nonatomic, assign) NSInteger       is_classify;    //等1的时候需要强制分类，等0的时候不需要
@property (nonatomic, copy) NSString        *diamond_name;          // 初始化接口下发钻石名字，服务端控制




#pragma mark ******************** XRLive Part *************************
@property (nonatomic, strong) NSString      *weibo_goods_price;         // 商品动态  价格区间
@property (nonatomic, strong) NSString      *weibo_goods_price_1;       // 商品动态  价格起点
@property (nonatomic, strong) NSString      *weibo_goods_price_2;       // 商品动态  价格顶线
@property (nonatomic, strong) NSString      *weibo_photo_price;         // 写真动态  价格区间
@property (nonatomic, strong) NSString      *weibo_photo_price_1;       // 写真动态  价格起点
@property (nonatomic, strong) NSString      *weibo_photo_price_2;       // 写真动态  价格顶线
@property (nonatomic, strong) NSString      *weibo_red_price;           // 红包动态  价格区间
@property (nonatomic, strong) NSString      *weibo_weixin_price;        // 微信动态  价格区间
@property (nonatomic, strong) NSString      *weibo_weixin_price_1;      // 微信动态  价格起点
@property (nonatomic, strong) NSString      *weibo_weixin_price_2;      // 微信动态  价格顶线
@property (nonatomic, strong) NSString      *open_xr;                   // 是否开启鲜肉系统

@property (nonatomic, strong) NSMutableArray * video_classified;        // 直播分类

@property (nonatomic, assign) NSInteger     is_no_light;                // 1:不需要点亮功能  0:需要（默认）

@end
