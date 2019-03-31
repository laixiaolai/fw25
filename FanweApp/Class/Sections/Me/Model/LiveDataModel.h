//
//  LiveDataModel.h
//  FanweApp
//
//  Created by fanwe2014 on 2016/11/19.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LiveDataModel : NSObject

@property (nonatomic, copy) NSString    *msg;//提示信息
@property (nonatomic, assign)int        is_agree;//同意收费
@property (nonatomic, assign)float      diamonds;//可用钻石
@property (nonatomic, assign)int        is_diamonds_low;//是否余额不足 0否 1是
@property (nonatomic, assign)int        is_recharge;//是否强制充值 0否 1是
@property (nonatomic, assign)int        count_down;//倒计时
@property (nonatomic, assign)int        live_fee;//收费

@property (nonatomic, assign)int is_live_pay;//直播是否收费 0指不收费，1指收费
@property (nonatomic, assign)int on_live_pay;//是否收费中 0指未开始收费，1指收费中
@property (nonatomic, assign)int live_pay_time;//开始收费时间

//收支榜
@property (nonatomic, copy) NSString *room_id;//直播间ID
@property (nonatomic, copy) NSString *total_time;//付费观看总时间
@property (nonatomic, copy) NSString *total_diamonds;//付费观看支出总钻石
@property (nonatomic, copy) NSString *user_id;//会员ID
@property (nonatomic, copy) NSString *head_image;//会员头像
@property (nonatomic, copy) NSString *user_level;//会员等级
@property (nonatomic, copy) NSString *sex;//会员性别
@property (nonatomic, copy) NSString *nick_name;//会员昵称
@property (nonatomic, copy) NSString *total_time_format;//格式化的时间
@property (nonatomic, copy) NSString *start_time;//开始时间
@property (nonatomic, copy) NSString *end_time;//结束时间
@property (nonatomic, copy) NSString *live_pay_type;//直播类型按场还是按时

//分销
@property (nonatomic, copy) NSString *user_name;//用户昵称
@property (nonatomic, copy) NSString *ticket;//贡献印票

@end
