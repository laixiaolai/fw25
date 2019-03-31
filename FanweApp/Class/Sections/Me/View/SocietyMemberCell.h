//
//  SocietyMemberCell.h
//  FanweApp
//
//  Created by 王珂 on 17/1/22.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SocietyMemberCell;
@protocol SocietyMemberCellDelegate <NSObject>
- (void)kickOutWithSocietyMemberCell:(SocietyMemberCell *)cell;
@end
@class SocietyMemberModel;

@interface SocietyMemberCell : UITableViewCell
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, assign) int isSocietyHeader;
@property (nonatomic, weak) id<SocietyMemberCellDelegate>delegate;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)creatCellWithModel:(SocietyMemberModel *)model WithRow:(int)row;
@end
