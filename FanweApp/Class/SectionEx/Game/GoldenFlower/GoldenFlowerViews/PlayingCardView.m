//
//  PlayingCardView.m
//  GoldenFlowerDemo
//
//  Created by GuoMs on 16/11/22.
//  Copyright © 2016年 zcd. All rights reserved.
//

#import "PlayingCardView.h"

@implementation PlayingCardView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    CGFloat width = kPokerW/3.0;
    self.numberOfCardWidth.constant = width-4;
    self.smallSuitWidth.constant =width-3;
    self.bigSuitWidth.constant = width*2-5;
    self.layer.cornerRadius = 5.0;
    self.layer.masksToBounds = YES;
}

@end
