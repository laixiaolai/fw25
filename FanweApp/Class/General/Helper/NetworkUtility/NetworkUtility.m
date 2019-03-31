//
//  NetworkUtility.m
//  CommonLibrary
//
//  Created by Alexi on 12-11-11.
//  Copyright (c) 2012年 . All rights reserved.
//

#import "NetworkUtility.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <netinet6/in6.h>
#import <arpa/inet.h>
#import <ifaddrs.h>
#import <netdb.h>
#import "Reachability.h"

// 网络断开通知
NSString *const kNetworkUtilityNotReachableNotification = @"NetworkUtilityNotReachableNotification";
// 切换到Wifi
NSString *const kNetworkUtilityWifiConnectNotification = @"NetworkUtilityWifiConnectNotification";
// 切换到移动网络
NSString *const kNetworkUtilityMONETConnectNotification = @"NetworkUtilityMONETConnectNotification";

@implementation NetworkUtility

static NetworkUtility *_sharedNetworkUtility;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_reachablity stopNotifier];
    CommonRelease(_reachablity);
    CommonSuperDealloc();
}

- (void)startCheckWifi
{
    if (_reachablity == nil)
    {
        _reachablity = [Reachability reachabilityForLocalWiFi];
    }
    [_reachablity startNotifier];
}

- (void)stopCheckWifi
{
    [_reachablity stopNotifier];
    _reachablity = nil;
}

- (id)init
{
    if (self = [super init])
    {
        _lastReachabilityStatus = -1;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onReachabilityChaned:) name:kReachabilityChangedNotification object:nil];
    }
    return self;
}

- (void)onReachabilityChaned:(NSNotification *)notify
{
    Reachability *info = (Reachability *)notify.object;
    NetworkStatus status = info.currentReachabilityStatus;
    
    if (_lastReachabilityStatus != status)
    {
        _lastReachabilityStatus = status;
        switch (status) {
            case ReachableViaWiFi:
                [[NSNotificationCenter defaultCenter] postNotificationName:kNetworkUtilityWifiConnectNotification object:nil];
                break;
            case ReachableViaWWAN:
                [[NSNotificationCenter defaultCenter] postNotificationName:kNetworkUtilityMONETConnectNotification object:nil];
                DebugLog(@"网络断开了ReachableViaWWAN");
                break;
            case NotReachable:
                [[NSNotificationCenter defaultCenter] postNotificationName:kNetworkUtilityNotReachableNotification object:nil];
                DebugLog(@"网络断开了NotReachable");
                break;
                
            default:
                break;
        }
    }
}

+ (NetworkUtility *)sharedNetworkUtility
{
    @synchronized(_sharedNetworkUtility)
    {
        if (_sharedNetworkUtility == nil) {
            _sharedNetworkUtility = [[NetworkUtility alloc] init];
        }
        return _sharedNetworkUtility;
    }
}

- (BOOL)isReachable
{
    return _reachablity && [_reachablity isReachable];
}

- (BOOL)isReachableViaWWAN
{
    return _reachablity && [_reachablity isReachableViaWWAN];
}

- (BOOL)isReachableViaWiFi
{
    return _reachablity && [_reachablity isReachableViaWiFi];
}

- (NSString *)wifiSSID
{
#if TARGET_IPHONE_SIMULATOR
    // 不能在模拟器上试
    return nil;
#else
    NSString *ssid = nil;
    
    CFArrayRef ifsRef = CNCopySupportedInterfaces();
    NSArray *ifs = (__bridge_transfer NSArray *)ifsRef;
    DebugLog(@"ifs:%@",ifs);
    
    for (NSString *ifnam in ifs)
    {
        CFDictionaryRef dic = CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        NSDictionary *info = (__bridge_transfer NSDictionary *)dic;
        DebugLog(@"dici：%@",[info  allKeys]);
        if (info[@"SSID"])
        {
            ssid = info[@"SSID"];
        }
    }
    return ssid;
#endif
}

@end
