//
//  UILabel+MyLabel.m
//  PopupWindow
//
//  Created by 杨仁伟 on 2017/5/16.
//  Copyright © 2017年 yrw. All rights reserved.
//

#import "UILabel+MyLabel.h"

@implementation UILabel (MyLabel)
+ (UILabel *)quickLabelWithFrame: (CGRect)frame color: (UIColor *)color font: (NSInteger)font text: (NSString *)text superView: (UIView *)superView
{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.textColor = color;
    label.font = [UIFont systemFontOfSize:font];
    label.text = text;
    [superView addSubview:label];
    return label;
}

+ (UILabel *)quickCreatePopupWindowRoomListLabelWithFrame:(CGRect)frame text:(NSString *)text supView:(UIView *)supView
{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.textColor = [UIColor darkGrayColor];
    label.backgroundColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:14];
    label.text = text;
    label.textAlignment = NSTextAlignmentCenter;
    [supView addSubview:label];
    return label;
}

@end
