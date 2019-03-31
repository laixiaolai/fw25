//
//  SFeeRecordV.m
//  FanweApp
//
//  Created by 丁凯 on 2017/8/29.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "SFeeRecordV.h"
#import "ChargerTableViewCell.h"
#import "LiveDataModel.h"

@implementation SFeeRecordV

- (instancetype)initWithFrame:(CGRect)frame andfeeType:(int)feeType andRecordType:(int)recordType
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = kBackGroundColor;
        self.myFeeType       = feeType;
        self.myRecordType    = recordType;
        [self creatMianView];
    }
    return self;
}

- (void)creatMianView
{
    self.listTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,10, kScreenW, self.height-10)];
    self.listTableView.delegate =self;
    self.listTableView.dataSource =self;
    self.listTableView.backgroundColor = kBackGroundColor;
    self.listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:self.listTableView];
    [self.listTableView registerNib:[UINib nibWithNibName:@"ChargerTableViewCell" bundle:nil] forCellReuseIdentifier:@"ChargerTableViewCell"];
    [FWMJRefreshManager refresh:self.listTableView target:self headerRereshAction:@selector(headerReresh) footerRereshAction:@selector(footerReresh)];
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
        [self loadDataWithPage:self.page];
    }
    else
    {
        [FWMJRefreshManager endRefresh:self.listTableView];
    }
}

- (void)loadDataWithPage:(int)page
{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"live" forKey:@"ctl"];
    [parmDict setObject:@"pay_cont" forKey:@"act"];
    [parmDict setObject:[NSString stringWithFormat:@"%d",page] forKey:@"p"];
    [parmDict setObject:@(self.myFeeType) forKey:@"live_pay_type"];
    [parmDict setObject:@(self.myRecordType) forKey:@"type"];
    FWWeakify(self)
    [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson)
     {
         FWStrongify(self)
         [FWMJRefreshManager endRefresh:_listTableView];
         if ([responseJson toInt:@"status"] == 1)
         {
             self.page = [[responseJson objectForKey:@"page"]toInt:@"page"];
             if (self.page < 2)
             {
                 [self.dataArray removeAllObjects];
             }
             self.has_next = [[responseJson objectForKey:@"page"]toInt:@"has_next"];
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
             if (self.dataArray.count)
             {
                 [self hideNoContentViewOnView:self];
             }else
             {
                 [self showNoContentViewOnView:self];
             }
             [self.listTableView reloadData];
         }
        
         [FWMJRefreshManager endRefresh:self.listTableView];
         
     } FailureBlock:^(NSError *error)
     {
         FWStrongify(self)
         [FWMJRefreshManager endRefresh:self.listTableView];
     }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChargerTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"ChargerTableViewCell"];
    LiveDataModel *model = self.dataArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == _dataArray.count -1)
    {
        cell.lineView.hidden = YES;
    }
    [cell setCellWithDict:model andType:self.myRecordType andLive_pay_type:self.myFeeType];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.dataArray.count)
    {
        LiveDataModel *model = _dataArray[indexPath.row];
        if (self.feeRecordBlock)
        {
            self.feeRecordBlock(model.user_id);
        }
    }
}

//- (FWNoContentView *)noContentView
//{
//    if (!_noContentView)
//    {
//        _noContentView = [FWNoContentView noContentWithFrame:CGRectMake(0, 0, 150, 175)];
//        _noContentView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
//    }
//    return _noContentView;
//}

- (NSMutableArray *)dataArray
{
    if (!_dataArray)
    {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

//- (void)showNoContentView
//{
//    [self addSubview:self.noContentView];
//}
//
//- (void)hideNoContentView
//{
//    [self.noContentView removeFromSuperview];
//    self.noContentView = nil;
//}

@end
