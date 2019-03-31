//
//  SusBaseWindow.m
//  FanweApp
//
//  Created by 岳克奎 on 16/9/24.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "SusBaseWindow.h"

@implementation SusBaseWindow

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.windowLevel = UIWindowLevelStatusBar - 2;
        [self addGesture];
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}

#pragma mark - 加手势
- (void)addGesture
{
    [self initTapGes];
    [self initPanGes];
}

#pragma amrk - Tap Ges
- (void)initTapGes
{
    _window_Tap_Ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesClick:)];
    [self addGestureRecognizer:_window_Tap_Ges];
}

- (void)tapGesClick:(UITapGestureRecognizer *)tap
{
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    
    // 关闭键盘
    [FWUtils closeKeyboard];
    
    if ([IQKeyboardManager sharedManager].keyboardShowing)
    {
        [FanweMessage alert:@"请先关闭键盘"];
        return;
    }
    
    if (SUS_WINDOW.reccordSusWidnowSale)
    {
        //tap
        if (_susBaseWindowTapGesBlock)
        {
            _susBaseWindowTapGesBlock();
        }
    }
}

#pragma mark - Pan Ges
- (void)initPanGes
{
    _window_Pan_Ges =[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGesClick:)];
    _window_Pan_Ges.delaysTouchesBegan = NO;
    [self addGestureRecognizer:_window_Pan_Ges];
}

- (void)panGesClick:(UIPanGestureRecognizer *)pan
{
    if (SUS_WINDOW.reccordSusWidnowSale)
    {
        if (_susBaseWindowPanGesBlock)
        {
            _susBaseWindowPanGesBlock();
        }
    }
}

#pragma mark- window 剪切 下角
- (void)setWindowCorner
{
    self.layer.cornerRadius = 8;
    self.layer.masksToBounds = YES;
}

- (void)setIsSusWindow:(BOOL)isSusWindow
{
    _isSusWindow = isSusWindow;
}

@end
