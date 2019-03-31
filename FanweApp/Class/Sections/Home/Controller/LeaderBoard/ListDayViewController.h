//
//  ListDayViewController.h
//  FanweApp
//
//  Created by ycp on 16/10/14.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ListDayViewControllerDelegate <NSObject>

- (void)pushToHomePage:(UserModel *)model;

@end

@interface ListDayViewController : FWBaseViewController

@property (assign, nonatomic) BOOL                               isHiddenTabbar;
@property ( nonatomic,weak) id<ListDayViewControllerDelegate>    delegate;
@property ( nonatomic,assign) int                                type;      //功德榜：日榜（1）,月榜(2),总榜(3)  贡献榜: 日榜（4），月榜（5),总榜(6)
@property ( nonatomic,copy) NSString                             *hostLiveId;//主播id

@end
