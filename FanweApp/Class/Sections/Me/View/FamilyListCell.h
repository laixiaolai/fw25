//
//  FamilyListCell.h
//  FanweApp
//
//  Created by fanwe2014 on 16/6/18.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FamilyListCell;
@protocol FamilyListCellDelegate <NSObject>
- (void)kickOutWithFamilyListCell:(FamilyListCell *)cell;
@end
@class SenderModel;

@interface FamilyListCell : UITableViewCell
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, assign) int isFamilyHeader;
@property (nonatomic, weak) id<FamilyListCellDelegate>delegate;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)creatCellWithModel:(SenderModel *)model WithRow:(int)row;

@end
