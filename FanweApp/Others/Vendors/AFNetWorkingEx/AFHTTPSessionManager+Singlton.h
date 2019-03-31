//
//  AFHTTPSessionManager.h
//  FanweApp
//
//  Created by xfg on 2017/5/3.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AFHTTPSessionManager (Singlton)

+ (AFHTTPSessionManager*)defaultNetManager;

@end
