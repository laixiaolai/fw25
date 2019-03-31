//
//  DebugMacro.h
//  CommonLibrary
//
//  Created by Alexi on 13-10-23.
//  Copyright (c) 2013年 ywchen. All rights reserved.
//

#ifndef DebugMacro_h
#define DebugMacro_h

// =================

#ifdef DEBUG

#ifndef DebugLog
#define DebugLog(fmt, ...) NSLog((@"[%s Line %d]" fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#endif

#else

#ifndef DebugLog
#define DebugLog(fmt, ...) // NSLog((@"[%s Line %d]" fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#endif

#define NSLog // NSLog

#endif


// =================
// 日志输出宏定义
#ifdef DEBUG
// 调试状态
#define NSLog(FORMAT, ...) fprintf(stderr,"%s:%d\t%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
// 发布状态
#define NSLog(...)
#endif


#endif

