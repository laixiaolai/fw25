//
//  FWBaseAppDelegate.h
//  CommonLibrary
//
//  Created by Alexi on 3/6/14.
//  Copyright (c) 2014 CommonLibrary. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FWBaseAppDelegate : UIResponder<UIApplicationDelegate>
{
@protected
    UIBackgroundTaskIdentifier _backgroundTaskIdentifier;
}

@property (strong, nonatomic) UIWindow *window;

+ (instancetype)sharedAppDelegate;

- (void)configAppLaunch;

// 进入登录界面
- (void)enterLoginUI;

// 进入主界面逻辑
- (void)enterMainUI;

// 代码中尽量改用以下方式去push/pop/present界面
- (UINavigationController *)navigationViewController;

- (UIViewController *)topViewController;

- (void)pushViewController:(UIViewController *)viewController;

- (NSArray *)popToViewController:(UIViewController *)viewController;

- (void)pushViewController:(UIViewController *)viewController withBackTitle:(NSString *)title;
//- (void)pushViewController:(UIViewController *)viewController withBackTitle:(NSString *)title backAction:(FWVoidBlock)action;

- (UIViewController *)popViewController;

- (NSArray *)popToRootViewController;

- (void)presentViewController:(UIViewController *)vc animated:(BOOL)animated completion:(void (^)())completion;

- (void)dismissViewController:(UIViewController *)vc animated:(BOOL)animated completion:(void (^)())completion;

@end
