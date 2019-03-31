//
//  STBaseSuspensionWindow.h
//  FanweApp
//
//  Created by 岳克奎 on 17/1/18.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STBaseSuspensionWindow : UIWindow

@property (strong,nonatomic)UITapGestureRecognizer  *tapGestureRecognizer;  //tap手势
@property (strong,nonatomic)UIPanGestureRecognizer  *panGestureRecognizer;  //pan手势

@property (assign,nonatomic)CGFloat                 stSuspensionWindowLevelValue;//基础悬浮widnow的等级

- (void)showPanClickForSTWindowOfPoint:(CGPoint)panPoint andMovePoint:(CGPoint)movePoint;

@end
