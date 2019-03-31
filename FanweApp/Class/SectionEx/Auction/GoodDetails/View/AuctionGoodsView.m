//
//  AuctionGoodsView.m
//  FanweApp
//
//  Created by 王珂 on 16/10/11.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "AuctionGoodsView.h"
#import "AuctionGoodsCell.h"
#import "MJRefresh.h"
#import "ShopGoodsModel.h"

@interface AuctionGoodsView()<UITableViewDelegate,UITableViewDataSource,AuctionGoodsCellDelegate>

@property (nonatomic, strong) UITableView * auctionGoodsTable;
@property (nonatomic, strong) NSMutableArray * auctionGoodsArray;
@property (nonatomic, assign) int has_next;
@property (nonatomic, assign) int currentPage;

@end


@implementation AuctionGoodsView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        if (_auctionGoodsTable == nil)
        {
            _auctionGoodsTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 300) style:UITableViewStylePlain];
            _auctionGoodsTable.delegate = self;
            _auctionGoodsTable.dataSource = self;
            _auctionGoodsTable.separatorStyle =  UITableViewCellSeparatorStyleNone;
            _auctionGoodsTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
            [self addSubview:_auctionGoodsTable];
        }
        if (_auctionGoodsArray == nil)
        {
            _auctionGoodsArray = [NSMutableArray array];
        }
        _currentPage=1;
        
        [FWMJRefreshManager refresh:_auctionGoodsTable target:self headerRereshAction:@selector(headerRefresh) shouldHeaderBeginRefresh:NO footerRereshAction:@selector(footerReresh)];
        
    }
    return self;
}

- (void)loadDataWithPage:(int)page
{
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    [mDict setObject:@"shop" forKey:@"ctl"];
    [mDict setObject:@"pai_goods" forKey:@"act"];
    [mDict setObject:[NSString stringWithFormat:@"%d",page] forKey:@"page"];
    [mDict setObject:@"shop" forKey:@"itype"];
    
    FWWeakify(self)
    [self.httpsManager POSTWithParameters:mDict SuccessBlock:^(NSDictionary *responseJson) {
        
        FWStrongify(self)
        if ([responseJson toInt:@"status"] == 1)
        {
            NSDictionary * dic = [responseJson objectForKey:@"page"];
            if (dic && [dic isKindOfClass:[NSDictionary class]])
            {
                self.currentPage = [dic toInt:@"page"];
                if (self.currentPage == 1 || self.currentPage == 0)
                {
                    [self.auctionGoodsArray removeAllObjects];
                }
                self.has_next = [dic toInt:@"has_next"];
            }
            NSArray * dataArray = [responseJson objectForKey:@"list"];
            if (dataArray && [dataArray isKindOfClass:[NSArray class]])
            {
                if(dataArray.count)
                {
                    for (NSDictionary * dic in dataArray)
                    {
                        ShopGoodsModel * model = [ShopGoodsModel mj_objectWithKeyValues:dic];
                        [self.auctionGoodsArray addObject:model];
                    }
                }
                [self.auctionGoodsTable reloadData];
            }
        }
        [FWMJRefreshManager endRefresh:self.auctionGoodsTable];
        if (!self.auctionGoodsArray.count)
        {
            [self showNoContentViewOnView:self];
        }
        else
        {
            [self hideNoContentViewOnView:self];
        }
    } FailureBlock:^(NSError *error) {
        
        FWStrongify(self)
        [FWMJRefreshManager endRefresh:self.auctionGoodsTable];
        
    }];
}

- (void)headerRefresh
{
    [self loadDataWithPage:1];
}

- (void)footerReresh
{
    
    if (_has_next == 1)
    {
        _currentPage ++;
        [self loadDataWithPage:_currentPage];
    }
    else
    {
        [FWMJRefreshManager endRefresh:_auctionGoodsTable];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.auctionGoodsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AuctionGoodsCell * cell = [AuctionGoodsCell cellWithTableView:tableView];
    cell.model=_auctionGoodsArray[indexPath.row];
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (void)clickAuctionWithAuctionGoodsCell:(AuctionGoodsCell *)cell
{
    NSIndexPath * indexPath = [_auctionGoodsTable indexPathForCell:cell];
    self.model = _auctionGoodsArray[indexPath.row];
    if (_delegate && [_delegate respondsToSelector:@selector(closeAuctionGoodsView)])
    {
        [_delegate closeAuctionGoodsView];
    }
}

@end
