//
//  UIView+FWAnimation.m
//  FanweApp
//
//  Created by xfg on 2017/5/3.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "UIView+FWAnimation.h"
#import "FTUtils.h"
#import "FTUtils+NSObject.h"

@implementation UIView (FWAnimation)

- (void)animation:(CommonBlock)animationBlock duration:(NSTimeInterval)duration completion:(CommonBlock)completion
{
    if (animationBlock)
    {
        [self performBlock:animationBlock];
        
        if (completion)
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self performBlock:completion];
            });
        }
    }
}

@end
