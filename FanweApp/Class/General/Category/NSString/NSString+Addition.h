//
//  NSString+Addition.h
//  PinChaoPhone
//
//  Created by 克奎  岳 on 15/9/1.
//  Copyright (c) 2015年 LSY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Addition)

/**
 计算单行行宽
 */
- (CGFloat)commonStringWidthForFont:(CGFloat)fontSize;

/**
 计算行高
*/
- (CGFloat)commonStringHeighforLabelWidth:(CGFloat)width withFontSize:(CGFloat)fontSize;

/**
 计算文本最后一个字坐标点,需输入Label的frame值
 */
- (CGPoint)commonStringLastPointWithLabelFrame:(CGRect)frame withFontSize:(CGFloat)fontSize;
/**
 正则表达式判断
 */

- (BOOL)isUserName;

- (BOOL)isPassword;

- (BOOL)isEmail;

- (BOOL)isUrl;

- (BOOL)isTelephone;

- (BOOL) isEmpty;

- (BOOL) isidentityCard;

/**
 在文本中间添加横划线

 @return NSMutableAttributedString
 */
- (NSMutableAttributedString *)addTextCenterLine;

// c纯数字
- (BOOL)isNumber;

+(NSString *)showTimeStrFormDate:(NSDate*)compareDate;
// 判断是不是小数2位
+(BOOL)isDecimalNum:(NSString *)numStr;

@end
