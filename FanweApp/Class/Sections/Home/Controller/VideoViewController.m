//
//  VideoViewController.m
//  FanweApp
//
//  Created by 王珂 on 17/5/2.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "VideoViewController.h"
#import "VideoCollectionViewCell.h"
#import "HMHotModel.h"

@interface VideoViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, assign) int page;
@property (nonatomic, assign) int has_next;
@property (nonatomic, assign) BOOL canClickItem;
@property (nonatomic, strong) HMHotModel * videoModel;

@end

@implementation VideoViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSMutableArray *)dataArray
{
    if (_dataArray == nil)
    {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createView];
}

- (void)createView
{
    self.view.backgroundColor = kBackGroundColor;
    
    UICollectionViewFlowLayout * flow = [[UICollectionViewFlowLayout alloc] init] ;
    CGFloat itemW = (self.viewFrame.size.width-40)/3.0;
    CGFloat itemH = (self.viewFrame.size.width-40)/3.0;
    //设置cell的大小
    flow.itemSize = CGSizeMake(itemW, itemH) ;
    flow.minimumLineSpacing = 9;
    flow.minimumInteritemSpacing = 9;
    flow.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10) ;
    _collectionView = [[UICollectionView alloc] initWithFrame:self.viewFrame collectionViewLayout:flow];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = kClearColor;
    [_collectionView registerNib:[UINib nibWithNibName:@"VideoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"VideoCollectionViewCell"];
    [self.view addSubview:_collectionView];
    [FWMJRefreshManager refresh:_collectionView target:self headerRereshAction:@selector(headerReresh) shouldHeaderBeginRefresh:NO footerRereshAction:@selector(footerRereshing)];
    _canClickItem = YES;
}

#pragma mark -- 头部刷新
- (void)headerReresh
{
    [self setNetworing:1];
}
//尾部刷新
- (void)footerRereshing
{
    if (_has_next == 1)
    {
        _page ++;
        [self setNetworing:_page];
    }
    else
    {
        [FWMJRefreshManager endRefresh:_collectionView];
    }
}

- (void)setNetworing:(int)page
{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"index" forKey:@"ctl"];
    [parmDict setObject:@"classify" forKey:@"act"];
    [parmDict setObject:@(_classified_id) forKey:@"classified_id"];
    [parmDict setObject:@(page) forKey:@"p"];
    FWWeakify(self)
    [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
        
        FWStrongify(self)
        if ([responseJson toInt:@"status"] == 1)
        {
            self.has_next = [responseJson toInt:@"has_next"];
            self.page = [responseJson toInt:@"page"];
            if (self.page == 1)
            {
                [self.dataArray removeAllObjects];
            }
            self.videoModel = [HMHotModel mj_objectWithKeyValues:responseJson];
            [self.dataArray addObjectsFromArray:self.videoModel.list];
            [self.collectionView reloadData];
        }
        
        [FWMJRefreshManager endRefresh:self.collectionView];
        
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
        [FWMJRefreshManager endRefresh:self.collectionView];
        
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    VideoCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"VideoCollectionViewCell" forIndexPath:indexPath] ;
    cell.model = self.dataArray[indexPath.item];
    return cell ;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self joinLivingRoom:self.dataArray[indexPath.item]];
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

@end
