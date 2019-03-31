//
//  UserModel.h
//  FanweApp
//
//  Created by fanwe2014 on 16/5/30.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cuserModel.h"
#import "AVIMAble.h"

@interface UserModel : NSObject<IMUserAble>

@property (nonatomic, assign) NSInteger     live_in;        // 当前视频状态，对应的枚举为：FW_LIVE_STATE
@property (nonatomic, copy) NSString        *ID;
@property (nonatomic, copy) NSString        *user_id;       // 用户ID
@property (nonatomic, copy) NSString        *luck_num;      // 用户靓号ID
@property (nonatomic, copy) NSString        *nick_name;     // 昵称
@property (nonatomic, copy) NSString        *signature;     // 我的个性签名
@property (nonatomic, copy) NSString        *sex;           // 性别 0:未知, 1-男，2-女
@property (nonatomic, copy) NSString        *city;          // 所在城市
@property (nonatomic, copy) NSString        *is_focus;      // 是否关注
@property (nonatomic, copy) NSString        *focus_count;   // 关注数
@property (nonatomic, copy) NSString        *head_image;    // 用户头像
@property (nonatomic, copy) NSString        *fans_count;    // 粉丝数
@property (nonatomic, copy) NSString        *ticket;        // 印票数
@property (nonatomic, copy) NSString        *use_ticket;    // 印票数
@property (nonatomic, copy) NSString        *user_level;    // 会员级别
@property (nonatomic, copy) NSString        *use_diamonds;  // 累计消费的钻石数
@property (nonatomic, copy) NSString        *diamonds;      // 钻石，只有查看自己时才有这个参数
@property (nonatomic, copy) NSString        *v_type;        // 认证类型:0: 未认证;1:普通认证;2:企业认证;
@property (nonatomic, copy) NSString        *v_icon;        // 认证图标
@property (nonatomic, copy) NSString        *v_explain;     // 认证说明
@property (nonatomic, copy) NSString        *home_url;      // 被查看的用户：个人主页地址
@property (nonatomic, copy) NSString        *num;           // 印票
@property (nonatomic, copy) NSString        *total_num;     // 总的印票
@property (nonatomic, copy) NSString        *title;         // title
@property (nonatomic, assign) BOOL          is_robot;

@property (nonatomic, copy) NSString        *sort_num;      // 该观众在当前直播间的排序权重
@property(nonatomic, strong) NSDictionary   *item;
@property (nonatomic, assign) NSInteger     sdk_type;       // SDK类型 对应的枚举是：FW_LIVESDK_TYPE

//主页的一些模型字段
@property (nonatomic, copy) NSString        *has_admin;
@property (nonatomic, copy) NSString        *has_focus;
@property (nonatomic, copy) NSString        *has_black;     //是否被拉黑
@property (nonatomic, copy) NSString        *show_admin;
@property (nonatomic, copy) NSString        *show_tipoff;
@property (nonatomic, copy) NSString        *status;
@property (nonatomic, strong) cuserModel    *user;          //user的信息

//检查直播状态
@property (nonatomic, copy) NSString        *room_id;
@property (nonatomic, copy) NSString        *group_id;
@property (nonatomic, copy) NSString        *content;

//编辑页面的
@property (nonatomic, copy) NSString        *is_authentication; // 是否认证 0指未认证  1指待审核 2指认证 3指审核不通过
@property (nonatomic, copy) NSString        *birthday;          // 生日
@property (nonatomic, copy) NSString        *emotional_state;   // 是否已婚
@property (nonatomic, copy) NSString        *province;
@property (nonatomic, copy) NSString        *job;
@property (nonatomic, copy) NSString        *is_edit_sex;

//地区界面的参数
@property (nonatomic, copy) NSString        *number;

//支付页面的网址
@property (nonatomic, copy) NSString        *pay_url;
@property (nonatomic, copy) NSString        *goods_name;
@property (nonatomic, copy) NSString        *goods_icon;
@property (nonatomic, copy) NSString        *order_sn;

//修改昵称提示信息
@property (nonatomic, copy) NSString        *nick_info;

//2.5服务端做量化处理
@property (nonatomic, copy) NSString        *n_fans_count;       // 粉丝数
@property (nonatomic, copy) NSString        *n_ticket;           // 印票数
@property (nonatomic, copy) NSString        *n_focus_count;      // 关注数
@property (nonatomic, copy) NSString        *n_use_diamonds;     // 累计消费的钻石数


@end
