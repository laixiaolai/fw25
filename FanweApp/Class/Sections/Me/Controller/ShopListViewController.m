//
//  ShopListViewController.m
//  FanweApp
//
//  Created by yy on 16/9/20.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "ShopListViewController.h"
#import "ShopListTableViewCell.h"
#import "ShopListModel.h"
#import "ReleaseViewController.h"
#import "EditWebView.h"

@interface ShopListViewController ()<UITableViewDelegate,UITableViewDataSource,ShopListTableViewCellDelegate,EditWebViewDelegate>

@end

@implementation ShopListViewController
{
    UITableView     *_listTableView;
    NSMutableArray  *_dataArray;            //数据数组
    BOOL            _isEdit;                //是否可编辑
    ShopListModel   *_model;
    int             _page;                  //页数
    int             _has_next;              //是否还有下一页
    NSInteger       _indexRow;
    EditWebView     *_editView;             //编辑网址视图
    CGRect          _beforeFrame;           //记录之前的坐标
    NSString        *_beforeUrl;            //记录商店Url
    NSString        *_shopUrl;              //商店url
    UIView          *_grayView;             //灰色背景
    BOOL            _isFirstLoad;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    _editView.editTextView.keyboardType = UIKeyboardTypeURL;
    
    if (!_isFirstLoad)
    {
        [self headerReresh];
    }
    _isFirstLoad = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _isFirstLoad = YES;
    
    self.navigationItem.leftBarButtonItem=[UIBarButtonItem itemWithTarget:self action:@selector(backClick) image:@"com_arrow_vc_back" highImage:@"com_arrow_vc_back"];
    
    _dataArray  = [[NSMutableArray alloc]init];;
    
    _page = 1;
    [self createTableView];
    
    _editView.editTextView.keyboardType = UIKeyboardTypeURL;
    if (_isOTOShop) {
        self.title = @"我的小店";
    }
    else
    {
        self.title  = @"我的星店";
    }
}

#pragma mark    创建表
- (void)createTableView
{
    if (!_listTableView) {
        
        _listTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH -kStatusBarHeight-kNavigationBarHeight-42)];
        if (kSupportH5Shopping || _isOTOShop) {
            _listTableView.frame = CGRectMake(0, 0, kScreenW, kScreenH -kStatusBarHeight-kNavigationBarHeight);
        }
    }
    
    _listTableView.delegate = self;
    _listTableView.dataSource = self;
    _listTableView.backgroundColor = kBackGroundColor;
    _listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_listTableView];
    
    [self createMJRefresh];
    if(kSupportH5Shopping || _isOTOShop)
    {
        [self createNavItem];
    }
    else
    {
        [self createNavItem];
        [self editShopAddress];
        [self createEditWeb];
    }
}

#pragma mark    创建刷新
- (void)createMJRefresh
{
    [FWMJRefreshManager refresh:_listTableView target:self headerRereshAction:@selector(headerReresh) footerRereshAction:@selector(footerReresh)];
}

#pragma mark    创建编辑网址视图
- (void)createEditWeb
{
    //灰色背景
    if (!_grayView)
    {
        _grayView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    }
    _grayView.backgroundColor = kGrayTransparentColor3;
    _grayView.hidden = YES;
    [self.view addSubview:_grayView];
    
    if (!_editView) {
        _editView = [EditWebView EditNibFromXib];
    }
    _editView.frame = CGRectMake((kScreenW-280)/2, kScreenH, 280 , 220);
    _editView.backgroundColor = [UIColor clearColor];
    _editView.backgroundView.backgroundColor = kAppMainColor;
    _beforeFrame = _editView.frame;
    _editView.delegate =self;
    _editView.backgroundView.layer.cornerRadius = 12;
    _editView.backgroundView.layer.masksToBounds = YES;
    [self.view addSubview:_editView];
}


#pragma mark    创建“新增”按钮
- (void)createNavItem
{
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 5, 45, 30);
    rightButton.tag = 1;
    rightButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [rightButton setTitle:@"新增" forState:UIControlStateNormal];
    [rightButton setTitleColor:kAppGrayColor1 forState:UIControlStateNormal];
    [rightButton setTitleColor:kAppGrayColor4 forState:UIControlStateSelected];
    [rightButton addTarget:self action:@selector(ClickButton:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

#pragma mark    创建“编辑小店地址”按钮
- (void)editShopAddress
{
    UIButton *editAddress_Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    editAddress_Btn.frame = CGRectMake(0, kScreenH -kStatusBarHeight-kNavigationBarHeight-42, kScreenW, 42);
    editAddress_Btn.tag = 2;
    [editAddress_Btn setTitle:@"编辑星店地址" forState:UIControlStateNormal];
    [editAddress_Btn setTitleColor:kNavBarThemeColor forState:UIControlStateNormal];
    [editAddress_Btn setBackgroundColor:kAppMainColor];
    editAddress_Btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [editAddress_Btn addTarget:self action:@selector(ClickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:editAddress_Btn];
}

#pragma mark    下拉刷新
- (void)headerReresh
{
    [self loadDataWithPage:1];
}

#pragma mark    上拉加载
- (void)footerReresh
{
    if (_has_next == 1)
    {
        _page ++;
        [self loadDataWithPage:_page];
    }
    else
    {
        [FWMJRefreshManager endRefresh:_listTableView];
    }
}

#pragma mark------------------------------网络请求---------------------------------------

#pragma mark    我的星店
- (void)loadDataWithPage:(int)page
{
    NSMutableDictionary *parmDict = [[NSMutableDictionary alloc]init];
    [parmDict setObject:@"shop" forKey:@"ctl"];
    if (_isOTOShop) {
        [parmDict setObject:@"podcast_mystore" forKey:@"act"];
    }
    else
    {
        [parmDict setObject:@"mystore" forKey:@"act"];
    }
    [parmDict setObject:[NSString stringWithFormat:@"%d",page] forKey:@"page"];
    [parmDict setObject:[NSString stringWithFormat:@"%@",self.user_id] forKey:@"podcast_user_id"];
    [parmDict setObject:@"shop" forKey:@"itype"];
    [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
        
        if ([responseJson toInt:@"status"] == 1)
        {
            NSMutableArray *listArray = [responseJson objectForKey:@"list"];
            NSDictionary * pageDic = [responseJson objectForKey:@"page"];
            
            _has_next = [pageDic toInt:@"has_next"];
            _page = [pageDic toInt:@"page"];
            
            if (page == 1) {
                [_dataArray removeAllObjects];
            }
            
            if (listArray.count>0)
            {
                for (NSDictionary *dic in listArray) {
                    _model = [ShopListModel mj_objectWithKeyValues:dic];
                    [_dataArray addObject:_model];
                }
            }
            
            _shopUrl = [responseJson objectForKey:@"url"];
            if (_shopUrl.length == 0) {
                _editView.editTextView.text = @"http://";
            }
            else
            {
                _editView.editTextView.text = _shopUrl;
            }
            [_listTableView reloadData];
        }
        
        [FWMJRefreshManager endRefresh:_listTableView];
        
        if (!_dataArray.count)
        {
            [self showNoContentView];
        }
        else
        {
            [self hideNoContentView];
        }
        
    } FailureBlock:^(NSError *error) {
        
        [FWMJRefreshManager endRefresh:_listTableView];
        
    }];
}

#pragma mark    删除商品
- (void)deleteData:(NSIndexPath *)indexPath
{
    
    if (indexPath.row < _dataArray.count) {
        _model = _dataArray[indexPath.row];
    }
    
    NSMutableDictionary *parmDict = [[NSMutableDictionary alloc]init];
    [parmDict setObject:@"shop" forKey:@"ctl"];
    [parmDict setObject:@"del_goods" forKey:@"act"];
    [parmDict setObject:[NSString stringWithFormat:@"%@",_model.ID]
                 forKey:@"id"];
    [parmDict setObject:@"shop" forKey:@"itype"];
    [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson)
     {
         if ([responseJson toInt:@"status"] == 1){
             [_dataArray removeObjectAtIndex:indexPath.row];
             [_listTableView reloadData];
         }
     } FailureBlock:^(NSError *error)
     {
         
     }];
}

#pragma mark    编辑星店地址
- (void)addShopUrl:(NSString *)urlStr
{
    NSMutableDictionary *parmDict = [[NSMutableDictionary alloc]init];
    [parmDict setObject:@"shop" forKey:@"ctl"];
    [parmDict setObject:@"edit_store_url" forKey:@"act"];
    [parmDict setObject:urlStr forKey:@"store_url"];
    [parmDict setObject:@"shop" forKey:@"itype"];
    [[FWHUDHelper sharedInstance] syncLoading:@""];
    [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
        if ([responseJson toInt:@"status"] == 1) {
            [[FWHUDHelper sharedInstance] syncStopLoading];
            
            [_editView.editTextView resignFirstResponder];
            [UIView animateWithDuration:0.3 animations:^{
                _editView.frame = _beforeFrame;
                _grayView.hidden = YES;
            }];
        }
    } FailureBlock:^(NSError *error) {
        [[FWHUDHelper sharedInstance] syncStopLoading];
        
    }];
}


#pragma mark----------------------------TableView代理方法-------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.fanweApp.appModel.open_podcast_goods == 1 && _isOTOShop)
    {
        return 120;
    }
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShopListTableViewCell *cell = [ShopListTableViewCell cellWithTableView:tableView];
    ShopListModel * model = _dataArray[indexPath.row];
    //model.showDes = _isOTOShop;
    cell.model = model;
    cell.delegate =self;
    return cell;
}

#pragma mark    删除cell方法
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (kSupportH5Shopping) {
        return UITableViewCellEditingStyleNone;
    }
    else
    {
        return UITableViewCellEditingStyleDelete;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self createAlert:indexPath];
    }
}

#pragma mark    点击cell方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"222222222222222222");
}

#pragma mark    警告框
- (void)createAlert:(NSIndexPath *)indexPath
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    
    //确定:UIAlertActionStyleDefault
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定"
                                                       style:UIAlertActionStyleDestructive
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         [self deleteData:indexPath];
                                                     }];
    [alertController addAction:okAction];
    
    //取消:UIAlertActionStyleDestructive
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             [_listTableView setEditing:NO animated:YES];
                                                         }];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark    返回
- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark    Auction方法
- (void)ClickButton:(UIButton *)button
{
    //1是新增，2是“编辑星店地址”
    if (button.tag == 1) {
        ReleaseViewController * releaseVC = [[ReleaseViewController alloc]init];
        releaseVC.shopType = @"EntityShopping";
        releaseVC.isOTOShop = self.isOTOShop;
        [self.navigationController pushViewController:releaseVC animated:YES];
    }
    else if(button.tag == 2)
    {
        if (_beforeUrl.length != 0) {
            _editView.editTextView.text = _beforeUrl;
        }
        [UIView animateWithDuration:0.3 animations:^{
            _grayView.hidden = NO;
            _editView.frame = CGRectMake((kScreenW-280)/2, (kScreenH-220)/2-kStatusBarHeight-kNavigationBarHeight, 280 , 220);
        }];
        _editView.editTextView.keyboardType = UIKeyboardTypeURL;
        //[_editView.editTextView becomeFirstResponder];
        
    }
}

#pragma mark----------------------------------按钮代理方法------------------------------------
#pragma mark    “编辑”代理方法
- (void)enterEditWithShopListTableViewCell:(ShopListTableViewCell *)shopListTableViewCell
{
    NSIndexPath * indexPath = [_listTableView indexPathForCell:shopListTableViewCell];
    ReleaseViewController * releaseVC = [[ReleaseViewController alloc]init];
    releaseVC.isOTOShop = self.isOTOShop;
    releaseVC.model = _dataArray[indexPath.row];
    releaseVC.shopType = @"EditShopping";
    [self.navigationController pushViewController:releaseVC animated:YES];
}

#pragma mark    "取消,确定"代理方法
- (void)viewDown:(UIButton *)sender
{
    
    //1是取消，2是确定
    if (sender.tag == 1) {
        [_editView.editTextView resignFirstResponder];
        [UIView animateWithDuration:0.3 animations:^{
            _editView.frame = _beforeFrame;
            _grayView.hidden = YES;
        } completion:^(BOOL finished) {
            if (_beforeUrl.length != 0) {
                _editView.editTextView.text = _beforeUrl;
            }
            else if (_shopUrl.length == 0)
            {
                _editView.editTextView.text = @"http://";
            }
            else
            {
                _editView.editTextView.text = _shopUrl;
            }
        }];
    }
    else
    {
        //如果网址不为空
        if (_editView.editTextView.text.length != 0) {
            if ([_editView.editTextView.text isUrl]) {
                [self addShopUrl:_editView.editTextView.text];
                _beforeUrl = _editView.editTextView.text;
            }
            else
                [[FWHUDHelper sharedInstance] tipMessage:@"请输入正确的网址链接"];
        }
        else
        {
            [FanweMessage alert:@"请输入网址"];
        }
    }
    
}

//- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
//{
//
//    [UIMenuController sharedMenuController].menuVisible = NO;  //donot display the menu
//    [_editView.editTextView resignFirstResponder];                     //do not allow the user to selected anything
//    return NO;
//
//}


@end
