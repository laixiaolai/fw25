//
//  PayModel.h
//  ZCTest
//
//  Created by GuoMs on 16/1/13.
//  Copyright © 2016年 guoms. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "configModel.h"

@interface PayModel : NSObject

@property (copy,nonatomic) NSString *session_id;
@property (copy,nonatomic) NSString *pay_code;
@property (copy,nonatomic) NSString *pay_wap;
@property (nonatomic, copy) NSString *act;
@property (nonatomic, copy) NSString *act_2;



@property (nonatomic, strong) NSNumber * response_code;
@property (nonatomic, strong) NSNumber * user_login_status;
@property (nonatomic, strong) NSNumber * is_sdk;
@property (nonatomic, strong) NSNumber * pay_status;
@property (nonatomic, strong) NSNumber * order_id;
@property (nonatomic, strong) NSNumber * payment_notice_id;
@property (nonatomic, strong) NSNumber * pay_type;

@property (nonatomic, strong) configModel *config;


@end
