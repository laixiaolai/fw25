//
//  SHomePageVC.m
//  FanweApp
//
//  Created by 丁凯 on 2017/7/4.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "SHomePageVC.h"
#import "MainPageView.h"
#import "HPContributionCell.h"
#import "MJRefresh.h"
#import "MainLiveTableViewCell.h"
#import "FollowerViewController.h"
#import "GetHeadImgViewController.h"
#import "SSaveHeadViewVC.h"
#import "MPCHeadView.h"
#import "SHomeSVideoV.h"
#import "SHomeLiveV.h"
#import "SHomeInfoV.h"
#import "FWVideoDetailController.h"


@interface SHomePageVC ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,privateLetterDelegate,videoDeleGate,LiveDeleGate>

@property ( nonatomic, strong) MainPageView         *bottomView;                   //底部的view
@property ( nonatomic, strong) UIView               *homeOrLiveView;               //主页 直播 小视频的view
@property ( nonatomic, strong) UIView               *HLineView1;                   //横线1
@property ( nonatomic, strong) UIView               *VLineView;                    //竖线1
@property ( nonatomic, strong) UIView               *newestOrHotView;              //最新 最热的view
@property ( nonatomic, strong) NSMutableArray       *imageArray;                   //贡献右边显示的头像
@property ( nonatomic, strong) NSArray              *countArray;                   //主页信息的个数
@property ( nonatomic, strong) MPCHeadView          *myTableHeadView;              //myTableview的headView

@property ( nonatomic, strong) UITableView          *myTableView;                  //tableView
@property ( nonatomic, strong) NSDictionary         *liveDict;                     //进入直播的信息
@property ( nonatomic, strong) UserModel            *userModel;                    //用户信息的模型
@property ( nonatomic, assign) BOOL                 isCouldLiveData;               //是否可以加载
@property ( nonatomic, assign) int                  currentPage;                   //当前页
@property ( nonatomic, assign) int                  has_next;                      //是否还有下一页
@property ( nonatomic, assign) BOOL                 canClickItem;                  //防止重复点击
@property ( nonatomic, strong) UIScrollView         *myScrollView;                 //滚动的ScrollView
@property ( nonatomic, strong) SHomeInfoV           *homeInfoV;                    //主页的view
@property ( nonatomic, strong) SHomeLiveV           *homeLiveV;                    //直播的view
@property ( nonatomic, strong) SHomeSVideoV         *smallVideoV;                  //小视频的view
@property ( nonatomic, assign) NSInteger            startPage;                     //起始页

@end

@implementation SHomePageVC

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)initFWUI
{
    [super initFWUI];
    self.startPage  = 0;
    self.currentPage = 1;
    self.canClickItem = YES;
    [self.view addSubview:self.myTableView];
    if (![self.user_id isEqualToString:[IMAPlatform sharedInstance].host.imUserId])
    {
        [self.view addSubview:self.bottomView];
    }else
    {
        CGRect rect = self.myTableView.frame;
        rect.size.height = kScreenH;
        self.myTableView.frame = rect;
    }
}

- (void)initFWData
{
    [super initFWData];
    [self loadHomeNetWithPage:1];
    [self showMyHud];
}

#pragma mark  数据加载
//主页数据请求
- (void)loadHomeNetWithPage:(int)page
{
    NSMutableDictionary *parmDict = [[NSMutableDictionary alloc]init];
    [parmDict setObject:@"user" forKey:@"ctl"];
    if (self.user_id)
    {
        [parmDict setObject:self.user_id forKey:@"to_user_id"];
    }
    [parmDict setObject:@"user_home" forKey:@"act"];
    FWWeakify(self)
    [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
        
        FWStrongify(self)
        [self hideMyHud];
        if ([responseJson toInt:@"status"] == 1)
        {
            if ([responseJson objectForKey:@"user"] && [[responseJson objectForKey:@"user"] count])
            {
                self.user_headimg = [[responseJson objectForKey:@"user"] toString:@"head_image"];
                self.user_nickname = [[responseJson objectForKey:@"user"] toString:@"nick_name"];
                //                 [self changeAlaphViewUI];
            }
            //印票贡献前3名的图标
            NSArray *cuser_listArray = [responseJson objectForKey:@"cuser_list"];
            if (cuser_listArray)
            {
                if (cuser_listArray.count > 0 )
                {
                    for (NSDictionary *dict in cuser_listArray)
                    {
                        SenderModel *model = [SenderModel new];
                        model.head_image = [dict objectForKey:@"head_image"];
                        [self.imageArray addObject:model.head_image];
                    }
                }
            }
            //获取字典的个数
            NSDictionary *dict = [[responseJson objectForKey:@"user"] objectForKey:@"item"];
            if (dict)
            {
                if (dict.count > 0)
                {
                    self.countArray = [dict allKeys];
                }
            }
            self.bottomView.has_focus = [responseJson toInt:@"has_focus"];
            self.bottomView.has_black = [responseJson toInt:@"has_black"];
            [self.bottomView changeState];
            
            self.userModel = [UserModel mj_objectWithKeyValues:responseJson];
            [self.myTableHeadView setViewWithModel:self.userModel withUserId:self.user_id];
            self.liveDict = responseJson[@"video"];
            [self.myTableHeadView setUIWithDict:self.liveDict];
            [self.homeInfoV setViewWithArray:self.countArray andMDict:self.userModel.user.item];
            [self.myTableView reloadData];
        }
        [FWMJRefreshManager endRefresh:self.myTableView];
        
    } FailureBlock:^(NSError *error) {
        
        FWStrongify(self)
        [self hideMyHud];
        [FWMJRefreshManager endRefresh:self.myTableView];
        
    }];
}

#pragma mark 主页和直播的点击事件
- (void)HLBtnClick:(UIButton *)btn
{
    [self updateUIWithTag:(int)btn.tag];
}

- (void)updateUIWithTag:(int)tag
{
    for (UIButton *newBtn in self.homeOrLiveView.subviews)
    {
        if ([newBtn isKindOfClass:[UIButton class]])
        {
            if (newBtn.tag ==tag)
            {
                [newBtn setTitleColor:kAppGrayColor1 forState:0];
            }else
            {
                [newBtn setTitleColor:kAppGrayColor3 forState:0];
            }
            [UIView animateWithDuration:0.5 animations:^{
                CGRect rect = self.HLineView1.frame;
                rect.origin.x = kScreenW/6 -25 + kScreenW*tag/3;
                self.HLineView1.frame = rect;
            }];
        }
    }
    [_myScrollView scrollRectToVisible:CGRectMake(tag * kScreenW, 0, kScreenW, CGRectGetHeight(_myScrollView.frame)) animated:YES];
}

#pragma mark -UITableViewDelegate&UITableViewDataSource
//返回行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

//返回cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == HPZeroSection)
    {
        return 45*kAppRowHScale;
    }else if (indexPath.section == HPFirstSection)
    {
        return 10*kAppRowHScale;
    }else
    {
        return kScreenW;
    }
}

//返回段数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return HPTab_Count;
}
//返回单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int newNection = (int)indexPath.section;
    if (newNection == HPZeroSection)
    {
        HPContributionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HPContributionCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setCellWithArray:self.imageArray];
        return cell;
    }else if (newNection == 1)
    {
        static NSString *CellIdentifier0 = @"CellIdentifier0";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier0];
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier0];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = kBackGroundColor;
        }
        return cell;
    }else
    {
        static NSString *CellIdentifier1 = @"CellIdentifier1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = kBackGroundColor;
            [cell addSubview:self.myScrollView];
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == HPSecondSection)
    {
        return 45*kAppRowHScale;
    }else
    {
        return 0.01;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == HPSecondSection)
    {
        return self.homeOrLiveView;
    }else
    {
        return nil;
    }
}

#pragma mark -- 进入正在直播的直播间
-(void)joinRoom:(UserModel *)model
{
    if (self.canClickItem)// 防止重复点击
    {
        self.canClickItem = NO;
        [self performSelector:@selector(changeClickState) withObject:nil afterDelay:2];
    }else{
        return;
    }
    if (![FWUtils isNetConnected])
    {
        return;
    }
    NSDictionary *dic = model.mj_keyValues;
    
    // 直播管理中心 开启观众直播
    // 开启直播（先API拿直播后台类型）  非悬浮 非小屏幕
    BOOL isSusWindow = [[LiveCenterManager sharedInstance] judgeIsSusWindow];
    BOOL isSmallScreen = [[LiveCenterManager sharedInstance] judgeIsSmallSusWindow];
    [[LiveCenterManager sharedInstance] showLiveOfAudienceLiveofPramaDic:dic.mutableCopy isSusWindow:isSusWindow isSmallScreen:isSmallScreen block:^(BOOL finished) {
    }];
}

- (void)changeClickState
{
    self.canClickItem = YES;
}

#pragma mark 私信
- (void)sentPersonLetter:(NSString*)taguserid
{
    SFriendObj* chattag = [[SFriendObj alloc]initWithUserId:[self.user_id intValue]];
    chattag.mNick_name = self.user_nickname;
    chattag.mHead_image = self.user_headimg;
    FWConversationServiceController* chatvc = [FWConversationServiceController makeChatVCWith:chattag];
    //ykk
    //加判断 避免循环push
    //如果上个界面是 聊天信息VC
    for(UIViewController *last_C in self.navigationController.viewControllers)
    {
        if([last_C isKindOfClass:[FWConversationServiceController class]])
        {
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
    }
    [[AppDelegate sharedAppDelegate] pushViewController:chatvc];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == HPZeroSection)
    {
        ContributionListViewController *contributionVC = [[ContributionListViewController alloc]init];
        contributionVC.user_id = self.user_id;
        contributionVC.type = @"2";
        [self.navigationController pushViewController:contributionVC animated:NO];
    }
}

- (void)comeBackTap
{
    [[AppDelegate sharedAppDelegate]popViewController];
}

#pragma mark ===============================================getter方法===================================================
#pragma mark 主页和直播
- (UIView *)homeOrLiveView
{
    if (!_homeOrLiveView)
    {
        _homeOrLiveView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, kScreenW, 45*kAppRowHScale)];
        _homeOrLiveView.backgroundColor = kWhiteColor;
        NSArray *nameArray = @[@"主页",@"直播",@"小视频"];
        for (int i = 0; i < nameArray.count; i ++)
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake((kScreenW-2)*i/3,0,kScreenW/3, 49);
            [button setTitle:nameArray[i] forState:0];
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            if (self.type == i)
            {
                [button setTitleColor:kAppGrayColor1 forState:UIControlStateNormal];
                
            }else
            {
                [button setTitleColor:kAppGrayColor3 forState:UIControlStateNormal];
            }
            
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            button.tag = i;
            [button addTarget:self action:@selector(HLBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [_homeOrLiveView addSubview:button];
            
            if (i < nameArray.count -1)
            {
                UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(kScreenW*(i+1)/3 - 1, (45-15)*kAppRowHScale/2, 1,15*kAppRowHScale)];
                lineView.backgroundColor = kAppSpaceColor4;
                [_homeOrLiveView addSubview:lineView];
            }
        }
        
        self.HLineView1 = [[UIView alloc]init];
        self.HLineView1.frame = CGRectMake(kScreenW/6 -25 +kScreenW*(self.type)/3, 45*kAppRowHScale-4, 50, 4);
        self.HLineView1.layer.cornerRadius = YES;
        self.HLineView1.layer.cornerRadius = 2;
        self.HLineView1.backgroundColor = kAppGrayColor1;
        [_homeOrLiveView addSubview:self.HLineView1];
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0,45*kAppRowHScale-1, kScreenW, 1)];
        view.backgroundColor = kAppSpaceColor4;
        [_homeOrLiveView addSubview:view];
    }
    return _homeOrLiveView;
}

- (UITableView *)myTableView
{
    if (!_myTableView)
    {
        _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, kScreenW, kScreenH-50)];
        _myTableView.backgroundColor = kBackGroundColor;
        _myTableView.dataSource = self;
        _myTableView.delegate = self;
        self.myTableHeadView = [[MPCHeadView alloc]initWithFrame:CGRectMake(0,0 , kScreenW,kScreenH*0.41) andHeadType:2];
        FWWeakify(self)
        [self.myTableHeadView setHeadViewBlock:^(int btnIndex){
            FWStrongify(self)
            [self pushToVCWithIndex:btnIndex];
            
        }];
        _myTableView.tableHeaderView = self.myTableHeadView;
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_myTableView registerNib:[UINib nibWithNibName:@"HPContributionCell" bundle:nil] forCellReuseIdentifier:@"HPContributionCell"];
    }
    return _myTableView;
}

- (void)pushToVCWithIndex:(int)btnTag
{
    switch (btnTag) {
        case 100:
        {
            if ([self.navigationController topViewController] == self)
            { //如果有导航控制器,并且顶部就是自己,那么应该返回
                if (self.navigationController.viewControllers.count == 1)
                { //如果只有一个
                    if (self.presentingViewController)
                    { //如果有就dismiss
                        
                        [self dismissViewControllerAnimated:YES
                                                 completion:^{
                                                     
                                                 }];
                        return;
                    }
                }
                else
                {
                    [self.navigationController popViewControllerAnimated:NO];
                }
            }
            else //其他情况,就再判断是否有 presentingViewController
            {
                if (self.presentingViewController)
                { //如果有就dismiss
                    [self dismissViewControllerAnimated:YES
                                             completion:^{
                                             }];
                    return;
                }
            }
            
        }
            break;
        case 101:
        {
            if ([self.fanweApp.liveState.roomId intValue]>0)
            {
                [FanweMessage alertHUD:@"当前有视频正在播放"];
            }
            else
            {
                UserModel *liveModel = [UserModel mj_objectWithKeyValues:self.liveDict];
                [self joinRoom:liveModel];
            }
        }
            break;
        case 102:
        {
            SSaveHeadViewVC *headVC = [[SSaveHeadViewVC alloc]init];
            headVC.url = [NSURL URLWithString:self.userModel.user.head_image];
            [[AppDelegate sharedAppDelegate]pushViewController:headVC];
        }
            break;
        case 103:
        {
            //送出 没有，个人中心才有
        }
            break;
        case 104:
        {
            //送出 没有，没有点击事件
        }
            break;
        case 105:
        {
            FollowerViewController *followVC = [[FollowerViewController alloc]init];
            followVC.user_id = self.user_id;
            followVC.type = @"1";
            [[AppDelegate sharedAppDelegate] pushViewController:followVC];
        }
            break;
        case 106:
        {
            FollowerViewController *followVC = [[FollowerViewController alloc]init];
            followVC.user_id = self.user_id;
            followVC.type = @"2";
            [[AppDelegate sharedAppDelegate] pushViewController:followVC];
        }
            break;
            
        default:
            break;
    }
}

- (UIView *)bottomView
{
    if (!_bottomView)
    {
        _bottomView = [[[NSBundle mainBundle]loadNibNamed:@"MainPageView" owner:self options:nil] objectAtIndex:0];
        _bottomView.delegate = self;
        _bottomView.user_id = self.user_id;
        _bottomView.frame = CGRectMake(0,kScreenH-50,kScreenW,50);
    }
    return _bottomView;
}

- (NSMutableArray *)imageArray
{
    if (!_imageArray)
    {
        _imageArray = [[NSMutableArray alloc]init];
    }
    return _imageArray;
}

- (UIScrollView *)myScrollView
{
    if (!_myScrollView)
    {
        _myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenW,kScreenW)];
        _myScrollView.delegate = self;
        _myScrollView.backgroundColor = kBackGroundColor;
        _myScrollView.pagingEnabled = YES;
        _myScrollView.contentSize = CGSizeMake(kScreenW * 3, CGRectGetHeight(_myScrollView.frame));
        
        self.homeInfoV = [[SHomeInfoV alloc]initWithFrame:CGRectMake(0, 0, kScreenW, _myScrollView.height) ];
        [_myScrollView addSubview:self.homeInfoV];
        
        self.homeLiveV = [[SHomeLiveV alloc]initWithFrame:CGRectMake(kScreenW, 0, kScreenW, _myScrollView.height) andUserId:self.user_id];
        self.homeLiveV.LDelegate = self;
        [_myScrollView addSubview:self.homeLiveV];
        
        self.smallVideoV = [[SHomeSVideoV alloc]initWithFrame:CGRectMake(kScreenW*2, 0, kScreenW, _myScrollView.height) andUserId:self.user_id];
        self.smallVideoV.VDelegate = self;
        [_myScrollView addSubview:self.smallVideoV];
    }
    return _myScrollView;
}

- (void)goToLiveRoomWithModel:(UserModel *)model andView:(SHomeLiveV *)homeLiveView
{
    [self joinRoom:model];
}

- (void)pushToVideoDetailWithWeiboId:(NSString *)weiboId andView:(SHomeSVideoV *)homeSVideoV
{
    FWVideoDetailController *VideoVC = [[FWVideoDetailController alloc]init];
    VideoVC.weibo_id = weiboId;
    [[AppDelegate sharedAppDelegate] pushViewController:VideoVC];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == _myScrollView)
    {
        CGFloat pageWidth = scrollView.frame.size.width;
        NSInteger tmpPage = scrollView.contentOffset.x / pageWidth;
        float tmpPage2    = scrollView.contentOffset.x / pageWidth;
        NSInteger page    = tmpPage2-tmpPage>=0.5 ? tmpPage+1 : tmpPage;
        
        if (_startPage != page)
        {
            [self updateUIWithTag:(int)page];
            _startPage = page;
        }
    }
}



@end
