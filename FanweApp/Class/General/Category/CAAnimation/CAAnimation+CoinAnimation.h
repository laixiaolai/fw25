//
//  CAAnimation+CoinAnimation.h
//  FanweApp
//
//  Created by yy on 17/1/6.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CAAnimation (CoinAnimation)

/** 
 *  抖动动画
 */
+ (CAKeyframeAnimation *)jitterAnimation;

/**
 *  呼吸灯动画
 *
 *  @param  time        动画时间
 *  @param  fromValue   开始透明度
 *  @param  toValue     结束透明度
 */
+ (CABasicAnimation *)AlphaLight:(float)time fromValue:(float)fromValue toValue:(float)toValue;

/**
 *  先移动后缩小动画
 *  
 *  @param  begin               移动开始的位置
 *  @param  end                 移动结束的位置
 *  @param  moveTime            移动的时间
 *  @param  narrowTime          缩小的时间
 *  @param  narrowFromValue     缩小开始倍率
 *  #param  narrowToValue       缩小结束倍率
 *  @return CAAnimationGroup    动画组
 */
+ (CAAnimationGroup *)coinMoveAntimationWithBegin:(CGPoint)begin WithEnd:(CGPoint)end andMoveTime:(CGFloat)moveTime andNarrowTime:(CGFloat)narrowTime andNarrowFromValue:(CGFloat)narrowFromValue andNarrowToValue:(CGFloat)narrowToValue;

@end
