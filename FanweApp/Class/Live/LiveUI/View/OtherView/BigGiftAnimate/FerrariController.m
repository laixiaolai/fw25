//
//  FerrariController.m
//  animatedemo
//
//  Created by 7yword on 16/7/13.
//  Copyright © 2016年 7yworld. All rights reserved.
//

#import "FerrariController.h"

@interface FerrariController ()

@property (weak, nonatomic) IBOutlet UIView *car_body;
@property (weak, nonatomic) IBOutlet UIImageView *front;
@property (weak, nonatomic) IBOutlet UIImageView *back;


@property (weak, nonatomic) IBOutlet UIView *back_car_view;
@property (weak, nonatomic) IBOutlet UIImageView *back_back;
@property (weak, nonatomic) IBOutlet UIImageView *back_front;
@property (weak, nonatomic) IBOutlet UIImageView *back_body;


@end

@implementation FerrariController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = kClearColor;
    
    _senderNameLabel1.textColor = kTextColorSenderName;
    _senderNameLabel2.textColor = kTextColorSenderName;
    
    _senderNameLabel1.text = _senderNameStr1;
    _senderNameLabel2.text = _senderNameStr2;
    
    [_back_car_view bringSubviewToFront:_back_body];
    [_back_car_view setHidden:YES];
    
    [self do_rotation:_front];
    [self do_rotation:_back];
    
    [self do_move:_car_body];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    NSString * value = [anim valueForKey:@"moveAnimation"];
    
    if ([value isEqualToString:@"moveAnimation"])
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            CABasicAnimation * moveAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
            moveAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(0, [[UIScreen mainScreen] bounds].size.height + 50)];
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
        [_back_car_view setHidden:NO];
        
        CABasicAnimation* rotationAnimation1;
        rotationAnimation1 = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation1.toValue = [NSNumber numberWithFloat: M_PI * 1.0];
        rotationAnimation1.duration = 0.2f;
        rotationAnimation1.cumulative = YES;
        rotationAnimation1.repeatCount = INT_MAX;
        [_back_front.layer addAnimation:rotationAnimation1 forKey:@"rotationAnimation"];
        
        CABasicAnimation* rotationAnimation2;
        rotationAnimation2 = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation2.toValue = [NSNumber numberWithFloat: M_PI * 1.0];
        rotationAnimation2.duration = 0.2f;
        rotationAnimation2.cumulative = YES;
        rotationAnimation2.repeatCount = INT_MAX;
        [_back_back.layer addAnimation:rotationAnimation2 forKey:@"rotationAnimation"];
        
//        _back_back.animationImages = @[[UIImage imageNamed:@"fw_gift_ferrari_tyre2"],[UIImage imageNamed:@"fw_gift_ferrari_tyre2_2"],[UIImage imageNamed:@"fw_gift_ferrari_tyre2_3"],[UIImage imageNamed:@"fw_gift_ferrari_tyre2_4"],[UIImage imageNamed:@"fw_gift_ferrari_tyre2_5"],[UIImage imageNamed:@"fw_gift_ferrari_tyre2_6"],[UIImage imageNamed:@"fw_gift_ferrari_tyre2_7"],[UIImage imageNamed:@"fw_gift_ferrari_tyre2_8"]];
//        _back_back.animationDuration = 0.5f;
//        _back_back.animationRepeatCount = INT_MAX;
//        [_back_back startAnimating];

        CABasicAnimation * moveAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
        moveAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake([[UIScreen mainScreen] bounds].size.width, -50)];
        moveAnimation.duration = 3.0f;
        moveAnimation.removedOnCompletion = NO;
        moveAnimation.repeatCount = 1;
        moveAnimation.fillMode = kCAFillModeForwards;
        moveAnimation.delegate = self;
        [moveAnimation setValue:@"moveAnimation2" forKey:@"moveAnimation2"];
        
        [_back_car_view.layer addAnimation:moveAnimation forKey:@"moveAnimation2"];
    }
    else if([[anim valueForKey:@"moveAnimation2"] isEqualToString:@"moveAnimation2"])
    {
        if (_delegate && [_delegate respondsToSelector:@selector(ferrariAnimationFinished)])
        {
            [_delegate ferrariAnimationFinished];
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
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * -1.0];
    rotationAnimation.duration = 0.2f;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = INT_MAX;
    
    [view.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

@end
