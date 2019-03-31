//
//  RechargeWayCell.h
//  FanweApp
//
//  Created by 王珂 on 17/5/10.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EdgeInsetsLabel.h"
@class RechargeWayCell;

@protocol RechargeWayCellDelegate<NSObject>

- (void)clickWithRechargeWayCell:(RechargeWayCell *)cell;

@end

@interface RechargeWayCell : UICollectionViewCell

@property (nonatomic, weak) id<RechargeWayCellDelegate> delegate;
//@property (weak, nonatomic) IBOutlet UILabel            *payWayLabel;
@property (weak, nonatomic) IBOutlet EdgeInsetsLabel *payWayLabel;
@property (nonatomic, strong) PayTypeModel              *model;

@end
