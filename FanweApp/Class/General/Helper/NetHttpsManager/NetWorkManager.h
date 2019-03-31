//
//  NetWorkManager.h
//  FanweApp
//
//  Created by xfg on 2017/7/26.
//  Copyright © 2017年 xfg. All rights reserved.
//  网络请求

#import <Foundation/Foundation.h>
#import "AppNetWorkModel.h"

/**
 成功回调Block

 @param responseJson 获取的字典返回值
 @param netWorkModel 可扩展Model
 */
typedef void (^SuccessBlock2)(NSDictionary *responseJson, AppNetWorkModel *netWorkModel);

/**
 失败回调Block

 @param error 返回的Error
 @param netWorkModel 可扩展Model
 */
typedef void (^FailureBlock2)(NSError *error, AppNetWorkModel *netWorkModel);


@interface NetWorkManager : NSObject

/**
 POST异步请求方法一
 
 @param act act、ctl组合起来就是一个接口
 @param ctl act、ctl组合起来就是一个接口
 @param paramDict 请求参数
 @param successBlock 成功回调
 @param failureBlock 失败回调
 */
+ (void)asyncPostWithAct:(NSString*)act ctl:(NSString*)ctl paramDict:(NSMutableDictionary *)paramDict successBlock:(SuccessBlock2)successBlock failureBlock:(FailureBlock2)failureBlock;

/**
 POST异步请求方法二

 @param paramDict 请求参数
 @param successBlock 成功回调
 @param failureBlock 失败回调
 */
+ (void)asyncPostWithParameters:(NSMutableDictionary *)paramDict successBlock:(SuccessBlock2)successBlock failureBlock:(FailureBlock2)failureBlock;

/**
 POST异步请求方法三

 @param urlStr 请求的链接
 @param paramDict 请求参数
 @param successBlock 成功回调
 @param failureBlock 失败回调
 */
+ (void)asyncPostWithUrl:(NSString *)urlStr paramDict:(NSMutableDictionary *)paramDict successBlock:(SuccessBlock2)successBlock failureBlock:(FailureBlock2)failureBlock;

/**
 POST异步请求方法四

 @param fileUrlStr 文件的url，流传输方式
 @param urlStr 请求的链接，传nil则表示用底层默认的
 @param paramDict 请求参数
 @param successBlock 成功回调
 @param failureBlock 失败回调
 */
+ (void)asyncPostWithFileUrl:(NSURL *)fileUrlStr url:(NSString *)urlStr paramDict:(NSMutableDictionary *)paramDict successBlock:(SuccessBlock2)successBlock failureBlock:(FailureBlock2)failureBlock;

/**
 GET异步请求方法

 @param urlStr 请求的链接
 @param headers headers，可传nil
 @param successBlock 成功回调
 @param failureBlock 失败回调
 */
+ (void)asyncGetWithUrl:(NSString *)urlStr headers:(NSMutableDictionary *)headers successBlock:(SuccessBlock2)successBlock failureBlock:(FailureBlock2)failureBlock;

/**
 POST同步请求方法

 @param urlStr 请求的链接
 @param paramDict 请求的链接，传nil则表示用底层默认的
 @param successBlock 成功回调
 @param failureBlock 失败回调
 */
+ (void)syncPostWithUrl:(NSString *)urlStr paramDict:(NSMutableDictionary *)paramDict successBlock:(SuccessBlock2)successBlock failureBlock:(FailureBlock2)failureBlock;


#pragma mark - ----------------------- 为了兼容NetHttpsManager，开放以下方法 -----------------------

/**
 判断当前网络状态

 @return 返回状态值
 */
+ (BOOL)isExistenceNetwork;

/**
 非指定url时，获取url

 @param parmDict 底层参数
 @return 返回URL
 */
+ (NSString *)getUrlStr:(NSMutableDictionary *)parmDict;

/**
 底层参数组装

 @param parmDict 传入的参数
 @param urlStr URL地址
 @return 返回组装后的参数
 */
+ (NSMutableDictionary *)getLocalParm:(NSMutableDictionary *)parmDict url:(NSString *)urlStr;

/**
 保存cookie
 */
+ (void)myCookieStorage;

/**
 处理网络请求成功结果

 @param responseObject 请求返回的数据（当前是NSData类型）
 @param urlStr 请求的链接
 @param paramDict 请求参数
 @param successBlock 成功回调，该参数为了兼容NetHttpsManager
 @param successBlock2 成功回调2
 @param failureBlock 失败回调，该参数为了兼容NetHttpsManager
 @param failureBlock2 失败回调2
 */
+ (void)doResult:(id)responseObject url:(NSString *)urlStr paramDict:(NSMutableDictionary *)paramDict successBlock:(SuccessBlock)successBlock successBlock2:(SuccessBlock2)successBlock2 failureBlock:(FailureBlock)failureBlock failureBlock2:(FailureBlock2)failureBlock2;

/**
 处理网络请求失败

 @param urlStr 请求的链接
 @param paramDict 请求参数
 @param errorString 错误描述
 */
+ (void)updateErrorToServiceWithUrl:(NSString *)urlStr paramDict:(NSMutableDictionary *)paramDict errorString:(NSString *)errorString;

@end
