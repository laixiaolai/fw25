//
//  cuserModel.h
//  FanweApp
//
//  Created by fanwe2014 on 16/5/30.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface cuserModel : NSObject

@property (nonatomic, copy) NSString            *user_id;           //印客号
@property (nonatomic, copy) NSString            *nick_name;         //昵称
@property (nonatomic, copy) NSString            *head_image;        //用户头像

//主页的一些模型字段
@property (nonatomic, copy) NSString            *birthday;          //生日
@property (nonatomic, copy) NSString            *city;              //家乡
@property (nonatomic, copy) NSString            *emotional_state;
@property (nonatomic, copy) NSString            *fans_count;        //粉丝数
@property (nonatomic, copy) NSString            *focus_count;       //关注数
@property (nonatomic, copy) NSString            *home_url;          //个人主页地址
@property (nonatomic, copy) NSMutableDictionary *item;              //用户年龄等一些信息
@property (nonatomic, copy) NSString            *job;
@property (nonatomic, copy) NSString            *province;
@property (nonatomic, copy) NSString            *sex;               //性别
@property (nonatomic, copy) NSString            *signature;         //个性签名
@property (nonatomic, copy) NSString            *ticket;            //印票
@property (nonatomic, copy) NSString            *use_diamonds;      //累计消费的钻石数
@property (nonatomic, copy) NSString            *user_level;        //会员级别
@property (nonatomic, copy) NSString            *v_explain;         //认证说明
@property (nonatomic, copy) NSString            *v_icon;            //认证图标
@property (nonatomic, copy) NSString            *v_type;            //认证类型
@property (nonatomic, copy) NSString            *is_authentication; //小图标
@property (nonatomic, copy) NSString            *luck_num;          //靓号

//首页-最新
@property (nonatomic, copy) NSString            *cate_id;
@property (nonatomic, copy) NSString            *title;
@property (nonatomic, copy) NSString            *num;

//认证初始化数据
@property (nonatomic, copy) NSString            *id;
@property (nonatomic, copy) NSString            *name;

//2.5 服务端做量化
@property (nonatomic, copy) NSString            *n_fans_count;        //粉丝数
@property (nonatomic, copy) NSString            *n_focus_count;       //关注数
@property (nonatomic, copy) NSString            *n_use_diamonds;      //累计消费的钻石数


@end
