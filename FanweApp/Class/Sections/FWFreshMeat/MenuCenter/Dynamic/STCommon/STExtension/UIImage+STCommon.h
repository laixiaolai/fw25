//
//  UIImage+STCommon.h
//  FanweApp
//
//  Created by 岳克奎 on 17/3/13.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (STCommon)

#pragma mark -获取视频首帧
+(UIImage *)st_thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time ;
#pragma mark - 1.0 高斯模糊
#pragma mark - 1.0 高斯模糊
/**
 *  高斯模糊 CoreImage Api
 *  @param image 图片
 *  @param blur  模糊数值(默认是10)
 *  @other： Core Image设置模糊之后会在周围产生白边
 */
+(UIImage *)coreBlurImage:(UIImage *)image withBlurNumber:(CGFloat)blur;
/**
 *  高斯模糊 vImage
 *  @param image 原始图片
 *  @param blur  模糊数值(0-1)
 *  @other： 常用  需要导入：#import <Accelerate/Accelerate.h>
 */
+(UIImage *)boxblurImage:(UIImage *)image withBlurNumber:(CGFloat)blur;


#pragma mark -图片加文字
/**
 * @brief: 单张图片+一行文字
 *
 * @parameter: bgImg  背景img
 * @parameter: contentStr
 * @parameter: strColor
 * @parameter: fontSize
 * @parameter: contentStrFrame
 *
 */
#pragma mark -图片加文字
/**
 * @brief: 单张图片+一行文字
 *
 * @parameter: bgImg  背景img
 * @parameter: contentStr
 * @parameter: strColor
 * @parameter: fontSize
 * @parameter: contentStrFrame
 *
 */
+(UIImage *)showBgImge:(UIImage *)bgImg
            contentStr:(NSString *)contentStr
              strColor:(UIColor *)strColor
    contentStrFontSize:(CGFloat)fontSize
              strFrame:(CGRect)contentStrFrame;
#pragma mark -图片加文字 2行
/**
 * @brief: 单张图片+2行文字
 *
 *
 */
+(UIImage *)showBgImge:(UIImage *)bgImg
            contentStr:(NSString *)contentStr
              otherStr:(NSString *)otherStr
              strColor:(UIColor *)strColor
    contentStrFontSize:(CGFloat)fontSize
              strFrame:(CGRect)contentStrFrame
         otherStrFrame:(CGRect)otherStrFrame;
@end
