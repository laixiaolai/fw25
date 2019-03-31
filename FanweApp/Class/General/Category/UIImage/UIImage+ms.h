//
//  UIImage+ms.h
//  微博微微
//
//  Created by GuoMS on 14-6-15.
//  Copyright (c) 2014年 MAC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ms)

+ (UIImage*)fullscrennImage:(NSString*)name;
// 可以自由拉伸的图片
+ (UIImage *)resizedImage:(NSString *)imgName;

+ (UIImage *)resizedImage:(NSString *)imgName xPos:(CGFloat)xPos yPos:(CGFloat)yPos;
// 添加文字水印
+(UIImage *) imageWithStringWaterMark:(UIImage*)image mark:(NSString *)markString inRect:(CGRect)rect color:(UIColor *)color font:(UIFont *)font;

@end
