//
//  CountDownView.h
//  FanweApp
//
//  Created by 岳克奎 on 16/11/28.
//  Copyright © 2016年 xfg. All rights reserved.
//  用用直播 开始 的倒计时

#import <UIKit/UIKit.h>

@interface CountDownView : UIView

@property (weak, nonatomic) IBOutlet UILabel    *numLab;//倒计时lab
@property (nonatomic, strong) dispatch_source_t timer;
@property (assign,nonatomic)int                  secondsCountDown;

// 加载一个倒计时View
+ (void)showCountDownViewInLiveVCwithFrame:(CGRect)rect inViewController:(UIViewController *)liveViewController  block:(void(^)(BOOL finished))block;

@end
