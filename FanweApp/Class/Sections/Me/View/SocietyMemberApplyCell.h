//
//  SocietyMemberApplyCell.h
//  FanweApp
//
//  Created by 王珂 on 17/1/22.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SocietyMemberApplyCell;
@protocol SocietyMemberApplyCellDelegate <NSObject>
- (void)agreeWithSocietyMemberApplyCell:(SocietyMemberApplyCell *)cell;
- (void)refuseWithSocietyMemberApplyCell:(SocietyMemberApplyCell *)cell;
@end

@class SocietyMemberModel;
@interface SocietyMemberApplyCell : UITableViewCell

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, weak) id<SocietyMemberApplyCellDelegate>delegate;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)creatCellWithModel:(SocietyMemberModel *)model WithRow:(int)row;
@end
