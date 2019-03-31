//
//  GameBetModel.h
//  FanweApp
//
//  Created by 王珂 on 16/11/25.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameBetModel : NSObject

@property (nonatomic, copy)  NSString * bet;       //总投注数
@property (nonatomic, copy)  NSString * user_bet; //玩家投注数

@end
