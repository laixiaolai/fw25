//
//  FWPaddingLabel.m
//  FanweApp
//
//  Created by xfg on 2017/7/11.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "FWPaddingLabel.h"

@implementation FWPaddingLabel

- (void)drawRect:(CGRect)rect
{
    // 边距，上左下右
    UIEdgeInsets insets = {0, 5, 0, 5};
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

@end
