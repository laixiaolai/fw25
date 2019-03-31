//
//  ShopGoodsTableViewCell.h
//  UIAuctionShop
//
//  Created by 王珂 on 16/9/18.
//  Copyright © 2016年 zongyoutec.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ShopGoodsTableViewCell;

@protocol ShopGoodsTableViewCellDelegate<NSObject>
- (void)closeViewWithShopGoodsTableViewCell:(ShopGoodsTableViewCell *)cell;

@end

@class ShopGoodsModel;

@interface ShopGoodsTableViewCell : UITableViewCell

@property (nonatomic, strong) ShopGoodsModel * model;
@property (nonatomic, assign) int type;//如果是主播type为0，观众为1，无商品为2；
@property (nonatomic, weak) id<ShopGoodsTableViewCellDelegate>delegate;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
