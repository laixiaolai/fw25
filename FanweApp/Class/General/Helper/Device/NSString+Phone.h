//
//  NSString+Phone.h
//  FanweApp
//
//  Created by GuoMs on 16/8/31.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Phone)

+(NSString  *)PhoneType;//设备型号

- (BOOL)matchRegex:(NSString *)regex;

- (BOOL)isValidateMobile;

@end
