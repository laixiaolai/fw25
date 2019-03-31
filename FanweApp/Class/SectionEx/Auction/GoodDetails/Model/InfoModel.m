//
//  InfoModel.m
//  FanweApp
//
//  Created by fanwe2014 on 16/8/9.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "InfoModel.h"

@implementation InfoModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"ID" : @"id",
              @"Description" : @"description",
             };
}
@end
