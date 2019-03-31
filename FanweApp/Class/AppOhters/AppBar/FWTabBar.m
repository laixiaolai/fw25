//
//  FWTabBar.m
//  FanweApp
//
//  Created by xfg on 2017/6/26.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "FWTabBar.h"

@interface FWTabBar()

@property (nonatomic, weak) UIButton *centerBtn;

@end

@implementation FWTabBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setupInit];
    }
    return self;
}

- (void)setupInit
{
    if (!isIPhoneX())
    {
        // 设置样式 取出边线
        self.barStyle = UIBarStyleBlack;
        self.backgroundImage = [UIImage imageNamed:@"ic_tab_bg"];
    }
    else
    {
        self.backgroundColor = [UIColor whiteColor];
        self.tintColor = [UIColor whiteColor];
        self.translucent = NO;
    }
}

- (void)centerButtonClicked
{
    if (self.centerBtnClickBlock)
    {
        self.centerBtnClickBlock();
    }
}

#pragma mark 布局子控件
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NSInteger count = self.items.count;
    
    //确定单个控件大小
    CGFloat buttonW = self.frame.size.width / (count + 1);
    CGFloat buttonH = 49;
    CGFloat tabBarBtnY = 0;
    
    int tabBarBtnIndex = 0;
    for (UIView *subView in self.subviews)
    {
        if ([subView isKindOfClass:NSClassFromString(@"UITabBarButton")])
        {
            if (tabBarBtnIndex == count / 2)
            {
                tabBarBtnIndex ++;
            }
            CGFloat btnX = tabBarBtnIndex * buttonW;
            subView.frame = CGRectMake(btnX, tabBarBtnY, buttonW, buttonH);
            
            tabBarBtnIndex ++;
            
            UIControl *tabBarBtn = (UIControl *)subView;
            [tabBarBtn addTarget:self action:@selector(tabBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    /****    设置中间按钮frame   ****/
    self.centerBtn.centerX = self.width * 0.5;
#if kSupportH5Shopping
    self.centerBtn.y = buttonH - self.centerBtn.height;
#else
    self.centerBtn.y = buttonH - self.centerBtn.height;
#endif
}

#pragma mark 动画
- (void)tabBarButtonClick:(UIControl *)tabBarButton
{
    for (UIView *imageView in tabBarButton.subviews)
    {
        if ([imageView isKindOfClass:NSClassFromString(@"UITabBarSwappableImageView")])
        {
            // 需要实现的帧动画,这里根据需求自定义
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
            animation.keyPath = @"transform.scale";
            // @1.0,@1.3,@0.9,@1.15,@0.95,@1.02,@1.0
            animation.values = @[@1.0,@1.25,@0.9,@1.15,@1.0];
            animation.duration = 0.4;
            animation.calculationMode = kCAAnimationCubic;
            // 把动画添加上去就OK了
            [imageView.layer addAnimation:animation forKey:nil];
        }
    }
}

#pragma mark 设置允许交互的区域     方法返回的view为处理事件最合适的view
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *view = [super hitTest:point withEvent:event];
    if (!self.isHidden)
    {
        //转换坐标到中间按钮,生成一个新的点
        CGPoint pointInCenterBtn = [self convertPoint:point toView:self.centerBtn];
        //判断  如果该点是在中间按钮,那么处理事件最合适的View,就是这个button
        if ([self.centerBtn pointInside:pointInCenterBtn withEvent:event])
        {
            return self.centerBtn;
        }
        return view;
    }
    return view;
}

#pragma mark - lazy
- (UIButton *)centerBtn
{
    if (!_centerBtn)
    {
        UIButton *centerButton = [UIButton buttonWithType:UIButtonTypeCustom];
#if kSupportH5Shopping
        [centerButton setImage:[UIImage imageNamed:@"ic_H5_tab_live"] forState:UIControlStateNormal];
        [centerButton setImage:[UIImage imageNamed:@"ic_H5_tab_live"] forState:UIControlStateHighlighted];
#else
        [centerButton setImage:[UIImage imageNamed:@"ic_live_tab_create_live_normal"] forState:UIControlStateNormal];
        [centerButton setImage:[UIImage imageNamed:@"ic_live_tab_create_live_normal"] forState:UIControlStateHighlighted];
#endif
        [centerButton addTarget:self action:@selector(centerButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [centerButton sizeToFit];
        [self addSubview:centerButton];
        _centerBtn = centerButton;
    }
    return _centerBtn;
}

@end
