//
//  PersonCenterUserModel.h
//  FanweApp
//
//  Created by fanwe2014 on 2017/3/15.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonCenterUserModel : NSObject

@property (nonatomic, copy) NSString *user_id;              //用户靓号ID
@property (nonatomic, copy) NSString *nick_name;            //昵称
@property (nonatomic, copy) NSString *signature;            //我的个性签名
@property (nonatomic, copy) NSString *sex;                  //性别 0:未知, 1-男，2-女
@property (nonatomic, copy) NSString *city;                 //所在城市
@property (nonatomic, copy) NSString *focus_count;          //关注数
@property (nonatomic, copy) NSString *head_image;           //用户头像
@property (nonatomic, copy) NSString *fans_count;           //粉丝数
@property (nonatomic, copy) NSString *weibo_count;          //微博数
@property (nonatomic, copy) NSString *user_level;           //会员级别
@property (nonatomic, copy) NSString *is_authentication;    //是否认证 0指未认证 1指待审核 2指认证 3指审核不通过
@property (nonatomic, copy) NSString *v_type;               //认证类型
@property (nonatomic, copy) NSString *v_icon;               //认证图标
@property (nonatomic, copy) NSString *v_explain;            //认证介绍
@property (nonatomic, strong) NSMutableArray*showImageArray;//显示的头像数组
@property (nonatomic, copy) NSString *xpoint;               //经度
@property (nonatomic, copy) NSString *ypoint;               //纬度
@property (nonatomic, copy) NSString *weixin_price;         //微信价格
@property (nonatomic, copy) NSString *weibo_chat_price;     //聊聊的价格
@property (nonatomic, copy) NSString *weibo_chatprice_hadpay;//聊聊的价格
@property (nonatomic, copy) NSString *money;                //总收入
@property (nonatomic, assign) int    has_focus;             //是否关注按钮 0表示未关注 1表示已关注
@property (nonatomic, copy) NSString *today_money;          //今日收入
@property (nonatomic, copy) NSString *weibo_photo_img;      //背景图
@property (nonatomic, copy) NSString *level_imagView;       //等级图片


@property(nonatomic,assign)BOOL is_robot;


@end
