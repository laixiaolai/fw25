
//
//  NewestViewController.m
//  FanweApp
//
//  Created by fanwe2014 on 16/7/4.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "NewestViewController.h"
#import "cuserModel.h"
#import "LivingModel.h"
#import "OneSectionCell.h"
#import "WebModels.h"
#import <QMapKit/QMapKit.h>
#import <QMapSearchKit/QMapSearchKit.h>
#import "DistanceModel.h"
#import "NewestItemCell.h"

NS_ENUM(NSInteger ,NewEstiewTableView)
{
    FWNewEstFirstSection,                //直播间的画面
    FWNewEstTab_Count,
};

@interface NewestViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property ( nonatomic,strong) UICollectionView                *collectionView;      //CollectionView
@property ( nonatomic,strong) UICollectionViewFlowLayout      *layout;
@property ( nonatomic,assign) int                             page;
@property ( nonatomic,assign) int                             has_next;
@property ( nonatomic,strong) NSMutableArray                  *dataArray;           //数据源
@property ( nonatomic,strong) NSMutableArray                  *titleArray;
//@property ( nonatomic,strong) UIView                          *NoThingView;

@end

@implementation NewestViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)initFWUI
{
    [super initFWUI];
    self.navigationController.navigationBar.hidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    _dataArray = [[NSMutableArray alloc]init];
    _titleArray = [[NSMutableArray alloc]init];
    [self creatView];
}

- (void)initFWData
{
    [super initFWData];
    [self loadDataWithPage:1];
}

#pragma mark 创建UICollectionView
- (void)creatView
{
    _layout = [[UICollectionViewFlowLayout alloc]init];
    _layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _layout.minimumInteritemSpacing = 0;
    _layout.itemSize = CGSizeMake((kScreenW-20)/3,(kScreenW-20)/3+24);
    CGRect tmpFrame;
    if (_collectionViewFrame.size.height)
    {
        tmpFrame = _collectionViewFrame;
    }
    else
    {
        tmpFrame = CGRectMake(0, 0, kScreenW, kScreenH-kNavigationBarHeight-kSegmentedHeight-kTabBarHeight-kStatusBarHeight);
    }
    _collectionView = [[UICollectionView alloc]initWithFrame:tmpFrame collectionViewLayout:_layout];
//    [_collectionView registerClass:[OneSectionCell class] forCellWithReuseIdentifier:@"OneSectionCell"];
    [_collectionView registerNib:[UINib nibWithNibName:@"NewestItemCell" bundle:nil] forCellWithReuseIdentifier:@"NewestItemCell"];
    _collectionView.backgroundColor = kBackGroundColor;
    _collectionView.dataSource =self;
    _collectionView.delegate = self;
    _collectionView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_collectionView];
    //刷新该页面（主要为了删除最新页已经退出的直播间）
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshHome:) name:@"refreshHome" object:nil];
    [FWMJRefreshManager refresh:_collectionView target:self headerRereshAction:@selector(headerReresh) shouldHeaderBeginRefresh:NO footerRereshAction:nil];
    
//    self.NoThingView =[[UIView alloc]initWithFrame:CGRectMake(_collectionView.size.width/2 -75 , _collectionView.size.height/2 -175/2, 150, 175)];
//    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 150, 150)];
//    imageView.image = [UIImage imageNamed:@"com_no_content"];
//    [self.NoThingView addSubview:imageView];
//    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame), 150, 25)];
//    label.text = @"亲~暂无任何内容";
//    label.textAlignment = NSTextAlignmentCenter;
//    label.font = [UIFont systemFontOfSize:13];
//    label.textColor = kLightGrayColor;
//    [self.NoThingView addSubview:label];
//    self.NoThingView.hidden = YES;
//    [_collectionView addSubview:self.NoThingView];
}

#pragma mark ==========================通知==========================
- (void)refreshHome:(NSNotification *)noti
{
    if (noti)
    {
        NSDictionary *tmpDict = (NSDictionary *)noti.object;
        NSString *room_id = [tmpDict toString:@"room_id"];
        @synchronized (_dataArray)
        {
            NSMutableArray *tmpArray = _dataArray;
            for (LivingModel *model in tmpArray)
            {
                if (model.room_id == [room_id intValue])
                {
                    [tmpArray removeObject:model];
                    _dataArray = tmpArray;
                    [_collectionView reloadData];
                    return;
                }
            }
        }
    }
}

#pragma mark 头部刷新
- (void)headerReresh
{
    [self loadDataWithPage:1];
}

#pragma mark 尾部刷新
- (void)footerReresh
{
    if (_has_next == 1)
    {
        _page ++;
        [self loadDataWithPage:_page];
    }
    else
    {
        [FWMJRefreshManager endRefresh:_collectionView];
    }
}

#pragma mark 网络加载
- (void)loadDataWithPage:(int)page
{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"index" forKey:@"ctl"];
    [parmDict setObject:@"new_video" forKey:@"act"];
    [parmDict setObject:[NSString stringWithFormat:@"%d",page] forKey:@"p"];
    [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson)
     {
         if ([responseJson toInt:@"status"] == 1)
         {
             _has_next = [responseJson toInt:@"has_next"];
             _page = [responseJson toInt:@"page"];
             if (_page == 1)
             {
                 [_dataArray removeAllObjects];
                 [_titleArray removeAllObjects];
             }
             //直播数组
             NSArray *listArray = [responseJson objectForKey:@"list"];
             NSMutableArray *listMArray = [[NSMutableArray alloc]init];
             if (listArray && [listArray isKindOfClass:[NSArray class]])
             {
                 if (listArray.count > 0)
                 {
                     for (NSDictionary *dict in listArray)
                     {
                         LivingModel *model = [LivingModel mj_objectWithKeyValues:dict];
                         model.xponit = [dict toFloat:@"xpoint"];
                         model.yponit = [dict toFloat:@"ypoint"];
                         [listMArray addObject:model];
                     }
                 }
             }
             QMapPoint point1 = QMapPointForCoordinate(CLLocationCoordinate2DMake(self.fanweApp.longitude,self.fanweApp.latitude));
             DistanceModel *distanceModel = [[DistanceModel alloc]init];
             if (listMArray.count)
             {
                 _dataArray = [distanceModel CalculateDistanceWithArray:listMArray andPoint:point1];
             }
             [_collectionView reloadData];
             
             if (!self.dataArray.count)
             {
                 [self showNoContentView];
//                 self.NoThingView.hidden = NO;
             }else
             {
                  [self hideNoContentView];
//                   self.NoThingView.hidden = YES;
             }
         }
         [FWMJRefreshManager endRefresh:_collectionView];
         
     } FailureBlock:^(NSError *error)
     {
         [FWMJRefreshManager endRefresh:_collectionView];
     }];
}

#pragma mark UICollectionViewDataSource UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return FWNewEstTab_Count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NewestItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NewestItemCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    LivingModel *LModel = _dataArray[indexPath.row];
    [cell setCellContent:LModel];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((kScreenW-20)/3, (kScreenW-20)/3 + 24);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

#pragma mark  跳转到在线直播
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    LivingModel *model = _dataArray[indexPath.row];
    if (self.delegate)
    {
        if ([self.delegate respondsToSelector:@selector(pushToLiveController:)])
        {
            [self.delegate pushToLiveController:model];
        }
    }
}

#pragma mark 跳转到直播的tableView
- (void)GotoNextViewWithBlockTag:(int)tag
{
    cuserModel *model = _titleArray[tag];
    if (self.delegate)
    {
        if ([self.delegate respondsToSelector:@selector(pushToNextControllerWithModel:)])
        {
            [self.delegate pushToNextControllerWithModel:model];
        }
    }
}




@end
