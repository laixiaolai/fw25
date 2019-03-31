//
//  userPageModel.h
//  FanweApp
//
//  Created by yy on 16/7/11.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface userPageModel : NSObject

@property (nonatomic, copy) NSString *nick_name;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *head_image;
@property (nonatomic, copy) NSString *fans_count;
@property (nonatomic, copy) NSString *focus_count;
@property (nonatomic, copy) NSString *user_level;//会员级别
@property (nonatomic, copy) NSString *v_explain;//认证说明
@property (nonatomic, copy) NSString *v_type;//认证类型
@property (nonatomic, copy) NSString *v_icon;//认证图标
@property (nonatomic, copy) NSString *use_diamonds;//送出钻石
@property (nonatomic, copy) NSString *diamonds;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *luck_num;//靓号
@property (nonatomic, copy) NSString *video_count;
@property (nonatomic, copy) NSString *ticket;//钱票
@property (nonatomic, copy) NSString *coin;//金币
@property (nonatomic, copy) NSString *signature;
@property (nonatomic, copy) NSString *is_authentication;
@property (nonatomic, copy) NSString *show_user_order;//【我的订单】 0否 1是
@property (nonatomic, copy) NSString *user_order;//我的订单数(观众)
@property (nonatomic, copy) NSString *show_user_pai;//【我的竞拍】 0否 1是
@property (nonatomic, copy) NSString *user_pai;//我的竞拍数（观众）
@property (nonatomic, copy) NSString *show_podcast_order;//订单管理(主播) 0否 1是
@property (nonatomic, copy) NSString *podcast_order;//订单数
@property (nonatomic, copy) NSString *show_podcast_goods;//商品管理（主播） 0否 1是
@property (nonatomic, copy) NSString *podcast_goods;//商品数量
@property (nonatomic, copy) NSString *show_podcast_pai;//竞拍管理(主播) 0否 1是
@property (nonatomic, copy) NSString *podcast_pai;//竞拍管理数量
@property (nonatomic, copy) NSString *shopping_cart;//购物车数量
//useable_ticket  收益里 显示 钱票
@property (nonatomic, copy) NSString *useable_ticket;//钱票

//家族字段
@property (nonatomic, copy) NSString * family_id;//家族ID
//@property (nonatomic, copy) NSString * jia_status;            //家族状态
@property (nonatomic, copy) NSString * family_chieftain;         //是否家族长；0：否、1：是

@property (nonatomic, copy) NSString *is_vip;               //用户是否VIP
@property (nonatomic, copy) NSString *vip_expire_time;      //会员到期日期

@property (nonatomic, copy) NSString * society_id;                 //公会ID
@property (nonatomic, copy) NSString * society_chieftain;         //是否公会长；0：否、1：是
@property (nonatomic, copy) NSString * shop_goods;  //我的小店商品数量
@property (nonatomic, copy) NSString * open_podcast_goods;  //是否打开我的小店
@property (nonatomic, copy) NSString *gh_status; //公会审核状态，0未审核，1审核通过，2拒绝通过,

//2.5版本 后台处理量化数据
@property ( nonatomic, copy) NSString *n_diamonds;              //钻石数
@property ( nonatomic, copy) NSString *n_fans_count;            //粉丝数
@property ( nonatomic, copy) NSString *n_focus_count;           //关注数
@property ( nonatomic, copy) NSString *n_use_diamonds;          //送出钻石
@property ( nonatomic, copy) NSString *n_video_count;           //直播数
@property ( nonatomic, copy) NSString *n_ticket;                //钱票
@property ( nonatomic, copy) NSString *n_coin;                  //金币
@property ( nonatomic, copy) NSString *n_useable_ticket;        //钱票
@property ( nonatomic, copy) NSString *n_podcast_order;         //订单管理的数量
@property ( nonatomic, copy) NSString *n_podcast_pai;           //竞拍管理的数量
@property ( nonatomic, copy) NSString *n_user_order;            //我的订单的数量
@property ( nonatomic, copy) NSString *n_podcast_goods;         //商品管理的数量
@property ( nonatomic, copy) NSString *n_user_pai;              //我的竞拍的数量（观众）
@property ( nonatomic, copy) NSString *n_shopping_cart;         //我的购物车的数量
@property ( nonatomic, copy) NSString *n_shop_goods;            //我的小店的数量
@property ( nonatomic, copy) NSString *n_svideo_count;          //小视频个数



@end
