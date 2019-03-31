//
//  MyProfitConverModel.h
//  FanweApp
//
//  Created by yy on 16/7/28.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyProfitConverModel : NSObject

@property (nonatomic, copy) NSString *diamonds;
@property (nonatomic, copy) NSString *ticket;//拥有票数
@property (nonatomic, copy) NSString *refund_ticket;//已使用票数
@property (nonatomic, copy) NSString *useable_ticket;//可用的票数
@property (nonatomic, copy) NSString *exchange_rules;
@property (nonatomic, copy) NSString *ratio;//兑换比例
@property (nonatomic, copy) NSString *error;//说明

@end
