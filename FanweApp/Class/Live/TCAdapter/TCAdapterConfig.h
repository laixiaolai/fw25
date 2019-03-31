//
//  TCAdapterConfig.h
//  TCShow
//
//  Created by AlexiChen on 16/6/2.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#ifndef TCAdapterConfig_h
#define TCAdapterConfig_h

//================================以下是项目状态控制宏==================================================

// BetaVersation配置
#if DEBUG

#ifndef kBetaVersion
#define kBetaVersion                1
#endif

#else

#if kAppStoreVersion

#ifndef kBetaVersion
#define kBetaVersion                0
#endif

#else

#ifndef kBetaVersion
#define kBetaVersion                1
#endif

#endif

#endif


//==================================================================================

// 为方便测试同事进行日志查看
#if kBetaVersion

#define TIMLog(fmt, ...) [[TIMManager sharedInstance] log:TIM_LOG_INFO tag:@"TIMLog" msg:[NSString stringWithFormat:@"[%s Line %d]" fmt, __PRETTY_FUNCTION__, __LINE__,  ##__VA_ARGS__]];

#else

#if DEBUG
#define TIMLog(fmt, ...) NSLog((@"[%s Line %d]" fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define TIMLog(fmt, ...) //NSLog((@"[%s Line %d]" fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#endif

#endif


//==================================================================================
// 是否支持消息缓存，而不是立即显示，主要是看大消息量时，立即显示会导致界面卡顿
// 因不清楚各App的消息种类，以及消息类型（是否支持IM等），故放到业务层去处理，各App可依照此处逻辑
// 为0时，立即显示
// 为1时，会按固定频率刷新
#ifndef kSupportIMMsgCache
#define kSupportIMMsgCache  1
#endif

//==================================================================================
// 用于真机时，测试获取日志
static NSDateFormatter *kTCAVIMLogDateFormatter = nil;

#if DEBUG

// 主要用于腾讯测试同事，获取获取进行统计进房间时间，以及第一帧画面时间，外部用户使用时可改为0
#ifndef kSupportTimeStatistics
#define kSupportTimeStatistics 1
#endif

#define TCAVIMLog(fmt, ...)  {\
if (!kTCAVIMLogDateFormatter) \
{\
kTCAVIMLogDateFormatter = [[NSDateFormatter alloc] init];\
[kTCAVIMLogDateFormatter setDateStyle:NSDateFormatterMediumStyle];\
[kTCAVIMLogDateFormatter setTimeStyle:NSDateFormatterShortStyle];\
[kTCAVIMLogDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];\
}\
NSLog((@"TCAdapter时间统计 时间点:%@ [%s Line %d] ------->>>>>>\n" fmt), [kTCAVIMLogDateFormatter stringFromDate:[NSDate date]], __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);\
}

#else


#if kAppStoreVersion

// AppStore版本不统计
#ifndef kSupportTimeStatistics
#define kSupportTimeStatistics 0
#endif

// 用于release时，真机下面获取App关键路径日志日志
#define TCAVIMLog(fmt, ...)  /**/
#else

// 主要用于腾讯测试同事，获取获取进行统计进房间时间，以及第一帧画面时间，外部用户使用时可改为0
#ifndef kSupportTimeStatistics
#define kSupportTimeStatistics 1
#endif

// 用于release时，真机下面获取App关键路径日志日志
#define TCAVIMLog(fmt, ...) {\
if (!kTCAVIMLogDateFormatter) \
{ \
kTCAVIMLogDateFormatter = [[NSDateFormatter alloc] init];\
[kTCAVIMLogDateFormatter setDateStyle:NSDateFormatterMediumStyle];\
[kTCAVIMLogDateFormatter setTimeStyle:NSDateFormatterShortStyle];\
[kTCAVIMLogDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];\
}\
[[TIMManager sharedInstance] log:TIM_LOG_INFO tag:@"TCAdapter时间统计" msg:[NSString stringWithFormat:(@"时间点:%@ [%s Line %d] ------->>>>>>" fmt), [kTCAVIMLogDateFormatter stringFromDate:[NSDate date]], __PRETTY_FUNCTION__, __LINE__,  ##__VA_ARGS__]];\
}

#endif

#endif

//==================================================================================
#if DEBUG
// 调试状态下
// 是否使用AVChatRoom创建直播聊天室
// 使用聊天室主要来验证性能，直正直播时，使用AVChatRoom
#ifndef kSupportAVChatRoom
#define kSupportAVChatRoom 1
#endif

#ifndef kSupportFixLiveChatRoomID
// 是否因定群ID
#define kSupportFixLiveChatRoomID 0
#endif

#if kSupportAVChatRoom
#ifndef kAVChatRoomType
#define kAVChatRoomType @"AVChatRoom"
#endif
#else
#ifndef kAVChatRoomType
#define kAVChatRoomType @"ChatRoom"
#endif
#endif

#else

#ifndef kSupportAVChatRoom
// Release下
#define kSupportAVChatRoom 1
#endif

#ifndef kAVChatRoomType
#define kAVChatRoomType @"AVChatRoom"
#endif

#endif

#endif /* TCAdapterConfig_h */
