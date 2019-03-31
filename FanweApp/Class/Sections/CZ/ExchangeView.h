//
//  ExchangeView.h
//  FanweApp
//
//  Created by 王珂 on 17/3/14.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountRechargeModel.h"

@protocol ExchangeViewDelegate<NSObject>

- (void)choseRecharge:(BOOL )recharge orExchange:(BOOL )exchange;

@end

@interface ExchangeView : FWBaseView

@property (nonatomic, strong) AccountRechargeModel * model;
@property (nonatomic, weak) id<ExchangeViewDelegate>delegate;

- (void)cancleExchange;

@end
