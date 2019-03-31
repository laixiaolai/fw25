//
//  FWBaseViewController.m
//  FanweLive
//
//  Created by xfg on 16/11/25.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "FWBaseViewController.h"

@interface FWBaseViewController ()

@property (nonatomic, copy) BackBlock backBlock;

@end

@implementation FWBaseViewController

- (void)dealloc
{
    NSLog(@"dealloc %@", [self description]);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self hideMyHud];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 指定边缘要延伸的方向，子类有其他需求时记得重写该属性
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
    // 1、初始化变量
    [self initFWVariables];
    // 2、UI创建
    [self initFWUI];
    // 3、加载数据
    [self initFWData];
}


#pragma mark - ----------------------- 供子类重写 -----------------------

#pragma mark 初始化变量
- (void)initFWVariables
{
    // 子类重写
}

#pragma mark UI创建
- (void)initFWUI
{
    // 子类重写
}

#pragma mark 加载数据
- (void)initFWData
{
    // 子类重写
}


#pragma mark - ----------------------- 返回按钮、事件 -----------------------

- (void)setupBackBtnWithBlock:(BackBlock)backBlock
{
    self.backBlock = backBlock;
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(onReturnBtnPress) image:@"com_arrow_vc_back" highImage:@"com_arrow_vc_back"];
}

#pragma mark - 返回上一级
- (void)onReturnBtnPress
{
    if (self.backBlock)
    {
        self.backBlock();
    }
    else
    {
        [self.navigationController popViewControllerAnimated:NO];
    }
}


#pragma mark - ----------------------- 指示器 -----------------------

#pragma mark - HUD
- (MBProgressHUD *)proHud
{
    if (!_proHud)
    {
        _proHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        _proHud.mode = MBProgressHUDModeIndeterminate;
    }
    return _proHud;
}

- (void)hideMyHud
{
    if (_proHud)
    {
        [_proHud hideAnimated:YES];
        _proHud = nil;
    }
}

- (void)showMyHud
{
    [self.proHud showAnimated:YES];
}


#pragma mark - ----------------------- 无内容视图 -----------------------

- (void)showNoContentView
{
    [self.view addSubview:self.noContentView];
}

- (void)hideNoContentView
{
    [self.noContentView removeFromSuperview];
    self.noContentView = nil;
}

- (FWNoContentView *)noContentView
{
    if (!_noContentView)
    {
//        _noContentView = [FWNoContentView noContentWithFrame:CGRectMake(0, 0, 150, 175)];
        _noContentView = [[FWNoContentView alloc]initWithFrame:CGRectMake(0, 0, 150, 175)];
        _noContentView.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    }
    return _noContentView;
}

#pragma mark ------------------------ GET -----------------------
- (NetHttpsManager *)httpsManager
{
    if (!_httpsManager)
    {
        _httpsManager = [NetHttpsManager manager];
    }
    return _httpsManager;
}

- (GlobalVariables *)fanweApp
{
    if (!_fanweApp)
    {
        _fanweApp = [GlobalVariables sharedInstance];
    }
    return _fanweApp;
}

@end
