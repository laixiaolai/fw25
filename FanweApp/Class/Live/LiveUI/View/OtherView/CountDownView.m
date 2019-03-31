//
//  CountDownView.m
//  FanweApp
//
//  Created by 岳克奎 on 16/11/28.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "CountDownView.h"

@implementation CountDownView

#pragma mark mark - init
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        // 因没实力化，子控件要在from nib 写
        // self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

#pragma mark mark -  set
- (void)setNumLab:(UILabel *)numLab
{
    _numLab = numLab;
}

#pragma mark mark -  show  CountDownView
//开启定时器，让lab不断的做动画。。如果count =0 那就销毁定时器

+ (void)showCountDownViewInLiveVCwithFrame:(CGRect)rect inViewController:(UIViewController *)liveViewController block:(void(^)(BOOL finished))block
{
    CountDownView * countdown_View = [[NSBundle mainBundle]loadNibNamed:@"CountDownView" owner:nil options:nil][0];
    [liveViewController.view addSubview:countdown_View];
    countdown_View.frame = rect;
    countdown_View.center = liveViewController.view.center;
    countdown_View.secondsCountDown = 4;
    // 获得队列
    dispatch_queue_t queue =dispatch_get_main_queue();
    // 创建一个定时器(dispatch_source_t本质还是个OC对象)
    countdown_View.timer =dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER,0, 0, queue);
    dispatch_time_t start =dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC));
    uint64_t interval = (uint64_t)(1.0 *NSEC_PER_SEC);
    dispatch_source_set_timer(countdown_View.timer , start, interval,0);
    // 设置回调
    dispatch_source_set_event_handler(countdown_View.timer, ^{
        
        countdown_View.secondsCountDown--;
        countdown_View.numLab.text = [NSString stringWithFormat:@"%d",countdown_View.secondsCountDown];
        
        //加载动画
        countdown_View.transform = CGAffineTransformScale(CGAffineTransformIdentity, CGFLOAT_MIN, CGFLOAT_MIN);
        [UIView animateWithDuration:1.0
                         animations:^{
                             countdown_View.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
                         }
                         completion:^(BOOL finished) {
                             
                         }];
        if (countdown_View.secondsCountDown == 1)
        {
            // 取消定时器
            dispatch_cancel(countdown_View.timer);
            countdown_View.timer = nil;
            // countdown_View.numLab.text = @"GO!";
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [countdown_View removeFromSuperview];
                if(block)
                {
                    block(YES);
                }
            });
            
            
        }
    });
    // 启动定时器
    dispatch_resume(countdown_View.timer);
}

@end
