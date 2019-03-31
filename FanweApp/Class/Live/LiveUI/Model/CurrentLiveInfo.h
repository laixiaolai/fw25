//
//  CurrentLiveInfo.h
//  FanweApp
//
//  Created by xfg on 16/6/1.
//  Copyright © 2016年 xfg. All rights reserved.
//  获得当前直播的信息

#import <Foundation/Foundation.h>
#import "shareModel.h"
#import "PodcastModel.h"

@interface CurrentLiveInfo : NSObject

@property (nonatomic, copy) NSString        *room_id;           // 房间ID
@property (nonatomic, copy) NSString        *user_id;           // 主播ID
@property (nonatomic, copy) NSString        *luck_num;          // 靓号
@property (nonatomic, copy) NSString        *group_id;          // 聊天群ID
@property (nonatomic, copy) NSString        *cont_url;          // 印票贡献榜地址
@property (nonatomic, assign) NSInteger     viewer_num;         // 当前房间人数
@property (nonatomic, assign) NSInteger     online_status;      // 1:主播在线；0：主播离开
@property (nonatomic, assign) NSInteger     live_in;            // 当前视频状态，对应的枚举为：FW_LIVE_STATE

@property (nonatomic, strong) PodcastModel  *podcast;           // 主播信息
@property (nonatomic, strong) ShareModel    *share;             // 分享信息

@property (nonatomic, assign) NSInteger     pai_id;
@property (nonatomic, assign) NSInteger     game_log_id;        // 游戏轮数id
// 直播、回播
@property (nonatomic, copy) NSString        *play_url;          // 点播播放地址
@property (nonatomic, copy) NSString        *push_rtmp;         // 直播中主播推流地址
@property (nonatomic, copy) NSString        *push_url;          // 推流地址；主播时有效
@property (nonatomic, assign) NSInteger     has_video_control;  // 点播时，视频控制操作（是否显示播放进度条等）
@property (nonatomic, assign) NSInteger     sdk_type;           // SDK类型 对应的枚举是：FW_LIVESDK_TYPE

@property (nonatomic, copy) NSString        *live_fee;          // 每场或者每分钟钻石数量
@property (nonatomic, assign) NSInteger     is_live_pay;        // 是否有付费直播 1：该直播间已经开启了付费直播
@property (nonatomic, assign) NSInteger     live_pay_type;      // 0：按时间付费直播 1:按场付费直播
@property (nonatomic, assign) NSInteger     is_pay_over;        // 该参数是否付费过 1:付费过 0:未付费
@property (nonatomic, assign) NSInteger     join_room_prompt;   // 是否可以发送“来了”消息

@property (nonatomic, assign) NSInteger     is_vip;             // 当前用户是否vip会员
@property (nonatomic, assign) NSInteger     create_type;        // 0：手机直播 1：pc直播

@property (nonatomic, copy) NSString        *video_title;       // 视频类型名称，显示在视频左上角（不为空的时候才显示，为空时按本地的逻辑）

@property (nonatomic, copy) NSString        *share_type;        // 分享类型
@property (nonatomic, copy) NSString        *is_private;        // 是否私密直播
@property (nonatomic, copy) NSString        *private_share;     // 私密key

@property (nonatomic, assign) NSInteger     has_lianmai;        // 1:显示连麦按钮; 0:不显示连麦按钮

@end
