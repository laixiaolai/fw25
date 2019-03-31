//
//  payWayModel.h
//  FanweApp
//
//  Created by 强强 on 16/7/10.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface payWayModel : NSObject

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *pay_Name;
@property (nonatomic, copy) NSString *rule_Name;
@property (nonatomic, copy) NSString *rule_Money;
@property (nonatomic, copy) NSString *rule_diamonds;
@property (nonatomic, copy) NSString *pay_Class_Name;
@property (nonatomic, copy) NSString *pay_logo;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *diamonds;
@property (nonatomic, copy) NSString *rate;
@property (nonatomic, assign) NSInteger show_other;
@property (nonatomic, copy) NSString *rule_id;
@property (nonatomic, copy) NSString *pay_id;

@end
