

//
//  GlobalVariables.m
//  FanweApp
//
//  Created by xfg on 16/2/15.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "GlobalVariables.h"
#import "NSString+guoMS.h"

@implementation GlobalVariables

+ (GlobalVariables *)sharedInstance
{
    static GlobalVariables *myInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        myInstance = [[self alloc] init];
        
        NSMutableDictionary *tmpDict = [[NSMutableDictionary alloc] init];
        myInstance.config = tmpDict;
        
        NSMutableArray *tmpArray = [[NSMutableArray alloc] init];
        myInstance.newestLivingMArray = tmpArray;
        
        NSMutableArray *tmpArray2 = [[NSMutableArray alloc] init];
        myInstance.listMsgMArray = tmpArray2;
        
        // 两种情况启用新打包时的域名：1、如果本地保存的日期版本号为空；2、本地保存的日期版本号小于当前打包时填写的日期版本号（意思是更新版本）
        NSString *tmpVersionTime = [[NSUserDefaults standardUserDefaults] objectForKey:kAppVersionTimeKey];
        if ([FWUtils isBlankString:tmpVersionTime] || [tmpVersionTime longLongValue] < [VersionTime longLongValue])
        {
            if (AppDoMainUrlArray)
            {
                if ([AppDoMainUrlArray count])
                {
                    NSString *tmpMainUrl = [AppDoMainUrlArray firstObject];
                    tmpMainUrl = [tmpMainUrl stringByAppendingString:AppDoMainUrlSuffix];
                    myInstance.currentDoMianUrlStr = tmpMainUrl;
                    
                    myInstance.doMainUrlArray = AppDoMainUrlArray;
                }
                else
                {
                    [FanweMessage alert:@"域名列表不为空，但是没有数据！"];
                }
            }
            else
            {
                [FanweMessage alert:@"域名列表为空！"];
            }
        }
        else
        {
            // 获取保存在本地的域名列表
            NSArray *tmpMainUrlArray = [[NSUserDefaults standardUserDefaults] objectForKey:kAppDoMainUrlListKey];
            if (tmpMainUrlArray)
            {
                if ([tmpMainUrlArray count])
                {
                    myInstance.doMainUrlArray = tmpMainUrlArray;
                }
                else
                {
                    myInstance.doMainUrlArray = AppDoMainUrlArray;
                }
            }
            else
            {
                myInstance.doMainUrlArray = AppDoMainUrlArray;
            }
            
            // 获取保存在本地的域名
            NSString *tmpMainUrl = [[NSUserDefaults standardUserDefaults] objectForKey:kAppCurrentMainUrlKey];
            // 如果保存在本地的域名为空，则启用域名列表中的首个域名
            if ([FWUtils isBlankString:tmpMainUrl])
            {
                if (myInstance.doMainUrlArray)
                {
                    if ([myInstance.doMainUrlArray count])
                    {
                        tmpMainUrl = [myInstance.doMainUrlArray firstObject];
                        tmpMainUrl = [tmpMainUrl stringByAppendingString:AppDoMainUrlSuffix];
                    }
                    else
                    {
                        [FanweMessage alert:@"域名列表不为空，但是没有数据！"];
                    }
                }
                else
                {
                    [FanweMessage alert:@"域名列表为空！"];
                }
            }
            myInstance.currentDoMianUrlStr = tmpMainUrl;
        }
        
        if ([IsNeedStorageDoMainUrl isEqualToString:@"YES"])
        {
            [[NSUserDefaults standardUserDefaults] setObject:myInstance.currentDoMianUrlStr forKey:kAppCurrentMainUrlKey];
            [[NSUserDefaults standardUserDefaults] setObject:VersionTime forKey:kAppVersionTimeKey];
        }
        
        // 获取保存在本地的AESKey
        NSString *tmpAESKeyUrl = [[NSUserDefaults standardUserDefaults] objectForKey:kFWAESKey];
        // 如果保存在本地的AESKey为空，则用打包时填写的AppAESKey
        if ([FWUtils isBlankString:tmpAESKeyUrl])
        {
            tmpAESKeyUrl = AppAESKey;
        }
        myInstance.aesKeyStr = tmpAESKeyUrl;
        
        AppModel *appModel = [[AppModel alloc]init];
        myInstance.appModel = appModel;
        
    });
    return myInstance;
}

#pragma mark 保存服务端下发的域名列表
- (void)storageAppMainUrls:(NSArray *)mainUrlArray
{
    self.doMainUrlArray = mainUrlArray;
    [[NSUserDefaults standardUserDefaults] setObject:mainUrlArray forKey:kAppDoMainUrlListKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark 保存当前可用的域名，一下次启动app时使用
- (void)storageAppCurrentMainUrl:(NSString *)currentMainUrl
{
    currentMainUrl = [self getStandardMainUrl:currentMainUrl];
    
    self.currentDoMianUrlStr = currentMainUrl;
    if ([IsNeedStorageDoMainUrl isEqualToString:@"YES"])
    {
        [[NSUserDefaults standardUserDefaults] setObject:currentMainUrl forKey:kAppCurrentMainUrlKey];
        [[NSUserDefaults standardUserDefaults] setObject:VersionTime forKey:kAppVersionTimeKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

#pragma mark 获取系统准确的接口地址（主要为了防止客户后台备用域名填写的有问题）
- (NSString *)getStandardMainUrl:(NSString *)urlStr
{
    if (![FWUtils isBlankString:urlStr])
    {
        // 如果有多个 AppDoMainUrlSuffix 时，先全部删除
        if ([urlStr countOccurencesOfString:AppDoMainUrlSuffix] > 1)
        {
            urlStr = [urlStr stringByReplacingOccurrencesOfString:AppDoMainUrlSuffix withString:@""];
        }
        
        // 根域名如果不包含 AppDoMainUrlSuffix 则加上
        if ([urlStr rangeOfString:AppDoMainUrlSuffix].location == NSNotFound)
        {
            urlStr = [urlStr stringByAppendingString:AppDoMainUrlSuffix];
        }
        
        return urlStr;
    }
    return @"";
}

#pragma mark 保存当前可用的aeskey，一下次启动app时使用
- (void)storageAppAESKey:(NSString *)aesKeyStr
{
    self.aesKeyStr = aesKeyStr;
    [[NSUserDefaults standardUserDefaults] setObject:aesKeyStr forKey:kFWAESKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
