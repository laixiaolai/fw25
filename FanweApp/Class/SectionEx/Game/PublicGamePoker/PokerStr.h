//
//  PokerStr.h
//  GoldenFlowerDemo
//
//  Created by 王珂 on 16/11/23.
//  Copyright © 2016年 zcd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PokerStr : NSObject
+(NSString *)exchangePokerNumberFromSuit:(int)suit andNumber:(int)pokerNumber;//给牌的itype类型返回牌的点数图片的名称
+(NSString *)exchangePokerSmallSuit:(int)suit;//给牌的花色itype类型返回花色名称，用于小的花色图片
+(NSString *)exchangePokerBigSuitFromSuit:(int)suit andNumber:(int) pokerNumber;//给牌的花色itype类型返回花色名称，用于大的花色图片
+(NSString *)exchanegeGoldFlowerOrBullResultFromResultType:(int)type goldFlowerOrBull:(id)poker;
+ (void)aboutClassOfPokerOrBullPoker:(id)poker dict:(NSDictionary *)dic typeIMG:(NSString *)typeIMG;//针对炸金花和斗牛进行赋值
@end
