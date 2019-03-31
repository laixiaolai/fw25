//
//  BullPoker.m
//  FanweApp
//
//  Created by 王珂 on 16/12/2.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "BullPoker.h"

@implementation BullPoker
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.pokWidth = kBullPokerW;
    self.pokHeight = kBullPokerH-4;
    self.BullPokerTwoLeftLeading.constant = kBullPokerW *1.0/3.0+1;
    self.BullPokerThreeLeftLeading.constant = kBullPokerW * 2.0/3.0;
    self.BullPokerFourLeftLeading.constant = kBullPokerW * 3.0/3.0-1;
    self.BullPokerFiveLeftLeding.constant = kBullPokerW * 4.0/3.0-2;
    self.backgroundColor = [kBlackColor colorWithAlphaComponent:0.3];
    self.pokerResultView.hidden = YES;
    self.BullPokerOne.layer.cornerRadius = 5;
    self.BullPokerOne.layer.masksToBounds = YES;
    self.BullPokerTwo.layer.cornerRadius = 5;
    self.BullPokerTwo.layer.masksToBounds = YES;
    self.BullPokerThree.layer.cornerRadius = 5;
    self.BullPokerThree.layer.masksToBounds = YES;
    self.BullPokerFour.layer.cornerRadius = 5;
    self.BullPokerFour.layer.masksToBounds = YES;
    self.BullPokerFive.layer.cornerRadius = 5;
    self.BullPokerFive.layer.masksToBounds = YES;
    self.layer.cornerRadius = 4;
    self.layer.masksToBounds = YES;
}

#pragma mark -- 隐藏 所有的牌
- (void)hidenBullPoker:(BOOL)hiden
{
    self.BullPokerOne.hidden = hiden;
    self.BullPokerTwo.hidden = hiden;
    self.BullPokerThree.hidden = hiden;
    self.BullPokerFour.hidden = hiden;
    self.BullPokerFive.hidden = hiden;
}

@end
