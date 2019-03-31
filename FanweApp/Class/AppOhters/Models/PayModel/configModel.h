//
//  configModel.h
//  ZCTest
//
//  Created by GuoMs on 16/1/13.
//  Copyright © 2016年 guoms. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface configModel : NSObject
@property (nonatomic, copy) NSString *retCode;
@property (nonatomic, copy) NSString *retMsg;
@property (nonatomic, strong) NSNumber * is_debug;
@property (nonatomic, copy) NSString * tradeNo;
@end

