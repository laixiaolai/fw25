//
//  SHomeLiveV.m
//  FanweApp
//
//  Created by 丁凯 on 2017/8/26.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "SHomeLiveV.h"
#import "MainLiveTableViewCell.h"

@implementation SHomeLiveV

- (instancetype)initWithFrame:(CGRect)frame andUserId:(NSString *)userId
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = kBackGroundColor;
        self.user_id = userId;
        [self creatMainView];
        [self loadNewNetDataWithPage:1];
        [self loadHotNetDataWithPage:1];
    }
    return self;
}

- (void)creatMainView
{
    self.liveTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, kScreenW, self.height)];
    self.liveTableView.backgroundColor = kBackGroundColor;
    self.liveTableView.dataSource = self;
    self.liveTableView.delegate = self;
    self.liveTableView.tableHeaderView = self.newestOrHotView;
    self.liveTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:self.liveTableView];
    [self.liveTableView registerNib:[UINib nibWithNibName:@"MainLiveTableViewCell" bundle:nil] forCellReuseIdentifier:@"MainLiveTableViewCell"];
    [FWMJRefreshManager refresh:_liveTableView target:self headerRereshAction:nil footerRereshAction:@selector(footerRereshing)];
}

#pragma mark  尾部刷新
- (void)footerRereshing
{
    if (_has_next == 1)
    {
        self.currentPage ++;
        if (self.newOrHotType == 0)
        {
            [self loadNewNetDataWithPage:self.currentPage];
        }else
        {
            [self loadHotNetDataWithPage:self.currentPage];
        }
    }else
    {
        [FWMJRefreshManager endRefresh:self.liveTableView];
        return;
    }
}

#pragma mark  最新
- (void)loadNewNetDataWithPage:(int)page
{
    NSMutableDictionary *parmDict = [[NSMutableDictionary alloc]init];
    [parmDict setObject:@"user" forKey:@"ctl"];
    if (self.user_id)
    {
        [parmDict setObject:self.user_id forKey:@"to_user_id"];
    }
    [parmDict setObject:@"user_review" forKey:@"act"];
    [parmDict setObject:@"0" forKey:@"sort"];
    [parmDict setObject:[NSString stringWithFormat:@"%d",page] forKey:@"p"];
    FWWeakify(self)
    [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
        
        FWStrongify(self)
        if ([responseJson toInt:@"status"] == 1)
        {
            self.currentPage = [responseJson toInt:@"page"];
            self.has_next = [responseJson toInt:@"has_next"];
            self.newHotLabel.text = [NSString stringWithFormat:@"共%d个精彩回放",[responseJson toInt:@"count"]];
            if ([responseJson toInt:@"page"] <= 1)
            {
                [self.newestArray removeAllObjects];
            }
            NSArray *array = [responseJson objectForKey:@"list"];
            if (array)
            {
                if (array.count > 0)
                {
                    for (NSDictionary *dict in array)
                    {
                        SenderModel *model = [SenderModel mj_objectWithKeyValues:dict];
                        [self.newestArray addObject:model];
                    }
                }
            }
            
            if (!self.newestArray.count)
            {
                [self showNoContentViewOnView:self.liveTableView];
            }else
            {
                 [self hideNoContentViewOnView:self.liveTableView];
            }
            [self.liveTableView reloadData];
        }
        [FWMJRefreshManager endRefresh:self.liveTableView];
        
    } FailureBlock:^(NSError *error) {
        
        FWStrongify(self)
        [FWMJRefreshManager endRefresh:self.liveTableView];
        
    }];
}

#pragma mark  最热
- (void)loadHotNetDataWithPage:(int)page
{
    NSMutableDictionary *parmDict = [[NSMutableDictionary alloc]init];
    [parmDict setObject:@"user" forKey:@"ctl"];
    if (self.user_id)
    {
        [parmDict setObject:self.user_id forKey:@"to_user_id"];
    }
    [parmDict setObject:@"user_review" forKey:@"act"];
    [parmDict setObject:@"1" forKey:@"sort"];
    [parmDict setObject:[NSString stringWithFormat:@"%d",page] forKey:@"p"];
    FWWeakify(self)
    [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson)
     {
         FWStrongify(self)
         if ([responseJson toInt:@"status"] == 1)
         {
             self.currentPage = [responseJson toInt:@"page"];
             self.has_next = [responseJson toInt:@"has_next"];
             self.newHotLabel.text = [NSString stringWithFormat:@"共%d个精彩回放",[responseJson toInt:@"count"]];
             if ([responseJson toInt:@"page"] <= 1)
             {
                 [self.hotArray removeAllObjects];
             }
             NSArray *array = [responseJson objectForKey:@"list"];
             if (array)
             {
                 if (array.count > 0)
                 {
                     for (NSDictionary *dict in array)
                     {
                         SenderModel *model = [SenderModel mj_objectWithKeyValues:dict];
                         [self.hotArray addObject:model];
                     }
                 }
             }
             if (self.isCouldLiveData)
             {
                 [self.liveTableView reloadData];
                 if (!self.hotArray.count)
                 {
                     [self hideNoContentViewOnView:self.liveTableView];
                 }else
                 {
                     [self showNoContentViewOnView:self.liveTableView];
                 }
             }
         }
         [FWMJRefreshManager endRefresh:self.liveTableView];
         
     } FailureBlock:^(NSError *error)
     {
         [FWMJRefreshManager endRefresh:self.liveTableView];
         NSLog(@"error==%@",error);
     }];
}

#pragma mark -UITableViewDelegate&UITableViewDataSource
//返回段数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
//返回行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.newOrHotType == 0)//最新
    {
        return self.newestArray.count;
    }else //最热
    {
        return self.hotArray.count;
    }
}
//返回cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55*kAppRowHScale;
}

//返回单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int newRow = (int)indexPath.row;
    MainLiveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MainLiveTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.newOrHotType == 0)
    {
        if (indexPath.row < self.newestArray.count)
        {
            SenderModel *model = self.newestArray[newRow];
            [cell creatCellWithModel:model];
        }
    }else
    {
        if (indexPath.row < self.hotArray.count)
        {
            SenderModel *model = self.hotArray[newRow];
            [cell creatCellWithModel:model];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.fanweApp.liveState.roomId intValue]>0)
    {
        [FanweMessage alert:@"当前有视频正在播放"];
    }
    else
    {
        UserModel *liveModel;
        if (self.newOrHotType == 0)
        {
            if (indexPath.row < self.newestArray.count)
            {
                liveModel = self.newestArray[indexPath.row];
            }
        }else if (self.newOrHotType == 1)
        {
            if (indexPath.row < self.hotArray.count)
            {
                liveModel = self.hotArray[indexPath.row];
            }
        }
        if (self.LDelegate)
        {
            [self.LDelegate goToLiveRoomWithModel:liveModel andView:self];
        }
    }
}

#pragma mark 最新和最热的点击事件
- (void)NHBtnClick:(UIButton *)btn
{
    for (UIButton *newBtn in self.newestOrHotView.subviews)
    {
        if ([newBtn isKindOfClass:[UIButton class]])
        {
            if (newBtn.tag ==btn.tag)
            {
                [newBtn setTitleColor:kAppGrayColor1 forState:0];
            }else
            {
                [newBtn setTitleColor:kAppGrayColor3 forState:0];
            }
        }
    }
    self.isCouldLiveData = YES;
    self.newOrHotType = (int)btn.tag;
    [self.liveTableView reloadData];
    if (self.newOrHotType == 0)
    {
        [self loadNewNetDataWithPage:1];
    }else
    {
        [self loadHotNetDataWithPage:1];
    }
}

#pragma mark  最新和最热的界面
- (UIView *)newestOrHotView
{
    if (!_newestOrHotView)
    {
        _newestOrHotView = [[UIView alloc]initWithFrame:CGRectMake(0,0,kScreenW,50)];
        _newestOrHotView.backgroundColor = kBackGroundColor;
        
        [_newestOrHotView addSubview:self.newHotLabel];
        NSArray *array2 = [[NSArray alloc]initWithObjects:@"最新",@"最热", nil];
        for (int i= 0; i < 2; i ++)
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];;
            button.frame = CGRectMake(kScreenW*3/4+kScreenW*i/8, 0, kScreenW/8, 50);
            [button setTitle:array2[i] forState:0];
            button.titleLabel.font = [UIFont systemFontOfSize:12];
            button.tag = i;
            [button addTarget:self action:@selector(NHBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [_newestOrHotView addSubview:button];
            if (i == self.newOrHotType)
            {
                [button setTitleColor:kAppGrayColor1 forState:0];
            }else
            {
                [button setTitleColor:kAppGrayColor3 forState:0];
            }
        }
    }
    return _newestOrHotView;
}

- (UILabel *)newHotLabel
{
    if (!_newHotLabel)
    {
        _newHotLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, kScreenW/3, 49)];
        _newHotLabel.font = [UIFont systemFontOfSize:12];
        _newHotLabel.textColor = kAppGrayColor1;
    }
    return _newHotLabel;
}

- (NSMutableArray *)hotArray
{
    if (!_hotArray)
    {
        _hotArray = [[NSMutableArray alloc]init];
    }
    return _hotArray;
}

- (NSMutableArray *)newestArray
{
    if (!_newestArray)
    {
        _newestArray = [[NSMutableArray alloc]init];
    }
    return _newestArray;
}

@end
