//
//  AuctionGoodsCell.h
//  FanweApp
//
//  Created by 王珂 on 16/10/11.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AuctionGoodsCell;
@class ShopGoodsModel;

@protocol AuctionGoodsCellDelegate <NSObject>

- (void)clickAuctionWithAuctionGoodsCell:(AuctionGoodsCell *)cell;

@end

@interface AuctionGoodsCell : UITableViewCell

@property (nonatomic, strong) ShopGoodsModel * model;
@property (nonatomic, weak) id<AuctionGoodsCellDelegate>delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
