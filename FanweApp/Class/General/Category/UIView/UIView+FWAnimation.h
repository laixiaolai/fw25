//
//  UIView+FWAnimation.h
//  FanweApp
//
//  Created by xfg on 2017/5/3.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "FTAnimationManager.h"
#import "NSObject+CommonBlock.h"

/**
 This category provides extra methods on `UIView` which make it very easy to use
 the FTAnimationManager pre-built animations.
*/
@interface UIView (FWAnimation)

- (void)animation:(CommonBlock)animationBlock duration:(NSTimeInterval)duration completion:(CommonBlock)block;

@end
