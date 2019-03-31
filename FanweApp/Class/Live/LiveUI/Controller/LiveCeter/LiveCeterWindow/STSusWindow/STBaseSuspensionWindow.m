//
//  STBaseSuspensionWindow.m
//  FanweApp
//
//  Created by 岳克奎 on 17/1/18.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "STBaseSuspensionWindow.h"

@implementation STBaseSuspensionWindow

#pragma mark -tap手势

- (UITapGestureRecognizer *)tapGestureRecognizer
{
    if (!_tapGestureRecognizer)
    {
        _tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureRecognizerClick:)];
        [self addGestureRecognizer:_tapGestureRecognizer];
    }
    return _tapGestureRecognizer;
}

//基础悬浮widnow的等级
- (void)setStSuspensionWindowLevelValue:(CGFloat)stSuspensionWindowLevelValue
{
    _stSuspensionWindowLevelValue = stSuspensionWindowLevelValue;
}

#pragma mark ------------------------------------------- private methods
//tap子重写
- (void)tapGestureRecognizerClick:(UITapGestureRecognizer *)tapGestureRecognizer
{
    
}

//pan 子重写
- (void)panGestureRecognizerClick:(UIPanGestureRecognizer *)panGestureRecognizer
{
    
}

- (void)showPanClickForSTWindowOfPoint:(CGPoint)panPoint andMovePoint:(CGPoint)movePoint
{
    self.transform = CGAffineTransformTranslate( self.transform, movePoint.x, movePoint.y);
    [self.panGestureRecognizer setTranslation:CGPointZero inView:self];
    
    if (self.panGestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
    }
    
    if (self.panGestureRecognizer.state == UIGestureRecognizerStateChanged)
    {
    }
    
    if (self.panGestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        if(self.x<0)
        {
            [UIView animateWithDuration:0.2 animations:^{
                self.x = 0;
            } completion:^(BOOL finished) {
                
            }];
        }
        if(self.frame.origin.y<0)
        {
            [UIView animateWithDuration:0.2 animations:^{
                self.y = 0;
            } completion:^(BOOL finished) {
                
            }];
        }
        if(self.frame.origin.y> kScreenH-0.6*kScreenW)
        {
            [UIView animateWithDuration:0.2 animations:^{
                self.y = kScreenH-0.6*kScreenW;
            } completion:^(BOOL finished) {
                
            }];
            
        }
        if(self.x>kScreenW-0.4*kScreenW)
        {
            [UIView animateWithDuration:0.2 animations:^{
                self.x = kScreenW-0.4*kScreenW;
            } completion:^(BOOL finished) {
                
            }];
            
        }
    }
}

@end
