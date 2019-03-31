//
//  FollowerViewController.m
//  FanweApp
//
//  Created by fanwe2014 on 16/6/18.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "FollowerViewController.h"
#import "SSearchVC.h"
#import "FollowerTableViewCell.h"
#import "SenderModel.h"
#import "SHomePageVC.h"

@interface FollowerViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView          *myTableView;
@property (nonatomic, strong) NSMutableArray       *dataArray;
@property (nonatomic, assign) int                  has_next;
@property (nonatomic, assign) int                  currentPage;
@property (nonatomic, assign) BOOL                 isfirstLoad;


@end

@implementation FollowerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = kWhiteColor;
}

- (void)initFWUI
{
    [super initFWUI];
    if ([self.type isEqualToString:@"1"])
    {
        self.navigationItem.title = @"关注的人";
    }
    else if ([self.type isEqualToString:@"2"])
    {
        self.navigationItem.title = @"粉丝";
    }
    else
    {
        self.navigationItem.title = @"黑名单";
    }
    self.dataArray = [[NSMutableArray alloc]init];
    self.has_next = 0;
    self.currentPage =1;
    self.isfirstLoad = YES;
    [self creatView];
}

- (void)creatView
{
    self.navigationItem.leftBarButtonItem=[UIBarButtonItem itemWithTarget:self action:@selector(comeBack) image:@"com_arrow_vc_back" highImage:@"com_arrow_vc_back"];
    
    if ([self.type isEqualToString:@"1"] && [self.user_id isEqualToString:[IMAPlatform sharedInstance].host.imUserId])
    {
        self.navigationItem.rightBarButtonItem=[UIBarButtonItem itemWithTarget:self action:@selector(searchController) image:@"ic_me_follow" highImage:@"ic_me_follow"];
    }
    
    self.myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-kStatusBarHeight-kNavigationBarHeight)];
    self.myTableView.backgroundColor = kBackGroundColor;
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.myTableView registerNib:[UINib nibWithNibName:@"FollowerTableViewCell" bundle:nil] forCellReuseIdentifier:@"FollowerTableViewCell"];
    [self.view addSubview:self.myTableView];
    
    [FWMJRefreshManager refresh:self.myTableView target:self headerRereshAction:@selector(headerReresh) footerRereshAction:@selector(footerReresh)];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!self.isfirstLoad)
    {
        [self loadNetDataWithPage:1];
    }
    self.isfirstLoad = NO;
}

- (void)headerReresh
{
    [self loadNetDataWithPage:1];
}

- (void)footerReresh
{
    if (self.has_next == 1)
    {
        self.currentPage ++;
        [self loadNetDataWithPage:self.currentPage];
    }
    else
    {
        [FWMJRefreshManager endRefresh:self.myTableView];
    }
}

- (void)loadNetDataWithPage:(int)page
{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    if ([self.type isEqualToString:@"1"])
    {
        [parmDict setObject:@"user" forKey:@"ctl"];
        [parmDict setObject:@"user_follow" forKey:@"act"];
    }else if ([self.type isEqualToString:@"2"])
    {
        [parmDict setObject:@"user" forKey:@"ctl"];
        [parmDict setObject:@"user_focus" forKey:@"act"];
    }else if ([self.type isEqualToString:@"3"]){
        [parmDict setObject:@"settings" forKey:@"ctl"];
        [parmDict setObject:@"black_list" forKey:@"act"];
    }
    if (self.user_id.length > 0)
    {
        [parmDict setObject:self.user_id forKey:@"to_user_id"];
    }
    [parmDict setObject:[NSString stringWithFormat:@"%d",page] forKey:@"p"];
    
    FWWeakify(self)
    [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
        
        FWStrongify(self)
        if ([responseJson toInt:@"status"] == 1)
        {
            self.currentPage = [responseJson toInt:@"page"];
            if (self.currentPage == 1)
            {
                [self.dataArray removeAllObjects];
            }
            self.has_next = [responseJson toInt:@"has_next"];
            
            if ([responseJson toInt:@"status"] == 1)
            {
                NSArray *listArray ;
                //由于字段不同，在设置来源界面做判断
                if ([self.type isEqualToString:@"3"])
                {
                    listArray = [responseJson objectForKey:@"user"];
                }
                else
                {
                    listArray = [responseJson objectForKey:@"list"];
                }
                for (NSDictionary *dict in listArray)
                {
                    SenderModel *sModel = [SenderModel mj_objectWithKeyValues:dict];
                    [self.dataArray addObject:sModel];
                }
                [self.myTableView reloadData];
            }
        }
        [FWMJRefreshManager endRefresh:self.myTableView];
        
        if (!self.dataArray.count)
        {
            [self showNoContentView];
        }
        else
        {
            [self hideNoContentView];
        }
        
    } FailureBlock:^(NSError *error) {
        
        FWStrongify(self)
        [FWMJRefreshManager endRefresh:self.myTableView];
        
    }];
}

//返回
- (void)comeBack
{
    [[AppDelegate sharedAppDelegate]popViewController];
}

#pragma mark -UITableViewDelegate&UITableViewDataSource
//返回行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

//返回段数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}
//返回单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FollowerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FollowerTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.dataArray.count > indexPath.section)
    {
        SenderModel *model = _dataArray[indexPath.section];
        [cell creatCellWithModel:model WithRow:(int)indexPath.section];
    }
    if (self.dataArray.count-1 == indexPath.section)
    {
        cell.lineView.hidden = YES;
    }
    if ([self.type isEqualToString:@"3"])
    {
        cell.joinBtn.userInteractionEnabled = NO;
        cell.rightImgView.userInteractionEnabled = NO;
        cell.rightImgView.image = [UIImage imageNamed:@"me_black"];
    }
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SenderModel *sModel = _dataArray[indexPath.section];
    SHomePageVC *homeVC = [[SHomePageVC alloc]init];
    homeVC.user_id = sModel.user_id;
    homeVC.type = 0;
    homeVC.user_nickname = sModel.nick_name;
    homeVC.user_headimg = sModel.head_image;
    [self.navigationController pushViewController:homeVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65*kAppRowHScale;
}

//下一个页面
- (void)searchController
{
    SSearchVC *searchVC = [[SSearchVC alloc]init];
    searchVC.searchType = @"0";
    [[AppDelegate sharedAppDelegate] pushViewController:searchVC];
}

@end
