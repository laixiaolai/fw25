//
//  IOSDeviceConfig.m
//  CommonLibrary
//
//  Created by AlexiChen on 13-1-11.
//  Copyright (c) 2013年 AlexiChen. All rights reserved.
//

#import "IOSDeviceConfig.h"
#import "FanweDeviceMacro.h"

@implementation IOSDeviceConfig

static IOSDeviceConfig *_sharedConfig = nil;

+ (IOSDeviceConfig *)sharedConfig
{
    @synchronized(_sharedConfig)
    {
        if (_sharedConfig == nil) {
            _sharedConfig = [[IOSDeviceConfig alloc] init];
        }
        return _sharedConfig;
    }
}

- (void)dealloc
{
    CommonRelease(_deviceUUID);
    CommonSuperDealloc();
}

- (id)init
{
	if (self = [super init])
	{
        _isIPad = isIPad();
        _isIPhone = isIPhone();
        
        _isIPhone5 = isIPhone5();
        
        _isIOS7 = isIOS7();
        _isIOS8 = isIOS8();
        _isIOS9 = isIOS9();
        _isIOS10 = isIOS10();
        
        _isIOS7Later = [[UIDevice currentDevice].systemVersion doubleValue]>= 8.0;
    }
	return self;
}

- (BOOL)isPortrait
{
    return UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation);
}

@end
