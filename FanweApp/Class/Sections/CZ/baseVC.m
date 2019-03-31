//
//  baseVC.m
//  switchPicChat
//
//  Created by zzl on 16/3/30.
//  Copyright © 2016年 zzl. All rights reserved.
//

#import "baseVC.h"

@interface baseVC ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation baseVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view setTranslatesAutoresizingMaskIntoConstraints:YES];
    
    if( !self.mHidNarBar )
        [self addNav];
}

- (void)setMHidNarBar:(BOOL)mHidNarBar
{
    _mHidNarBar = mHidNarBar;
    self.mItNav.view.hidden = _mHidNarBar;
}

- (void)addNav
{
    self.mItNav = [[baseNav alloc]initWithNibName:@"baseNav" bundle:nil];
    if( [self.mItNav respondsToSelector:@selector(loadViewIfNeeded)] )
        [self.mItNav loadViewIfNeeded];
    
    [self addChildViewController:self.mItNav];
    [self.view addSubview:self.mItNav.view];
    
    NSLayoutConstraint* w = [NSLayoutConstraint constraintWithItem:self.mItNav.view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1 constant:0];
    
    NSLayoutConstraint* t = [NSLayoutConstraint constraintWithItem:self.mItNav.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    
    NSLayoutConstraint* c = [NSLayoutConstraint constraintWithItem:self.mItNav.view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    
    [self.view addConstraint:w];
    [self.view addConstraint:t];
    [self.view addConstraint:c];
    
    [self.mItNav.mLeftBt addTarget:self action:@selector(backBtClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.mItNav.mRightBt addTarget:self action:@selector(rightBtClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.mItNav.mrightsecond addTarget:self action:@selector(rightSecBtClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)hidBackBt
{
    self.mItNav.mLeftBt.hidden = YES;
    self.mItNav.mLeftImg.hidden = YES;
}

- (void)setMTitle:(NSString *)mTitle
{
    _mTitle = mTitle;
    self.mItNav.mtitle.text = mTitle;
}

- (void)presentDismissCompletion
{
    
}
- (void)backBtClicked:(UIButton*)sender
{
    
    if( [self.navigationController topViewController] == self )
    {
        if( self.navigationController.viewControllers.count == 1 )
        {//如果只有一个,,,那么
            goto presentingback;
            
        }else
            [self.navigationController popViewControllerAnimated:YES];
        
        return;
    }
    else
    {
        
    presentingback:
        if( self.presentingViewController )
        {
            __weak UIViewController* vcvcref = self.presentingViewController;
            if( [vcvcref isKindOfClass:[UINavigationController class]] )
            {
                vcvcref = ((UINavigationController*)vcvcref).topViewController;
            }
            UIViewController* refself = self;
            [self dismissViewControllerAnimated:YES completion:^{
                if( [vcvcref respondsToSelector:@selector(presentDismissCompletion:)] )
                    [vcvcref performSelector:@selector(presentDismissCompletion:) withObject:refself];
            }];
            
            return;
        }
    }
    NSLog(@"how to back?");
}

- (void)presentDismissCompletion:(UIViewController*)backFrom
{
    
}

- (void)delayBackClicked
{
    [self performSelector:@selector(backBtClicked:) withObject:nil afterDelay:0.3f];
}

- (void)setRightTxt:(NSString*)str
{
    [self.mItNav.mRightBt setTitle:str forState:UIControlStateNormal];
}

- (void)setRightSecondeTxt:(NSString*)str
{
    [self.mItNav.mrightsecond setTitle:str forState:UIControlStateNormal];
}

- (void)rightBtClicked:(UIButton*)sender
{
    
}

- (void)rightSecBtClicked:(UIButton*)sender
{
    
}

- (void)pushToVC:(UIViewController*)vc
{
    [self.navigationController pushViewController:vc animated:YES];
}

//edg 表明 上下左右的距离 和父,
- (void)createTableViewWithEdg:(UIEdgeInsets)edg//调用这个函数就好创建好上面的
{
    self.mTableView = [[UITableView alloc]init];
    self.mTableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.mTableView.delegate = self;
    self.mTableView.dataSource =self;
    self.mTableView.tableFooterView = UIView.new;
    
    self.mDataArr = NSMutableArray.new;
    self.mPage = 0;
    [self.view addSubview:self.mTableView];
    
    //添加约束
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.mTableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:edg.top]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.mTableView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:edg.bottom]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.mTableView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:edg.left]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.mTableView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:edg.right]];
    
    self.mHaveHeader = YES;
    self.mHaveFooter = YES;
}

- (void)setMHaveHeader:(BOOL)mHaveHeader
{
    _mHaveHeader = mHaveHeader;
    if( _mHaveHeader )
    {
        [FWMJRefreshManager refresh:self.mTableView target:self headerRereshAction:@selector(headerStartRefresh) shouldHeaderBeginRefresh:NO footerRereshAction:nil];
    }
}

- (void)setMHaveFooter:(BOOL)mHaveFooter
{
    _mHaveFooter = mHaveFooter;
    if( _mHaveFooter )
    {
        [FWMJRefreshManager refresh:self.mTableView target:self headerRereshAction:nil footerRereshAction:@selector(footerStartRefresh)];
    }
}

- (void)forcesHeaderReFresh
{
    [self.mTableView.mj_header beginRefreshing];
}

- (void)headerStartRefreshWithBlock:(void(^)(NSArray* all,SResBase* resb))block
{
    block( nil, [SResBase infoWithString:@"base error:you do't have implementation headerStartRefreshWithBlock"] );
}

- (void)headerStartRefresh
{
    [self headerStartRefreshWithBlock:^(NSArray *all, SResBase *resb) {
        
        [self headerEndRefresh];
        [self.mDataArr removeAllObjects];
        if( resb.msuccess )
        {
            [SVProgressHUD dismiss];
            [self.mDataArr addObjectsFromArray:all];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:resb.mmsg];
        }
        [self.mTableView reloadData];
        [self removeEmptView];
        if( self.mDataArr.count == 0 ){
            [self addEmptView];
        }
        
    }];
}

- (void)headerEndRefresh
{
    [FWMJRefreshManager endRefresh:self.mTableView];
}

- (void)footerStartRefreshWithBlock:(void(^)(NSArray* all,SResBase* resb))block
{
    block( nil, [SResBase infoWithString:@"base error:you do't have implementation footerStartRefreshWithBlock"]);
}

- (void)footerStartRefresh
{
    [self footerStartRefreshWithBlock:^(NSArray *all, SResBase *resb) {
        [self footerEndRefresh];
        
        if( resb.msuccess )
        {
            [SVProgressHUD dismiss];
            [self.mDataArr addObjectsFromArray:all];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:resb.mmsg];
        }
        [self.mTableView reloadData];
        [self removeEmptView];
        if( self.mDataArr.count == 0 ){
            [self addEmptView];
        }
        
    }];
}

- (void)footerEndRefresh
{
    [FWMJRefreshManager endRefresh:self.mTableView];
}

- (void)createJustTableView//普通的列表,就是64开始,全部大小
{
    [self createTableViewWithEdg:UIEdgeInsetsMake(64, 0, 0, 0)];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.mDataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  UITableViewAutomaticDimension;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (void)addEmptView
{
    [self addEmptView:nil img:nil];
}

- (void)addEmptView:(NSString*)strInfo img:(UIImage*)img
{
    
}
- (void)removeEmptView
{
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    assert(_mPageName);
    
    
    self.mItNav.view.hidden = self.mHidNarBar;
    
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager]setEnableAutoToolbar:YES];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [[IQKeyboardManager sharedManager]setEnableAutoToolbar:NO];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = NO;
    
}

@end


@implementation MyUIAlertView


@end


@implementation MyUIActionSheet


@end
