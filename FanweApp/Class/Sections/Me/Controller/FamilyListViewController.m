//
//  FamilyListViewController.m
//  FanweApp
//
//  Created by 王珂 on 16/9/26.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "FamilyListViewController.h"
#import "FamilyListViewCell.h"
#import "MJRefresh.h"
#import "FamilyListModel.h"
#import "FamilyDesViewController.h"

@interface FamilyListViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,FamilyListViewCellDelegate>
{
    NSString *_searchString;
    UIView *_searchHeaderView;
    UIButton *_rightButton;
    UIImageView *_searchImgView;
}
@property (nonatomic, strong) UISearchBar *SearchBar;
@property (nonatomic, strong) UIView * displayView;
@property (nonatomic, strong) UIView * slideLineView;
@property (nonatomic, strong) NSMutableArray *userDataArray;
@property (nonatomic, strong) UITableView *displayTabel;
@property (nonatomic, assign) int has_next;
@property (nonatomic, assign) int currentPage;;
@property (nonatomic, assign) int state;;
@property (nonatomic, strong) UITextField *textFiled;

@end

@implementation FamilyListViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UIApplication *application = [UIApplication sharedApplication];
    [application setStatusBarHidden:NO];
    
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    
    _rightButton.hidden = NO;
    _textFiled.hidden = NO;
    _searchImgView.hidden = NO;
    _searchHeaderView.hidden = NO;
    
    [self loadNetDataWithPage:1];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    _userDataArray = [[NSMutableArray alloc]initWithCapacity:0];
    [self searchbarDisplay];
    _currentPage = 1;
    [self creatTabelView];
}

- (void)searchbarDisplay
{
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(comeBack) image:@"com_arrow_vc_back" highImage:@"com_arrow_vc_back"];
    self.navigationItem.title = @"家族列表";
    //画线
    UILabel * lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 0.5)];
    lineLabel.backgroundColor = kAppGrayColor4;
    lineLabel.alpha = 0.5;
    [self.view addSubview:lineLabel];
    _searchHeaderView = [[UIView alloc] initWithFrame:CGRectMake(10, 6, kScreenW-80, 30)];
    [_searchHeaderView setBackgroundColor:[UIColor whiteColor]];
    _searchHeaderView.layer.cornerRadius = 5;
    _searchHeaderView.layer.borderWidth = 1;
    _searchHeaderView.layer.borderColor = kAppMainColor.CGColor;
    [self.view addSubview:_searchHeaderView];
    
    _searchImgView = [[UIImageView alloc]initWithFrame:CGRectMake(4, 7, 16, 16)];
    _searchImgView.backgroundColor = [UIColor whiteColor];
    _searchImgView.image = [UIImage imageNamed:@"ic_edit_search_gray"];
    [_searchHeaderView addSubview:_searchImgView];
    
    _textFiled = [[UITextField alloc]initWithFrame:CGRectMake(22, 0, kScreenW -110, 30)];
    _textFiled.backgroundColor = [UIColor whiteColor];
    _textFiled.textAlignment = NSTextAlignmentLeft;
    _textFiled.font = [UIFont systemFontOfSize:14];
    _textFiled.delegate = self;
    [_textFiled addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _textFiled.clearsOnBeginEditing = YES;
    _textFiled.clearsContextBeforeDrawing = YES;
    _textFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    _textFiled.placeholder = @"请输入您想要加入的家族";
    [_searchHeaderView addSubview:_textFiled];
    
    _rightButton = [[UIButton alloc]initWithFrame:CGRectMake(kScreenW-70, 6, 60, 30)];
    [_rightButton setTitle:@"取消" forState:0];
    [_rightButton setTitleColor:kAppMainColor forState:0];
    [_rightButton addTarget:self action:@selector(cancelButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_rightButton];
    self.view.backgroundColor = [UIColor whiteColor];
    UIView * blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, kScreenW, 10)];
    blackView.backgroundColor = kFamilyBackGroundColor;
    blackView.alpha = 0.5;
    [self.view addSubview:blackView];
}

- (void)cancelButtonAction
{
    [_textFiled resignFirstResponder];
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)comeBack
{
    [_textFiled resignFirstResponder];
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _rightButton.hidden = YES;
    _textFiled.hidden = YES;
    _searchImgView.hidden = YES;
    _searchHeaderView.hidden = YES;
    
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}

#pragma mark展示数据的表格创建
- (void)creatTabelView
{
    _displayTabel = [[UITableView alloc] initWithFrame:CGRectMake(0,50,kScreenW, kScreenH-110) style:UITableViewStylePlain];
    _displayTabel.delegate =self;
    _displayTabel.dataSource =self;
    _displayTabel.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_displayTabel];
    
    [FWMJRefreshManager refresh:_displayTabel target:self headerRereshAction:@selector(headerReresh) footerRereshAction:@selector(footerReresh)];
}

- (void)headerReresh
{
    [self loadNetDataWithPage:1];
}

- (void)footerReresh
{
    if (_has_next == 1)
    {
        _currentPage ++;
        [self loadNetDataWithPage:_currentPage];
    }
    else
    {
        [FWMJRefreshManager endRefresh:_displayTabel];
    }
}

#pragma mark 请求数据
- (void)loadNetDataWithPage:(int)page
{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    
    [parmDict setObject:@"family" forKey:@"ctl"];
    [parmDict setObject:@"family_list" forKey:@"act"];
    if (_textFiled.text.length)
    {
        [parmDict setObject:_textFiled.text forKey:@"family_name"];
    }
    else
    {
        [parmDict setObject:@"" forKey:@"family_name"];
    }
    [parmDict setObject:[NSString stringWithFormat:@"%d",page] forKey:@"page"];
    [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson)
     {
         _state = [responseJson toInt:@"status"];
         if (_state == 1)
         {
             NSDictionary * dic = [responseJson objectForKey:@"page"];
             if (dic && [dic isKindOfClass:[NSDictionary class]])
             {
                 _currentPage = [dic toInt:@"page"];
                 if (_currentPage == 1 || _currentPage == 0)
                 {
                     [_userDataArray removeAllObjects];
                 }
                 _has_next = [dic toInt:@"has_next"];
             }
             NSArray *listArray = [responseJson objectForKey:@"list"];
             if (listArray && [listArray isKindOfClass:[NSArray class]]&& listArray.count)
             {
                 for (NSDictionary *dict in listArray)
                 {
                     FamilyListModel * model = [FamilyListModel mj_objectWithKeyValues:dict];
                     [_userDataArray addObject:model];
                 }
             }
         }
         [_displayTabel reloadData];
         
         [FWMJRefreshManager endRefresh:_displayTabel];
         
     } FailureBlock:^(NSError *error)
     {
         
         [FWMJRefreshManager endRefresh:_displayTabel];
         
     }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_userDataArray.count>0) {
        return _userDataArray.count;
    }
    else
        return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"cellID";
    FamilyListViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell== nil) {
        cell = [[FamilyListViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.model = _userDataArray[indexPath.row];
    cell.delegate = self;
    return cell;
}

//点击cell跳转到家族详情
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FamilyListModel * model = _userDataArray[indexPath.row];
    FamilyDesViewController * familyDesVC = [[FamilyDesViewController alloc] init];
    familyDesVC.isFamilyHeder = 2;
    familyDesVC.jid = model.family_id;
    familyDesVC.is_apply = model.is_apply;
    familyDesVC.listModel = model;
    //    for (FamilyListModel * model in _userDataArray) {
    //        if ([model.is_apply isEqualToString:@"2"]) {
    //        }
    //    }
    [self.navigationController pushViewController:familyDesVC animated:YES];
}

// 监听改变按钮
- (void)textFieldDidChange:(UITextField*) sender
{
    NSLog(@"_SearchBarField.text==%@",_textFiled.text);
    [self loadNetDataWithPage:1];
}

//当用户按下ruturn，把焦点从textField移开那么键盘就会消失了
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    //  [self loadNetDataWithPage:1];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self loadNetDataWithPage:1];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    //    [_textFiled becomeFirstResponder];
    return YES;
}


//滑动键盘下落
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_textFiled resignFirstResponder];
}

//申请加入家族
- (void)applyWithFamilyListViewCell:(FamilyListViewCell *)cell
{
    for (FamilyListModel * model in _userDataArray)
    {
        if ([model.is_apply isEqualToString:@"2"])
        {
            return;
        }
    }
    
    FWWeakify(self)
    [FanweMessage alert:nil message:@"是否申请加入该家族" destructiveAction:^{
        
        FWStrongify(self)
        NSIndexPath * indexPath = [_displayTabel indexPathForCell:cell];
        FamilyListModel * model = _userDataArray[indexPath.row];
        NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
        [parmDict setObject:@"family_user" forKey:@"ctl"];
        [parmDict setObject:@"user_join" forKey:@"act"];
        [parmDict setObject:model.family_id forKey:@"family_id"];
        
        [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
            
            if ([responseJson toInt:@"status"]==1)
            {
                model.is_apply = @"1";
                self.userDataArray[indexPath.row] = model;
                [self.displayTabel reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                [[FWHUDHelper sharedInstance] tipMessage:@"申请已提交"];
            }
            
        } FailureBlock:^(NSError *error) {
            NSLog(@"%@",error);
        }];
        
    } cancelAction:^{
        
    }];
}

@end
