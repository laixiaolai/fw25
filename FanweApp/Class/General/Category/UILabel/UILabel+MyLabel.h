//
//  UILabel+MyLabel.h
//  PopupWindow
//
//  Created by 杨仁伟 on 2017/5/16.
//  Copyright © 2017年 yrw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (MyLabel)

+ (UILabel *)quickLabelWithFrame: (CGRect)frame color: (UIColor *)color font: (NSInteger)font text: (NSString *)text superView: (UIView *)superView;

+ (UILabel *)quickCreatePopupWindowRoomListLabelWithFrame:(CGRect)frame text:(NSString *)text supView:(UIView *)supView;
@end
