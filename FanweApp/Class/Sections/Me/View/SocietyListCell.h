//
//  SocietyListCell.h
//  FanweApp
//
//  Created by 王珂 on 17/1/22.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SocietyListCell;
@protocol SocietyListCellDelegate <NSObject>
- (void)applyWithSocietyListCell:(SocietyListCell *)cell;
@end
@class SocietyListModel;
@interface SocietyListCell : UITableViewCell
@property (nonatomic, strong) UIButton * applyBtn;
@property (nonatomic, strong) SocietyListModel * model;
@property (nonatomic, weak) id<SocietyListCellDelegate>delegate;
@end
