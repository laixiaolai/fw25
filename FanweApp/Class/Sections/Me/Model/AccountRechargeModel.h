//
//  AccountRechargeModel.h
//  FanweApp
//
//  Created by hym on 2016/10/25.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PayTypeModel : NSObject

@property (nonatomic, copy) NSString *class_name;
@property (nonatomic, copy) NSString *logo;
@property (nonatomic, assign) NSInteger payWayID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) BOOL isSelect;
@property (nonatomic, strong) NSMutableArray * rule_list;

@end

@interface PayMoneyModel : NSObject

@property (nonatomic, copy) NSString *iap_money;
@property (nonatomic, assign) NSInteger diamonds;
@property (nonatomic, assign) NSInteger payID;
@property (nonatomic, copy) NSString *money;
@property (nonatomic, copy) NSString *money_name;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *day_num;
@property (nonatomic, copy) NSString *gift_coins;
@property (nonatomic, copy) NSString *gift_coins_des;
@property (nonatomic, assign) BOOL hasOtherPay; //有其它充值可以选择

@end

@interface AccountRechargeModel : NSObject

@property (nonatomic, assign) NSInteger diamonds;
@property (nonatomic, strong) NSMutableArray *pay_list;
@property (nonatomic, strong) NSMutableArray *rule_list;
@property (nonatomic, copy) NSString *rate;
@property (nonatomic, copy) NSString *show_other;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, copy) NSString *vip_expire_time;          //会员到期日期
@property (nonatomic, assign) NSInteger is_vip;                 //是否会员 1-是，0-否
@property (nonatomic, copy) NSString * exchange_rate;         //钻石兑换游戏币的比例

@end
