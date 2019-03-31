//
//  NSObject+myobj.m
//  com.yizan.vso2o.business
//
//  Created by zzl on 15/4/28.
//  Copyright (c) 2015年 zy. All rights reserved.
//

#import "NSObject+myobj.h"

@implementation NSObject (myobj)
- (id)objectForKeyMy:(id)aKey
{
    if( [self isKindOfClass:[NSDictionary class]] ||
       [self isKindOfClass:[NSMutableDictionary class]] )
    {
        id s = self;
        id v = [s objectForKey:aKey];
        if( v && [v isKindOfClass: [NSNull class]] ) return nil;
        return v;
    }
    return nil;
}
@end
