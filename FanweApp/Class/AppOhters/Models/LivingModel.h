//
//  LivingModel.h
//  FanweApp
//
//  Created by xfg on 16/5/24.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LivingModel : NSObject

@property (nonatomic, assign) int           room_id;
@property (nonatomic, copy) NSString        *group_id;
@property (nonatomic, copy) NSString        *user_id;       // 直播者ID

//首页-最新
@property (nonatomic, copy) NSString        *city;
@property (nonatomic, copy) NSString        *user_level;
@property (nonatomic, copy) NSString        *head_image;
@property (nonatomic, copy) NSString        *thumb_head_image;
@property (nonatomic, copy) NSString        *live_image;
@property (nonatomic, assign) NSInteger     live_in;        // 当前视频状态，对应的枚举为：FW_LIVE_STATE
@property (nonatomic, assign) NSInteger     sdk_type;       // SDK类型 对应的枚举是：FW_LIVESDK_TYPE
@property (nonatomic, assign) NSInteger     room_type;      // 1:私密直播;3:直播 xponit

@property (nonatomic, assign) float         xponit;         // 经度
@property (nonatomic, assign) float         yponit;         // 维度
@property (nonatomic, assign) float         distance;       // 距离

@property (nonatomic, strong) NSString      *today_create;  // 新人标识（1.是 0.否）
@property (nonatomic, strong) NSString      *is_live_pay;   // 付费直播（1.是 0.否）

//鲜肉
@property (nonatomic, copy) NSString *fans_count;            //粉丝数
@property (nonatomic, copy) NSString *focus_count;           //关注数
@property (nonatomic, copy) NSString *is_authentication;     //是否认证
@property (nonatomic, copy) NSString *nick_name;             //是否认证

@end
