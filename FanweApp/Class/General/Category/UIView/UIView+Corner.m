//
//  UIView+Corner.m
//  XKSCommonSDK
//
//  _____  _           _          _____ _          _
//  |  ___(_)_ __   __| | ___ _ _|_   _(_)_      _| | __
//  | |_  | | '_ \ / _` |/ _ \ '__|| | | \ \ /\ / / |/ /
//  |  _| | | | | | (_| |  __/ |   | | | |\ V  V /|   <
//  |_|   |_|_| |_|\__,_|\___|_|   |_| |_| \_/\_/ |_|\_\
//
//  Created by _Finder丶Tiwk on 16/2/18.
//  Copyright © 2016年 _Finder丶Tiwk. All rights reserved.
//

#import "UIView+Corner.h"
#import <objc/runtime.h>

@implementation UIView (Corner)

- (CGFloat)xks_cornerRadius
{
    NSNumber *number = objc_getAssociatedObject(self,@selector(xks_cornerRadius));
    return [number floatValue];
}

- (void)setXks_cornerRadius:(CGFloat)xks_cornerRadius
{
    objc_setAssociatedObject(self, @selector(xks_cornerRadius), @(xks_cornerRadius),OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)xks_addCornerAtPostion:(UIRectCorner)postion
{
    CGFloat radius = (self.xks_cornerRadius>0)?self.xks_cornerRadius:6.f;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:postion cornerRadii:CGSizeMake(radius,radius)];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame         = self.bounds;
    maskLayer.path          = maskPath.CGPath;
    self.layer.mask         = maskLayer;
    [self.layer setMasksToBounds:YES];
}

@end
