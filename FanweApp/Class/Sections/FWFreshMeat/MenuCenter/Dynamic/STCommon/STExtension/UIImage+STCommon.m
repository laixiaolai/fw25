//
//  UIImage+STCommon.m
//  FanweApp
//
//  Created by 岳克奎 on 17/3/13.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "UIImage+STCommon.h"
#import <Accelerate/Accelerate.h>
@implementation UIImage (STCommon)
+(UIImage *)st_thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time {
    UIImage *thumbnailImage;
    @autoreleasepool {
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator =[[AVAssetImageGenerator alloc] initWithAsset:asset];
    
    //获取任意帧
    assetImageGenerator.requestedTimeToleranceAfter = kCMTimeZero;
    assetImageGenerator.requestedTimeToleranceBefore = kCMTimeZero;
    
    
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode =AVAssetImageGeneratorApertureModeEncodedPixels;
    
    
    
    
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = time;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 1)actualTime:NULL error:&thumbnailImageGenerationError];
    
    if(!thumbnailImageRef)
        NSLog(@"thumbnailImageGenerationError %@",thumbnailImageGenerationError);
    
    thumbnailImage = thumbnailImageRef ? [[UIImage alloc]initWithCGImage:thumbnailImageRef] : nil;
        
    }
    return thumbnailImage;
}
#pragma mark - 1.0 高斯模糊
/**
 *  CoreImage:
 * iOS5.0之后就出现了Core Image的API,Core Image的API被放在CoreImage.framework库中, 在iOS和OS X平台上，Core Image都提供了大量的（Filter），在OS X上有120多种Filter，而在iOS上也有90多。
 *
 */
+(UIImage *)coreBlurImage:(UIImage *)image withBlurNumber:(CGFloat)blur
{
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage= [CIImage imageWithCGImage:image.CGImage];
    //设置filter
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey]; [filter setValue:@(blur) forKey: @"inputRadius"];
    //模糊图片
    CIImage *result=[filter valueForKey:kCIOutputImageKey];
    CGImageRef outImage=[context createCGImage:result fromRect:[result extent]];
    UIImage *blurImage=[UIImage imageWithCGImage:outImage];
    CGImageRelease(outImage);
    return blurImage;
}
/**
 * vImage
 * vImage属于Accelerate.Framework，需要导入 Accelerate下的 Accelerate头文件， Accelerate主要是用来做数字信号处理、图像处理相关的向量、矩阵运算的库。图像可以认为是由向量或者矩阵数据构成的，Accelerate里既然提供了高效的数学运算API，自然就能方便我们对图像做各种各样的处理 ，模糊算法使用的是vImageBoxConvolve_ARGB8888这个函数。
 *
 */
+(UIImage *)boxblurImage:(UIImage *)image withBlurNumber:(CGFloat)blur
{
    if (blur < 0.f || blur > 1.f) {
        blur = 0.5f;
    }
    int boxSize = (int)(blur * 40);
    boxSize = boxSize - (boxSize % 2) + 1;
    CGImageRef img = image.CGImage;
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    void *pixelBuffer;
    //从CGImage中获取数据
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    //设置从CGImage获取对象的属性
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    if(pixelBuffer == NULL)
        NSLog(@"No pixelbuffer");
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate( outBuffer.data, outBuffer.width, outBuffer.height, 8, outBuffer.rowBytes, colorSpace, kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    //clean up CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    free(pixelBuffer);
    CFRelease(inBitmapData);
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);
    return returnImage;
}

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
              strFrame:(CGRect)contentStrFrame {
    // 开启图形 '上下文'
    UIGraphicsBeginImageContextWithOptions(bgImg.size, NO, 0);
    // 绘制原生图片
    [bgImg drawAtPoint:CGPointZero];
    // 在原生图上绘制文字
    NSString *str = contentStr;
    // 创建文字属性字典
    NSDictionary *dictionary = @{NSForegroundColorAttributeName: strColor,
                                 NSFontAttributeName: [UIFont systemFontOfSize:fontSize]};
    // 绘制文字属性
    [str drawInRect:contentStrFrame withAttributes:dictionary];
    // 从当前上下文获取修改后的图片
    UIImage *newImg = UIGraphicsGetImageFromCurrentImageContext();
    // 结束图形上下文
    UIGraphicsEndImageContext();
    return newImg;
}

+(UIImage *)showBgImge:(UIImage *)bgImg contentStr:(NSString *)contentStr otherStr:(NSString *)otherStr strColor:(UIColor *)strColor contentStrFontSize:(CGFloat)fontSize strFrame:(CGRect)contentStrFrame otherStrFrame:(CGRect)otherStrFrame{
    // 开启图形 '上下文'
    UIGraphicsBeginImageContextWithOptions(bgImg.size, NO, 0);
    // 绘制原生图片
    [bgImg drawAtPoint:CGPointZero];
    // 在原生图上绘制文字
    NSString *str = contentStr;
    // 创建文字属性字典
    NSDictionary *dictionary = @{NSForegroundColorAttributeName: strColor,
                                 NSFontAttributeName: [UIFont systemFontOfSize:fontSize]};
    // 绘制文字属性
    [str drawInRect:contentStrFrame withAttributes:dictionary];
    // 从当前上下文获取修改后的图片
    UIImage *newImg = UIGraphicsGetImageFromCurrentImageContext();
    // 结束图形上下文
    UIGraphicsEndImageContext();
    return newImg;
}



@end
