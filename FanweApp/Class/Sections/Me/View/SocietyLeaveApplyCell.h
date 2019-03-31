//
//  SocietyLeaveApplyCell.h
//  FanweApp
//
//  Created by 王珂 on 17/1/22.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SocietyLeaveApplyCell;
@protocol SocietyLeaveApplyCellDelegate <NSObject>
- (void)agreeQuitWithSocietyLeaveApplyCell:(SocietyLeaveApplyCell *)cell;
- (void)refuseQuitWithSocietyLeaveApplyCell:(SocietyLeaveApplyCell *)cell;
@end
@class SocietyMemberModel;
@interface SocietyLeaveApplyCell : UITableViewCell

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, weak) id<SocietyLeaveApplyCellDelegate>delegate;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)creatCellWithModel:(SocietyMemberModel *)model WithRow:(int)row;
@end
