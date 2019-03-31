//
//  OnLiveViewController.m
//  FanweApp
//
//  Created by fanwe2014 on 16/6/22.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "OnLiveViewController.h"
#import "MBProgressHUD.h"
#import "SenderModel.h"
#import "MainLiveTableViewCell.h"

@interface OnLiveViewController ()<UITableViewDelegate,UITableViewDataSource,MBProgressHUDDelegate>
{
    UITableView *_myTableView;
    NSMutableArray *_dataArray;
    int _has_next;
    int _currentPage;
    int _state;
    UIView *_view2;
    UILabel *_liveLabel;
    UIButton *_lastButton2;
    int _sortState;
    int _page;
    int _status;
    int _count;
    
}
@end

@implementation OnLiveViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"我的回播";
    self.navigationItem.leftBarButtonItem=[UIBarButtonItem itemWithTarget:self action:@selector(backClick) image:@"com_arrow_vc_back" highImage:@"com_arrow_vc_back"];
    _dataArray = [[NSMutableArray alloc]init];
    _currentPage= 1;
    _sortState = 0;
    [self creatView];
}

- (void)creatView{
    
    //最新和最热的界面
    _view2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 50)];
    _view2.backgroundColor = [UIColor whiteColor];
    
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0, 49, kScreenW, 1)];
    view2.backgroundColor = myTextColorLine5;
    [_view2 addSubview:view2];
    
    _liveLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, kScreenW/3, 50)];
    _liveLabel.font = [UIFont systemFontOfSize:14];
    _liveLabel.textColor = kAppGrayColor1;
    [_view2 addSubview:_liveLabel];
    
    NSArray *array2 = [[NSArray alloc]initWithObjects:@"最新",@"最热", nil];
    for (int i= 0; i < 2; i ++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(kScreenW*3/4+kScreenW*i/8, 0, kScreenW/8, 50);
        [button setTitle:array2[i] forState:0];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        if (i == 0)
        {
            [button setTitleColor:kAppGrayColor1 forState:0];
        }else
        {
            [button setTitleColor:kAppGrayColor3 forState:0];
        }
        button.tag = 100+i;
        [button addTarget:self action:@selector(buttonClick2:) forControlEvents:UIControlEventTouchUpInside];
        [_view2 addSubview:button];
    }
    
    _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-kStatusBarHeight-kNavigationBarHeight)];
    _myTableView.backgroundColor = kBackGroundColor;
    _myTableView.dataSource = self;
    _myTableView.delegate = self;
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_myTableView registerNib:[UINib nibWithNibName:@"MainLiveTableViewCell" bundle:nil] forCellReuseIdentifier:@"MainLiveTableViewCell"];
    [self.view addSubview:_myTableView];
    
    [FWMJRefreshManager refresh:_myTableView target:self headerRereshAction:@selector(headerReresh) footerRereshAction:@selector(footerReresh)];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)backClick
{
    [[AppDelegate sharedAppDelegate]popViewController];
}

//最新和最热的点击事件
- (void)buttonClick2:(UIButton *)button
{
    for (UIButton *btn in _view2.subviews)
    {
        if ([btn isKindOfClass:[UIButton class]])
        {
            if (btn.tag == button.tag)
            {
                [btn setTitleColor:kAppGrayColor1 forState:UIControlStateNormal];
            }else
            {
                [btn setTitleColor:kAppGrayColor3 forState:UIControlStateNormal];
            }
        }
    }
    _sortState = (int)button.tag -100;
    [self loadNetDataWithPage:1];
}

- (void)headerReresh
{
    [self loadNetDataWithPage:1];
}

- (void)footerReresh
{
    if (_has_next == 1)
    {
        _page ++;
        [self loadNetDataWithPage:_page];
    }
    else
    {
        [FWMJRefreshManager endRefresh:_myTableView];
    }
}

//数据加载
- (void)loadNetDataWithPage:(int)page
{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"user" forKey:@"ctl"];
    if (self.user_id)
    {
        [parmDict setObject:self.user_id forKey:@"to_user_id"];
    }
    [parmDict setObject:@"user_review" forKey:@"act"];
    [parmDict setObject:[NSString stringWithFormat:@"%d",_sortState] forKey:@"sort"];
    [parmDict setObject:[NSString stringWithFormat:@"%d",page] forKey:@"p"];
    FWWeakify(self)
    [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
        
        FWStrongify(self)
        if ([responseJson toInt:@"status"] == 1)
        {
            _page = [responseJson toInt:@"page"];
            if (_page == 1 || _page == 0)
            {
                _count = [responseJson toInt:@"count"];
            }
            _status = [responseJson toInt:@"status"];
            if (_page == 1)
            {
                [_dataArray removeAllObjects];
            }
            _has_next = [responseJson toInt:@"has_next"];
            _liveLabel.text = [NSString stringWithFormat:@"%d个精彩回放",_count];
            NSArray *array = [responseJson objectForKey:@"list"];
            if (array)
            {
                if (array.count > 0)
                {
                    for (NSDictionary *dict in array)
                    {
                        //UserModel *model = [UserModel mj_objectWithKeyValues:dict];SenderModel
                        SenderModel *model = [SenderModel mj_objectWithKeyValues:dict];
                        [_dataArray addObject:model];
                    }
                }
            }
            if (_dataArray.count > 0)
            {
                [self hideNoContentView];
            }
            else
            {
                [self showNoContentView];
            }
            [self.myTableView reloadData];
        }else
        {
            [FanweMessage alertHUD:[responseJson toString:@"error"]];
        }
        [FWMJRefreshManager endRefresh:_myTableView];
        
    } FailureBlock:^(NSError *error)
     {
         [FWMJRefreshManager endRefresh:_myTableView];
     }];
}

#pragma mark -UITableViewDelegate&UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_dataArray.count > 0)
    {
        return _dataArray.count;
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
    //通过复用id(reusedID)来寻找,只有同种类型的cell才能算找到
    if (_dataArray.count > 0 && indexPath.row < _dataArray.count)
    {
        MainLiveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MainLiveTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UserModel *model = _dataArray[indexPath.row];
        [cell creatCellWithModel:model];
        return  cell;
    }else
    {
        return nil;
    }
}
//返回cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

//段头
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return _view2;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_dataArray.count > 0 && _dataArray.count > indexPath.row)
    {
        if ([self checkUser:[IMAPlatform sharedInstance].host])
        {
            SenderModel *model = _dataArray[indexPath.row];
            TCShowUser *user = [[TCShowUser alloc] init];
            user.avatar = model.head_image;
            user.uid = model.user_id;
            user.username = model.nick_name;
            
            TCShowLiveListItem *liveRoom = [[TCShowLiveListItem alloc] init];
            liveRoom.liveType = 1;
            liveRoom.host = user;
            liveRoom.avRoomId = [model.id intValue];
            liveRoom.title = model.id;
            liveRoom.vagueImgUrl = model.head_image;
            
            [[LiveCenterManager sharedInstance] showLiveOfAudienceLiveofTCShowLiveListItem:liveRoom isSusWindow:NO isSmallScreen:NO block:^(BOOL finished) {
            }];
            
        }else
        {
            [[FWHUDHelper sharedInstance] loading:@"" delay:2 execute:^{
                [[FWIMLoginManager sharedInstance] loginImSDK:YES succ:nil failed:nil];
            } completion:^{
                
            }];
        }
    }
}

//删除操作,需要两个代理方法配合使用
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //indexPath 就是删除的位置,通过代理方法,给我们了
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        //1.数据源删除
        SenderModel *model = _dataArray[indexPath.row];
        NSMutableDictionary *dictM = [[NSMutableDictionary alloc]init];
        [dictM setObject:@"video" forKey:@"ctl"];
        [dictM setObject:@"del_video_history" forKey:@"act"];
        [dictM setObject:[NSString stringWithFormat:@"%@",model.id] forKey:@"room_id"];
        [self.httpsManager POSTWithParameters:dictM SuccessBlock:^(NSDictionary *responseJson)
         {
             [self loadNetDataWithPage:1];
             if ([responseJson toInt:@"status"] == 1)
             {
                 [[FWHUDHelper sharedInstance] tipMessage:@"删除回播视频成功"];
             }
             
         } FailureBlock:^(NSError *error)
         {
             [[FWHUDHelper sharedInstance] tipMessage:@"删除回播视频失败，请重新操作"];
         }];
    }
}

//返回编辑类型.是增加还是删除
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)checkUser:(id<IMHostAble>)user
{
    if (![user conformsToProtocol:@protocol(AVUserAble)])
    {
        return NO;
    }
    return YES;
}


@end
