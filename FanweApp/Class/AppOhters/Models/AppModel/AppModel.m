//
//  AppModel.m
//  ZCTest
//
//  Created by xfg on 16/2/17.
//  Copyright © 2016年 guoms. All rights reserved.
//

#import "AppModel.h"
@implementation VideoClassifiedModel

@end

@implementation AppModel

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"api_link" : @"ApiLinkModel",
             @"start_diagram" : @"AppAdModel",
             @"video_classified":@"VideoClassifiedModel"
             };
}

@end
