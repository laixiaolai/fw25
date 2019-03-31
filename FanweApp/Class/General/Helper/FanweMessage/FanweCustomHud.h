//
//  FanweCustomHud.h
//  FanweApp
//
//  Created by xfg on 2017/3/9.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FanweCustomHud : NSObject

+ (instancetype)sharedInstance;

- (void)startLoadingInView:(UIView*)view tipMsg:(NSString *)tipMsg;

- (void)stopLoading;

@end
