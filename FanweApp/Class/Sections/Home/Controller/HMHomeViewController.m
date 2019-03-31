//
//  HMHomeViewController.m
//  FanweApp
//
//  Created by xfg on 2017/6/29.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "HMHomeViewController.h"
#import "SSearchVC.h"
#import "UpgradeTipView.h"
#import "SHomePageVC.h"
#import "FWConversationSegmentController.h"
#import "VideoViewController.h"
#import "SocietyDetailVC.h"
#import "SociatyListModel.h"
#import "SocietyHomePageVC.h"
#import "SChooseAreaView.h"

// 动态项，便于后期拓展以及灵活组装
static NSString const *kFocusOnStr  = @"关注";
static NSString const *kHotStr      = @"热门";
static NSString const *kNearbyStr   = @"附近";

static float const      kSegmentLeftEdge        = 10;   // segmentedControl左边边距
static float const      kSegmentTitleFont       = 13;   // segmentedControl字体大小
static NSInteger const  kSelectedSegmentIndex   = 1;    // segmentedControl默认选中的index

@interface HMHomeViewController ()<UIScrollViewDelegate, handleMainDelegate, pushToLiveControllerDelegate, HMHotViewControllerDelegate, SocietyHomePageVCDelegate>
{
    JSBadgeView                     *_badge;
    BOOL                            _isFirstLoad;           // 是否首次加载
    NSString                        *_oldSocietyListName;   // 公会名称可以修改，修改前的公会名字
    NSString                        *_societyListName;      // 公会名称
    UIButton                        *_addressBtn;
}

@property (nonatomic, strong) HMHotViewController   *hotViewController;         // 热门
@property (nonatomic, strong) FocusOnViewController *focusOnViewController;     // 关注
@property (nonatomic, strong) NewestViewController  *livingListViewController;  // 最新

@property (nonatomic, strong) SocietyHomePageVC     *societyHomePage;           // 公会

@property (nonatomic, strong) UIScrollView          *scrollView;                // ScrollView
@property (nonatomic, strong) HMSegmentedControl    *segmentedControl;          // Segmented
@property (nonatomic, strong) NSTimer               *refreshHomeTimer;          // 首页定时刷新
@property (nonatomic, assign) BOOL                  isRefreshing;               // 是否正在刷新

@property (nonatomic, assign) NSInteger             startPage;                  // Segmented的滑块起始页
@property (nonatomic, assign) BOOL                  isClickedSegmented;         // 是否点击了Segmented的滑块

@property (nonatomic, strong) SChooseAreaView       *chooseAreaView;            // 地区选择
@property (nonatomic, assign) int                   sexType;                    // 性别

@property (nonatomic, strong) NSMutableArray                            *itemTitleMutableArray;         // 完整的分类标题容器
@property (nonatomic, strong) NSMutableArray<VideoClassifiedModel *>    *classifiedModelMutableArray;   // 服务端下发分类的模型容器
@property (nonatomic, strong) NSMutableArray<VideoViewController *>     *videoVCMutableArray;           // 服务端下发分类的对应的控制器容器

@end

@implementation HMHomeViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadClassifiedVC];
    
    [self loadBtnBadageData];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    // 加载礼物列表
    [[GiftListManager sharedInstance] reloadGiftList];
    
    [self setupTimer];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (!_isFirstLoad)
    {
        [self refreshOfTime];
    }
    _isFirstLoad = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self invalidateTimer];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)initFWUI
{
    [super initFWUI];
    
    [FWIMMsgHandler sharedInstance];
    
    self.navigationItem.title = @"首页";
    
    self.fanweApp.appNavigationBarHeight = self.navigationController.navigationBar.frame.size.height;
    self.fanweApp.appTabBarHeight = self.tabBarController.tabBar.frame.size.height;
    
    _startPage = kSelectedSegmentIndex;
    
    _videoVCMutableArray = [NSMutableArray array];
    _oldSocietyListName = self.fanweApp.appModel.society_list_name;
    
    CGFloat viewWidth = CGRectGetWidth(self.view.frame);
    CGFloat viewHeight = CGRectGetHeight(self.view.frame);
    
#if kSupportH5Shopping
    self.itemTitleMutableArray = [NSMutableArray arrayWithObjects:kFocusOnStr, kHotStr, nil];
#else
    // 配置本地分类
    self.itemTitleMutableArray = [NSMutableArray arrayWithObjects:kFocusOnStr, kHotStr, kNearbyStr, nil];
#endif
    
    self.segmentedControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, 0, viewWidth, kSegmentedHeight)];
    self.segmentedControl.sectionTitles = self.itemTitleMutableArray;
    self.segmentedControl.selectedSegmentIndex = kSelectedSegmentIndex;
    self.segmentedControl.backgroundColor = kWhiteColor;
    self.segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName : kAppGrayColor3, NSFontAttributeName : [UIFont systemFontOfSize:kSegmentTitleFont]};
    self.segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : kAppMainColor, NSBackgroundColorAttributeName : kClearColor, NSFontAttributeName : [UIFont systemFontOfSize:kSegmentTitleFont]};
    self.segmentedControl.selectionIndicatorColor = kAppMainColor;
    self.segmentedControl.selectionIndicatorHeight = 3;
    self.segmentedControl.selectionIndicatorBoxColor = kClearColor;
    self.segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
    self.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.segmentedControl.segmentEdgeInset = UIEdgeInsetsMake(0, kSegmentLeftEdge, 0, kSegmentLeftEdge);
    self.segmentedControl.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleDynamicFixedSuperView;
    self.segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    FWWeakify(self)
    [self.segmentedControl setIndexChangeBlock:^(NSInteger index) {
        
        FWStrongify(self)
        [self.scrollView scrollRectToVisible:CGRectMake(viewWidth * index, 0, viewWidth, CGRectGetHeight(self.scrollView.frame)) animated:YES];
        [self loadClassifiedVC];
        
        [self refreshClassifiedVC:index];
        
        self.isClickedSegmented = YES;
        
    }];
    [self.view addSubview:self.segmentedControl];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kSegmentedHeight, viewWidth, viewHeight-kNavigationBarHeight-kSegmentedHeight-kTabBarHeight-kStatusBarHeight)];
    self.scrollView.delegate = self;
    self.scrollView.backgroundColor = kClearColor;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.bounces = NO;
    self.scrollView.contentSize = CGSizeMake(viewWidth * [self.itemTitleMutableArray count], CGRectGetHeight(self.scrollView.frame));
    [self.scrollView scrollRectToVisible:CGRectMake(kSelectedSegmentIndex * viewWidth, 0, viewWidth, CGRectGetHeight(self.scrollView.frame)) animated:NO];
    [self.view addSubview:self.scrollView];
    
    // 关注
    if ([self.itemTitleMutableArray containsObject:kFocusOnStr])
    {
        _focusOnViewController = [[FocusOnViewController alloc]init];
        _focusOnViewController.tableViewFrame = CGRectMake(0, 0, viewWidth, _scrollView.frame.size.height);
        _focusOnViewController.view.frame = CGRectMake(viewWidth * [self.itemTitleMutableArray indexOfObject:kFocusOnStr], 0, viewWidth, _scrollView.bounds.size.height);
        _focusOnViewController.delegate = self;
        [_scrollView addSubview:_focusOnViewController.view];
    }
    
    // 热门
    if ([self.itemTitleMutableArray containsObject:kHotStr])
    {
        _hotViewController = [[HMHotViewController alloc]init];
        _hotViewController.tableViewFrame = CGRectMake(0, 0, viewWidth, _scrollView.bounds.size.height);
        _hotViewController.view.frame = CGRectMake(viewWidth * [self.itemTitleMutableArray indexOfObject:kHotStr], 0, viewWidth, _scrollView.bounds.size.height);
        _hotViewController.delegate = self;
        _hotViewController.areaString = [NSString stringWithFormat:@"%@",kHotStr];
        [_scrollView addSubview:_hotViewController.view];
    }
    
    // 附近
    if ([self.itemTitleMutableArray containsObject:kNearbyStr])
    {
        _livingListViewController = [[NewestViewController alloc]init];
        _livingListViewController.collectionViewFrame = CGRectMake(0, 0, viewWidth, _scrollView.bounds.size.height);
        _livingListViewController.view.frame = CGRectMake(viewWidth * [self.itemTitleMutableArray indexOfObject:kNearbyStr], 0, viewWidth, _scrollView.bounds.size.height);
        _livingListViewController.delegate = self;
        [_scrollView addSubview:_livingListViewController.view];
    }
    
    [self loadClassifiedVC];
    
    [self leftOrRightNavItem];
    
    [self.fanweApp addObserver:self forKeyPath:@"appModel.video_classified" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
    // 升级提示等
    UpgradeTipView *upgradeTipView = [[UpgradeTipView alloc] init];
    [upgradeTipView initRewards];
}

- (void)initFWData
{
    [super initFWData];
    
    _isFirstLoad = YES;
    _isRefreshing = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(iMChatHaveNotification:) name:g_notif_chatmsg object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTitleName:) name:@"updateTitleName" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(invalidateTimer) name:kInvalidateHomeTimer object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshHome) name:kRefreshHome object:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self loadBtnBadageData];
    });
}

- (void)leftOrRightNavItem
{
#if kSupportH5Shopping
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(6, 22, 20, 20)];
    [rightButton setImage:[UIImage imageNamed:@"hm_search"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(goSearch) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = leftBarButtonItem;
#else
    // 左上角按钮
    UIButton *leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 35, kNavigationBarHeight)];
    [leftButton setImage:[UIImage imageNamed:@"hm_search"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(goSearch) forControlEvents:UIControlEventTouchUpInside];
    leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    // 右上角按钮
    UIView *rightViewContrainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 70, kNavigationBarHeight)];
    rightViewContrainer.backgroundColor = kClearColor;
    
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetWidth(rightViewContrainer.frame)-35, 0, 35, rightViewContrainer.frame.size.height)];
    [rightButton setImage:[UIImage imageNamed:@"hm_private_message"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(clickRightHeadBtn:) forControlEvents:UIControlEventTouchUpInside];
    rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightViewContrainer addSubview:rightButton];
    
    _addressBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 35, rightViewContrainer.frame.size.height)];
    [_addressBtn setImage:[UIImage imageNamed:@"hm_address"] forState:UIControlStateNormal];
    [_addressBtn addTarget:self action:@selector(clickRightHeadBtn:) forControlEvents:UIControlEventTouchUpInside];
    _addressBtn.tag = 1;
    _addressBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightViewContrainer addSubview:_addressBtn];
    
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightViewContrainer];
    
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    // 设置角标
    [self initBadgeBtn:rightButton];
#endif
}

#pragma mark 动态加载初始化接口下发的分类、公会等
- (void)loadClassifiedVC
{
    CGFloat viewWidth = CGRectGetWidth(self.view.frame);
    
    // 动态添加、删除公会
    if (self.fanweApp.appModel.open_society_module.intValue == 1 && ![FWUtils isBlankString:self.fanweApp.appModel.society_list_name])
    {
        _societyListName = self.fanweApp.appModel.society_list_name;
        if (![_societyListName isEqualToString:_oldSocietyListName] && [self.itemTitleMutableArray containsObject:_oldSocietyListName])//修改了公会名字并且原来有公会就替换
        {
            NSInteger index = [self.itemTitleMutableArray indexOfObject:_oldSocietyListName];
            [self.itemTitleMutableArray replaceObjectAtIndex:index withObject:_societyListName];
            _oldSocietyListName = _societyListName;

        }else if(![_societyListName isEqualToString:_oldSocietyListName] && ![self.itemTitleMutableArray containsObject:_oldSocietyListName])//修改了公会名字并且原来没有公会加上去
        {
            [self.itemTitleMutableArray addObject:_societyListName];
            _oldSocietyListName = _societyListName;
        }else
        {
            if (![self.itemTitleMutableArray containsObject:_societyListName])
            {
                 [self.itemTitleMutableArray addObject:_societyListName];
            }
        }
        
        if (!self.societyHomePage.view.superview)
        {
            self.societyHomePage.view.frame = CGRectMake(viewWidth * [self.itemTitleMutableArray indexOfObject:_societyListName], 0, viewWidth, _scrollView.bounds.size.height);
            [self.scrollView addSubview:self.societyHomePage.view];
        }
    }
    else if (self.fanweApp.appModel.open_society_module.intValue == 0 && [self.itemTitleMutableArray containsObject:_societyListName])
    {
        [self.itemTitleMutableArray removeObject:_societyListName];
        
        [self.societyHomePage.view removeFromSuperview];
    }
    
    if (![self.fanweApp.appModel.video_classified isEqual:self.classifiedModelMutableArray])
    {
        [self updateClassiFiedVC];
    }
}

- (void)updateClassiFiedVC
{
    CGFloat viewWidth = CGRectGetWidth(self.view.frame);
    @synchronized (self)
    {
        if (self.classifiedModelMutableArray.count > 0)
        {
            // 获取到本地暂存的服务端下发的分类的在完整的分类容器中的起点与终点，进行移除视频分类相关视图和视图控制器的操作
            VideoClassifiedModel *tmpModel = [self.classifiedModelMutableArray firstObject];
            NSInteger tmpIndex = [self.itemTitleMutableArray indexOfObject:tmpModel.title];
            VideoClassifiedModel *lastVideoModel = [self.classifiedModelMutableArray lastObject];
            NSInteger lastIndex = [self.itemTitleMutableArray indexOfObject:lastVideoModel.title];
            [self.videoVCMutableArray removeAllObjects];
            for (NSInteger i = tmpIndex; i <= lastIndex; i++)
            {
                if (self.scrollView.subviews.count > i)
                {
                    [self.scrollView.subviews[i] removeFromSuperview];
                }
            }
            
            // 动态删除视频分类
            for (VideoClassifiedModel *tmpModel in self.classifiedModelMutableArray)
            {
                [self.itemTitleMutableArray removeObject:tmpModel.title];
            }
        }
        
        // 动态添加视频分类
        for (VideoClassifiedModel *model in self.fanweApp.appModel.video_classified)
        {
            [self.itemTitleMutableArray addObject:model.title];
        }
        
        self.classifiedModelMutableArray = self.fanweApp.appModel.video_classified;
        
        self.segmentedControl.sectionTitles = self.itemTitleMutableArray;
        self.scrollView.contentSize = CGSizeMake(viewWidth * [self.itemTitleMutableArray count], CGRectGetHeight(self.scrollView.frame));
        
        for (NSInteger i = 0; i < self.classifiedModelMutableArray.count; ++i)
        {
            // 服务端下发的分类的在完整的分类容器中的起点
            VideoClassifiedModel *tmpModel = [self.classifiedModelMutableArray firstObject];
            NSUInteger tmpIndex = [self.itemTitleMutableArray indexOfObject:tmpModel.title];
            
            VideoViewController *videoVC = [[VideoViewController alloc] init];
            VideoClassifiedModel * model = [self.fanweApp.appModel.video_classified objectAtIndex:i];
            videoVC.viewFrame = CGRectMake(0, 0, viewWidth, self.scrollView.bounds.size.height);
            videoVC.view.frame = CGRectMake(viewWidth * (i+tmpIndex), 0, viewWidth, self.scrollView.bounds.size.height);
            videoVC.classified_id = model.classified_id;
            [self.scrollView addSubview:videoVC.view];
            
            [self.videoVCMutableArray addObject:videoVC];
        }
    }
}

#pragma mark 刷新分类VC的数据
- (void)refreshClassifiedVC:(NSInteger)page
{
    if (self.classifiedModelMutableArray.count > 0)
    {
        // 服务端下发的分类的在完整的分类容器中的起点
        VideoClassifiedModel *tmpModel = [self.classifiedModelMutableArray firstObject];
        NSUInteger tmpIndex = [self.itemTitleMutableArray indexOfObject:tmpModel.title];
        
        // 服务端下发的分类的在完整的分类容器中的终点
        VideoClassifiedModel *tmpModel2 = [self.classifiedModelMutableArray lastObject];
        NSUInteger tmpIndex2 = [self.itemTitleMutableArray indexOfObject:tmpModel2.title];
        
        if (page >= tmpIndex && page <= tmpIndex2)
        {
            VideoViewController *videoVC = self.videoVCMutableArray[page-tmpIndex];
            [videoVC setNetworing:1];
        }
    }
    
    NSString *tmpStr = [FWUtils isBlankString:self.hotViewController.areaString] ? kHotStr : self.hotViewController.areaString;
    [self isShowAddressBtn:(page==[self.itemTitleMutableArray indexOfObject:tmpStr] ? YES : NO)];
}


#pragma mark - ----------------------- 事件处理 -----------------------

- (void)isShowAddressBtn:(BOOL)isShow
{
    if (isShow)
    {
        _addressBtn.hidden = NO;
    }
    else
    {
        _addressBtn.hidden = YES;
    }
}

#pragma mark 搜索
- (void)goSearch
{
    [self removeChooseView];
    SSearchVC *searchVC = [[SSearchVC alloc]init];
    searchVC.searchType = @"0";
    [[AppDelegate sharedAppDelegate] pushViewController:searchVC];
}

#pragma mark 右上角地区、IM按钮事件
- (void)clickRightHeadBtn:(UIButton *)btn
{
    if (btn.tag == 1)
    {
        if (!self.chooseAreaView)
        {
            self.chooseAreaView = [[SChooseAreaView alloc]initWithFrame:CGRectMake(0, kScreenH, kScreenW, kScreenH-kStatusBarHeight-kNavigationBarHeight) andChooseType:[self.hotViewController.sexString intValue] andAreaStr:self.hotViewController.areaString];
            FWWeakify(self)
            [self.chooseAreaView setAreaBlock:^(NSString *areStr, int sexType){
                FWStrongify(self)
                [self.itemTitleMutableArray replaceObjectAtIndex:1 withObject:areStr];
                self.segmentedControl.sectionTitles = self.itemTitleMutableArray;
                self.hotViewController.areaString = areStr;
                self.hotViewController.sexString  = [NSString stringWithFormat:@"%d",sexType];
                [self.hotViewController loadDataFromNet:1];
                [self removeChooseView];
            }];
            [[[UIApplication sharedApplication] keyWindow] addSubview:self.chooseAreaView];
            
            [UIView animateWithDuration:0.6 animations:^{
                CGRect rect = self.chooseAreaView.frame;
                rect.origin.y = kStatusBarHeight+kNavigationBarHeight;
                self.chooseAreaView.frame = rect;
            }];
        }
        else
        {
            [self removeChooseView];
        }
    }
    else
    {
        [self removeChooseView];
        FWConversationSegmentController *chatListVC = [[FWConversationSegmentController alloc]init];
        [[AppDelegate sharedAppDelegate] pushViewController:chatListVC];
    }

}

- (void)removeChooseView
{
    [UIView animateWithDuration:0.6 animations:^{
        CGRect rect = self.chooseAreaView.frame;
        rect.origin.y = kScreenH;
        self.chooseAreaView.frame = rect;
    } completion:^(BOOL finished) {
        [self.chooseAreaView removeFromSuperview];
        self.chooseAreaView = nil;
    }];
}

#pragma mark 通知处理事件
- (void)updateTitleName:(NSNotification *)noti
{
    if ([[noti.object objectForKey:@"name"] length])
    {
        [self.itemTitleMutableArray replaceObjectAtIndex:1 withObject:[noti.object objectForKey:@"name"]];
        self.segmentedControl.sectionTitles = self.itemTitleMutableArray;
    }
}


#pragma mark - ----------------------- 首页刷新机制 -----------------------

- (void)refreshHome
{
    [self setupTimer];
    
    [self refreshOfTime];
}

- (void)setupTimer
{
    @synchronized (self)
    {
        if (!_refreshHomeTimer)
        {
            _refreshHomeTimer = [NSTimer scheduledTimerWithTimeInterval:kRefreshWithNewaTimeInterval target:self selector:@selector(refreshOfTime) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:_refreshHomeTimer forMode:NSRunLoopCommonModes];
        }
    }
}

- (void)invalidateTimer
{
    [_refreshHomeTimer invalidate];
    _refreshHomeTimer = nil;
}

#pragma mark 最新和最热20秒定时刷新
- (void)refreshOfTime
{
    // 防止短时间内重复刷新
    if (self.isRefreshing && [[[FWTabBarController sharedInstance] selectedViewController].childViewControllers[0] isKindOfClass:[HMHomeViewController class]])
    {
        self.isRefreshing = NO;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            self.isRefreshing = YES;
            
        });
    }
    else
    {
        return;
    }
    
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"HH:mm:ss"];
    NSLog(@"============调起首页刷新机制时间点：%@",[dateformatter stringFromDate:[NSDate date]]);
    
    if (_focusOnViewController)
    {
        [_focusOnViewController requestNetWorking];
    }
    
    if (_hotViewController)
    {
        [_hotViewController loadDataFromNet:1];
    }
    
    if (_livingListViewController)
    {
        [_livingListViewController loadDataWithPage:1];
    }
    
    // 当 open_society_module == 1 开启公会功能，公会名称根据字段 society_list_name 由服务器下发
    if (self.fanweApp.appModel.open_society_module.intValue == 1)
    {
        [_societyHomePage loadDataWithPage:1];
    }
}


#pragma mark - ----------------------- 代理 -----------------------

#pragma mark 解决Segmented的滑块快速滑动时的延迟，同时把点击滑块的情况排除在外
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!self.isClickedSegmented)
    {
        CGFloat pageWidth = scrollView.frame.size.width;
        NSInteger tmpPage = scrollView.contentOffset.x / pageWidth;
        float tmpPage2 = scrollView.contentOffset.x / pageWidth;
        NSInteger page = tmpPage2-tmpPage>=0.5 ? tmpPage+1 : tmpPage;
        
        if (_startPage != page)
        {
            [self.segmentedControl setSelectedSegmentIndex:page animated:YES];
            _startPage = page;
        }
    }
}

#pragma mark 页面滚动，同时调起Segmented的滑块滑动起来等
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = scrollView.contentOffset.x / pageWidth;
    [self loadClassifiedVC];
    
    [self refreshClassifiedVC:page];
    
    self.isClickedSegmented = NO;
    
    [self.segmentedControl setSelectedSegmentIndex:page animated:YES];
}

#pragma mark 跳转HomePageController页面
- (void)goToMainPage:(NSString *)userID
{
    SHomePageVC *tmpController= [[SHomePageVC alloc]init];
    tmpController.user_id = userID;
    tmpController.type = 0;
    [[AppDelegate sharedAppDelegate] pushViewController:tmpController];
}

- (void)goToNewestView
{
    if ([self.itemTitleMutableArray containsObject:kHotStr])
    {
        NSUInteger tmpIndex = [self.itemTitleMutableArray indexOfObject:kHotStr];
        self.segmentedControl.selectedSegmentIndex = tmpIndex;
        [self.scrollView scrollRectToVisible:CGRectMake(kScreenW * tmpIndex, 0, kScreenW, CGRectGetHeight(self.scrollView.frame)-10) animated:NO];
    }
}

#pragma mark 跳转到话题页面和hotTopicViewController二级页面
- (void)pushToNextControllerWithModel:(cuserModel *)model
{
    if ([model.cate_id isEqualToString:@"0"])
    {
        // 暂时不能跳转
    }
    else
    {
        HMHotViewController *tmpController = [[HMHotViewController alloc]init];
        tmpController.topicName = model.title;
        tmpController.cate_id = model.cate_id;
        [[AppDelegate sharedAppDelegate] pushViewController:tmpController];
    }
}

#pragma mark NewestViewController跳转到直播
- (void)pushToLiveController:(LivingModel *)model
{
    if (![FWUtils isNetConnected])
    {
        return;
    }
    
    [self.fanweApp.newestLivingMArray removeAllObjects];
    [self.fanweApp.newestLivingMArray addObject:model];
    
    if ([self checkUser:[IMAPlatform sharedInstance].host])
    {
        TCShowLiveListItem *item = [[TCShowLiveListItem alloc]init];
        item.chatRoomId = model.group_id;
        item.avRoomId = model.room_id;
        item.title = StringFromInt(model.room_id);
        item.vagueImgUrl = model.head_image;
        
        TCShowUser *showUser = [[TCShowUser alloc]init];
        showUser.uid = model.user_id;
        showUser.avatar = model.head_image;
        item.host = showUser;
        
        if (model.live_in == FW_LIVE_STATE_ING)
        {
            item.liveType = FW_LIVE_TYPE_AUDIENCE;
        }
        else if (model.live_in == FW_LIVE_STATE_RELIVE)
        {
            item.liveType = FW_LIVE_TYPE_RELIVE;
        }
        
        BOOL isSusWindow = [[LiveCenterManager sharedInstance] judgeIsSusWindow];
        [[LiveCenterManager sharedInstance]  showLiveOfAudienceLiveofTCShowLiveListItem:item isSusWindow:isSusWindow isSmallScreen:NO block:^(BOOL finished) {
        }];
        
        [self invalidateTimer];
    }
    else
    {
        [[FWHUDHelper sharedInstance] loading:@"" delay:2 execute:^{
            [[FWIMLoginManager sharedInstance] loginImSDK:YES succ:nil failed:nil];
        } completion:^{
            
        }];
    }
}

- (BOOL)checkUser:(id<IMHostAble>)user
{
    if (![user conformsToProtocol:@protocol(AVUserAble)])
    {
        return NO;
    }
    return YES;
}

#pragma mark 跳转到天团详情页面
- (void)pushSocietyDetail:(SociatyListModel *)listModel
{
    SocietyDetailVC *tianTuanVC = [[SocietyDetailVC alloc] init];
    tianTuanVC.mySocietyID = [listModel.society_id intValue];
    tianTuanVC.type = [listModel.type intValue];
    [[AppDelegate sharedAppDelegate] pushViewController:tianTuanVC];
}


#pragma mark - ----------------------- 私信消息、角标 -----------------------
#pragma mark IM

- (void)iMChatHaveNotification:(NSNotification*)notification
{
    //all 角标数据
    [self loadBtnBadageData];
}

/**
 获取角标的数据： 注意：调All未读／调好友&&非好友方法 算All时，别调后者2各和来算，里面有耗时操作
 使用：1.在willApperar 2.SDK监听会发通知，通知的方法／block 里调用
 给控件初始化一个角标
 
 badage的 数据 获取（个人页面获取所有未读的条数）
 1.在willApear里调用一次   2.SDk消息变化，接受通知，在通知方法还要调用 用于更新 角标数据
 
 */
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


#pragma mark - ----------------------- GET -----------------------

- (SocietyHomePageVC *)societyHomePage
{
    if (!_societyHomePage)
    {
        _societyHomePage = [[SocietyHomePageVC alloc] init];
        _societyHomePage.societyFrame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), _scrollView.bounds.size.height);
        _societyHomePage.delegate = self;
    }
    return _societyHomePage;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    [self updateClassiFiedVC];
}

- (void)dealloc
{
    [self.fanweApp removeObserver:self forKeyPath:@"appModel.video_classified" context:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
