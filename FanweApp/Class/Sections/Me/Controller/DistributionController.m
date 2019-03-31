//
//  DistributionController.m
//  FanweApp
//
//  Created by fanwe2014 on 2016/12/27.
//  Copyright © 2016年 xfg. All rights reserved.


#import "DistributionController.h"
#import "DistributionCell.h"
#import "LiveDataModel.h"

@interface DistributionController ()<UITableViewDelegate,UITableViewDataSource>
{
    int             _page;                  //页数
    int             _has_next;              //是否还有下一页
}

@property (nonatomic, strong) UITableView       *listTableView;
@property (nonatomic, strong) NSMutableArray    *dataArray;            //数据数组


@end

@implementation DistributionController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _dataArray = [[NSMutableArray alloc]init];
    _page = 1;
    self.view.backgroundColor = kWhiteColor;
    self.navigationItem.leftBarButtonItem=[UIBarButtonItem itemWithTarget:self action:@selector(backClick) image:@"com_arrow_vc_back" highImage:@"com_arrow_vc_back"];
    self.title = @"分享收益";
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
    
    [_listTableView registerNib:[UINib nibWithNibName:@"DistributionCell" bundle:nil] forCellReuseIdentifier:@"DistributionCell"];
    
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
    [parmDict setObject:@"distribution" forKey:@"ctl"];
    [parmDict setObject:@"index" forKey:@"act"];
    [parmDict setObject:[NSString stringWithFormat:@"%d",page] forKey:@"p"];
    
    FWWeakify(self)
    [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
        
        FWStrongify(self)
        [self.dataArray removeAllObjects];
        if ([responseJson toInt:@"status"] == 1)
        {
            _page = [[responseJson objectForKey:@"page"]toInt:@"page"];
            _has_next = [[responseJson objectForKey:@"page"]toInt:@"has_next"];
            if ([responseJson objectForKey:@"data"])
            {
                NSArray *array = [responseJson objectForKey:@"data"];
                if (array && [array isKindOfClass:[NSArray class]])
                {
                    if (array.count)
                    {
                        for (NSDictionary *dict in array)
                        {
                            LiveDataModel *model = [LiveDataModel mj_objectWithKeyValues:dict];
                            [self.dataArray addObject:model];
                        }
                    }
                }
            }
            [self.listTableView reloadData];
        }
        
        [FWMJRefreshManager endRefresh:self.listTableView];
        
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
        [FWMJRefreshManager endRefresh:self.listTableView];
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DistributionCell *cell =[tableView dequeueReusableCellWithIdentifier:@"DistributionCell"];
    if (_dataArray.count)
    {
        LiveDataModel *model = _dataArray[indexPath.row];
        [cell setCellWithModel:model];
    }
    return cell;
}



@end
