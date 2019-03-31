//
//  PokerView.m
//  GoldenFlowerDemo
//
//  Created by GuoMs on 16/11/17.
//  Copyright © 2016年 zcd. All rights reserved.
//

#import "PokerView.h"

@implementation PokerView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.pokWidth = kPokerW;
    self.pokHeight = kPokerH-4;
    self.secondpokerLeading.constant = kPokerW*2.0/3;
    self.thirdpokerLeading.constant = kPokerW*4.0/3-2;
    self.pokerResultView.hidden = YES;
    self.backgroundColor = [kBlackColor colorWithAlphaComponent:0.3];
    self.pokerOne.layer.cornerRadius = 5;
    self.pokerOne.layer.masksToBounds = YES;
    self.pokerTwo.layer.cornerRadius = 5;
    self.pokerTwo.layer.masksToBounds = YES;
    self.pokerThree.layer.cornerRadius = 5;
    self.pokerThree.layer.masksToBounds = YES;
    self.layer.cornerRadius = 4;
    self.layer.masksToBounds = YES;
}

- (void)hidenPoker:(BOOL)hiden
{
    self.pokerOne.hidden = hiden;
    self.pokerTwo.hidden = hiden;
    self.pokerThree.hidden = hiden;
}

@end
