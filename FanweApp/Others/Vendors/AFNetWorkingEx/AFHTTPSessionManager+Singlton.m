//
//  AFHTTPSessionManager.m
//  FanweApp
//
//  Created by xfg on 2017/5/3.
//  Copyright © 2017年 xfg. All rights reserved.
//

#define kOvertime 30     // 请求超时时间

#import "AFHTTPSessionManager+Singlton.h"

@implementation AFHTTPSessionManager (Singlton)

+ (AFHTTPSessionManager*)defaultNetManager
{
    static AFHTTPSessionManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[AFHTTPSessionManager alloc]init];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.requestSerializer.timeoutInterval = kOvertime;
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/xml", @"text/plain", nil];
        // manager.requestSerializer.cachePolicy = NSURLRequestReturnCacheDataElseLoad;
        
    });
    return manager;
}

@end
