//
//  GameDataModel.h
//  FanweApp
//
//  Created by 王珂 on 16/11/25.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CardsDataModel : NSObject

@property (nonatomic, copy) NSString *type;        //牌型
@property (nonatomic, strong) NSArray *cards;        //手牌

@end

@interface GameDataModel : NSObject

@property (nonatomic, copy)  NSString   *win;         //获胜位
@property (nonatomic, strong) NSArray * bet;           //总投注数
@property (nonatomic, strong) NSArray * user_bet;      //玩家投注数
@property (nonatomic, strong) NSArray * cards_data;    //手牌
@property (nonatomic, strong) NSArray * public_cards;    //公牌
@property (nonatomic, strong) NSArray * dices;        //点数

@end


@interface GameHistoryModel : NSObject

@property (nonatomic, copy) NSString *historyNum;

@end

