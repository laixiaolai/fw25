//
//  GameDistributionViewController.m
//  FanweApp
//
//  Created by 王珂 on 17/4/5.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "GameDistributionViewController.h"
#import "GameDistributionCell.h"
#import "GameDistributionModel.h"
#import "SHomePageVC.h"
#import "EdgeInsetsLabel.h"

@interface GameDistributionViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    
    int             _page;                  //页数
    int             _has_next;              //是否还有下一页
    
}

@property (nonatomic, strong) GameDistributionModel     *model;
@property (nonatomic, strong) UITableView               *listTableView;
@property (nonatomic, strong) NSMutableArray            *listArray;     //数据数组

@end

@implementation GameDistributionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _listArray = [[NSMutableArray alloc]init];
    _page = 1;
    self.view.backgroundColor = kWhiteColor;
    self.navigationItem.leftBarButtonItem=[UIBarButtonItem itemWithTarget:self action:@selector(backClick) image:@"com_arrow_vc_back" highImage:@"com_arrow_vc_back"];
    self.title = @"游戏分享收益";
    [self creatView];
}

- (void)creatView
{
    if (!_listTableView)
    {
        
        _listTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-64)];
        _listTableView.delegate =self;
        _listTableView.dataSource =self;
        _listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_listTableView];
    }
    
    [FWMJRefreshManager refresh:_listTableView target:self headerRereshAction:@selector(headerReresh) footerRereshAction:@selector(footerReresh)];
}

- (void)backClick
{
    [self.navigationController popViewControllerAnimated:NO];
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

- (void)loadDataWithPage:(int)page
{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"games" forKey:@"ctl"];
    [parmDict setObject:@"getDistributionList" forKey:@"act"];
    [parmDict setObject:@(page) forKey:@"page"];
    
    FWWeakify(self)
    [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
        
        FWStrongify(self)
        if ([responseJson toInt:@"status"] == 1)
        {
            if (page == 1 || page == 0)
            {
                [self.listArray removeAllObjects];
            }
            NSDictionary * dataDic = responseJson[@"data"];
            GameDistributionModel * distrModel = [GameDistributionModel mj_objectWithKeyValues:dataDic];
            self.model = distrModel;
            [self.listArray addObjectsFromArray:distrModel.list];
            _has_next = [dataDic[@"page"] toInt:@"has_next"];
            _page = [dataDic[@"page"] toInt:@"page"];
            [self.listTableView reloadData];
        }
        
        [FWMJRefreshManager endRefresh:self.listTableView];
        
        if (!self.listArray.count)
        {
            [self showNoContentView];
        }
        else
        {
            [self hideNoContentView];
        }
        
    } FailureBlock:^(NSError *error) {
        
        FWStrongify(self)
        [FWMJRefreshManager endRefresh:self.listTableView];
        
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return [self.model.parent.userID integerValue] > 0 ? 1 : 0;
    }
    else if (section == 1)
    {
        return _listArray.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 51;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return [self.model.parent.userID integerValue] > 0 ? 25 : 0;
    }
    return 25;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    EdgeInsetsLabel *titleLabel = [[EdgeInsetsLabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 25)];
    titleLabel.textColor = kAppGrayColor1;
    titleLabel.font = kAppMiddleTextFont_1;
    titleLabel.backgroundColor = kBackGroundColor;
    titleLabel.edgeInsets = UIEdgeInsetsMake(0 , 15, 0, 15);      // 设置内边距
    
    if (section == 0)
    {
        titleLabel.text = @"我的推荐人";
    }
    else
    {
        titleLabel.text = @"我的收益";
    }
    return titleLabel;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return @"我的推荐人";
    }
    else
    {
        return @"我的收益";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GameDistributionCell * cell = [GameDistributionCell cellWithTableView:tableView];
    GameUserModel * userModel =[[GameUserModel alloc] init];
    if (indexPath.section == 0)
    {
        userModel = self.model.parent;
        userModel.isParent = YES;
        cell.model = userModel;
    }
    else if (indexPath.section == 1)
    {
        userModel = _listArray[indexPath.row];;
        userModel.isParent = NO;
        cell.model = userModel;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GameUserModel * gameUserModel;
    if (indexPath.section == 0)
    {
        gameUserModel = self.model.parent;
    }
    else if (indexPath.section == 1)
    {
        gameUserModel = _listArray[indexPath.row];
    }
    SHomePageVC *homeVC = [[SHomePageVC alloc]init];
    homeVC.user_id = gameUserModel.userID;
    homeVC.user_nickname =gameUserModel.nick_name;
    homeVC.type = 0;
    [[AppDelegate sharedAppDelegate]pushViewController:homeVC];
}

@end
