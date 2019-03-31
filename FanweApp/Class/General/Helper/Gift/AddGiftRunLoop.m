//
//  AddGiftRunLoop.m
//  FanweApp
//
//  Created by xfg on 16/7/6.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "AddGiftRunLoop.h"
#include <sys/time.h>


@implementation AddGiftRunLoop

static void AddGiftEvent(void* info __unused)
{
    // NSLog(@"MSFRunloop source perform");
    // do nothing
}

- (void)dealloc
{
    DebugLog(@"%@ [%@] Release", self, [AddGiftRunLoop class]);
}

static AddGiftRunLoop *_sharedRunLoop = nil;


+ (AddGiftRunLoop *)sharedAddGiftRunLoop
{
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        _sharedRunLoop = [[AddGiftRunLoop alloc] init];
    });
    
    return _sharedRunLoop;
}

- (id)init
{
    if(self = [super init])
    {
        [self start];
    }
    return self;
}

- (void)runloopThreadEntry
{
    NSAssert(![NSThread isMainThread], @"runloopThread error");
    CFRunLoopSourceRef source;
    CFRunLoopSourceContext sourceContext;
    bzero(&sourceContext, sizeof(sourceContext));
    sourceContext.perform = AddGiftEvent;
    source = CFRunLoopSourceCreate(NULL, 0, &sourceContext);
    CFRunLoopAddSource(CFRunLoopGetCurrent(), source, kCFRunLoopCommonModes);
    
    while (YES)
    {
        [[NSRunLoop currentRunLoop] run];
    }
}

- (void)start
{
    if(_thread)
    {
        return;
    }
    
    _thread = [[NSThread alloc] initWithTarget:self selector:@selector(runloopThreadEntry) object:nil];
    
    [_thread setName:@"AddGiftRunLoopThread"];
    if ([[IOSDeviceConfig sharedConfig] isIOS7Later])
    {
        // 设置成线程优先级（优先级最好不要太高，需要保证AV正常）
        [_thread setQualityOfService:NSQualityOfServiceUserInitiated];
    }
    else
    {
        [_thread setThreadPriority:1.0];
    }
    [_thread start];
}


@end


