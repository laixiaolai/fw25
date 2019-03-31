//
//  EditWebView.m
//  FanweApp
//
//  Created by yy on 16/9/22.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "EditWebView.h"

@implementation EditWebView

+ (instancetype)EditNibFromXib
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}

- (IBAction)ButtonClick:(UIButton *)sender {
    
    if (_delegate && [_delegate respondsToSelector:@selector(viewDown:)]) {
        [_delegate viewDown:sender];
    }
    
}

@end
