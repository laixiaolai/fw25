//
//  RecommendTypeModel.m
//  FanweApp
//
//  Created by 王珂 on 17/4/10.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "RecommendTypeModel.h"

@implementation RecommendModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"typeID" : @"id",
             @"descrStr": @"description",
             };
}

@end

@implementation RecommendTypeModel

+ (NSDictionary *)objectClassInArray
{
    return @{
             @"invite_type_list" : @"RecommendModel",
             };
}

@end
