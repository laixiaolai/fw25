//
//  FocusOnViewController.m
//  FanweApp
//
//  Created by GuoMs on 16/7/4.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "FocusOnViewController.h"
#import "HMHotItemModel.h"
#import "HMHotTableViewCell.h"

NS_ENUM(NSInteger ,FocusOnViewTableView)
{
    FWFocusOnZeroSection,                 //广告图
    FWFocusOnFirstSection,                //热门定位
    FWFocusOnTab_Count,
};

static NSString *const cellReuseIdentifier0 = @"cellReuseIdentifie0";
static NSString *const cellReuseIdentifier1 = @"cellReuseIdentifier1";
static NSString *const cellReuseIdentifier2 = @"cellReuseIdentifier2";

@interface FocusOnViewController ()<UITableViewDelegate,UITableViewDataSource,HMHotTableViewCellDelegate,playToMainDelegate>
{
    NSString                       *_sexString;
    NSString                       *_areaString;
}

@property (nonatomic, strong) NSMutableArray   *dataArr;
@property (nonatomic, strong) NSMutableArray   *dataSource;
@property (nonatomic, assign) CGFloat          heigth;
@property (nonatomic, strong) UITableView     *tableView;

@end

@implementation FocusOnViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = kBackGroundColor;
    
    CGRect tmpFrame;
    if (_tableViewFrame.size.height)
    {
        tmpFrame = _tableViewFrame;
    }
    else
    {
        tmpFrame = CGRectMake(0, 0, kScreenW, self.view.frame.size.height);
    }
    
    _tableView = [[UITableView alloc]initWithFrame:tmpFrame];
    [self.view addSubview:_tableView];
    _tableView.backgroundColor = kBackGroundColor;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:@"HMHotTableViewCell" bundle:nil] forCellReuseIdentifier:cellReuseIdentifier0];
    [_tableView registerNib:[UINib nibWithNibName:@"PlaybackTableViewCell" bundle:nil] forCellReuseIdentifier:cellReuseIdentifier2];
    
    [FWMJRefreshManager refresh:_tableView target:self headerRereshAction:@selector(refresherOfFocusOn) footerRereshAction:nil];
    
    // 刷新该页面（主要为了删除最新页已经退出的直播间）
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshHome:) name:kRefreshHomeItem object:nil];
}

#pragma mark 刷新
- (void)refresherOfFocusOn
{
    [self requestNetWorking];
}

#pragma mark ========================通知=========================
- (void)willViewApprer:(NSNotification *)not
{
    NSMutableDictionary *dict = [NSMutableDictionary new];
    dict = [not valueForKey:@"userInfo"];
    NSString *str = dict[@"refresh"];
    if ( [str isEqualToString:@"yes"])
    {
        [self requestNetWorking];
    }
}

- (void)refreshHome:(NSNotification *)noti
{
    if (noti)
    {
        NSDictionary *tmpDict = (NSDictionary *)noti.object;
        NSString *room_id = [tmpDict toString:@"room_id"];
        
        @synchronized (self.dataArr)
        {
            NSMutableArray *tmpArray = self.dataArr;
            for (HMHotItemModel *model in tmpArray)
            {
                if ([model.room_id isEqualToString:room_id])
                {
                    [tmpArray removeObject:model];
                    self.dataArr = tmpArray;
                    [_tableView reloadData];
                    return;
                }
            }
        }
    }
}

#pragma mark NetWorking
- (void)requestNetWorking
{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"index" forKey:@"ctl"];
    [parmDict setObject:@"focus_video" forKey:@"act"];
    FWWeakify(self)
    [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson)
     {
         FWStrongify(self)
         //关注好友的直播
         if ([responseJson toInt:@"status"] == 1)
         {
             NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
             [self.dataArr removeAllObjects];
             arr = responseJson[@"list"];
             if ([arr isKindOfClass:[NSArray class]])
             {
                 if (arr.count > 0)
                 {
                     for (NSDictionary *dic in arr)
                     {
                         HMHotItemModel *model = [HMHotItemModel mj_objectWithKeyValues:dic];
                         [self.dataArr addObject:model];
                     }
                 }
             }
             //精彩回放
             NSMutableArray *sourcearr = [NSMutableArray arrayWithCapacity:0];
             sourcearr = responseJson[@"playback"];
             [self.dataSource removeAllObjects];
             if ([sourcearr isKindOfClass:[NSArray class]])
             {
                 if (sourcearr.count > 0)
                 {
                     for (NSDictionary *dic in sourcearr)
                     {
                         HMHotItemModel *model = [HMHotItemModel mj_objectWithKeyValues:dic];
                         [self.dataSource addObject:model];
                     }
                 }
             }
             [self.tableView reloadData];
             
             if (!self.dataArr.count && !self.dataSource.count)
             {
                 [self showNoContentView];
             }
             else
             {
                 [self hideNoContentView];
             }
         }
         
         [FWMJRefreshManager endRefresh:self.tableView];
         
     } FailureBlock:^(NSError *error){
         
         FWStrongify(self)
         [FWMJRefreshManager endRefresh:self.tableView];
         
     }];
}


#pragma mark - ----------------------- 代理 -----------------------
#pragma mark 点击跳转到话题
- (void)pushToTopic:(NSInteger)rowIndex
{
    if ([self.dataArr count] > rowIndex)
    {
        HMHotItemModel *tmpModel = [self.dataArr objectAtIndex:rowIndex];
        HMHotViewController *tmpController = [[HMHotViewController alloc]init];
        tmpController.topicName = tmpModel.title;
        tmpController.cate_id = tmpModel.cate_id;
        [[AppDelegate sharedAppDelegate] pushViewController:tmpController];
    }
}

#pragma mark 点击用户头像
- (void)clickUserIcon:(NSInteger)rowIndex
{
    if ([self.delegate respondsToSelector:@selector(goToMainPage:)])
    {
        if ([self.dataArr count] > rowIndex)
        {
            HMHotItemModel *tmpModel = [self.dataArr objectAtIndex:rowIndex];
            [self.delegate goToMainPage:tmpModel.user_id];
        }
    }
}

#pragma mark 回放点击头像进入主页
- (void)handleWithPlayBackMainPage:(UITapGestureRecognizer *)sender index:(NSInteger)tag
{
    if ([self.delegate respondsToSelector:@selector(goToMainPage:)])
    {
        HMHotItemModel *tmpModel = [self.dataSource objectAtIndex:tag];
        [self.delegate goToMainPage:tmpModel.user_id];
    }
}

#pragma mark push到最新直播的点击事件
- (void)clickToNewsAction:(UIButton *)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(goToNewestView)])
    {
        [_delegate goToNewestView];
    }
}


#pragma mark - ----------------------- Table view data source -----------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return FWFocusOnTab_Count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == FWFocusOnZeroSection)
    {
        if (self.dataArr.count)
        {
            return self.dataArr.count;
        }
        else
        {
            return 0;
        }
    }
    else
    {
        if (self.dataSource.count)
        {
            return self.dataSource.count;
        }
        else
        {
            return 0;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == FWFocusOnZeroSection)
    {
        if (self.dataArr.count)
        {
            HMHotItemModel *model = self.dataArr[indexPath.row];
            if ([model.title isEqualToString:@""])
            {
                return kScreenW + 70;
            }
            else
            {
                return kScreenW + 110;
            }
        }
        else
        {
            return 106;
        }
    }
    else
    {
        return 60;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == FWFocusOnZeroSection)
    {
        if (self.dataArr.count)
        {
            HMHotTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier0 forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            if ([self.dataArr count] > indexPath.row)
            {
                HMHotItemModel *tmpModel = [self.dataArr objectAtIndex:indexPath.row];
                [cell initWidthModel:tmpModel rowIndex:indexPath.row];
            }
            return cell;
        }
        else
        {
            return nil;
        }
    }
    else
    {
        if (self.dataSource.count)
        {
            HMHotItemModel *model = self.dataSource[indexPath.row];
            PlaybackTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier2 forIndexPath:indexPath];
            cell.delegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setValueForCell:model index:indexPath.row];
            return cell;
        }
        else
        {
            return nil;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (indexPath.section == FWFocusOnZeroSection)
    {
        if (self.dataArr.count > indexPath.row)
        {
            HMHotItemModel *model = self.dataArr[indexPath.row];
            [self joinOtherLivingRoom:model];
        }
    }
    else
    {
        if (self.dataSource.count > indexPath.row)
        {
            HMHotItemModel *model = self.dataSource[indexPath.row];
            model.live_in = FW_LIVE_STATE_RELIVE;
            [self joinOtherLivingRoom:model];
        }
    }
}

#pragma mark -- 返回分区区头
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        if (self.dataArr.count)
        {
            UILabel *textLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 180, 30)];
            textLable.text = @"关注好友的直播";
            textLable.font = [UIFont systemFontOfSize:13];
            textLable.backgroundColor = kBackGroundColor;
            UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 30)];
            headerView.backgroundColor = kBackGroundColor;
            [headerView addSubview:textLable];
            return headerView;
        }
        else
        {
            return nil;
        }
    }
    else
    {
        if (self.dataSource.count)
        {
            UILabel *textLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 180, 30)];
            textLable.text = @"精彩回放";
            textLable.font = [UIFont systemFontOfSize:13];
            UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 30)];
            [headerView addSubview:textLable];
            return headerView;
        }
        else
        {
            return nil;
        }
    }
    return nil;
}

#pragma mark 返回区头的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == FWFocusOnZeroSection)
    {
        if (self.dataArr.count)
        {
            return 30;
        }
        else
        {
            return 0;
        }
    }
    else
    {
        if (self.dataSource.count>0)
        {
            return 30;
        }
        else
        {
            return 0;
        }
    }
}

#pragma mark 加入直播间
- (void)joinOtherLivingRoom:(HMHotItemModel *)model
{
    if (![FWUtils isNetConnected])
    {
        return;
    }
    if ([IMAPlatform sharedInstance].host)
    {
        TCShowLiveListItem *liveRoom = [[TCShowLiveListItem alloc]init];
        liveRoom.chatRoomId = model.group_id;
        liveRoom.avRoomId = [model.room_id intValue];
        liveRoom.title = model.room_id;
        liveRoom.vagueImgUrl = model.head_image;
        
        TCShowUser *showUser = [[TCShowUser alloc]init];
        showUser.uid = model.user_id;
        showUser.avatar = model.head_image;
        showUser.username = model.nick_name;
        liveRoom.host = showUser;
        
        if (model.live_in == FW_LIVE_STATE_ING)
        {
            liveRoom.liveType = FW_LIVE_TYPE_AUDIENCE;
        }
        else if (model.live_in == FW_LIVE_STATE_RELIVE)
        {
            liveRoom.liveType = FW_LIVE_TYPE_RELIVE;
        }
        
        BOOL isSusWindow = [[LiveCenterManager sharedInstance] judgeIsSusWindow];
        [[LiveCenterManager sharedInstance]  showLiveOfAudienceLiveofTCShowLiveListItem:liveRoom isSusWindow:isSusWindow isSmallScreen:NO block:^(BOOL finished) {
        }];
    }
    else
    {
        [[FWHUDHelper sharedInstance] loading:@"" delay:2 execute:^{
            [[FWIMLoginManager sharedInstance] loginImSDK:YES succ:nil failed:nil];
        } completion:^{
            
        }];
    }
}


#pragma mark - ----------------------- GET方法 -----------------------
- (NSMutableArray *)dataArr
{
    if (!_dataArr)
    {
        self.dataArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArr;
}

- (NSMutableArray *)dataSource
{
    if (!_dataSource)
    {
        self.dataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSource;
}

@end
