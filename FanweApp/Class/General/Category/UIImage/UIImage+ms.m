//
//  UIImage+ms.m
//  微博微微
//
//  Created by GuoMS on 14-6-15.
//  Copyright (c) 2014年 MAC. All rights reserved.
//

#import "UIImage+ms.h"
#import "NSString+guoMS.h"

@implementation UIImage (ms)

+ (UIImage*)fullscrennImage:(NSString*)imageName
{
    //如果是iPhone5，对文件名做特殊处理
    if(isIPhone5())
    {
       imageName = [imageName fileAppend:@"-568h@2x"];
    }
    return [self imageNamed:imageName];
}

#pragma mark 可以自由拉伸的图片
+ (UIImage *)resizedImage:(NSString *)imgName
{
    return [self resizedImage:imgName xPos:0.5 yPos:0.5];
}

+ (UIImage *)resizedImage:(NSString *)imgName xPos:(CGFloat)xPos yPos:(CGFloat)yPos
{
    UIImage *image = [UIImage imageNamed:imgName];
    
    return [image stretchableImageWithLeftCapWidth:image.size.width * xPos topCapHeight:image.size.height * yPos];
}

+ (UIImage *) imageWithStringWaterMark:(UIImage*)image mark:(NSString *)markString inRect:(CGRect)rect color:(UIColor *)color font:(UIFont *)font
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 4.0)
    {
        UIGraphicsBeginImageContextWithOptions([image size], NO, 0.0); // 0.0 for scale means "scale for device's main screen".
    }
#else
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 4.0)
    {
        UIGraphicsBeginImageContext([image size]);
    }
#endif
    
    //原图
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    
    //文字颜色
    [color set];
    
    //水印文字
    [markString drawInRect:rect withFont:font];
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newPic;
}

@end
