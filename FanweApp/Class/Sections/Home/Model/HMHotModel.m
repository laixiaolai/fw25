//
//  HMHotModel.m
//  FanweApp
//
//  Created by xfg on 2017/7/5.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "HMHotModel.h"

@implementation HMHotModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"ID" : @"id",
             };
}

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"banner" : @"HMHotBannerModel",
             @"list" : @"HMHotItemModel"
             };
}

@end
