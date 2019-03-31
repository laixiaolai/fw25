//
//  Plane2Controller.m
//  animatedemo
//
//  Created by 7yword on 16/7/11.
//  Copyright © 2016年 7yworld. All rights reserved.
//

#import "Plane2Controller.h"

#define a_duration    2.0f

@interface Plane2Controller ()

@property (weak, nonatomic) IBOutlet UIImageView *planeImgView;

@property (weak, nonatomic) IBOutlet UIImageView *y1;
@property (weak, nonatomic) IBOutlet UIImageView *y2;
@property (weak, nonatomic) IBOutlet UIImageView *y3;
@property (weak, nonatomic) IBOutlet UIImageView *y4;

@property (weak, nonatomic) IBOutlet UIView *moveable;

@end

@implementation Plane2Controller

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = kClearColor;
    
    _contrainerView.hidden = YES;
    [self.view bringSubviewToFront:_contrainerView];
    
    _senderNameLabel.textColor = kTextColorSenderName;
    _senderNameLabel.text = _senderNameStr;
    
    [self do_up:nil withView:_moveable];
    
    
    __weak typeof(self) weakSelf = self;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(a_duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        weakSelf.contrainerView.hidden = NO;
        [weakSelf do_move:_contrainerView];
        
    });
}

#pragma mark - 云朵上移

- (void)do_up:(NSLayoutConstraint *)constraint withView:(UIView *)view
{
    CABasicAnimation * moveAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    moveAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake([[UIScreen mainScreen] bounds].size.width / 2, [[UIScreen mainScreen] bounds].size.height / 2)];
    moveAnimation.duration = a_duration;
    moveAnimation.removedOnCompletion = NO;
    moveAnimation.repeatCount = 1;
    moveAnimation.fillMode = kCAFillModeForwards;
    [moveAnimation setValue:@"moveAnimation1" forKey:@"moveAnimation1"];
    [view.layer addAnimation:moveAnimation forKey:@"moveAnimation1"];
}

#pragma mark - 平移动画

- (void)do_move:(UIView *)view
{
    CABasicAnimation * moveAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    moveAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(kScreenW, 0)];
    moveAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake([[UIScreen mainScreen] bounds].size.width / 2.0f, [[UIScreen mainScreen] bounds].size.height / 2.0f)];
    moveAnimation.duration = 3.0f;
    moveAnimation.removedOnCompletion = NO;
    moveAnimation.repeatCount = 1;
    moveAnimation.delegate = self;
    moveAnimation.fillMode = kCAFillModeForwards;
    [moveAnimation setValue:@"moveAnimation" forKey:@"moveAnimation"];
    
    [view.layer addAnimation:moveAnimation forKey:@"moveAnimation"];
    
    _planeImgView.animationImages = @[[UIImage imageNamed:@"fw_gift_aircraft3"],[UIImage imageNamed:@"fw_gift_aircraft2"]];
    _planeImgView.animationDuration = 0.8f;
    _planeImgView.animationRepeatCount = INT_MAX;
    [_planeImgView startAnimating];
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
        
        if (_delegate && [_delegate respondsToSelector:@selector(plane2AnimationFinished)])
        {
            [_delegate plane2AnimationFinished];
            [self.view removeFromSuperview];
        }
    }
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
}

@end
