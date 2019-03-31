//
//  FWBaseModel.m
//  FanweApp
//
//  Created by xfg on 2017/5/3.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "FWBaseModel.h"

@implementation FWBaseModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"errorStr" : @"error",
             };
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@",[self mj_keyValues]];
}

- (NSString *)debugDescription
{
    return [NSString stringWithFormat:@"%@",[self mj_keyValues]];
}

@end
