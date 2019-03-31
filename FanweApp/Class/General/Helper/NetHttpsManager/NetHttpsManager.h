//
//  NetHttpsManager.h
//  FanweApp
//
//  Created by xfg on 2017/3/13.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^SuccessBlock)(NSDictionary *responseJson);
typedef void (^FailureBlock)(NSError *error);

@interface NetHttpsManager : NSObject

+ (instancetype)manager;

/**
 POST异步请求方法一

 @param paramDict 请求参数
 @param PostSuccess 成功回调
 @param PostFailure 失败回调
 */
- (void)POSTWithParameters:(NSMutableDictionary *)paramDict SuccessBlock:(SuccessBlock)PostSuccess FailureBlock:(FailureBlock)PostFailure;

/**
 POST异步请求方法二

 @param urlStr 接口基本地址
 @param paramDict 请求参数
 @param PostSuccess 成功回调
 @param PostFailure 失败回调
 */
- (void)POSTWithUrl:(NSString *)urlStr paramDict:(NSMutableDictionary *)paramDict SuccessBlock:(SuccessBlock)PostSuccess FailureBlock:(FailureBlock)PostFailure;

/**
 POST异步请求方法三，带文件

 @param parmDict 请求参数
 @param fileUrl 文件的url，流传输方式
 @param PostSuccess 成功回调
 @param PostFailure 失败回调
 */
- (void)POSTWithDict:(NSMutableDictionary *)parmDict andFileUrl:(NSURL *)fileUrl SuccessBlock:(SuccessBlock)PostSuccess FailureBlock:(FailureBlock)PostFailure;

/**
 POST异步请求方法四，带接口名字的方式
 
 @param method act
 @param ctl ctl
 @param param 请求参数
 @param successBlock 成功回调
 @param failBlock 失败回调
 */
- (void)postMethod:(NSString*)method ctl:(NSString*)ctl param:(NSDictionary*)param successBlock:(SuccessBlock)successBlock failBlock:(FailureBlock)failBlock;

/**
 GET异步请求

 @param urlStr 接口基本地址
 @param headers headers
 @param GetSuccess 成功回调
 @param GetFailure 失败回调
 */
- (void)GETWithUrl:(NSString *)urlStr headers:(NSMutableDictionary *)headers SuccessBlock:(SuccessBlock)GetSuccess FailureBlock:(FailureBlock)GetFailure;

/**
 NSURLSession同步请求

 @param urlStr 接口基本地址
 @param parmDict 请求参数
 @param PostSuccess 成功回调
 @param PostFailure 失败回调
 */
- (void)syncPostWithUrl:(NSString *)urlStr parameters:(NSMutableDictionary *)parmDict SuccessBlock:(SuccessBlock)PostSuccess FailureBlock:(FailureBlock)PostFailure;

/**
 同步 调用接口,不要在主线程调用

 @param method act
 @param ctl ctl
 @param param 请求参数
 @return 返回NSDictionary值
 */
- (NSDictionary *)postSynchMehtod:(NSString*)method ctl:(NSString*)ctl param:(NSDictionary*)param;

@end


/**
 重新NSCondition
 
 原因：如果wait类函数后于signal调用,就会一直等待,也就是说signal线程比wait快执行
 注意：尽量做2个线程之间的同步,否则可能结果不符合预期
 */
@interface MYNSCondition : NSCondition

@end
