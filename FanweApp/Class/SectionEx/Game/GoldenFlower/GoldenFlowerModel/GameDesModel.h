//
//  GameDesModel.h
//  FanweApp
//
//  Created by 王珂 on 16/11/25.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameDesModel : NSObject

@property(nonatomic,  copy)NSString *game_id;  //游戏编号
@property(nonatomic,  copy)NSString *name;     //游戏名称
@property(nonatomic,  copy)NSString *image;    //游戏封面图
@property(nonatomic,  copy)NSString *principal;  //开始本金

@end
