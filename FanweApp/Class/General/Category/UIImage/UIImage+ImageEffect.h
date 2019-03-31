//
//  UIImage+ImageEffect.h
//  CommonLibrary
//
//  Created by AlexiChen on 15/12/24.
//  Copyright © 2015年 AlexiChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ImageEffect)

- (UIImage *)applyLightEffect;
- (UIImage *)applyExtraLightEffect;
- (UIImage *)applyDarkEffect;
- (UIImage *)applyTintEffectWithColor:(UIColor *)tintColor;

- (UIImage *)blurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor deltaFactor:(CGFloat)deltaFactor maskImage:(UIImage *)maskImage;

+ (void)frostedGlassEffectWithView:(UIView *)view effect:(UIBlurEffect *)effect;
@end
