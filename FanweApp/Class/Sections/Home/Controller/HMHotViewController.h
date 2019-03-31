//
//  HMHotViewController.h
//  FanweApp
//
//  Created by xfg on 2017/7/5.
//  Copyright © 2017年 xfg. All rights reserved.
//  热门

#import "FWBaseViewController.h"

@protocol HMHotViewControllerDelegate <NSObject>
@required

- (void)goToMainPage:(NSString *)userID;

@end

@interface HMHotViewController : FWBaseViewController

@property (nonatomic, weak) id<HMHotViewControllerDelegate> delegate;

@property (nonatomic, strong) UITableView   *tableView;

@property (nonatomic, copy) NSString        *cate_id;       // 话题分类ID
@property (nonatomic, copy) NSString        *topicName;     // 话题名称
@property (nonatomic, copy) NSString        *sexString;     // 性别
@property (nonatomic, copy) NSString        *areaString;    // 地区

@property (nonatomic, assign) CGRect        tableViewFrame;

/**
 加载热门页数据

 @param page 页码
 */
- (void)loadDataFromNet:(int)page;

@end
