//
//  SHomeSVideoV.m
//  FanweApp
//
//  Created by 丁凯 on 2017/8/26.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "SHomeSVideoV.h"
#import "SmallVideoCell.h"
#import "SmallVideoListModel.h"
#import "FWVideoDetailController.h"

@implementation SHomeSVideoV

- (instancetype)initWithFrame:(CGRect)frame andUserId:(NSString *)userId
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = kBackGroundColor;
        self.user_id = userId;
        [self creatMainView];
        [self requestNetDataWithPage:1];
    }
    return self;
}

- (void)creatMainView
{
    self.myCollectionLayout = [[UICollectionViewFlowLayout alloc]init];
    self.myCollectionLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.myCollectionLayout.minimumInteritemSpacing = 5;
    self.myCollectionLayout.itemSize = CGSizeMake((kScreenW-5*kScaleWidth)/2,(kScreenW-5*kScaleWidth)/2);
    self.videoCollectionV = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, self.height) collectionViewLayout:self.myCollectionLayout];
    self.videoCollectionV.delegate = self;
    self.videoCollectionV.dataSource = self;
    self.videoCollectionV.backgroundColor = kBackGroundColor;
    [self.videoCollectionV registerNib:[UINib nibWithNibName:@"SmallVideoCell" bundle:nil] forCellWithReuseIdentifier:@"SmallVideoCell"];
    [self addSubview:self.videoCollectionV];
    [self.videoCollectionV registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"foot"];
    [FWMJRefreshManager refresh:self.videoCollectionV target:self headerRereshAction:nil footerRereshAction:@selector(refreshFooter)];
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

- (void)requestNetDataWithPage:(int)page
{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"svideo" forKey:@"ctl"];
    if (self.user_id)
    {
        [parmDict setObject:self.user_id forKey:@"to_user_id"];
    }
    [parmDict setObject:@"video" forKey:@"act"];
    [parmDict setObject:[NSString stringWithFormat:@"%d",page] forKey:@"page"];
    FWWeakify(self)
    [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
        FWStrongify(self)
        if ([responseJson toInt:@"status"] == 1)
        {
            if (page == 1)
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
            if (self.dataArray.count)
            {
                [self hideNoContentViewOnView:self.videoCollectionV];
            }else
            {
                [self showNoContentViewOnView:self.videoCollectionV];
            }
            [self.videoCollectionV reloadData];
        }
        else
        {
            [[FWHUDHelper sharedInstance] tipMessage:responseJson[@"error"]];
        }
        [FWMJRefreshManager endRefresh:self.videoCollectionV];
        
    } FailureBlock:^(NSError *error)
     {
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
    return 5.0*kScaleWidth;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
   
    if (indexPath.row < self.dataArray.count)
    {
        SmallVideoListModel *model = _dataArray[indexPath.row];
        if (self.VDelegate)
        {
            [self.VDelegate pushToVideoDetailWithWeiboId:model.weibo_id andView:self];
        }
    }
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray)
    {
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArray;
}

@end
