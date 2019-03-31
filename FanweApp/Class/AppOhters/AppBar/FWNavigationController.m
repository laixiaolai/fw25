//
//  FWNavigationController.m
//  FanweApp
//
//  Created by xfg on 2017/6/26.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "FWNavigationController.h"

@interface FWNavigationController ()

@end

@implementation FWNavigationController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
    if (self = [super initWithRootViewController:rootViewController])
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.view.backgroundColor = kWhiteColor;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavigationBarAppearance];
}

- (void)setNavigationBarAppearance
{
    [[UINavigationBar appearance] setBackgroundImage:[FWUtils imageWithColor:kNavBarThemeColor]  forBarMetrics:UIBarMetricsDefault];
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = kAppGrayColor1;     // 设置item颜色
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:16];  // 统一设置item字体大小
    [UINavigationBar appearance].titleTextAttributes=textAttrs;
}

@end
