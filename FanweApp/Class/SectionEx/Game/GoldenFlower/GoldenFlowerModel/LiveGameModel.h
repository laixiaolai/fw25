//
//  LiveGameModel.h
//  FanweApp
//
//  Created by 王珂 on 16/11/25.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameDataModel.h"
#import "GameBankerModel.h"

@interface LiveGameModel : NSObject

@property (nonatomic, copy)  NSString * type;            //推送编号（无用）
@property (nonatomic, copy)  NSString * desc;            //推送描述，一般为''（无用）
@property (nonatomic, copy)  NSString * game_id;         //游戏种类 1:炸金花
@property (nonatomic, copy)  NSString * game_log_id;     //游戏id（轮数）
@property (nonatomic, copy)  NSString * game_status;     //游戏状态 1：游戏开始，2：游戏结束
//1:投注中，2：开牌中，3：游戏结束 //投注中game_date不会有win、cards、type数据
@property (nonatomic, copy)  NSString * time;            //剩余秒数
@property (nonatomic, copy)  NSString * game_action;     //游戏操作，不同游戏略有不同：开始：1；下注：2；停止：3；结算：4；翻牌：5；

@property (nonatomic, strong) NSArray * option;      //投注选项
@property (nonatomic, strong) NSArray * bet_option;       //投注金额选项
@property (nonatomic, strong) GameDataModel * game_data;  //游戏数据
@property (nonatomic, copy)  NSString * banker_status;    //上庄状态，0：未开启上庄，1：玩家申请上庄，2：玩家上庄
@property (nonatomic, strong) GameBankerModel * banker;  //上庄玩家信息
@property (nonatomic, copy)  NSString * principal;        //申请上庄底金
@property (nonatomic, assign) NSInteger auto_start;    //0手动，1自动

@end
