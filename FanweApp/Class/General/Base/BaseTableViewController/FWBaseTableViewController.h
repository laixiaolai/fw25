//
//  FWBaseTableViewController.h
//  FanweApp
//
//  Created by xfg on 2017/7/5.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const cellReuseIdentifier = @"cellReuseIdentifier";

@interface FWBaseTableViewController : UITableViewController

/**
 网络请求
 */
@property (nonatomic, strong) NetHttpsManager *httpsManager;

/**
 全局参数控制
 */
@property (nonatomic, strong) GlobalVariables *fanweApp;

/**
 指示器
 */
@property (nonatomic, strong) MBProgressHUD   *proHud;

/**
 当前类主要数据列表
 */
@property (nonatomic, strong) NSMutableArray *mainDataMArray;

/**
 当前页数
 */
@property (nonatomic, assign) int       currentPage;

/**
 总页数
 */
@property (nonatomic, assign) int       totalPage;

/**
 左上角返回按钮
 
 @param backBlock 点击返回按钮的回调，若nil则默认调用 [self.navigationController popViewControllerAnimated:YES]
 */
- (void)setupBackBtnWithBlock:(BackBlock)backBlock;

/**
 点击了返回按钮
 */
- (void)onReturnBtnPress;

/**
 显示指示器
 */
- (void)showMyHud;

/**
 隐藏指示器
 */
- (void)hideMyHud;


#pragma mark - 供子类重写

/**
 初始化变量
 */
- (void)initFWVariables NS_REQUIRES_SUPER;

/**
 UI创建
 */
- (void)initFWUI NS_REQUIRES_SUPER;

/**
 加载数据
 */
- (void)initFWData NS_REQUIRES_SUPER;

@end