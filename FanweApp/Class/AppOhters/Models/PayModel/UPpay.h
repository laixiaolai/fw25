//
//  UPpay.h
//  O2O
//  银联支付
//  Created by xfg on 15/5/18.
//  Copyright (c) 2015年 fanwe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UPpay : NSObject

@property (nonatomic, assign) int accessType;
@property(nonatomic, retain) NSString *bizType;
@property(nonatomic, retain) NSString *certId;
@property(nonatomic, retain) NSString *encoding;
@property(nonatomic, retain) NSString *merId;
@property(nonatomic, retain) NSString *orderId;
@property(nonatomic, retain) NSString *reqReserved;
@property(nonatomic, retain) NSString *respCode;
@property(nonatomic, retain) NSString *respMsg;
@property(nonatomic, retain) NSString *signMethod;
@property(nonatomic, retain) NSString *tn;
@property(nonatomic, retain) NSString *txnSubType;
@property(nonatomic, retain) NSString *txnTime;
@property(nonatomic, retain) NSString *txnType;
@property(nonatomic, retain) NSString *version;
@property(nonatomic, retain) NSString *signature;

@end
