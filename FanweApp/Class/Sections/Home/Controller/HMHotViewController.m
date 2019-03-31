//
//  HMHotViewController.m
//  FanweApp
//
//  Created by xfg on 2017/7/5.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "HMHotViewController.h"
#import "HMHotModel.h"
#import "HMHotTableViewCell.h"
#import "SDCycleScrollView.h"
#import "ChooseAreaCell.h"
#import "AdJumpViewModel.h"
#import "PublishLivestViewController.h"
#import "AgreementViewController.h"
#import "SChooseAreaView.h"

// 这样子写主要是为了方便拓展
typedef NS_ENUM(NSInteger, HMHotViewSections)
{
    HMHotViewSectionsBanner,        // 广告栏
    HMHotViewSectionsArea,          // 地区选择
    HMHotViewSectionsLiveItem,      // 直播项
};

static NSString *const cellReuseIdentifier0 = @"cellReuseIdentifier0";
static NSString *const cellReuseIdentifier1 = @"cellReuseIdentifier1";

// 广告图默认滚动时间
static float const bannerAutoScrollTimeInterval = 7;

@interface HMHotViewController () <SDCycleScrollViewDelegate, HMHotTableViewCellDelegate, UITableViewDelegate, UITableViewDataSource>
{
    
    ChooseAreaCell                  *_chooseAreaCell;
}

@property (nonatomic, strong) NSMutableArray            *mainDataMArray;
@property (nonatomic, strong) HMHotModel                *hotModel;
@property (nonatomic, strong) SDCycleScrollView         *cycleScrollView;
@property (nonatomic, assign) BOOL                      canClickItem;       // 防止视频列表被重复点击

@end

@implementation HMHotViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)initFWVariables
{
    [super initFWVariables];
    
    self.canClickItem = YES;
}

- (void)initFWUI
{
    [super initFWUI];
    
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
    self.tableView = [[UITableView alloc] initWithFrame:tmpFrame];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = kBackGroundColor;
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"ChooseAreaCell" bundle:nil] forCellReuseIdentifier:cellReuseIdentifier1];
    [self.tableView registerNib:[UINib nibWithNibName:@"HMHotTableViewCell" bundle:nil] forCellReuseIdentifier:cellReuseIdentifier];
    
    // 话题页相关
    if (![FWUtils isBlankString:self.topicName])
    {
        self.navigationItem.title = self.topicName;
    }
    if (![FWUtils isBlankString:self.cate_id])
    {
        [self initJoinTopicView];
        [self setupBackBtnWithBlock:nil];
    }
}

- (void)initFWData
{
    [super initFWData];
    
    [FWMJRefreshManager refresh:self.tableView target:self headerRereshAction:@selector(headerRefresh) footerRereshAction:nil];
    
    // 刷新该页面（主要为了删除最新页已经退出的直播间）
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshHome:) name:kRefreshHomeItem object:nil];
}

- (void)refreshHome:(NSNotification *)noti
{
    if (noti)
    {
        NSDictionary *tmpDict = (NSDictionary *)noti.object;
        NSString *room_id = [tmpDict toString:@"room_id"];
        
        @synchronized (self.mainDataMArray)
        {
            NSMutableArray *tmpArray = self.mainDataMArray;
            for (HMHotItemModel *model in tmpArray)
            {
                if ([model.room_id isEqualToString:room_id])
                {
                    [tmpArray removeObject:model];
                    self.mainDataMArray = tmpArray;
                    [_tableView reloadData];
                    return;
                }
            }
        }
    }
}

- (void)headerRefresh
{
    [self loadDataFromNet:1];
}

- (void)initBanner
{
    if (!_cycleScrollView)
    {
        // 网络加载 创建带标题的图片轮播器
        self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenW, [self bannerHeight]) delegate:self placeholderImage:nil];
        self.cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        self.cycleScrollView.currentPageDotColor = kAppMainColor; // 自定义分页控件小圆标颜色
        self.cycleScrollView.autoScrollTimeInterval = bannerAutoScrollTimeInterval;
        self.cycleScrollView.backgroundColor = kWhiteColor;
    }
    
    NSMutableArray *tmpMArray = [NSMutableArray array];
    for (HMHotBannerModel *bannerModel in self.hotModel.banner)
    {
        [tmpMArray addObject:bannerModel.image];
    }
    
    // 加载延迟
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        self.cycleScrollView.imageURLStringsGroup = tmpMArray;
        
    });
}

#pragma mark 点击图片回调
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    HMHotBannerModel *hotBannerModel = [self.hotModel.banner objectAtIndex:index];
    if ([AdJumpViewModel adToOthersWith:hotBannerModel])
    {
        [[AppDelegate sharedAppDelegate]pushViewController:[AdJumpViewModel adToOthersWith:hotBannerModel]];
    }
}

- (CGFloat)bannerHeight
{
    if (self.hotModel.banner)
    {
        if ([self.hotModel.banner count])
        {
            HMHotBannerModel *bannerModel = [self.hotModel.banner firstObject];
            return bannerModel.bannerHeight;
        }
        else
        {
            return 0;
        }
    }
    else
    {
        return 0;
    }
}

#pragma mark 加载热门页数据
- (void)loadDataFromNet:(int)page
{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"index" forKey:@"ctl"];
    [parmDict setObject:@"index" forKey:@"act"];
    
    if (![FWUtils isBlankString:_sexString])
    {
        [parmDict setObject:_sexString forKey:@"sex"];
    }
    if (![FWUtils isBlankString:_areaString])
    {
        [parmDict setObject:_areaString forKey:@"city"];
    }
    if (![FWUtils isBlankString:self.cate_id])
    {
        [parmDict setObject:self.cate_id forKey:@"cate_id"];
    }
    
    [parmDict setObject:@(page) forKey:@"p"];
    
    FWWeakify(self)
    
    [NetWorkManager asyncPostWithParameters:parmDict successBlock:^(NSDictionary *responseJson, AppNetWorkModel *netWorkModel) {
        
        FWStrongify(self)
        if ([responseJson toInt:@"status"] == 1)
        {
            self.hotModel = [HMHotModel mj_objectWithKeyValues:responseJson];
            self.mainDataMArray = self.hotModel.list;
            [self initBanner];
            [self.tableView reloadData];
        }
        
        [FWMJRefreshManager endRefresh:self.tableView];
        
    } failureBlock:^(NSError *error, AppNetWorkModel *netWorkModel) {
        
        FWStrongify(self)
        [FWMJRefreshManager endRefresh:self.tableView];
        
    }];
}


#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 2)
    {
        return kDefaultMargin;
    }
    else
    {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 2)
    {
        UIView *tmpView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kDefaultMargin)];
        tmpView.backgroundColor = kClearColor;
        return tmpView;
    }
    else
    {
        return nil;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (!_hotModel)
    {
        return 0;
    }
    else
    {
        return 3;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == HMHotViewSectionsBanner)
    {
        if (![FWUtils isBlankString:self.cate_id])
        {
            return 0;
        }
        else
        {
            return 1;
        }
    }
    else if (section == HMHotViewSectionsArea)
    {
        if (![FWUtils isBlankString:self.cate_id])
        {
            return 0;
        }
        else
        {
            return 0;
        }
    }
    else
    {
        return [self.mainDataMArray count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == HMHotViewSectionsBanner)
    {
        return [self bannerHeight];
    }
    else if (indexPath.section == HMHotViewSectionsArea)
    {
        return 44;
    }
    else
    {
        if ([self.mainDataMArray count])
        {
            HMHotItemModel *itemModel = self.mainDataMArray[indexPath.row];
            if ([itemModel.title isEqualToString:@""])
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
            return 0;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == HMHotViewSectionsBanner)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier0];
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReuseIdentifier0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cell addSubview:self.cycleScrollView];
        return cell;
    }
    else if (indexPath.section == HMHotViewSectionsArea)
    {
        _chooseAreaCell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier1 forIndexPath:indexPath];
        _chooseAreaCell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([FWUtils isBlankString:_areaString])
        {
            _chooseAreaCell.areaLabel.text = @"热门";
        }
        else
        {
            _chooseAreaCell.areaLabel.text = _areaString;
        }
        return _chooseAreaCell;
    }
    else
    {
        HMHotTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        if ([self.mainDataMArray count] > indexPath.row)
        {
            HMHotItemModel *tmpModel = [self.mainDataMArray objectAtIndex:indexPath.row];
            [cell initWidthModel:tmpModel rowIndex:indexPath.row];
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == HMHotViewSectionsArea)
    {
        //if need,could to do
    }
    else if (indexPath.section == HMHotViewSectionsLiveItem)
    {
        if ([self.mainDataMArray count] > indexPath.row)
        {
            HMHotItemModel *tmpModel = [self.mainDataMArray objectAtIndex:indexPath.row];
            [self joinLivingRoom:tmpModel];
        }
    }
}

- (void)changeClickState
{
    
}

#pragma mark 加入直播间
- (void)joinLivingRoom:(HMHotItemModel *)model
{
    // 防止重复点击
    if (self.canClickItem)
    {
        self.canClickItem = NO;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            self.canClickItem = YES;
            
        });
    }
    else
    {
        return;
    }
    
    if (![FWUtils isNetConnected])
    {
        return;
    }
    // model  转为 dic
    NSDictionary *dic = model.mj_keyValues;
    // 直播管理中心开启观众直播
    BOOL isSusWindow = [[LiveCenterManager sharedInstance] judgeIsSusWindow];
    [[LiveCenterManager sharedInstance] showLiveOfAudienceLiveofPramaDic:dic.mutableCopy isSusWindow:isSusWindow isSmallScreen:NO block:^(BOOL finished) {
    }];
}


#pragma mark - ----------------------- 代理 -----------------------
#pragma mark 热门搜索的代理
- (void)sentAreaWithName:(NSString *)name andType:(NSString *)typeString
{
    _chooseAreaCell.areaLabel.text = name;
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:name forKey:@"name"];
    [dict setObject:typeString forKey:@"sexType"];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"updateTitleName" object:dict];
    _areaString = name;
    _sexString = typeString;
    [self loadDataFromNet:1];
}

/**
 点击跳转到话题
 
 @param rowIndex 当前行的下标
 */
- (void)pushToTopic:(NSInteger)rowIndex
{
    //    if ([self.mainDataMArray count] > rowIndex)
    //    {
    //        HMHotItemModel *tmpModel = [self.mainDataMArray objectAtIndex:rowIndex];
    //        HMHotViewController *tmpController = [[HMHotViewController alloc]init];
    //        tmpController.topicName = tmpModel.title;
    //        tmpController.cate_id = tmpModel.cate_id;
    //        [[AppDelegate sharedAppDelegate] pushViewController:tmpController];
    //    }
}

/**
 点击用户头像
 
 @param rowIndex 当前行的下标
 */
- (void)clickUserIcon:(NSInteger)rowIndex
{
    if ([self.delegate respondsToSelector:@selector(goToMainPage:)])
    {
        if ([self.mainDataMArray count] > rowIndex)
        {
            HMHotItemModel *tmpModel = [self.mainDataMArray objectAtIndex:rowIndex];
            [self.delegate goToMainPage:tmpModel.user_id];
        }
    }
}


#pragma mark - ----------------------- 其他 -----------------------
#pragma mark 话题点击按钮
- (void)initJoinTopicView
{
    UIImageView *jionView = [UIImageView imageViewWithImage:[UIImage imageNamed:@"ic_create_topic_room"]];
    jionView.frame = CGRectMake((kScreenW - 50) / 2, kScreenH - 180, 50, 50);
    jionView.layer.cornerRadius = 25;
    jionView.layer.masksToBounds = YES;
    jionView.layer.borderWidth = 0.5;
    jionView.layer.borderColor = kAppBorderColor;
    [self.view addSubview:jionView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleToTopic)];
    jionView.userInteractionEnabled = YES;
    [jionView addGestureRecognizer:tap];
}

#pragma mark 点击事件
- (void)handleToTopic
{
    IMALoginParam *loginParam = [IMALoginParam loadFromLocal];
    if (loginParam.isAgree ==1)
    {
        PublishLivestViewController *pvc = [[PublishLivestViewController alloc] init];
        pvc.titleTopic = self.topicName;
        
        [self presentViewController:pvc animated:YES completion:nil];
    }
    else
    {
        loginParam.isAgree = 1;
        [loginParam saveToLocal];
        AgreementViewController *agreeVC = [AgreementViewController webControlerWithUrlStr:[GlobalVariables sharedInstance].appModel.agreement_link isShowIndicator:YES isShowNavBar:YES];
        FWNavigationController *nav = [[FWNavigationController alloc]initWithRootViewController:agreeVC];
        [self presentViewController:nav animated:YES completion:nil];
    }
}


#pragma mark - ----------------------- GET方法 -----------------------
- (NSMutableArray *)mainDataMArray
{
    if (!_mainDataMArray)
    {
        _mainDataMArray = [NSMutableArray array];
    }
    return _mainDataMArray;
}

@end
