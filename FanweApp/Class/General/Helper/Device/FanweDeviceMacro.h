//
//  FanweDeviceMacro.h
//  FanweApp
//
//  Created by xfg on 16/8/3.
//  Copyright © 2016年 xfg. All rights reserved.
//

#ifndef FanweDeviceMacro_h
#define FanweDeviceMacro_h

#define isIPad()                (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define isIPhone()              (!isIPad())

#define isIPhoneX()             (([[UIScreen mainScreen] bounds].size.height-812) ? NO : YES)

#define isIPhone5()             ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define isIPhone4()             ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

#define isIOS11()               ([[UIDevice currentDevice].systemVersion doubleValue]>= 11.0 && [[UIDevice currentDevice].systemVersion doubleValue] < 12.0)

#define isIOS10()               ([[UIDevice currentDevice].systemVersion doubleValue]>= 10.0 && [[UIDevice currentDevice].systemVersion doubleValue] < 11.0)

#define isIOS9()                ([[UIDevice currentDevice].systemVersion doubleValue]>= 9.0 && [[UIDevice currentDevice].systemVersion doubleValue] < 10.0)

#define isIOS8()                ([[UIDevice currentDevice].systemVersion doubleValue]>= 8.0 && [[UIDevice currentDevice].systemVersion doubleValue] < 9.0)

#define isIOS7()                ([[UIDevice currentDevice].systemVersion doubleValue]>= 7.0 && [[UIDevice currentDevice].systemVersion doubleValue] < 8.0)

#define isIOS6()                ([[UIDevice currentDevice].systemVersion doubleValue]>= 6.0 && [[UIDevice currentDevice].systemVersion doubleValue] < 7.0)

#endif /* FanweDeviceMacro_h */
