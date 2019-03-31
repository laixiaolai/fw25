//
//  SenderModel.h
//  FanweApp
//
//  Created by xfg on 16/5/30.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SenderModel : NSObject<IMUserAble>

@property (nonatomic, copy) NSString *user_id; //用户ID
@property (nonatomic, copy) NSString *nick_name; //昵称
@property (nonatomic, copy) NSString *head_image; //头像
@property (nonatomic, assign) int user_level; //等级
@property (nonatomic, copy) NSString *v_icon; //认证图标
@property (nonatomic, assign) NSInteger v_type; //认证类型:0: 未认证;1:普通认证;2:企业认证;
@property (nonatomic, copy) NSString *sort_num; //该观众在当前直播间的排序权重
@property (nonatomic, copy) NSString  *group_id;
@property (nonatomic, copy) NSString  *room_id;
@property (nonatomic, copy) NSString  *live_in;

//直播回看列表
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *begin_time_format;
@property (nonatomic, copy) NSString *watch_number_format;

//关注主页
@property (nonatomic, copy) NSString *signature;//个性签名
@property (nonatomic, copy) NSString *sex;//性别
@property (nonatomic, copy) NSString *follow_id;


//搜索话题
@property (nonatomic, copy) NSString *cate_id;
@property (nonatomic, copy) NSString *num;

//1是家族长0是成员
@property (nonatomic, copy) NSString * family_chieftain;

@end
