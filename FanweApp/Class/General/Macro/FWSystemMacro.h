//
//  FWSystemMacro.h
//  FanweApp
//
//  Created by xfg on 16/8/3.
//  Copyright © 2016年 xfg. All rights reserved.
//  系统宏

#ifndef FWSystemMacro_h
#define FWSystemMacro_h

#import "GlobalVariables.h"

// 屏幕frame,bounds,size,scale
#define kScreenFrame            [UIScreen mainScreen].bounds
#define kScreenBounds           [UIScreen mainScreen].bounds
#define kScreenSize             [UIScreen mainScreen].bounds.size
#define kScreenScale            [UIScreen mainScreen].scale
#define kScreenW                [[UIScreen mainScreen] bounds].size.width
#define kScreenH                [[UIScreen mainScreen] bounds].size.height
#define kScaleW                 (kScreenW)*(kScreenScale)
#define kScaleH                 (kScreenH)*(kScreenScale)

#define kScaleWidth             [[UIScreen mainScreen] bounds].size.width/375.00
#define kScaleHeight            [[UIScreen mainScreen] bounds].size.height/667.00

// 主窗口的宽、高
#define kMainScreenWidth        MainScreenWidth()
#define kMainScreenHeight       MainScreenHeight()
static __inline__ CGFloat MainScreenWidth()
{
    return UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation) ? [UIScreen mainScreen].bounds.size.width : [UIScreen mainScreen].bounds.size.height;
}

static __inline__ CGFloat MainScreenHeight()
{
    return UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation) ? [UIScreen mainScreen].bounds.size.height : [UIScreen mainScreen].bounds.size.width;
}

// 状态栏、导航栏、标签栏高度
#define kStatusBarHeight        ([UIApplication sharedApplication].statusBarFrame.size.height)
#define kNavigationBarHeight    ([GlobalVariables sharedInstance].appNavigationBarHeight ? : self.navigationController.navigationBar.frame.size.height)
#define kTabBarHeight           ([GlobalVariables sharedInstance].appTabBarHeight ? : self.tabBarController.tabBar.frame.size.height)

#define scale_hight1            kScreenH < 600 ? 50 : 55
#define scale_hight             kScreenH > 667 ? 60 : scale_hight1

// 当前所在window
#define kCurrentWindow          [AppDelegate sharedAppDelegate].sus_window.rootViewController ? [AppDelegate sharedAppDelegate].sus_window : [AppDelegate sharedAppDelegate].window

//// 当前系统版本号
//#define kCurrentVersionNum      [UIDevice currentDevice].systemVersion.doubleValue

#endif /* FWSystemMacro_h */
