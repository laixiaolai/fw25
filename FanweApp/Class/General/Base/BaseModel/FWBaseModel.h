//
//  FWBaseModel.h
//  FanweApp
//
//  Created by xfg on 2017/5/3.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FWBaseModel : NSObject

@property (nonatomic, copy) NSString            *act;             // 接口名称
@property (nonatomic, copy) NSString            *ctl;             // 接口名称

@property (nonatomic, copy) NSString            *errorStr;        // 错误信息
@property (nonatomic, assign) NSInteger         status;           // 0：业务上的失败 1：业务上的成功

@end
