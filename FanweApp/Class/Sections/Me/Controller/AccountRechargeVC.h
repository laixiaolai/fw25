//
//  AccountRechargeVC.h
//  FanweApp
//
//  Created by hym on 2016/10/25.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountRechargeModel.h"

@interface AccountRechargeVC : FWBaseViewController

@property (nonatomic, assign) BOOL          is_vip;         //是否vip充值
@property (nonatomic, strong) UILabel       *lbTitles;
@property (nonatomic, strong) UIImageView   *diamImageView;
@property (nonatomic, strong) UILabel       *lbBalance;

@end
