//
//  RocketViewController.m
//  animatedemo
//
//  Created by 7yword on 16/7/13.
//  Copyright © 2016年 7yworld. All rights reserved.
//

#import "RocketViewController.h"

@interface RocketViewController (){
    
    NSTimer * timer;
    
    int cc;
}

@property (weak, nonatomic) IBOutlet UIView *rocketContrainerView;
@property (weak, nonatomic) IBOutlet UIImageView *rocketImgView;
@property (weak, nonatomic) IBOutlet UIImageView *effect;

@property (weak, nonatomic) IBOutlet UILabel *count;

@end

@implementation RocketViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = kClearColor;
    
    _senderNameLabel.textColor = kTextColorSenderName;
    _senderNameLabel.text = _senderNameStr;
    
    _rocketContrainerView.hidden = YES;
    
    _count.textColor = [UIColor colorWithRed:238 / 255.0f green:201 / 255.0f blue:0 alpha:1.0];
    
    cc = 3;
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(count_1:) userInfo:nil repeats:YES];
}

- (void)count_1:(id)sender
{
    if(cc > 0)
    {
        _count.text = [NSString stringWithFormat:@"%i",cc];
        
        CABasicAnimation * scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnimation.fromValue = [NSNumber numberWithFloat:3.0f];
        scaleAnimation.toValue = [NSNumber numberWithFloat:0.3f];
        scaleAnimation.duration = 1.0f;
        scaleAnimation.removedOnCompletion = YES;
        scaleAnimation.repeatCount = 1;
        scaleAnimation.delegate = self;
        [scaleAnimation setValue:@"scaleAnimation" forKey:@"scaleAnimation"];
        [_count.layer addAnimation:scaleAnimation forKey:@"scaleAnimation"];
        
        cc--;
    }
    else
    {
        [timer invalidate];
        timer = nil;
        
        _rocketContrainerView.hidden = NO;
        
        [self do_move:_rocketContrainerView];
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    __weak typeof(self) weakSelf = self;
    
    if ([[anim valueForKey:@"moveAnimation"] isEqualToString:@"moveAnimation"])
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [weakSelf do_effect:_effect];
            
            CABasicAnimation * moveAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
            moveAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake([[UIScreen mainScreen] bounds].size.width / 2.0f, -50)];
            moveAnimation.duration = 3.0f;
            moveAnimation.removedOnCompletion = NO;
            moveAnimation.fillMode = kCAFillModeForwards;
            moveAnimation.repeatCount = 1;
            moveAnimation.delegate = self;
            [moveAnimation setValue:@"moveAnimation1" forKey:@"moveAnimation1"];
            [weakSelf.rocketContrainerView.layer addAnimation:moveAnimation forKey:@"moveAnimation1"];
            
        });
    }
    else if([[anim valueForKey:@"scaleAnimation"] isEqualToString:@"scaleAnimation"] && cc == 0)
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            weakSelf.count.hidden = YES;
            
        });
    }
    else if ([[anim valueForKey:@"moveAnimation1"] isEqualToString:@"moveAnimation1"])
    {
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(rocketAnimationFinished)])
        {
            [weakSelf.delegate rocketAnimationFinished];
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
    
    _rocketImgView.animationImages = @[[UIImage imageNamed:@"fw_gift_rocket3"],[UIImage imageNamed:@"fw_gift_rocket2"]];
    _rocketImgView.animationDuration = 0.8f;
    _rocketImgView.animationRepeatCount = INT_MAX;
    [_rocketImgView startAnimating];
}

- (void)do_effect:(UIImageView *)view
{
    CABasicAnimation * alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    alphaAnimation.duration = 1.0f;
    alphaAnimation.removedOnCompletion = NO;
    alphaAnimation.repeatCount = 1;
    alphaAnimation.autoreverses = YES;
    alphaAnimation.fillMode = kCAFillModeForwards;
    [alphaAnimation setValue:@"alphaAnimation" forKey:@"alphaAnimation"];
    
    [view.layer addAnimation:alphaAnimation forKey:@"alphaAnimation"];
    
    /*
     CABasicAnimation * alphaAnimation1 = [CABasicAnimation animationWithKeyPath:@"scale"];
     alphaAnimation1.toValue = [NSNumber numberWithFloat:2.0f];
     //    alphaAnimation1.duration = 3.0f;
     alphaAnimation1.removedOnCompletion = NO;
     alphaAnimation1.repeatCount = 1;
     alphaAnimation1.autoreverses = YES;
     alphaAnimation1.fillMode = kCAFillModeForwards;
     [alphaAnimation1 setValue:@"alphaAnimation1" forKey:@"alphaAnimation1"];
     
     //    CABasicAnimation * alphaAnimation2 = [CABasicAnimation animationWithKeyPath:@"opacity"];
     //    alphaAnimation2.toValue = [NSNumber numberWithFloat:1.0f];
     //    alphaAnimation2.duration = 3.0f;
     //    alphaAnimation2.removedOnCompletion = NO;
     //    alphaAnimation2.repeatCount = 1;
     //    alphaAnimation2.autoreverses = YES;
     //    alphaAnimation2.fillMode = kCAFillModeForwards;
     //    [alphaAnimation2 setValue:@"alphaAnimation2" forKey:@"alphaAnimation2"];
     
     CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
     animationGroup.duration = 3;
     animationGroup.autoreverses = YES;
     animationGroup.repeatCount = 1;
     animationGroup.animations =[NSArray arrayWithObjects:alphaAnimation, alphaAnimation1, nil];
     [view.layer addAnimation:animationGroup forKey:@"animationGroup"];
     
     
     //    [view.layer addAnimation:alphaAnimation forKey:@"alphaAnimation"];
     
     */
}

- (void) shakeToShow:(UIView*)aView
{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.5;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [aView.layer addAnimation:animation forKey:nil];
}

@end
