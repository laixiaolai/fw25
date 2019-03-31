//
//  GameModel.h
//  FanweApp
//
//  Created by GuoMs on 16/11/25.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameModel : NSObject
@property(nonatomic,  copy)NSString *is_enable;     //插件是否可用（1:可用，0:不可用）
@property(nonatomic,  copy)NSString *is_active;     //是否游戏中(0:不在游戏中;1:正在游戏中)
@property(nonatomic,  copy)NSString *status;
@property(nonatomic,  copy)NSString *rs_count;      //总数
@property(nonatomic,  copy)NSString *game_id;       //游戏编号
@property(nonatomic,  copy)NSString *name;          //游戏名称
@property(nonatomic,  copy)NSString *image;         //游戏封面图
@property(nonatomic,  copy)NSString *principal;     //开始本金
@property(nonatomic,retain)NSMutableArray *list;    //游戏列表单
//@property(nonatomic,  copy)NSString *game_log_id;   //游戏id(游戏轮数id)

@property(nonatomic,  copy)NSString *child_id;      //插件子编号（对应类别内的自增id）
@property(nonatomic,  copy)NSString *class_name;    //操作类名称 （比如游戏：“game”）
@property(nonatomic,  copy)NSString *type;          //插件类别（基础类：1；游戏类：2）

@property(nonatomic,  copy)NSString *banker_name;   //申请上庄玩家昵称
@property(nonatomic,  copy)NSString *coin;          //申请上庄底金

@end
