//
//  AddGiftRunLoop.h
//  FanweApp
//
//  Created by xfg on 16/7/6.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AddGiftRunLoop : NSObject
{
    NSThread    *_thread;
}

@property (nonatomic, readonly) NSThread *thread;

+ (AddGiftRunLoop *)sharedAddGiftRunLoop;
- (void)start;

@end

