//
//  RechargeView.h
//  FanweApp
//
//  Created by 王珂 on 17/3/13.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RechargeWayView.h"
#import "AccountRechargeModel.h"

@class RechargeView;

@protocol RechargeViewDelegate<NSObject>

- (void)choseRecharge:(BOOL )recharge orExchange:(BOOL )exchange;
//充值成功后调用进行刷新账号钻石相关的数据
- (void)rechargeSuccessWithRechargeView:(RechargeView *)rechargeView;
@optional
- (void)choseOtherRechargeWithRechargeView:(RechargeView *)rechargeView;

@end

@interface RechargeView : UIView

@property (nonatomic, strong) AccountRechargeModel * model;
@property (nonatomic, weak) id<RechargeViewDelegate>delegate;
@property (nonatomic, assign) NSInteger indexPayWay;
@property (nonatomic, strong) NSString *money;
@property (nonatomic, strong)UIViewController * viewController;

- (void)loadRechargeData;
- (void)payRequestWithModel:(PayMoneyModel *)payModel withPayWayIndex:(NSInteger )index; //其它充值调用的方法
- (instancetype)initWithFrame:(CGRect)frame andUIViewController:(UIViewController *)viewController;

@end
