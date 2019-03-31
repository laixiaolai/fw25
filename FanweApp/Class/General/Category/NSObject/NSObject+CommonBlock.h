//
//  NSObject+CommonBlock.h
//  CommonLibrary
//
//  Created by Alexi on 3/11/14.
//  Copyright (c) 2014 CommonLibrary. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppBlockModel.h"
// 错误码定义
#import "FWErrorCodeMacro.h"

// 通用的没有返回参数回调
typedef void (^FWVoidBlock)();
// 通用回调
typedef void (^CommonBlock)(id selfPtr);
// 通用的完成回调
typedef void (^CommonCompletionBlock)(id selfPtr, BOOL isFinished);
// 通用的错误回调
typedef void (^FWErrorBlock)(int errId, NSString *errMsg);
// 通用的没有返回参数的错误回调
typedef void (^FWVoidErrorBlock)();
// 通用的成功回调
typedef void (^FWIsSuccBlock)(BOOL isSucc);
// 通用的完成回调
typedef void (^FWIsFinishedBlock)(BOOL isFinished);
// 可扩展的block
typedef void (^AppCommonBlock)(AppBlockModel *blockModel);


@interface NSObject (CommonBlock)

- (void)excuteBlock:(CommonBlock)block;

- (void)performBlock:(CommonBlock)block;

//- (void)cancelBlock:(CommonBlock)block;

- (void)performBlock:(CommonBlock)block afterDelay:(NSTimeInterval)delay;

- (void)excuteCompletion:(CommonCompletionBlock)block withFinished:(NSNumber *)finished;

- (void)performCompletion:(CommonCompletionBlock)block withFinished:(BOOL)finished;

// 并发执行tasks里的作务，等tasks执行行完毕，回调到completion
- (void)asynExecuteCompletion:(CommonBlock)completion tasks:(CommonBlock)task, ... NS_REQUIRES_NIL_TERMINATION;

@end
