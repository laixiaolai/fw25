//
//  MemberApplyCell.h
//  FanweApp
//
//  Created by fanwe2014 on 16/6/18.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MemberApplyCell;
@protocol MemberApplyCellDelegate <NSObject>
- (void)agreeWithMemberApplyCell:(MemberApplyCell *)cell;
- (void)refuseWithMemberApplyCell:(MemberApplyCell *)cell;
@end

@class SenderModel;

@interface MemberApplyCell : UITableViewCell

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, weak) id<MemberApplyCellDelegate>delegate;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)creatCellWithModel:(SenderModel *)model WithRow:(int)row;

@end
