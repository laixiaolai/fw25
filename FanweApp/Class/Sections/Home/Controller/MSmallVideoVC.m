//
//  MSmallVideoVC.m
//  FanweApp
//
//  Created by 丁凯 on 2017/8/17.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "MSmallVideoVC.h"
#import "SSearchVC.h"
#import "SmallVideoCell.h"
#import "SmallVideoListModel.h"
#import "FWVideoDetailController.h"

@interface MSmallVideoVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate>

@property ( nonatomic,strong) UICollectionView                 *videoCollectionV;
@property ( nonatomic,strong) UICollectionViewFlowLayout       *myCollectionLayout;
@property ( nonatomic,strong) NSMutableArray                   *dataArray;
@property ( nonatomic,assign) int                              currentPage;
@property ( nonatomic,assign) int                              has_next;
@property ( nonatomic,strong) JSBadgeView                      *badge;

@end

@implementation MSmallVideoVC

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray)
    {
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArray;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [self loadBtnBadageData];
}

- (void)initFWUI
{
    [super initFWUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(iMChatHaveNotification:) name:g_notif_chatmsg object:nil];
    self.navigationItem.title = @"小视频";
    
    if (self.notHaveTabbar)
    {
        self.navigationItem.leftBarButtonItem=[UIBarButtonItem itemWithTarget:self action:@selector(returnCenterVC) image:@"com_arrow_vc_back" highImage:@"com_arrow_vc_back"];
    }
    else
    {
        [self leftOrRightNavItem];
    }
    
    self.myCollectionLayout = [[UICollectionViewFlowLayout alloc]init];
    self.myCollectionLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.myCollectionLayout.minimumInteritemSpacing = 5;
    self.myCollectionLayout.itemSize = CGSizeMake((kScreenW-5)/2.0f,(kScreenW-5)/2.0f);
    if (!self.notHaveTabbar)
    {
        self.videoCollectionV = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-kStatusBarHeight-kNavigationBarHeight-kTabBarHeight) collectionViewLayout:self.myCollectionLayout];
    }else
    {
        self.videoCollectionV = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-kStatusBarHeight-kNavigationBarHeight) collectionViewLayout:self.myCollectionLayout];
    }
    
    self.videoCollectionV.delegate = self;
    self.videoCollectionV.dataSource = self;
    self.videoCollectionV.backgroundColor = kWhiteColor;
    [self.videoCollectionV registerNib:[UINib nibWithNibName:@"SmallVideoCell" bundle:nil] forCellWithReuseIdentifier:@"SmallVideoCell"];
    [self.view addSubview:self.videoCollectionV];
    [self.videoCollectionV registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"foot"];
    [FWMJRefreshManager refresh:self.videoCollectionV target:self headerRereshAction:@selector(refreshHeader) footerRereshAction:@selector(refreshFooter)];
}

- (void)leftOrRightNavItem
{
    // 左上角按钮
    UIButton *leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 35, kNavigationBarHeight)];
    [leftButton setImage:[UIImage imageNamed:@"hm_search"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];
    leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    // 右上角按钮
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 35, kNavigationBarHeight)];
    [rightButton setImage:[UIImage imageNamed:@"hm_private_message"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(clickedIMChat) forControlEvents:UIControlEventTouchUpInside];
    rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    // 设置角标
    [self initBadgeBtn:rightButton];
    [self loadBtnBadageData];
}


- (void)returnCenterVC
{
    [[AppDelegate sharedAppDelegate]popViewController];
}

#pragma mark 搜索
- (void)searchClick
{
    SSearchVC *searchVC = [[SSearchVC alloc]init];
    searchVC.searchType = @"0";
    [[AppDelegate sharedAppDelegate] pushViewController:searchVC];
}

#pragma mark 搜索
- (void)clickedIMChat
{
    FWConversationSegmentController *chatListVC = [[FWConversationSegmentController alloc]init];
    [[AppDelegate sharedAppDelegate] pushViewController:chatListVC];
}

- (void)refreshHeader
{
    [self requestNetDataWithPage:1];
}

- (void)refreshFooter
{
    if (_has_next == 1)
    {
        _currentPage ++;
        [self requestNetDataWithPage:_currentPage];
    }
    else
    {
        [self.videoCollectionV.mj_footer endRefreshingWithNoMoreData];
    }
}

- (void)requestNetDataWithPage:(int)Page
{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"svideo" forKey:@"ctl"];
    if (!self.notHaveTabbar)
    {
        [parmDict setObject:@"index" forKey:@"act"];
    }else
    {
        [parmDict setObject:@"video" forKey:@"act"];
    }
    [parmDict setObject:[NSNumber numberWithInt:Page] forKey:@"page"];
    FWWeakify(self)
    [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
        FWStrongify(self)
        if ([responseJson toInt:@"status"] == 1)
        {
            if (Page == 1)
            {
                [self.dataArray removeAllObjects];
            }
            _has_next = [responseJson toInt:@"has_next"];
            _currentPage = [responseJson toInt:@"page"];
            NSArray *list = responseJson[@"list"];
            for ( NSDictionary *dict in list)
            {
                SmallVideoListModel *model = [SmallVideoListModel mj_objectWithKeyValues:dict];
                [self.dataArray addObject:model];
            }
            [self.videoCollectionV reloadData];
        }
        [FWMJRefreshManager endRefresh:self.videoCollectionV];
        
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
        [FWMJRefreshManager endRefresh:self.videoCollectionV];
    }];
}

#pragma mark collectionView delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SmallVideoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SmallVideoCell" forIndexPath:indexPath];
    SmallVideoListModel *model = self.dataArray[indexPath.row];
    [cell creatCellWithModel:model andRow:(int)indexPath.row];
    return cell;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5.0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.dataArray.count)
    {
        SmallVideoListModel *model = _dataArray[indexPath.row];
        FWVideoDetailController *VideoVC = [[FWVideoDetailController alloc]init];
        VideoVC.weibo_id = model.weibo_id;
        [[AppDelegate sharedAppDelegate] pushViewController:VideoVC];
    }
}

#pragma mark - ----------------------- scrollViewDelegate -----------------------
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}

#pragma mark - ----------------------- 角标 -----------------------
/**
 获取角标的数据： 注意：调All未读／调好友&&非好友方法 算All时，别调后者2各和来算，里面有耗时操作
 使用：1.在willApperar 2.SDK监听会发通知，通知的方法／block 里调用
 给控件初始化一个角标
 
 badage的 数据 获取（个人页面获取所有未读的条数）
 1.在willApear里调用一次   2.SDk消息变化，接受通知，在通知方法还要调用 用于更新 角标数据
 
 */

- (void)iMChatHaveNotification:(NSNotification*)notification
{
    //all 角标数据
    [self loadBtnBadageData];
}
- (void)loadBtnBadageData
{
    [SFriendObj getAllUnReadCountComplete:^(int num) {
        //all
        int scount = num;
        if( scount )
        {
            if(scount > 98)
            {
                _badge.badgeText = @"99+";
            }
            else
            {
                _badge.badgeText = [NSString stringWithFormat:@"%d",scount];
            }
        }
        else
        {
            _badge.badgeText = nil;
        }
    }];
}

/**
 设置 角标
 
 @param sender 对应的控件
 */
- (void)initBadgeBtn:(UIButton *)sender
{
    //-好友
    _badge = [[JSBadgeView alloc]initWithParentView:sender alignment:JSBadgeViewAlignmentTopRight];
    _badge.badgePositionAdjustment = CGPointMake(0, 12);
}

@end
