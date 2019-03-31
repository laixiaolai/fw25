//
//  CAAnimation+CoinAnimation.m
//  FanweApp
//
//  Created by yy on 17/1/6.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "CAAnimation+CoinAnimation.h"

@implementation CAAnimation (CoinAnimation)

+ (CAKeyframeAnimation *)jitterAnimation
{
    //缩小
    CAKeyframeAnimation* jitterAnimation    = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    jitterAnimation.duration                = 0.5;
    NSArray *values                         = @[
                                                [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.6, 0.6, 1.0)],
                                                [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)],
                                                [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)],
                                                [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]
                                                ];
    jitterAnimation.values                  = values;
    jitterAnimation.removedOnCompletion     = YES;
    
    return jitterAnimation;
}

+ (CABasicAnimation *) AlphaLight:(float)time fromValue:(float)fromValue toValue:(float)toValue
{
    CABasicAnimation *animation     = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue             = [NSNumber numberWithFloat:fromValue];
    animation.toValue               = [NSNumber numberWithFloat:toValue];                   //这是透明度。
    animation.autoreverses          = YES;
    animation.duration              = time;
    animation.repeatCount           = MAXFLOAT;
    animation.removedOnCompletion   = NO;
    animation.fillMode              = kCAFillModeForwards;
    animation.timingFunction        = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    return animation;
}

+ (CAAnimationGroup *)coinMoveAntimationWithBegin:(CGPoint)begin WithEnd:(CGPoint)end andMoveTime:(CGFloat)moveTime andNarrowTime:(CGFloat)narrowTime andNarrowFromValue:(CGFloat)narrowFromValue andNarrowToValue:(CGFloat)narrowToValue
{
    //移动
    CAKeyframeAnimation *moveAnimation  = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    moveAnimation.values                = @[
                                            [NSValue valueWithCGPoint:begin],
                                            [NSValue valueWithCGPoint:end]
                                            ];
    moveAnimation.fillMode              = kCAFillModeForwards;
    moveAnimation.removedOnCompletion   = NO;
    moveAnimation.duration              = moveTime;
    //缩小
    CABasicAnimation *narrowAnimation   = [CABasicAnimation animationWithKeyPath:@"transform.scale"]; ;
    narrowAnimation.fromValue           = [NSNumber numberWithFloat:narrowFromValue];       // 开始时的倍率
    narrowAnimation.toValue             = [NSNumber numberWithFloat:narrowToValue];         // 结束时的倍率
    narrowAnimation.duration            = narrowTime;
    narrowAnimation.fillMode            = kCAFillModeForwards;
    narrowAnimation.removedOnCompletion = NO;
    narrowAnimation.beginTime           = moveTime;
    
    CAAnimationGroup *groupAntimation   = [CAAnimationGroup animation];
    groupAntimation.animations          = @[moveAnimation,narrowAnimation];
    groupAntimation.duration            = moveTime + narrowTime;
    groupAntimation.fillMode            = kCAFillModeForwards;
    groupAntimation.removedOnCompletion = NO;
    [groupAntimation setValue:@"moveGroupAnimation"
                       forKey:@"moveGroupAnimation"];

    return groupAntimation;
}

@end
