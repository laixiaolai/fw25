//
//  BetView.m
//  GoldenFlowerDemo
//
//  Created by yy on 16/11/24.
//  Copyright © 2016年 zcd. All rights reserved.
//

#import "BetView.h"

@implementation BetView

+ (instancetype)EditNibFromXib
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}

- (IBAction)choseMoney:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(selectAmount:)]) {
        [_delegate selectAmount:sender];
    }
}

@end
