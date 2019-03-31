//
//  GoodsModel.m
//  FanweApp
//
//  Created by 王珂 on 16/9/18.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "GoodsModel.h"

@implementation GoodsModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if([key isEqualToString:@"description"])
    {
        self.descStr = value;
    }
}

@end
