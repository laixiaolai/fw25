//
//  ListDayViewController.m
//  FanweApp
//
//  Created by ycp on 16/10/14.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "ListDayViewController.h"
#import "UserModel.h"
#import "LeaderboardTableViewCell.h"
#import "SHomePageVC.h"
#import "SLeaderHeadView.h"

@interface ListDayViewController ()<UITableViewDelegate,UITableViewDataSource>

@property ( nonatomic,strong) UITableView                *listTableView;
@property ( nonatomic,strong) NSMutableArray             *dataArray;            //数据数组
@property ( nonatomic,strong) NSMutableArray             *haloArray;            //前三名
@property ( nonatomic,assign) int                        page;
@property ( nonatomic,assign) int                        has_next;
@property ( nonatomic,strong) SLeaderHeadView            *leadheadView;         //listTableView 的头部视图

@end


@implementation ListDayViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.dataArray = [[NSMutableArray alloc]init];
    self.haloArray = [[NSMutableArray alloc]init];
    self.view.backgroundColor = kBackGroundColor;
    self.page = 1;
    [self createTableView];
}

#pragma mark    创建表
- (void)createTableView
{
    if (!_listTableView)
    {
        if (self.isHiddenTabbar)
        {
            _listTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 0, kScreenW - 20, kScreenH-kStatusBarHeight-44 -44 )];
            if (isIPhoneX())
            {
                _listTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 0, kScreenW - 20, kScreenH-kStatusBarHeight-44 -44 )];
            }
        }
        else
        {
            _listTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 0, kScreenW - 20, kScreenH-kStatusBarHeight-44 -44-49)];
            if (isIPhoneX())
            {
                _listTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 0, kScreenW - 20, kScreenH-kStatusBarHeight*2-44 -44-40)];
            }
        }
        
        _listTableView.delegate =self;
        _listTableView.dataSource =self;
        _listTableView.backgroundColor = kAppSpaceColor3;
        _listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.leadheadView =  [[SLeaderHeadView alloc]initWithFrame:CGRectMake(10, 0, kScreenW - 20, 170*kScaleHeight)];
        FWWeakify(self)
        [self.leadheadView setLeadBlock:^(int imgaeIdnex){
            FWStrongify(self)
            if (imgaeIdnex < self.haloArray.count)
            {
                UserModel *model = self.haloArray[imgaeIdnex];
                if (self.delegate && [self.delegate respondsToSelector:@selector(pushToHomePage:)])
                {
                    [self.delegate pushToHomePage:model];
                }
            }
        }];
        [self.view addSubview:_listTableView];
    }
    
    [self.listTableView registerNib:[UINib nibWithNibName:@"LeaderboardTableViewCell" bundle:nil] forCellReuseIdentifier:@"LeaderboardTableViewCell"];
    
    [FWMJRefreshManager refresh:_listTableView target:self headerRereshAction:@selector(headerReresh) footerRereshAction:@selector(footerReresh)];
}

#pragma mark    下拉刷新
- (void)headerReresh
{
    [self loadDataWithPage:1];
}

#pragma mark    上拉加载
- (void)footerReresh
{
    if (self.has_next == 1)
    {
        self.page ++;
        [self loadDataWithPage:self.page];
    }
    else
    {
        [FWMJRefreshManager endRefresh:self.listTableView];
    }
}

- (void)loadDataWithPage:(int)page
{
    MMWeakify(self)
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"rank" forKey:@"ctl"];
    if (self.type < 4)
    {
        [parmDict setObject:@"consumption" forKey:@"act"];
        if (self.type == 1)
        {
            [parmDict setObject:@"day" forKey:@"rank_name"];
        }
        else if (self.type == 2)
        {
            [parmDict setObject:@"month" forKey:@"rank_name"];
        }
        else if (self.type == 3)
        {
            [parmDict setObject:@"all" forKey:@"rank_name"];
        }
    }
    else
    {
        [parmDict setObject:@"contribution" forKey:@"act"];
        if (self.type == 4)
        {
            [parmDict setObject:@"day" forKey:@"rank_name"];
        }
        else if (self.type == 5)
        {
            [parmDict setObject:@"month" forKey:@"rank_name"];
        }
        else if (self.type == 6)
        {
            [parmDict setObject:@"all" forKey:@"rank_name"];
        }
    }
    [parmDict setObject:[NSString stringWithFormat:@"%d",page] forKey:@"p"];
    FWWeakify(self)
    [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson)
     {
         FWStrongify(self)
         if ([responseJson toInt:@"status"] == 1)
         {
             self.page = [responseJson toInt:@"page"];
             //用户信息
             self.has_next = [responseJson toInt:@"has_next"];
             if (page == 1)
             {
                 [self.dataArray removeAllObjects];
             }
             NSArray *array = [responseJson objectForKey:@"list"];
             if (array && [array isKindOfClass:[NSArray class]])
             {
                 if (array.count > 0)
                 {
                     for (NSDictionary *dict in array)
                     {
                         UserModel *model = [UserModel mj_objectWithKeyValues:dict];
                         [self.dataArray addObject:model];
                     }
                 }
             }
             if (self.dataArray.count)
             {
                 MMStrongify(self)
                 [self disposeNOForThreeData];
                 self.listTableView.tableHeaderView = self.leadheadView;
                 [self hideNoContentView];
             }else
             {
                 [self showNoContentView];
                 self.listTableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _listTableView.width, 0.01)];
             }
             [self.listTableView reloadData];
         }
         [FWMJRefreshManager endRefresh:self.listTableView];
     } FailureBlock:^(NSError *error) {
         FWStrongify(self)
         [FWMJRefreshManager endRefresh:self.listTableView];
     }];
}

- (void)disposeNOForThreeData
{
    if (self.haloArray.count)
    {
        [self.haloArray removeAllObjects];
    }
    for (int i=0; i<3; i++)
    {
        [self judgeAndLoadHaloData];
    }
    [self.leadheadView setMyViewWithMArr:self.haloArray andType:0 consumeType:self.type];
}

- (void)judgeAndLoadHaloData
{
    if (_dataArray.count)
    {
        [_haloArray addObject:_dataArray[0]];
        [_dataArray removeObjectAtIndex:0];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LeaderboardTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"LeaderboardTableViewCell"];
    if (!cell)
    {
        cell = [[NSBundle mainBundle] loadNibNamed:@"LeaderboardTableViewCell" owner:nil options:nil].firstObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    UserModel *model = _dataArray[indexPath.row];
    [cell createCellWithModel:model withRow:(int)indexPath.row withType:self.type];
    if (indexPath.row == _dataArray.count-1)
    {
        cell.lineView.hidden = YES;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self jumpOffHomePage:_dataArray selectRow:indexPath.row];
}

/**
 跳转到主页
 
 @param array 数据源
 @param selectRow 所选择的行
 */
- (void)jumpOffHomePage:(NSMutableArray *)array selectRow:(NSInteger)selectRow
{
    if (array.count >0 && selectRow < array.count)
    {
        UserModel *model = array[selectRow];
        if (_delegate && [_delegate respondsToSelector:@selector(pushToHomePage:)])
        {
            [_delegate pushToHomePage:model];
        }
    }
}


@end
