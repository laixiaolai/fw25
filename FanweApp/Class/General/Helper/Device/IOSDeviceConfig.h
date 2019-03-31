//
//  IOSDeviceConfig.h
//  CommonLibrary
//
//  Created by AlexiChen on 13-1-11.
//  Copyright (c) 2013年 AlexiChen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IOSDeviceConfig : NSObject

// 固有属性
@property (nonatomic, readonly) BOOL isIPad;

@property (nonatomic, readonly) BOOL isIPhone;

@property (nonatomic, readonly) BOOL isIPhone5;

@property (nonatomic, readonly) BOOL isIOS7;

@property (nonatomic, readonly) BOOL isIOS8;

@property (nonatomic, readonly) BOOL isIOS9;

@property (nonatomic, readonly) BOOL isIOS10;

@property (nonatomic, readonly) BOOL isIOS7Later;

// 全局设置
@property (nonatomic, readonly) BOOL isPortrait;

+ (IOSDeviceConfig *)sharedConfig;

@end
