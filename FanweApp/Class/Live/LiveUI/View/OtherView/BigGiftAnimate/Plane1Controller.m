//
//  Plane1Controller.m
//  animatedemo
//
//  Created by 7yword on 16/7/11.
//  Copyright © 2016年 7yworld. All rights reserved.
//

#import "Plane1Controller.h"

#define a_duration    2.0f

@interface Plane1Controller ()

@property (weak, nonatomic) IBOutlet UIView *contrainerView;

@property (weak, nonatomic) IBOutlet UIImageView *wing1;
@property (weak, nonatomic) IBOutlet UIImageView *wing2;
@property (weak, nonatomic) IBOutlet UIImageView *wing3;
@property (weak, nonatomic) IBOutlet UIImageView *wing4;

@end

@implementation Plane1Controller

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = kClearColor;
    
    _contrainerView.hidden = YES;
    [self.view bringSubviewToFront:_contrainerView];
    
    _senderNameLabel.textColor = kTextColorSenderName;
    _senderNameLabel.text = _senderNameStr;
    
    [self do_rotation:_wing1];
    [self do_rotation:_wing2];
    [self do_rotation:_wing3];
    [self do_rotation:_wing4];
    
    __weak typeof(self) weakSelf = self;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(a_duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        weakSelf.contrainerView.hidden = NO;
        [weakSelf do_move:_contrainerView];
        
    });
}

#pragma mark - 旋转动画
- (void)do_rotation:(UIView *)view
{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 1.0];
    rotationAnimation.duration = 0.2f;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = INT_MAX;
    
    [view.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

#pragma mark - 平移动画
- (void)do_move:(UIView *)view
{
    CABasicAnimation * moveAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    moveAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(kScreenW, 0)];
    moveAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(kScreenW / 2.0f, kScreenH / 2.0f)];
    moveAnimation.duration = 3.0f;
    moveAnimation.removedOnCompletion = NO;
    moveAnimation.repeatCount = 1;
    moveAnimation.delegate = self;
    moveAnimation.fillMode = kCAFillModeForwards;
    [moveAnimation setValue:@"moveAnimation" forKey:@"moveAnimation"];
    
    [view.layer addAnimation:moveAnimation forKey:@"moveAnimation"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    NSString * value = [anim valueForKey:@"moveAnimation"];
    
    if ([value isEqualToString:@"moveAnimation"])
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            CABasicAnimation * moveAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
            moveAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(0, [[UIScreen mainScreen] bounds].size.height + 50)];
            moveAnimation.duration = 3.0f;
            moveAnimation.removedOnCompletion = NO;
            moveAnimation.repeatCount = 1;
            moveAnimation.delegate = self;
            moveAnimation.fillMode = kCAFillModeForwards;
            [moveAnimation setValue:@"moveAnimation1" forKey:@"moveAnimation1"];
            [_contrainerView.layer addAnimation:moveAnimation forKey:@"moveAnimation1"];
            
        });
    }
    else if([[anim valueForKey:@"moveAnimation1"] isEqualToString:@"moveAnimation1"])
    {
        [_contrainerView setHidden:YES];
        
        if (_delegate && [_delegate respondsToSelector:@selector(plane1AnimationFinished)])
        {
            [_delegate plane1AnimationFinished];
            [self.view removeFromSuperview];
        }
    }
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
}

@end
