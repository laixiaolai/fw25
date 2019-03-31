//
//  PokerStr.m
//  GoldenFlowerDemo
//
//  Created by 王珂 on 16/11/23.
//  Copyright © 2016年 zcd. All rights reserved.
//

#import "PokerStr.h"
#import "PokerView.h"
#import "BullPoker.h"
#import "TexasPokerLeftAndRight.h"
#import "TexasPokerBetween.h"
#import "PlayingCardView.h"
#import "TexasPokerLeftAndRight.h"
@implementation PokerStr
+(NSString *)exchangePokerNumberFromSuit:(int)suit andNumber:(int)pokerNumber
{
    NSString * colorPoker = suit%2 >0 ? @"red" :@"black";//根据牌的花色判断牌的点数的颜色
    if (pokerNumber >10)
    {
        if (pokerNumber == 11)
        {
            return [NSString stringWithFormat:@"gm_img_poker_jack_%@",colorPoker];
        }
        else if (pokerNumber == 12)
        {
            return [NSString stringWithFormat:@"gm_img_poker_queen_%@",colorPoker];
        }
        else if (pokerNumber == 13)
        {
            return [NSString stringWithFormat:@"gm_img_poker_king_%@",colorPoker];
        }
    }
    else if (pokerNumber <= 10)
    {
        if (pokerNumber == 1)
        {
            return [NSString stringWithFormat:@"gm_img_poker_ace_%@",colorPoker];
        }
        else
        {
            return [NSString stringWithFormat:@"gm_img_poker_%d_%@",pokerNumber,colorPoker];
        }
    }
    return @"error";
}

+(NSString *)exchangePokerSmallSuit:(int)suit
{
    if (suit == 0)
        return @"gm_poker_spade";//黑桃
    else if (suit == 1)
        return @"gm_poker_heart";//红桃
    else if (suit == 2)
        return @"gm_poker_club";//梅花
    else if (suit == 3)
        return @"gm_poker_diamond";//方块
    else
        return @"";
}

+(NSString *)exchangePokerBigSuitFromSuit:(int)suit andNumber:(int)pokerNumber
{
    NSString * suitStr ;//花色
    if (suit == 0)
        suitStr = @"gm_poker_spade";//黑桃
    else if (suit == 1)
        suitStr = @"gm_poker_heart";//红桃
    else if (suit == 2)
        suitStr = @"gm_poker_club";//梅花
    else if (suit == 3)
        suitStr = @"gm_poker_diamond";//方块
    //    else
    //        suitStr = @"";
    if (pokerNumber >10)
    {
        if (pokerNumber == 11)
        {
            return [NSString stringWithFormat:@"%@_j",suitStr];
        }
        else if (pokerNumber ==12)
        {
            return [NSString stringWithFormat:@"%@_k",suitStr];
        }
        else if (pokerNumber ==13)
        {
            return [NSString stringWithFormat:@"%@_q",suitStr];
        }
    }
    else if(pokerNumber <=10)
    {
        return suitStr;
    }
    return @"error";
}

+(NSString *)exchanegeGoldFlowerOrBullResultFromResultType:(int)type goldFlowerOrBull:(id)poker
{
    if ([poker isKindOfClass:[PokerView class]])
    {//判断炸金花牌型
        if (type==0)
            return @"gm_is_bao_zi";
        else if (type==1)
            return @"gm_is_tong_hua_shun";
        else if (type==2)
            return @"gm_is_tong_hua";
        else if (type==3)
            return @"gm_is_shun_zi";
        else if (type==4)
            return @"gm_is_dui_zi";
        else if (type==5)
            return @"gm_is_normal";
        return @"";
    }
    else if ([poker isKindOfClass:[BullPoker class]])
    {//判断斗牛牌型
        if (type==0)
          return @"gm_ico_bull_wxn";
        else if (type==1)
            return @"gm_ico_bull_zd";
        else if (type==2)
            return @"gm_ico_bull_whn";
        else if (type==3)
            return @"gm_ico_bull_shn";
        else if (type==4)
            return @"gm_ico_bull_nn";
        else if (type==5)
            return @"gm_ico_bull_n9";
        else if (type==6)
            return @"gm_ico_bull_n8";
        else if (type==7)
            return @"gm_ico_bull_n7";
        else if (type==8)
            return @"gm_ico_bull_n6";
        else if (type == 9)
            return @"gm_ico_bull_n5";
        else if (type == 10)
            return @"gm_ico_bull_n4";
        else if (type == 11)
            return @"gm_ico_bull_n3";
        else if (type == 12)
            return @"gm_ico_bull_n2";
        else if (type == 13)
            return @"gm_ico_bull_n1";
        else if (type == 14)
            return @"gm_ico_bull_mn";
        return @"";
    }
    else if ([poker isKindOfClass:[TexasPokerLeftAndRight class]])
    {//判断德州扑克的牌型
        if (type==0)
            return @"gm_tonghuasun";
        else if (type == 1)
            return @"gm_tonghua";
        else if (type == 2)
            return @"gm_sitiao";
        else if (type == 3)
            return @"gm_hulu";
        else if (type == 4)
            return @"gm_tonghua";
        else if (type == 5)
            return @"gm_sz";
        else if (type == 6)
            return @"gm_santiao";
        else if (type == 7)
            return @"gm_liangdui";
        else if (type == 8)
            return @"gm_yidui";
        else if (type == 9)
            return @"gm_gaopai";

    }
    return @"";

}
+ (void)aboutClassOfPokerOrBullPoker:(id)poker dict:(NSDictionary *)dic typeIMG:(NSString *)typeIMG{
    if ([poker isKindOfClass:[PokerView class]])
    {//判断单张炸金花牌的结果
        PokerView *pokerView = (PokerView *)poker;
        pokerView.pokerResultView.hidden = NO;
        pokerView.pokerResultView.image = [UIImage imageNamed:typeIMG];
        NSArray *cardsArr = [dic valueForKey:@"cards"];
        if (cardsArr.count == 3)
        {
            for (int i=0; i<3; ++i)
            {
                NSArray * cardArray = cardsArr[i];
                pokerView.playingCardView = [[NSBundle mainBundle]loadNibNamed:@"PlayingCardView" owner:self options:nil].lastObject;
                pokerView.playingCardView.frame =  CGRectMake(0, 0,  pokerView.pokWidth, pokerView.pokHeight);
                pokerView.playingCardView.layer.cornerRadius = 5.0;
                pokerView.playingCardView.layer.masksToBounds = YES;
                pokerView.playingCardView.layer.borderWidth = 2.0;
                pokerView.playingCardView.layer.borderColor = kGoldFolwerColor.CGColor;
                NSString * numberStr = [self exchangePokerNumberFromSuit:[cardArray.firstObject intValue] andNumber:[cardArray.lastObject intValue]];
                NSString * suitStr = [self exchangePokerSmallSuit:[cardArray.firstObject intValue]];
                NSString * bigSuitStr = [self exchangePokerBigSuitFromSuit:[cardArray.firstObject intValue] andNumber:[cardArray.lastObject intValue]];
                pokerView.playingCardView.numberOfCard.image = [UIImage imageNamed:numberStr];
                pokerView.playingCardView.smallSuit.image = [UIImage imageNamed:suitStr];
                pokerView.playingCardView.bigSuit.image = [UIImage imageNamed:bigSuitStr];
                if (i== 0)
                {
                    [pokerView.pokerOne addSubview:pokerView.playingCardView];
                }
                else if (i==1)
                {
                    [pokerView.pokerTwo addSubview:pokerView.playingCardView];
                }
                else if (i==2)
                {
                    [pokerView.pokerThree addSubview:pokerView.playingCardView];
                }
            }

        }

    }
    else if ([poker isKindOfClass:[BullPoker class]])
    {//判断单张斗牛牌的结果
      BullPoker  *pokerView = (BullPoker *)poker;
        pokerView.pokerResultView.hidden = NO;
        pokerView.pokerResultView.image = [UIImage imageNamed:typeIMG];
        NSArray *cardsArr = [dic valueForKey:@"cards"];
        NSLog(@"cardsArr--------%@",cardsArr);
        if (cardsArr.count == 5)
        {
            for (int i=0; i<5; ++i)
            {
                NSArray * cardArrayBull = cardsArr[i];
                pokerView.playingCardView = [[NSBundle mainBundle]loadNibNamed:@"PlayingCardView" owner:self options:nil].lastObject;
                pokerView.playingCardView.frame =  CGRectMake(0, 0,  pokerView.pokWidth, pokerView.pokHeight);
                pokerView.playingCardView.layer.cornerRadius = 5.0;
                pokerView.playingCardView.layer.masksToBounds = YES;
                pokerView.playingCardView.layer.borderWidth = 2.0;
                pokerView.playingCardView.layer.borderColor = kBullPokerColor.CGColor;
                NSString * numberStr = [self exchangePokerNumberFromSuit:[cardArrayBull.firstObject intValue] andNumber:[cardArrayBull.lastObject intValue]];
                NSString * suitStr = [self exchangePokerSmallSuit:[cardArrayBull.firstObject intValue]];
                NSString * bigSuitStr = [self exchangePokerBigSuitFromSuit:[cardArrayBull.firstObject intValue] andNumber:[cardArrayBull.lastObject intValue]];
                pokerView.playingCardView.numberOfCard.image = [UIImage imageNamed:numberStr];
                pokerView.playingCardView.smallSuit.image = [UIImage imageNamed:suitStr];
                pokerView.playingCardView.bigSuit.image = [UIImage imageNamed:bigSuitStr];
                if (i== 0)
                {
                    [pokerView.BullPokerOne addSubview:pokerView.playingCardView];
                }
                else if (i==1)
                {
                    [pokerView.BullPokerTwo addSubview:pokerView.playingCardView];
                }
                else if (i==2)
                {
                    [pokerView.BullPokerThree addSubview:pokerView.playingCardView];
                }
                else if (i==3)
                {
                    [pokerView.BullPokerFour addSubview:pokerView.playingCardView];
                }
                else if (i==4)
                {
                    [pokerView.BullPokerFive addSubview:pokerView.playingCardView];
                }
            }
            
        }
    }
    else if([poker isKindOfClass:[TexasPokerLeftAndRight class]])
    {//德州扑克(左右两张扑克牌)
        TexasPokerLeftAndRight *pokerView = (TexasPokerLeftAndRight *)poker;
        pokerView.pokerResultView.hidden = NO;
        pokerView.pokerResultView.image = [UIImage imageNamed:typeIMG];
        NSArray *cardsArr = [dic valueForKey:@"cards"];
        if (cardsArr.count == 2)
        {
            for (int i=0; i<2; ++i)
            {
                NSArray * cardArray = cardsArr[i];
                pokerView.playingCardView = [[NSBundle mainBundle]loadNibNamed:@"PlayingCardView" owner:self options:nil].lastObject;
                pokerView.playingCardView.frame =  CGRectMake(0, 0,  pokerView.pokWidth, pokerView.pokHeight);
                pokerView.playingCardView.layer.cornerRadius = 5.0;
                pokerView.playingCardView.layer.masksToBounds = YES;
                pokerView.playingCardView.layer.borderWidth = 2.0;
                pokerView.playingCardView.layer.borderColor = [UIColor grayColor].CGColor;
                NSString * numberStr = [self exchangePokerNumberFromSuit:[cardArray.firstObject intValue] andNumber:[cardArray.lastObject intValue]];
                NSString * suitStr = [self exchangePokerSmallSuit:[cardArray.firstObject intValue]];
                NSString * bigSuitStr = [self exchangePokerBigSuitFromSuit:[cardArray.firstObject intValue] andNumber:[cardArray.lastObject intValue]];
                pokerView.playingCardView.numberOfCard.image = [UIImage imageNamed:numberStr];
                pokerView.playingCardView.smallSuit.image = [UIImage imageNamed:suitStr];
                pokerView.playingCardView.bigSuit.image = [UIImage imageNamed:bigSuitStr];
                if (i== 0)
                {
                    [pokerView.texasLeftAndRightOne addSubview:pokerView.playingCardView];
                }
                else if (i==1)
                {
                    [pokerView.texasLeftAndRightTwo addSubview:pokerView.playingCardView];
                }
                
            }
            
        }
        
        
    }
    else if ([poker isKindOfClass:[TexasPokerBetween class]]){
      ///德州扑克(中间一副扑克牌)
        TexasPokerBetween *pokerView = (TexasPokerBetween *)poker;
//        pokerView.pokerResultView.hidden = NO;
//        pokerView.pokerResultView.image = [UIImage imageNamed:typeIMG];
        NSArray *cardsArr = [dic valueForKey:@"cards"];
        if (cardsArr.count == 5)
        {
            for (int i=0; i<5; ++i)
            {
                NSArray * cardArray = cardsArr[i];
                pokerView.playingCardView = [[NSBundle mainBundle]loadNibNamed:@"PlayingCardView" owner:self options:nil].lastObject;
                pokerView.playingCardView.frame =  CGRectMake(0, 0,  pokerView.pokWidth, pokerView.pokHeight);
                pokerView.playingCardView.layer.cornerRadius = 5.0;
                pokerView.playingCardView.layer.masksToBounds = YES;
                pokerView.playingCardView.layer.borderWidth = 2.0;
                pokerView.playingCardView.layer.borderColor = [UIColor grayColor].CGColor;
                NSString * numberStr = [self exchangePokerNumberFromSuit:[cardArray.firstObject intValue] andNumber:[cardArray.lastObject intValue]];
                NSString * suitStr = [self exchangePokerSmallSuit:[cardArray.firstObject intValue]];
                NSString * bigSuitStr = [self exchangePokerBigSuitFromSuit:[cardArray.firstObject intValue] andNumber:[cardArray.lastObject intValue]];
                pokerView.playingCardView.numberOfCard.image = [UIImage imageNamed:numberStr];
                pokerView.playingCardView.smallSuit.image = [UIImage imageNamed:suitStr];
                pokerView.playingCardView.bigSuit.image = [UIImage imageNamed:bigSuitStr];
                if (i == 0)
                {
                    [pokerView.texasPokerOne addSubview:pokerView.playingCardView];
                }
                else if (i == 1)
                {
                    [pokerView.texasPokerTwo addSubview:pokerView.playingCardView];
                }
                else if (i == 2)
                {
                    [pokerView.texasPokerThree addSubview:pokerView.playingCardView];
                }
                else if (i == 3)
                {
                    [pokerView.texasPokerFour addSubview:pokerView.playingCardView];
                }
                else if (i == 4)
                {
                    [pokerView.texasPokerFive addSubview:pokerView.playingCardView];
                }
            }
            
        }

    }
    

}
@end
