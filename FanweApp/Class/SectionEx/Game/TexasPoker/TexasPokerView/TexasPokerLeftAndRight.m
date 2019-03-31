//
//  TexasPokerLeftAndRight.m
//  FanweApp
//
//  Created by GuoMs on 16/12/12.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "TexasPokerLeftAndRight.h"

@implementation TexasPokerLeftAndRight

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.pokWidth = kPokerW;
    self.pokHeight = kPokerH;
    self.pokerTwoLeftLeading.constant = kBullPokerW*2.0/3.0;
    self.backgroundColor = [kBlackColor colorWithAlphaComponent:0.3];
    self.texasLeftAndRightOne.layer.cornerRadius = 5.0;
    self.texasLeftAndRightOne.layer.masksToBounds = YES;
    self.texasLeftAndRightTwo.layer.cornerRadius = 5.0;
    self.texasLeftAndRightTwo.layer.masksToBounds = YES;
    self.layer.cornerRadius = 4;
    self.layer.masksToBounds = YES;
}

- (void)hidenTexasPoker:(BOOL)hiden
{
    self.texasLeftAndRightOne.hidden = hiden;
    self.texasLeftAndRightTwo.hidden = hiden;
}

@end
