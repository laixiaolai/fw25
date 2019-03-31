//
//  SContributionView.m
//  FanweApp
//
//  Created by 丁凯 on 2017/9/5.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "SContributionView.h"
#import "LeaderboardTableViewCell.h"


@implementation SContributionView

- (id)initWithFrame:(CGRect)frame andDataType:(int)dataType andUserId:(NSString *)userId andLiveRoomId:(NSString *)liveRoomId
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.dataType = dataType;
        self.user_id  = userId;
        self.liveRoom_id = liveRoomId;
        self.userArray = [[NSMutableArray alloc]init];
        self.dataArray = [[NSMutableArray alloc]init];
        self.backgroundColor = kBackGroundColor;
        [self creatMyUI];
//        [self loadDataWithType:dataType andPage:1];
    }
    return self;
}

- (void)creatMyUI
{
    self.headView  = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, 25*kScaleHeight)];
    self.SHeadView.backgroundColor = kBackGroundColor;
    self.SHeadView = [[UIView alloc]initWithFrame:CGRectMake(self.headView.width/2 -10, 5*kScaleHeight, 20, 20*kScaleHeight)];
    [self.headView addSubview:self.SHeadView];
    self.headImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, (self.headView.height-13)/2, 15, 13)];
    self.headImgView.image = [UIImage imageNamed:@"hm_top_ticket"];
    [self.SHeadView addSubview:self.headImgView];
    
    self.headLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.headImgView.frame)+5, 0, self.headView.width-self.headImgView.width-5, self.headView.height)];
    self.headLabel.textColor = kAppGrayColor1;
    self.headLabel.font = [UIFont systemFontOfSize:12];
    [self.SHeadView addSubview:self.headLabel];
    
    self.LeaderHeadV = [[SLeaderHeadView alloc]initWithFrame:CGRectMake(0, 0, self.width,170*kScaleHeight)];
    FWWeakify(self)
    [self.LeaderHeadV setLeadBlock:^(int imgaeIdnex){
        FWStrongify(self)
        if (imgaeIdnex < self.dataArray.count)
        {
            UserModel *model = self.dataArray[imgaeIdnex];
            [self goTomyDelegateWithModel:model];
        }
        
    }];
    _myTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    _myTableview.backgroundColor = kBackGroundColor;
    _myTableview.dataSource = self;
    _myTableview.delegate = self;
    _myTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:_myTableview];
    
    [FWMJRefreshManager refresh:_myTableview target:self headerRereshAction:@selector(headerReresh) shouldHeaderBeginRefresh:YES footerRereshAction:@selector(footerReresh) refreshFooterType:@"MJRefreshBackNormalFooter"];
}

- (void)headerReresh
{
    [self loadDataWithType:self.dataType andPage:1];
}

- (void)footerReresh
{
    if (_has_next == 1)
    {
        _currentPage ++;
        [self loadDataWithType:self.dataType andPage:1];
    }
    else
    {
        [FWMJRefreshManager endRefresh:_myTableview];
    }
}

- (void)loadDataWithType:(int)dataType andPage:(int)page
{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"video" forKey:@"ctl"];
    [parmDict setObject:@"cont" forKey:@"act"];
    if (self.dataType == 1)
    {
        if (self.liveRoom_id)
        {
            [parmDict setObject:self.liveRoom_id forKey:@"room_id"];
        }
    }else
    {
        if (self.user_id)
        {
            [parmDict setObject:self.user_id forKey:@"user_id"];
        }
    }
    [parmDict setObject:@(page) forKey:@"p"];
    FWWeakify(self)
    [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
        FWStrongify(self)
        if ([responseJson toInt:@"status"] == 1)
        {
            [_userArray removeAllObjects];
            //用户信息
            _currentPage = [responseJson toInt:@"page"];
            _has_next = [responseJson toInt:@"has_next"];
            if (_currentPage <= 1)
            {
                [_userArray removeAllObjects];
            }
            _total_num = [responseJson toInt:@"total_num"];
            
            //贡献榜的排名
            NSArray *array = [responseJson objectForKey:@"list"];
            if (array && [array isKindOfClass:[NSArray class]])
            {
                if (array.count > 0)
                {
                    for (NSDictionary *dict in array)
                    {
                        UserModel *model = [UserModel mj_objectWithKeyValues:dict];
                        [_userArray addObject:model];
                    }
                }
            }
            
            if (self.userArray.count)
            {
                [self disposeNOForThreeData];
                [self updateTopView];
                _myTableview.tableHeaderView = self.headView;
                [self hideNoContentViewOnView:self];
            }else
            {
                [self showNoContentViewOnView:self];
                self.myTableview.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, 0.01)];
            }
            [_myTableview reloadData];
        }
        [FWMJRefreshManager endRefresh:_myTableview];
        
    } FailureBlock:^(NSError *error) {
        FWStrongify(self)
        [FWMJRefreshManager endRefresh:self.myTableview];
    }];
}
- (void)disposeNOForThreeData
{
    if (self.dataArray.count)
    {
        [self.dataArray removeAllObjects];
    }
    
    for (int i = 0; i < 3; i ++)
    {
        [self addAndRemoveData];
    }
    [self.LeaderHeadV setMyViewWithMArr:self.dataArray andType:1 consumeType:0];
}

- (void)addAndRemoveData
{
    if (_userArray.count)
    {
        [_dataArray addObject:_userArray[0]];
        [_userArray removeObjectAtIndex:0];
    }
}

- (void)updateTopView
{
    CGFloat width =[[NSString stringWithFormat:@"%d%@",_total_num,self.fanweApp.appModel.ticket_name] sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}].width;
    CGRect rect  = self.headLabel.frame;
    rect.size.width = width;
    self.headLabel.frame = rect;
    
    CGRect rect1  = self.SHeadView.frame;
    rect1.size.width = width+20;
    rect1.origin.x   = (self.width-width-20)/2;
    self.SHeadView.frame = rect1;
    self.headLabel.text = [NSString stringWithFormat:@"%d%@",_total_num,self.fanweApp.appModel.ticket_name];
}

#pragma mark -UITableViewDelegate&UITableViewDataSource
//返回行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataArray.count)
    {
        return self.userArray.count +1;
    }else
    {
        return 0;
    }
}

//返回段数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//返回单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        static NSString *CellIdentifier1 = @"CellIdentifier1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = kBackGroundColor;
            [cell addSubview:self.LeaderHeadV];
        }
        return cell;
        
    }else
    {
        LeaderboardTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"LeaderboardTableViewCell"];
        if (!cell)
        {
            cell = [[NSBundle mainBundle] loadNibNamed:@"LeaderboardTableViewCell" owner:nil options:nil].firstObject;
        }
        UserModel *model = self.userArray[indexPath.row-1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell createCellWithModel:model withRow:(int)indexPath.row-1 withType:0];
        cell.ticketLabel.text = [NSString stringWithFormat:@"消费%@%@",model.use_ticket,self.fanweApp.appModel.ticket_name];
        return cell;
    }
}
//返回cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return self.LeaderHeadV.height;
    }else
    {
        return 65*kAppRowHScale;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row > 0)
    {
        if (indexPath.row -1 < self.userArray.count)
        {
            UserModel *model = self.userArray[indexPath.row-1];
            [self goTomyDelegateWithModel:model];
        }
    }
}

- (void)goTomyDelegateWithModel:(UserModel *)model
{
    if (self.CDelegate)
    {
        if ([self.CDelegate respondsToSelector:@selector(goToHomeWithModel:)])
        {
            [self.CDelegate goToHomeWithModel:model];
        }
    }
}


@end
