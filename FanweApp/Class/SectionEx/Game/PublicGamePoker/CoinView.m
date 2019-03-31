//
//  CoinView.m
//  GoldenFlowerDemo
//
//  Created by yy on 16/11/21.
//  Copyright © 2016年 zcd. All rights reserved.
//

#import "CoinView.h"

@implementation CoinView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.gameRechargeWidth.constant = kScreenW-200;
}

+ (instancetype)EditNibFromXib
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}

- (IBAction)btnClick:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(selectAmount:)]) {
        [_delegate selectAmount:sender];
    }
}

@end
