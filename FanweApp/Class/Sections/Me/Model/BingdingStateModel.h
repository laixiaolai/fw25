//
//  BingdingStateModel.h
//  FanweApp
//
//  Created by yy on 16/7/28.
//  Copyright © 2016年 xfg. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface BingdingStateModel : NSObject

@property (nonatomic, copy) NSString *subscribe;
@property (nonatomic, copy) NSString *mobile_exist;
@property (nonatomic, copy) NSString *binding_wx;
@property (nonatomic, copy) NSString *money;
@property (nonatomic, copy) NSString *ticket;
@property (nonatomic, copy) NSString *data;
@property (nonatomic, copy) NSString *subscription;
@property (nonatomic, copy) NSString *useable_ticket;

//新增字段
@property (nonatomic, copy) NSString *is_refund;               //是否开启提现 0指未开启， 1指已开启
@property (nonatomic, copy) NSString *binding_alipay;          //是否绑定支付宝 0指未绑定， 1指已绑定
@property (nonatomic, copy) NSString *withdrawals_alipay;      //是否开启支付宝提现 0未开启，1开启
@property (nonatomic, copy) NSString *withdrawals_wx;          //是否开启微信提现 0未开启，1开启

@property (nonatomic, copy) NSString *refund_exist;           //是否有未处理的提现订单（0:没有 1：有）

@property (nonatomic, strong) NSMutableArray * refund_explain;        //提现说明
@property (nonatomic, copy) NSString * kf_phone;              //客服电话
@property (nonatomic, assign) CGFloat explainCellHeight;

@end
