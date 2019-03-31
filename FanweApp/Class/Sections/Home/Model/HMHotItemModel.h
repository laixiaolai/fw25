//
//  HMHotItemModel.h
//  FanweApp
//
//  Created by xfg on 2017/7/5.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "FWBaseModel.h"

@interface HMHotItemModel : FWBaseModel

@property (nonatomic, copy) NSString *live_image;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *sort;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *group_id;
@property (nonatomic, copy) NSString *head_image;
@property (nonatomic, copy) NSString *nick_name;
@property (nonatomic, copy) NSString *room_id;
@property (nonatomic, copy) NSString *thumb_head_image;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *v_icon;
@property (nonatomic, copy) NSString *v_type;
@property (nonatomic, copy) NSString *watch_number;
@property (nonatomic, copy) NSString *cate_id;          // ===>当cate_id>0时显示，话题
@property (nonatomic, assign) NSInteger live_in;          // 当前视频状态，对应的枚举为：FW_LIVE_STATE
@property (nonatomic, copy) NSString *sdk_type;         // SDK类型 对应的枚举是：FW_LIVESDK_TYPE
@property (nonatomic, copy) NSString *room_type;        // ===>1:私密直播;3:直播
@property (nonatomic, copy) NSString *is_live_pay;      // 付费直播（1.是 0.否）
@property (nonatomic, copy) NSString *live_pay_type;    // 收费类型（0按时收费，1按场次收费)
@property (nonatomic, copy) NSString *live_fee;         // 付费直播收费（每分钟收取的费用）
@property (nonatomic, copy) NSString *is_gaming;        // 是否在游戏中
@property (nonatomic, copy) NSString *game_name;        // 游戏名称
@property (nonatomic, copy) NSString *live_state;       // 当前视频类型的名称

@property (nonatomic, copy) NSString *page_title;
@property (nonatomic, copy) NSString *user_info;
@property (nonatomic, copy) NSString *is_login;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *sdk_data;
@property (nonatomic, copy) NSString *begin_time_format;
@property (nonatomic, copy) NSString *watch_number_format;
@property (nonatomic, copy) NSString *end_time;
@property (nonatomic, copy) NSString *playback_time;
@property (nonatomic, copy) NSString *max_watch_number;
@property (nonatomic, copy) NSString *begin_time;

@end
