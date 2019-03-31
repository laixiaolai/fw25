//
//  LambohiniViewController.m
//  animatedemo
//
//  Created by 7yword on 16/7/13.
//  Copyright © 2016年 7yworld. All rights reserved.
//

#import "LambohiniViewController.h"

@interface LambohiniViewController ()

@property (weak, nonatomic) IBOutlet UIView *car_body;
@property (weak, nonatomic) IBOutlet UIImageView *front;
@property (weak, nonatomic) IBOutlet UIImageView *body;

@end

@implementation LambohiniViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = kClearColor;
    
    _senderNameLabel.textColor = kTextColorSenderName;
    _senderNameLabel.text = _senderNameStr;
    
    [_car_body bringSubviewToFront:_body];
    
    [self do_rotation:_front];
    
    [self do_move:_car_body];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    NSString * value = [anim valueForKey:@"moveAnimation"];
    
    if ([value isEqualToString:@"moveAnimation"])
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            CABasicAnimation * moveAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
            moveAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake([[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height + 50)];
            moveAnimation.duration = 3.0f;
            moveAnimation.removedOnCompletion = NO;
            moveAnimation.fillMode = kCAFillModeForwards;
            moveAnimation.repeatCount = 1;
            moveAnimation.delegate = self;
            [moveAnimation setValue:@"moveAnimation1" forKey:@"moveAnimation1"];
            [_car_body.layer addAnimation:moveAnimation forKey:@"moveAnimation1"];
            
        });
    }
    else if([[anim valueForKey:@"moveAnimation1"] isEqualToString:@"moveAnimation1"])
    {
        [_car_body setHidden:YES];
        if (_delegate && [_delegate respondsToSelector:@selector(lambohiniAnimationFinished)])
        {
            [_delegate lambohiniAnimationFinished];
            [self.view removeFromSuperview];
        }
    }
}

#pragma mark - 平移动画
- (void)do_move:(UIView *)view
{
    CABasicAnimation * moveAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    moveAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake([[UIScreen mainScreen] bounds].size.width / 2.0f, [[UIScreen mainScreen] bounds].size.height / 2.0f)];
    moveAnimation.duration = 3.0f;
    moveAnimation.removedOnCompletion = NO;
    moveAnimation.repeatCount = 1;
    moveAnimation.delegate = self;
    moveAnimation.fillMode = kCAFillModeForwards;
    [moveAnimation setValue:@"moveAnimation" forKey:@"moveAnimation"];
    
    [view.layer addAnimation:moveAnimation forKey:@"moveAnimation"];
}

#pragma mark - 旋转动画
- (void)do_rotation:(UIView *)view
{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 1.0];
    rotationAnimation.duration = 0.3f;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = INT_MAX;
    
    [view.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

@end
