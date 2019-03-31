//
//  ReleaseViewController.h
//  拍卖
//
//  Created by GuoMs on 16/8/5.
//  Copyright © 2016年 zcd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopListModel.h"
#import "ShopGoodsModel.h"
@class ReleaseViewController;
@class ShopListModel;
@class ShopGoodsModel;

@protocol ReleaseViewControllerDelegate <NSObject>

- (void)onReleaseVCAuctionId:(NSInteger )auctionId;

@end

@interface ReleaseViewController : FWBaseViewController

@property (nonatomic, retain)ShopListModel *model;       //商品实体
@property (nonatomic, weak) id<ReleaseViewControllerDelegate> delegate;
@property (nonatomic, copy) NSString *host_id;
@property (retain, nonatomic) NSString *keyWordStr; //搜索关键字
@property (nonatomic, copy) NSString *shopType;//购物类型:VirtualShopping(虚拟购物)    EntityShopping(实体购物) EditShopping(编辑购物商品) EntityAuctionShopping(实物竞拍)
@property (nonatomic, strong) ShopGoodsModel * auctionGoodsModel; //实物竞拍商品实体
@property (nonatomic, assign) BOOL isOTOShop;

@end
