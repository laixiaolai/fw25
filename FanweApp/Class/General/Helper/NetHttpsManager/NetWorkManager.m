//
//  NetWorkManager.m
//  FanweApp
//
//  Created by xfg on 2017/7/26.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "NetWorkManager.h"
#import "AFNetworking.h"
#import "ApiLinkModel.h"
#import "GTMBase64.h"
#import "AFHTTPSessionManager+Singlton.h"

#define kOvertime 30     // 请求超时时间

@implementation NetWorkManager

#pragma mark - ----------------------- 相关配置 -----------------------

#pragma mark 判断当前网络状态
+ (BOOL)isExistenceNetwork
{
    BOOL isExistenceNetwork = YES;
    switch ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus)
    {
        case AFNetworkReachabilityStatusUnknown:
            isExistenceNetwork = YES;
            break;
        case AFNetworkReachabilityStatusNotReachable:
            isExistenceNetwork = NO;
            break;
        case AFNetworkReachabilityStatusReachableViaWWAN:
            isExistenceNetwork = YES;
            break;
        case AFNetworkReachabilityStatusReachableViaWiFi:
            isExistenceNetwork = YES;
            break;
            
        default:
            break;
    }
    
    return isExistenceNetwork;
}

#pragma mark 非指定url时，获取url
+ (NSString *)getUrlStr:(NSMutableDictionary *)parmDict
{
    GlobalVariables *fanweApp = [GlobalVariables sharedInstance];
    NSString *urlString = fanweApp.currentDoMianUrlStr;
    
    if (fanweApp.appModel.api_link)
    {
        if ([fanweApp.appModel.api_link count])
        {
            for (ApiLinkModel *apiLinkModel in fanweApp.appModel.api_link)
            {
                NSString *ctl_act = [NSString stringWithFormat:@"%@_%@",[parmDict toString:@"ctl"],[parmDict toString:@"act"]];
                if ([ctl_act isEqualToString:apiLinkModel.ctl_act])
                {
                    urlString = apiLinkModel.api;
                }
            }
        }
    }
    
    return urlString;
}

#pragma mark 底层参数等
+ (NSMutableDictionary *)getLocalParm:(NSMutableDictionary *)parmDict url:(NSString *)urlStr
{
    GlobalVariables *fanweApp = [GlobalVariables sharedInstance];
    
#if kSupportH5Shopping
    [parmDict setObject:@"sdk" forKey:@"itype"];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    NSString *filePath = [docDir stringByAppendingPathComponent:@"session_id"];
    NSArray *array = [[NSArray alloc]initWithContentsOfFile:filePath];
    if (array.count)
    {
        [parmDict setObject:array[0] forKey:@"session_id"];
    }
#endif
    
    [parmDict setObject:VersionNum forKey:@"sdk_version_name"];
    [parmDict setObject:@"ios" forKey:@"sdk_type"];
    [parmDict setObject:VersionTime forKey:@"sdk_version"];
    //    [parmDict setObject:[NSString stringWithFormat:@"%f",kScreenWidth] forKey:@"kScreenW"];
    //    [parmDict setObject:[NSString stringWithFormat:@"%f",kScreenHeight] forKey:@"kScreenH"];
    if (fanweApp.longitude && fanweApp.latitude)
    {
        [parmDict setObject:[NSString stringWithFormat:@"%f",fanweApp.longitude] forKey:@"xpoint"]; // 经度
        [parmDict setObject:[NSString stringWithFormat:@"%f",fanweApp.latitude] forKey:@"ypoint"];  // 经度
    }
    
#if kAppStoreVersion
    
#else
    
#ifdef DEBUG
    
    //=======================================此段代码只是用于打印URL============================================================
    /*调试代码 */
    NSInteger count = parmDict.count;
    NSString *str = [NSString stringWithFormat:@"%@?",urlStr];
    
    for (int i = 0;i < count;i++)
    {
        NSString *tmpStr = [NSString stringWithFormat:@"%@=%@&",parmDict.allKeys[i],parmDict.allValues[i]];
        if (tmpStr && ![tmpStr isEqualToString:@""])
        {
            str = [str stringByAppendingString:tmpStr];
        }
    }
    NSLog(@"请求链接-----------------------------------------------------\n%@",str);
    NSLog(@"-----------------------------------------------------------------------\n");
    //========================================此段代码只是用于打印URL============================================================
    
#endif
    
#endif
    
    if ([IsNeedAES isEqualToString:@"YES"])
    {
        if (fanweApp.aesKeyStr.length != 16)
        {
            [FanweMessage alert:@"您的AES加密密码长度不是16位！"];
        }
        // AES加密
        NSData *data = [NSJSONSerialization dataWithJSONObject:parmDict options:NSJSONWritingPrettyPrinted error:nil];
        if (data)
        {
            NSString *parmStr = [data AES256EncryptWithKey:fanweApp.aesKeyStr];
            if (![FWUtils isBlankString:parmStr])
            {
                NSMutableDictionary *tmpDict = [NSMutableDictionary dictionary];
                [tmpDict setObject:[parmDict toString:@"act"] forKey:@"act"];
                [tmpDict setObject:[parmDict toString:@"ctl"] forKey:@"ctl"];
                if ([parmDict objectForKey:@"itype"])
                {
                    [tmpDict setObject:[parmDict toString:@"itype"] forKey:@"itype"];
                }
                [tmpDict setObject:VersionNum forKey:@"sdk_version_name"];
                
                [parmDict removeAllObjects];
                parmDict = tmpDict;
                [parmDict setObject:parmStr forKey:@"requestData"];
                [parmDict setObject:@"1" forKey:@"i_type"];
            }
        }
    }
    
    return parmDict;
}

#pragma mark 保存cookie
+ (void)myCookieStorage
{
    NSData *cookiesdata = [[NSUserDefaults standardUserDefaults] objectForKey:kMyCookies];
    if([cookiesdata length])
    {
        NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:cookiesdata];
        NSHTTPCookie *cookie;
        for (cookie in cookies)
        {
            if (![FWUtils isBlankString:cookie.name] && ![FWUtils isBlankString:cookie.value])
            {
                [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
            }
        }
    }
}


#pragma mark - ----------------------- 请求网络方法 -----------------------

/**
 POST异步请求方法一
 
 @param act act、ctl组合起来就是一个接口
 @param ctl act、ctl组合起来就是一个接口
 @param paramDict 请求参数
 @param successBlock 成功回调
 @param failureBlock 失败回调
 */
+ (void)asyncPostWithAct:(NSString*)act ctl:(NSString*)ctl paramDict:(NSMutableDictionary *)paramDict successBlock:(SuccessBlock2)successBlock failureBlock:(FailureBlock2)failureBlock
{
    NSMutableDictionary* postdic = NSMutableDictionary.new;
    if(paramDict)
    {
        [postdic setDictionary:paramDict];
    }
    [postdic setObject:act forKey:@"act"];
    [postdic setObject:ctl forKey:@"ctl"];
    
    [NetWorkManager asyncPostWithParameters:postdic successBlock:successBlock failureBlock:failureBlock];
}

/**
 POST异步请求方法二
 
 @param paramDict 请求参数
 @param successBlock 成功回调
 @param failureBlock 失败回调
 */
+ (void)asyncPostWithParameters:(NSMutableDictionary *)paramDict successBlock:(SuccessBlock2)successBlock failureBlock:(FailureBlock2)failureBlock
{
    [NetWorkManager asyncPostWithUrl:[NetWorkManager getUrlStr:paramDict] paramDict:paramDict successBlock:successBlock failureBlock:failureBlock];
}

/**
 POST异步请求方法三
 
 @param urlStr 请求的链接
 @param paramDict 请求参数
 @param successBlock 成功回调
 @param failureBlock 失败回调
 */
+ (void)asyncPostWithUrl:(NSString *)urlStr paramDict:(NSMutableDictionary *)paramDict successBlock:(SuccessBlock2)successBlock failureBlock:(FailureBlock2)failureBlock
{
    [NetWorkManager asyncPostWithFileUrl:nil url:urlStr paramDict:paramDict successBlock:successBlock failureBlock:failureBlock];
}

/**
 POST异步请求方法四
 
 @param fileUrlStr 文件的url，流传输方式
 @param urlStr 请求的链接，传nil则表示用底层默认的
 @param paramDict 请求参数
 @param successBlock 成功回调
 @param failureBlock 失败回调
 */
+ (void)asyncPostWithFileUrl:(NSURL *)fileUrlStr url:(NSString *)urlStr paramDict:(NSMutableDictionary *)paramDict successBlock:(SuccessBlock2)successBlock failureBlock:(FailureBlock2)failureBlock
{
    if ([FWUtils isBlankString:urlStr])
    {
        urlStr = [NetWorkManager getUrlStr:paramDict];
    }
    paramDict = [self getLocalParm:paramDict url:urlStr];
    
    if (![NetWorkManager isExistenceNetwork])
    {
        NSLog(@"请检查当前网络");
    }
    else
    {
        [self myCookieStorage];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager defaultNetManager];
        
        [manager POST:urlStr parameters:paramDict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData){
            
            if (fileUrlStr)
            {
                [formData appendPartWithFileURL:fileUrlStr name:@"file" error:nil];
            }
            
        } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
            
            if (successBlock)
            {
                [NetWorkManager doResult:responseObject url:urlStr paramDict:paramDict successBlock:successBlock failureBlock:failureBlock];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            if (failureBlock)
            {
                [NetWorkManager updateErrorToServiceWithUrl:urlStr paramDict:paramDict errorString:[NSString stringWithFormat:@"%@",error]];
                failureBlock(error, [AppNetWorkModel manager]);
            }
            
        }];
    }
}

/**
 GET异步请求方法
 
 @param urlStr 请求的链接
 @param headers headers
 @param successBlock 成功回调
 @param failureBlock 失败回调
 */
+ (void)asyncGetWithUrl:(NSString *)urlStr headers:(NSMutableDictionary *)headers successBlock:(SuccessBlock2)successBlock failureBlock:(FailureBlock2)failureBlock
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
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/xml", @"text/plain", nil];
        
        [manager GET:urlStr parameters:[self getLocalParm:[NSMutableDictionary dictionary] url:urlStr] progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            if (successBlock)
            {
                [NetWorkManager doResult:responseObject url:urlStr paramDict:nil successBlock:successBlock failureBlock:failureBlock];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            if (failureBlock)
            {
                failureBlock(error, [AppNetWorkModel manager]);
            }
            
        }];
    }
}

/**
 POST同步请求方法
 
 @param urlStr 请求的链接
 @param paramDict 请求的链接，传nil则表示用底层默认的
 @param successBlock 成功回调
 @param failureBlock 失败回调
 */
+ (void)syncPostWithUrl:(NSString *)urlStr paramDict:(NSMutableDictionary *)paramDict successBlock:(SuccessBlock2)successBlock failureBlock:(FailureBlock2)failureBlock
{
    if ([FWUtils isBlankString:urlStr])
    {
        urlStr = [NetWorkManager getUrlStr:paramDict];
    }
    NSURL *url = [NSURL URLWithString:urlStr];
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0); //创建信号量
    
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
    if(nil != paramDict)
    {
        params = [[NSMutableString alloc] init];
        for(id key in paramDict)
        {
            NSString *encodedkey = [key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            CFStringRef value = (__bridge CFStringRef)[[paramDict objectForKey:key] copy];
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
    __block NSData *resposeNSData = nil;
    __block NSError *tmperror = nil;
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        resposeNSData = data;
        tmperror = error;
        
        dispatch_semaphore_signal(semaphore);   //发送信号
        
    }];
    
    [task resume];
    dispatch_semaphore_wait(semaphore,DISPATCH_TIME_FOREVER);  //等待
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (!tmperror)
        {
            if (resposeNSData)
            {
                if (successBlock)
                {
                    
                    [NetWorkManager doResult:resposeNSData url:urlStr paramDict:paramDict successBlock:successBlock failureBlock:failureBlock];
                }
            }
            else
            {
                if (failureBlock)
                {
                    failureBlock(nil, [AppNetWorkModel manager]);
                }
            }
        }
        else
        {
            if (failureBlock)
            {
                failureBlock(nil, [AppNetWorkModel manager]);
            }
        }
        
    });
}


#pragma mark - ----------------------- 请求网络结果处理 -----------------------

#pragma mark 请求网络成功结果处理
+ (void)doResult:(id)responseObject url:(NSString *)urlStr paramDict:(NSMutableDictionary *)paramDict successBlock:(SuccessBlock2)successBlock failureBlock:(FailureBlock2)failureBlock
{
    [NetWorkManager doResult:responseObject url:urlStr paramDict:paramDict successBlock:nil successBlock2:successBlock failureBlock:nil failureBlock2:failureBlock];
}

+ (void)doResult:(id)responseObject url:(NSString *)urlStr paramDict:(NSMutableDictionary *)paramDict successBlock:(SuccessBlock)successBlock successBlock2:(SuccessBlock2)successBlock2 failureBlock:(FailureBlock)failureBlock failureBlock2:(FailureBlock2)failureBlock2
{
    if (!responseObject)
    {
        if (failureBlock2)
        {
            failureBlock2(nil, [AppNetWorkModel manager]);
        }
        else if (failureBlock)
        {
            failureBlock(nil);
        }
    }
    
    GlobalVariables *fanweApp = [GlobalVariables sharedInstance];
    
    NSHTTPCookie *sessinCookie;
    NSHTTPCookieStorage *sharedHTTPCookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookies = [sharedHTTPCookieStorage cookiesForURL:[NSURL URLWithString:urlStr]];
    NSEnumerator *enumerator = [cookies objectEnumerator];
    NSHTTPCookie *cookie;
    while (cookie = [enumerator nextObject])
    {
        if (![cookie.name isEqualToString:@""] && ![cookie.value isEqualToString:@""])
        {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
            if ([cookie.name isEqualToString:@"PHPSESSID2"])
            {
                sessinCookie = cookie;
            }
        }
    }
    
    if ([IsNeedAES isEqualToString:@"YES"] && [responseObject isKindOfClass:[NSData class]])
    {
        // 获取加密串
        NSDictionary *tmpResposeJson = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if (tmpResposeJson && [tmpResposeJson isKindOfClass:[NSDictionary class]])
        {
            NSString *tmpJsonStr = [tmpResposeJson toString:@"output"];
            if (![FWUtils isBlankString:tmpJsonStr])
            {
                // base64解密
                NSData *decodeData = [GTMBase64 decodeString:tmpJsonStr];
                // AES解密
                NSString *resultStr = [decodeData AES256DecryptWithKey:fanweApp.aesKeyStr];
                
                // 如果解密失败，重新请求aeskey
                if ([FWUtils isBlankString:resultStr])
                {
                    [[FWIMLoginManager sharedInstance] obtainAesKeyFromFullGroup:nil error:nil];
                    
                    NSLog(@"===================：解密失败，请检查AES加密的KEY等！");
                    if (failureBlock2)
                    {
                        failureBlock2(nil, [AppNetWorkModel manager]);
                    }
                    else if (failureBlock)
                    {
                        failureBlock(nil);
                    }
                    return;
                }
                
                responseObject = [resultStr dataUsingEncoding:NSUTF8StringEncoding];
            }
            else
            {
                [[FWIMLoginManager sharedInstance] obtainAesKeyFromFullGroup:nil error:nil];
            }
        }
        else
        {
            NSLog(@"===================：获取加密串失败！");
        }
    }
    
    NSDictionary *resposeJson = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
    
    if (resposeJson && [resposeJson isKindOfClass:[NSDictionary class]])
    {
        if([resposeJson count])
        {
            // 判断当前是否有业务上的错误，有则把错误显示出来
            FWBaseModel *tmpModel = [FWBaseModel mj_objectWithKeyValues:resposeJson];
            if (![FWUtils isBlankString:tmpModel.errorStr])
            {
                if (tmpModel.status != 1)
                {
                    [FanweMessage alertHUD:tmpModel.errorStr];
                    NSLog(@"===================：错误信息：接口名为 ctl=%@,act=%@，弹出错误信息：%@",tmpModel.ctl,tmpModel.act,tmpModel.errorStr);
                }
                else
                {
                    NSLog(@"===================：正确信息：接口名为 ctl=%@,act=%@，弹出正确信息：%@",tmpModel.ctl,tmpModel.act,tmpModel.errorStr);
                }
            }
            
            if ([[resposeJson allKeys] containsObject:@"user_login_status"])
            { // 判断字典中是否含有这个key
                if ([resposeJson toInt:@"user_login_status"] == 1)
                { // 判断是否登录状态
                    if (successBlock2)
                    {
                        successBlock2(resposeJson, [AppNetWorkModel manager]);
                    }
                    else if (successBlock)
                    {
                        successBlock(resposeJson);
                    }
                }
                else
                {
                    if (failureBlock2)
                    {
                        failureBlock2(nil, [AppNetWorkModel manager]);
                    }
                    else if (failureBlock)
                    {
                        failureBlock(nil);
                    }
                    
#if kSupportH5Shopping
                    
#else
                    
                    [AppDelegate sharedAppDelegate].isTabBarShouldLoginIMSDK = NO;
                    
                    [[IMAPlatform sharedInstance] logout:^{
                        [[AppDelegate sharedAppDelegate] enterLoginUI];
                    } fail:^(int code, NSString *msg) {
                        [[AppDelegate sharedAppDelegate] enterLoginUI];
                    }];
                    
#endif
                }
            }
            else
            {
                if (successBlock2)
                {
                    successBlock2(resposeJson, [AppNetWorkModel manager]);
                }
                else if (successBlock)
                {
                    successBlock(resposeJson);
                }
            }
            
            if ([[resposeJson allKeys] containsObject:@"init_version"])
            {
                if ([[resposeJson toString:@"init_version"] longLongValue] > fanweApp.appModel.init_version)
                {
                    [AppViewModel loadInit];
                }
            }
        }
        else
        {
            [self updateErrorToServiceWithUrl:urlStr paramDict:paramDict errorString:@"返回的数据为空"];
            if (failureBlock2)
            {
                failureBlock2(nil, [AppNetWorkModel manager]);
            }
            else if (failureBlock)
            {
                failureBlock(nil);
            }
        }
    }
    else
    {
        [self updateErrorToServiceWithUrl:urlStr paramDict:paramDict errorString:@"返回的数据为空"];
        if (failureBlock2)
        {
            failureBlock2(nil, [AppNetWorkModel manager]);
        }
        else if (failureBlock)
        {
            failureBlock(nil);
        }
    }
}

#pragma mark 数据请求失败请求网络
+ (void)updateErrorToServiceWithUrl:(NSString *)urlStr paramDict:(NSMutableDictionary *)paramDict errorString:(NSString *)errorString
{
    if (!paramDict)
    {
        return;
    }
    
    if (![NetWorkManager isExistenceNetwork])
    {
        NSLog(@"请检查当前网络");
    }
    else
    {
        [self myCookieStorage];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager defaultNetManager];
        
        NSMutableDictionary *errorDict = [NSMutableDictionary new];
        NSString *valueString = [NSString stringWithFormat:@"act=%@ctl=%@%@",[paramDict toString:@"act"],[paramDict toString:@"ctl"],errorString];
        [errorDict setObject:valueString forKey:@"desc"];
        
        [manager POST:urlStr parameters:errorDict progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    }
}

@end
