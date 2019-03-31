//
//  AppDelegate.h
//  FanweApp
//
//  Created by xfg on 16/4/12.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuspenionWindow.h"
#import "FWBaseAppDelegate.h"
#import "AFNetworking.h"
#import "FWLiveBaseController.h"
#import "FWTabBarController.h"
#import "FWNavigationController.h"

@interface AppDelegate : FWBaseAppDelegate

@property (nonatomic, strong) SuspenionWindow               *sus_window;

@property (nonatomic, assign) AFNetworkReachabilityStatus   reachabilityStatus;

@property (nonatomic, assign) BOOL                          isTabBarShouldLoginIMSDK;

@property (nonatomic, strong) FWNavigationController        *webViewNav;                // 需要我们重写get，去保存老的web页面，这样 好与H5交互

+ (instancetype)sharedAppDelegate;

- (void)entertabBar;

- (void)isShowHud:(BOOL)isShow hideTime:(float)hideTime;

- (void)hideHud;

- (void)beginEnterMianUI;

@end

