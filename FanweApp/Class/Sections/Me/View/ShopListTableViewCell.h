//
//  ShopListTableViewCell.h
//  FanweApp
//
//  Created by yy on 16/9/21.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ShopListModel;
@class ShopListTableViewCell;
@protocol ShopListTableViewCellDelegate <NSObject>

- (void)enterEditWithShopListTableViewCell:(ShopListTableViewCell *)shopListTableViewCell;

@end

@interface ShopListTableViewCell : UITableViewCell
@property (nonatomic, strong) ShopListModel * model;
@property (nonatomic, weak) id<ShopListTableViewCellDelegate> delegate;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
