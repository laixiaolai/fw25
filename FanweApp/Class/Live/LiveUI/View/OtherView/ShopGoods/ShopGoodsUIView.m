//
//  ShopGoodsUIView.m
//  UIAuctionShop
//
//  Created by 王珂 on 16/9/18.
//  Copyright © 2016年 qhy. All rights reserved.
//

#import "ShopGoodsUIView.h"
#import "ShopGoodsTableViewCell.h"
#import "ShopGoodsModel.h"

@interface  ShopGoodsUIView()<UITableViewDelegate,UITableViewDataSource,ShopGoodsTableViewCellDelegate>

@property (nonatomic, strong) UITableView   *shopGoodsTable;
//进入主播星店的按钮
@property (nonatomic, strong) UIButton      *starShopBtn;
//购物车按钮
@property (nonatomic, strong) UIButton      *shoppingBtn;
//购物数据
@property (nonatomic, copy)  NSString       *starShopUrl;//星店url地址
//购物数据
@property (nonatomic, strong) NSMutableArray*shopGoodsArray;

//@property (nonatomic, strong) UILabel       *noGoodsLabel;

@property (nonatomic, assign) int           has_next;
@property (nonatomic, assign) int           currentPage;

@end


@implementation ShopGoodsUIView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        if (_shopGoodsTable == nil)
        {
            _shopGoodsTable =[[UITableView alloc] init];
            _shopGoodsTable.delegate = self;
            _shopGoodsTable.dataSource = self;
            _shopGoodsTable.separatorStyle =  UITableViewCellSeparatorStyleNone;
            _shopGoodsTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
            [self addSubview:_shopGoodsTable];
        }
        if (_starShopBtn== nil)
        {
            _starShopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [self addSubview:_starShopBtn];
        }
        if (_shopGoodsArray == nil)
        {
            _shopGoodsArray = [NSMutableArray array];
        }
        _currentPage = 1;
        [self createMJRefresh];
    }
    return self;
}

- (void)starShopBtn:(UIButton *)starShopButton
{
    if (_delegate && [_delegate respondsToSelector:@selector(closeShopGoodsViewWithDic: andIsOTOShop:)])
    {
        NSString * url = _starShopUrl.length > 0 ? _starShopUrl : @"";
        [_delegate closeShopGoodsViewWithDic:@{@"url":url} andIsOTOShop:_isOTOShop];
    }
}

- (void)loadDataWithPage:(int)page
{
    _shopGoodsTable.frame = CGRectMake(0, 0, kScreenW, kShoppingHeight-40) ;
    _starShopBtn.frame = CGRectMake(0, kShoppingHeight-40, kScreenW, 40);
    _starShopBtn.backgroundColor = kAppMainColor;
    if (_type==0)
    {
        if (kSupportH5Shopping || _isOTOShop)
        {
            _shopGoodsTable.frame = CGRectMake(0, 0, kScreenW, kShoppingHeight) ;
            _starShopBtn.hidden = YES;
        }
        else
        {
            [_starShopBtn setTitle:@"星店商品管理" forState:UIControlStateNormal];
            [_starShopBtn addTarget:self action:@selector(starShopBtn:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    else if (_type==1)
    {
        if (_isOTOShop)
        {
            _shopGoodsTable.frame = CGRectMake(0, 0, kScreenW, kShoppingHeight) ;
            _starShopBtn.hidden = YES;
        }
        else
        {
            [_starShopBtn setTitle:@"查看星店" forState:UIControlStateNormal];
            [_starShopBtn addTarget:self action:@selector(starShopBtn:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    if (_hostID.length == 0)
    {
        return;
    }
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    [mDict setObject:@"shop" forKey:@"ctl"];
    if (self.fanweApp.appModel.open_podcast_goods == 1 && _isOTOShop)
    {
        [mDict setObject:@"podcast_mystore" forKey:@"act"];
    }
    else
    {
        [mDict setObject:@"mystore" forKey:@"act"];
    }
    [mDict setObject:_hostID forKey:@"podcast_user_id"];
    [mDict setObject:[NSString stringWithFormat:@"%d",page] forKey:@"page"];
    [mDict setObject:@"shop" forKey:@"itype"];
    FWWeakify(self)
    [self.httpsManager POSTWithParameters:mDict SuccessBlock:^(NSDictionary *responseJson) {
        FWStrongify(self)
        if ([responseJson toInt:@"status"] == 1)
        {
            if([[responseJson allKeys] containsObject:@"url"])
            {
                self.starShopUrl = [responseJson stringForKey:@"url"];
            }
            NSDictionary * dic = [responseJson objectForKey:@"page"];
            if (dic && [dic isKindOfClass:[NSDictionary class]])
            {
                self.currentPage = [dic toInt:@"page"];
                if (self.currentPage == 1 || self.currentPage == 0)
                {
                    [self.shopGoodsArray removeAllObjects];
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
                        [self.shopGoodsArray addObject:model];
                    }
                }
                [self.shopGoodsTable reloadData];
                if (!self.shopGoodsArray.count)
                {
                    [self showNoContentViewOnView:self];
                }
                else
                {
                    [self hideNoContentViewOnView:self];
                }
            }
        }
        
        [FWMJRefreshManager endRefresh:self.shopGoodsTable];
        
    } FailureBlock:^(NSError *error) {
        FWStrongify(self)
        [FWMJRefreshManager endRefresh:self.shopGoodsTable];
        
    }];
}

//上拉刷新
- (void)createMJRefresh
{
    [FWMJRefreshManager refresh:_shopGoodsTable target:self headerRereshAction:@selector(headerRefresh) footerRereshAction:@selector(footerReresh)];
}

- (void)headerRefresh
{
    [self loadDataWithPage:1];
}

//尾部刷新
- (void)footerReresh
{
    if (_has_next == 1)
    {
        _currentPage ++;
        [self loadDataWithPage:_currentPage];
    }
    else
    {
        [FWMJRefreshManager endRefresh:_shopGoodsTable];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.shopGoodsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShopGoodsTableViewCell * cell = [ShopGoodsTableViewCell cellWithTableView:tableView];
    cell.delegate = self;
    ShopGoodsModel * model = _shopGoodsArray[indexPath.row];
    model.type = self.type;
    //model.showDes = self.isOTOShop;
    cell.model = model;
    return cell;
}

//点击tableView的cell的时候跳转界面
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShopGoodsModel * model = _shopGoodsArray[indexPath.row];
    if (_delegate && [_delegate respondsToSelector:@selector(closeShopGoodsViewWithDic: andIsOTOShop:)]) {
        NSString * goodsUrl = model.url.length >0 ? model.url :@"";
        NSString * goodsId = model.goodsId.length >0 ? model.goodsId : @"";
        [_delegate closeShopGoodsViewWithDic:@{@"url":goodsUrl,@"goodsId":goodsId} andIsOTOShop:_isOTOShop];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.fanweApp.appModel.open_podcast_goods == 1 && _isOTOShop) {
        return 120;
    }
    return 100;
}

- (void)closeViewWithShopGoodsTableViewCell:(ShopGoodsTableViewCell *)cell
{
    NSIndexPath * indexPath = [_shopGoodsTable indexPathForCell:cell];
    ShopGoodsModel * goodsModel = _shopGoodsArray[indexPath.row];
    NSString * goodsID =goodsModel.goodsId;
    NSString * goodsUrl =goodsModel.url;
    if (self.type==0)
    {
        if (_delegate && [_delegate respondsToSelector:@selector(closeShopGoodsViewWithDic:andIsOTOShop:)]) {
            [_delegate closeShopGoodsViewWithDic:nil andIsOTOShop:_isOTOShop];
        }
        NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
        [mDict setObject:@"shop" forKey:@"ctl"];
        if (self.fanweApp.appModel.open_podcast_goods == 1 && _isOTOShop) {
            [mDict setObject:@"push_podcast_goods" forKey:@"act"];
        }
        else
        {
            [mDict setObject:@"push_goods" forKey:@"act"];
            [mDict setObject:_hostID forKey:@"podcast_user_id"];
        }
        [mDict setObject:goodsID forKey:@"goods_id"];
        [mDict setObject:@"shop" forKey:@"itype"];
        [self.httpsManager POSTWithParameters:mDict SuccessBlock:^(NSDictionary *responseJson) {
            [[FWHUDHelper sharedInstance] tipMessage:[NSString stringWithFormat:@"%@",[responseJson toString:@"error"]]];
        } FailureBlock:^(NSError *error) {
            
        }];
    }
    //如果是观众点击之后跳转到商品的购买链接
    else if (self.type==1)
    {
        if (_delegate && [_delegate respondsToSelector:@selector(closeShopGoodsViewWithDic:andIsOTOShop:)]) {
            if (goodsUrl.length>0) {
                [_delegate closeShopGoodsViewWithDic:@{@"url":goodsUrl} andIsOTOShop:_isOTOShop];
            }
            else
            {
                [_delegate closeShopGoodsViewWithDic:@{@"url":@""} andIsOTOShop:_isOTOShop];
            }
        }
    }
}

@end
