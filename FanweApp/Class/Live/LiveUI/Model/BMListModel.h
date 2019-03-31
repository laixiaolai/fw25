//
//  BMListModel.h
//  FanweApp
//
//  Created by 丁凯 on 2017/5/19.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BMListModel : NSObject

@property (nonatomic, copy) NSString              * ID;                 //插件id
@property (nonatomic, copy) NSString              * child_id;           //游戏id
@property (nonatomic, copy) NSString              * name;               //插件名称
@property (nonatomic, copy) NSString              * image;              //插件图片
@property (nonatomic, copy) NSString              * type;               //插件类型：游戏为2
@property (nonatomic, copy) NSString              * class_name;         //无
@property (nonatomic, copy) NSString              * online_user;        //当前在线人数
@property (nonatomic, copy) NSString              * head_image;         //头像
@property (nonatomic, copy) NSString              * diamonds;           //
@property (nonatomic, assign) NSInteger           has_room;             // 是否有已创建房间
@property (nonatomic, copy) NSString              *index_image;
@property (nonatomic, copy) NSString              *coins;               //游戏币

// 每日任务列表
@property (nonatomic, copy) NSString              *current;             //当前进度次数
@property (nonatomic, copy) NSString              *left_times;          //剩余次数
@property (nonatomic, copy) NSString              *max_times;           //总次数
@property (nonatomic, copy) NSString              *money;               //奖励数
@property (nonatomic, copy) NSString              *progress;            //进度百分比
@property (nonatomic, copy) NSString              *target;              //目标次数
@property (nonatomic, copy) NSString              *time;                //剩余时间(秒数)
@property (nonatomic, copy) NSString              *title;               //奖励描述（xx枚钻石）
@property (nonatomic, copy) NSString              *desc;                //奖励描述（xx枚钻石）

@end
