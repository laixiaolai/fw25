//
//  NewestViewController.h
//  FanweApp
//
//  Created by fanwe2014 on 16/7/4.
//  Copyright © 2016年 xfg. All rights reserved.
//
#import "FWNoContentView.h"

@class LivingModel;
@class cuserModel;

@protocol pushToLiveControllerDelegate <NSObject>

// 跳转到直播界面
- (void)pushToLiveController:(LivingModel *)model;
// 跳转到热门页
- (void)pushToNextControllerWithModel:(cuserModel *)model;

@end

@interface NewestViewController : FWBaseViewController

@property (nonatomic, weak) id<pushToLiveControllerDelegate>delegate;
@property (nonatomic, assign) CGRect collectionViewFrame;

/**
 无内容视图
 */
@property (nonatomic, strong) FWNoContentView *noContentViews;


- (void)loadDataWithPage:(int)page;

@end
