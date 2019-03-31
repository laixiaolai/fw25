//
//  RechargeDesCell.h
//  FanweApp
//
//  Created by 王珂 on 17/3/13.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountRechargeModel.h"

@class RechargeDesCell;

@protocol RechargeDesCellDelegate<NSObject>
- (void)clickWithRechargeDesCell:(RechargeDesCell *)cell;

@end

@interface RechargeDesCell : UICollectionViewCell

@property (nonatomic, weak) id<RechargeDesCellDelegate> delegate;
@property (nonatomic, strong) UIView        * rechargeView;
@property (nonatomic, strong) UILabel       * numberLabel;
@property (nonatomic, strong) UIImageView   * diamondImageView;
@property (nonatomic, strong) UILabel       * priceLabel;
@property (nonatomic, strong) UILabel       * gameCoinLabel;
@property (nonatomic, strong) UILabel       * otherPayLabel;
@property (nonatomic, strong) PayMoneyModel * model;

@end
