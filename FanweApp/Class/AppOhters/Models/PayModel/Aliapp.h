//
//  Aliapp.h
//  O2O
//
//  Created by xfg on 15/4/28.
//  Copyright (c) 2015年 fanwe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Aliapp : NSObject

@property(nonatomic, retain) NSString *subject;
@property(nonatomic, retain) NSString *body;
@property (nonatomic, assign) float total_fee;
@property(nonatomic, retain) NSString *total_fee_format;
@property(nonatomic, retain) NSString *out_trade_no;
@property(nonatomic, retain) NSString *notify_url;
@property(nonatomic, retain) NSString *payment_type;
@property(nonatomic, retain) NSString *service;
@property(nonatomic, retain) NSString *_input_charset;
@property(nonatomic, retain) NSString *partner;
@property(nonatomic, retain) NSString *seller_id;
@property(nonatomic, retain) NSString *pay_code;
@property(nonatomic, retain) NSString *order_spec;
@property(nonatomic, retain) NSString *sign;
@property(nonatomic, retain) NSString *sign_type;

@end
