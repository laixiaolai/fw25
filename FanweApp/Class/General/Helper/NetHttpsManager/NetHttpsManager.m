//
//  NetHttpsManager.m
//  FanweApp
//
//  Created by xfg on 2017/3/13.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "NetHttpsManager.h"
#import "AFNetworking.h"
#import "ApiLinkModel.h"
#import "GTMBase64.h"
#import "AFHTTPSessionManager+Singlton.h"

#define kOvertime 30     // 请求超时时间

@implementation NetHttpsManager

+ (instancetype)manager
{
    return [[NetHttpsManager alloc] init];
}

#pragma mark - ----------------------- 请求网络方法 -----------------------
/**
 POST异步请求方法一
 
 @param paramDict 请求参数
 @param PostSuccess 成功回调
 @param PostFailure 失败回调
 */
- (void)POSTWithParameters:(NSMutableDictionary *)paramDict SuccessBlock:(SuccessBlock)PostSuccess FailureBlock:(FailureBlock)PostFailure
{
    [self POSTWithUrl:[NetWorkManager getUrlStr:paramDict] paramDict:paramDict SuccessBlock:PostSuccess FailureBlock:PostFailure];
}

/**
 POST异步请求方法二
 
 @param urlStr 接口基本地址
 @param paramDict 请求参数
 @param PostSuccess 成功回调
 @param PostFailure 失败回调
 */
- (void)POSTWithUrl:(NSString *)urlStr paramDict:(NSMutableDictionary *)paramDict SuccessBlock:(SuccessBlock)PostSuccess FailureBlock:(FailureBlock)PostFailure
{
    paramDict = [NetWorkManager getLocalParm:paramDict url:urlStr];
    
    if (![NetWorkManager isExistenceNetwork])
    {
        NSLog(@"请检查当前网络");
    }
    else
    {
        [NetWorkManager myCookieStorage];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager defaultNetManager];
        
        [manager POST:urlStr parameters:paramDict progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            [NetWorkManager doResult:responseObject url:urlStr paramDict:paramDict successBlock:PostSuccess successBlock2:nil failureBlock:PostFailure failureBlock2:nil];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            [NetWorkManager updateErrorToServiceWithUrl:urlStr paramDict:paramDict errorString:[NSString stringWithFormat:@"%@",error]];
            if (PostFailure)
            {
                PostFailure(error);
            }
            
        }];
    }
}

/**
 POST异步请求方法三，带文件
 
 @param parmDict 请求参数
 @param fileUrl 文件的url，流传输方式
 @param PostSuccess 成功回调
 @param PostFailure 失败回调
 */
- (void)POSTWithDict:(NSMutableDictionary *)parmDict andFileUrl:(NSURL *)fileUrl SuccessBlock:(SuccessBlock)PostSuccess FailureBlock:(FailureBlock)PostFailure
{
    NSString *urlStr = [NetWorkManager getUrlStr:parmDict];
    parmDict = [NetWorkManager getLocalParm:parmDict url:urlStr];
    
    if (![NetWorkManager isExistenceNetwork])
    {
        NSLog(@"请检查当前网络");
    }
    else
    {
        [NetWorkManager myCookieStorage];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager defaultNetManager];
        
        [manager POST:urlStr parameters:parmDict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData){
            
            [formData appendPartWithFileURL:fileUrl name:@"file" error:nil];
            
        } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
            
            [NetWorkManager doResult:responseObject url:urlStr paramDict:parmDict successBlock:PostSuccess successBlock2:nil failureBlock:PostFailure failureBlock2:nil];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            [NetWorkManager updateErrorToServiceWithUrl:urlStr paramDict:parmDict errorString:[NSString stringWithFormat:@"%@",error]];
            if (PostFailure)
            {
                PostFailure(error);
            }
            
        }];
    }
}

/**
 POST异步请求方法四，带接口名字的方式
 
 @param method act
 @param ctl ctl
 @param param 请求参数
 @param successBlock 成功回调
 @param failBlock 失败回调
 */
- (void)postMethod:(NSString*)method ctl:(NSString*)ctl param:(NSDictionary*)param successBlock:(SuccessBlock)successBlock failBlock:(FailureBlock)failBlock
{
    NSMutableDictionary* postdir = NSMutableDictionary.new;
    if(param)
    {
        [postdir setDictionary:param];
    }
    
    [postdir setObject:method forKey:@"act"];
    [postdir setObject:ctl forKey:@"ctl"];
    [self POSTWithParameters:postdir SuccessBlock:successBlock FailureBlock:failBlock];
}

/**
 GET异步请求
 
 @param urlStr 接口基本地址
 @param headers headers
 @param GetSuccess 成功回调
 @param GetFailure 失败回调
 */
- (void)GETWithUrl:(NSString *)urlStr headers:(NSMutableDictionary *)headers SuccessBlock:(SuccessBlock)GetSuccess FailureBlock:(FailureBlock)GetFailure
{
    
    if (![NetWorkManager isExistenceNetwork])
    {
        NSLog(@"请检查当前网络");
    }
    else
    {
        AFHTTPSessionManager *manager;
        NSURL *baseURL = [NSURL URLWithString:urlStr];
        if (headers)
        {
            //设置和加入头信息
            NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
            [config setHTTPAdditionalHeaders:headers];
            
            manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL sessionConfiguration:config];
        }
        else
        {
            manager = [[AFHTTPSessionManager alloc]initWithBaseURL:baseURL];
        }
        
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer =[AFHTTPResponseSerializer serializer];
        manager.requestSerializer.timeoutInterval = kOvertime;
        
        [manager GET:urlStr parameters:[NetWorkManager getLocalParm:[NSMutableDictionary dictionary] url:urlStr] progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            [NetWorkManager doResult:responseObject url:urlStr paramDict:nil successBlock:GetSuccess successBlock2:nil failureBlock:GetFailure failureBlock2:nil];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            if (GetFailure)
            {
                GetFailure(error);
            }
            
        }];
    }
}

/**
 NSURLSession同步请求
 
 @param urlStr 接口基本地址
 @param parmDict 请求参数
 @param PostSuccess 成功回调
 @param PostFailure 失败回调
 */
- (void)syncPostWithUrl:(NSString *)urlStr parameters:(NSMutableDictionary *)parmDict SuccessBlock:(SuccessBlock)PostSuccess FailureBlock:(FailureBlock)PostFailure
{
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(10000); //创建信号量
    NSURL *url = [NSURL URLWithString:urlStr];
    
    //(1)构造Request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    //(2)设置为POST请求
    [request setHTTPMethod:@"POST"];
    
    //(3)超时
    [request setTimeoutInterval:kOvertime];
    
    //(4)设置请求头
    //[request setAllHTTPHeaderFields:nil];
    
    //(5)设置请求体
    NSMutableString *params = nil;
    if(nil != parmDict)
    {
        params = [[NSMutableString alloc] init];
        for(id key in parmDict)
        {
            NSString *encodedkey = [key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            CFStringRef value = (__bridge CFStringRef)[[parmDict objectForKey:key] copy];
            CFStringRef encodedValue = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, value,NULL,(CFStringRef)@";/?:@&=+$", kCFStringEncodingUTF8);
            [params appendFormat:@"%@=%@&", encodedkey, encodedValue];
            CFRelease(value);
            CFRelease(encodedValue);
        }
        [params deleteCharactersInRange:NSMakeRange([params length] - 1, 1)];
    }
    
    NSData *bodyData = [params dataUsingEncoding:NSUTF8StringEncoding];
    
    //    if (bodyData)
    //    {
    //        [request setValue:[NSString stringWithFormat:@"%ld",(long)[bodyData length]] forHTTPHeaderField:@"Content-Length"];
    //        [request setHTTPMethod:@"POST"];
    //        [request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    //        [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    
    [request setHTTPBody:bodyData];
    //    }
    
    //(6)构造Session
    NSURLSession *session = [NSURLSession sharedSession];
    
    //(7)task
    __block NSDictionary *resposeDict = nil;
    __block NSError *tmperror = nil;
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        resposeDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        NSLog(@"dict:%@",resposeDict);
        tmperror = error;
        
        dispatch_semaphore_signal(semaphore);   //发送信号
        
    }];
    
    [task resume];
    dispatch_semaphore_wait(semaphore,DISPATCH_TIME_FOREVER);  //等待
    
    if (!tmperror)
    {
        if (resposeDict)
        {
            if([resposeDict count])
            {
                if (PostSuccess!=nil) {
                    PostSuccess(resposeDict);
                }
            }
            else
            {
                if (PostFailure!=nil)
                {
                    PostFailure(tmperror);
                }
            }
        }
        else
        {
            if (PostFailure!=nil)
            {
                PostFailure(tmperror);
            }
        }
    }
    else
    {
        if (PostFailure!=nil)
        {
            PostFailure(tmperror);
        }
    }
}

/**
 同步 调用接口,不要在主线程调用
 
 @param method act
 @param ctl ctl
 @param param 请求参数
 @return 返回NSDictionary值
 */
- (NSDictionary *)postSynchMehtod:(NSString*)method ctl:(NSString*)ctl param:(NSDictionary*)param
{
    MYNSCondition* itlock = [[MYNSCondition alloc] init];//搞个事件来同步下
    
    __block NSDictionary* itret = nil;
    
    [self postMethod:method ctl:ctl param:param successBlock:^(NSDictionary *jsonData) {
        
        itret = jsonData;
        
        [itlock lock];
        
        [itlock signal];//设置事件,下面那个等待就可以收到事件返回了
        
        [itlock unlock];
        
    } failBlock:^(NSError *error) {
        
        NSLog(@"postSynchMehtod eror:%@",error);
        
        [itlock lock];
        
        [itlock signal];//设置事件,下面那个等待就可以收到事件返回了
        
        [itlock unlock];
    }];
    
    [itlock lock];//启动AFNETWORKING之后就等待事件
    
    [itlock wait];
    
    [itlock unlock];
    
    return  itret;
}

@end


#pragma mark - ----------------------- MYNSCondition -----------------------
// 重新NSCondition,原因：如果wait类函数后于signal调用,就会一直等待,也就是说signal线程比wait快执行
@implementation MYNSCondition
{
    __volatile int _waitcounts;
}

- (void)wait
{
    _waitcounts += 1;
    if(_waitcounts <= 0)
    {
        return;     // 本来一进入应该是等于1的,如果其他地方已经有signal了,就直接返回了
    }
    [super wait];
}

- (BOOL)waitUntilDate:(NSDate *)limit
{
    _waitcounts += 1;
    if(_waitcounts <= 0)
    {
        return YES; // 本来一进入应该是等于1的,如果其他地方已经有signal了,就直接返回了
    }
    return [super waitUntilDate:limit];
}

- (void)signal
{
    [super signal];
    _waitcounts -= 1;
}

- (void)broadcast
{
    [super broadcast];
    _waitcounts = -1;
}

@end

