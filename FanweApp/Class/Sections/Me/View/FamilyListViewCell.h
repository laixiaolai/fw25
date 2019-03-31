//
//  FamilyListViewCell.h
//  FanweApp
//
//  Created by 王珂 on 16/9/26.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FamilyListViewCell;
@protocol FamilyListViewCellDelegate <NSObject>
- (void)applyWithFamilyListViewCell:(FamilyListViewCell *)cell;
@end
@class FamilyListModel;
@interface FamilyListViewCell : UITableViewCell
@property (nonatomic, strong) UIButton * applyBtn;
@property (nonatomic, strong) FamilyListModel * model;
@property (nonatomic, weak) id<FamilyListViewCellDelegate>delegate;
@end
