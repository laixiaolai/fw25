//
//  Mwxpay.h
//  O2O
//
//  Created by xfg on 15/4/23.
//  Copyright (c) 2015年 fanwe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Mwxpay : NSObject

@property(nonatomic, retain) NSString *appid;
@property(nonatomic, retain) NSString *noncestr;
@property(nonatomic, retain) NSString *package;
@property(nonatomic, retain) NSString *packagevalue;
@property(nonatomic, retain) NSString *partnerid;
@property(nonatomic, retain) NSString *prepayid;
@property(nonatomic, retain) NSString *timestamp;
@property(nonatomic, retain) NSString *sign;
@property(nonatomic, retain) NSString *subject;
@property(nonatomic, retain) NSString *body;
@property (nonatomic, assign) float total_fee;
@property(nonatomic, retain) NSString *total_fee_format;
@property(nonatomic, retain) NSString *out_trade_no;
@property(nonatomic, retain) NSString *notify_url;
@property(nonatomic, retain) NSString *pay_code;
@property(nonatomic, retain) NSString *key;
@property(nonatomic, retain) NSString *secret;

@end
