//
//  AuctionGoodsView.h
//  FanweApp
//
//  Created by 王珂 on 16/10/11.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ShopGoodsModel;

@protocol AuctionGoodsViewDelegate<NSObject>

- (void)closeAuctionGoodsView;

@end

@interface AuctionGoodsView : FWBaseView

@property (nonatomic, weak) id<AuctionGoodsViewDelegate> delegate;
@property (nonatomic, copy)  NSString              *hostID;//主播用户ID
@property (nonatomic, strong) ShopGoodsModel          *model;//商品数据模型

- (void)loadDataWithPage:(int)page;

@end
