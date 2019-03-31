//
//  TexasPokerBetween.m
//  FanweApp
//
//  Created by 王珂 on 16/12/14.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "TexasPokerBetween.h"

@implementation TexasPokerBetween

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.pokWidth = kBullPokerW;
    self.pokHeight = kBullPokerH-4;
    self.texasPokerTwoLeftLeading.constant = kTexasPokerWidth*2.0/3.0;
    self.texasPokerThreeLeftLeading.constant = kTexasPokerWidth * 4.0/3.0;
    self.texasPokerFourLeftLeading.constant = kTexasPokerWidth * 6.0/3.0;
    self.texasPokerFiveLeftLeading.constant = kTexasPokerWidth * 8.0/3.0;
    self.backgroundColor = [kBlackColor colorWithAlphaComponent:0.3];
    self.pokerResultView.hidden = YES;
    self.texasPokerOne.layer.cornerRadius = 5;
    self.texasPokerOne.layer.masksToBounds = YES;
    self.texasPokerTwo.layer.cornerRadius = 5;
    self.texasPokerTwo.layer.masksToBounds = YES;
    self.texasPokerThree.layer.cornerRadius = 5;
    self.texasPokerThree.layer.masksToBounds = YES;
    self.texasPokerFour.layer.cornerRadius = 5;
    self.texasPokerFour.layer.masksToBounds = YES;
    self.texasPokerFive.layer.cornerRadius = 5;
    self.texasPokerFive.layer.masksToBounds = YES;
    self.layer.cornerRadius = 4;
    self.layer.masksToBounds = YES;
}

- (void)hidenTexasPoker:(BOOL)hiden
{
    self.texasPokerOne.hidden = hiden;
    self.texasPokerTwo.hidden = hiden;
    self.texasPokerThree.hidden = hiden;
    self.texasPokerFour.hidden = hiden;
    self.texasPokerFive.hidden = hiden;
}

@end
