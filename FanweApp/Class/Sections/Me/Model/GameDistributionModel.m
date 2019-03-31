//
//  GameDistributionModel.m
//  FanweApp
//
//  Created by 王珂 on 17/4/8.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "GameDistributionModel.h"

@implementation GameUserModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"userID" : @"id",
             @"descrStr": @"description",
             };
}

@end

@implementation PageModel



@end

@implementation GameDistributionModel
+ (NSDictionary *)objectClassInArray{
    return @{
             @"list" : @"GameUserModel",
             };
}

@end
