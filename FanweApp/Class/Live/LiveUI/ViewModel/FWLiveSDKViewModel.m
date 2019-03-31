//
//  FWLiveSDKViewModel.m
//  FanweApp
//
//  Created by xfg on 2017/4/24.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "FWLiveSDKViewModel.h"

@implementation FWLiveSDKViewModel

#pragma mark  - ----------------------- 腾讯SDK独有的 -----------------------
+ (void)tLiveMixStream:(NSString *)roomId toUserId:(NSString *)toUserId
{
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    [mDict setObject:@"video" forKey:@"ctl"];
    [mDict setObject:@"mix_stream" forKey:@"act"];

    [mDict setObject:roomId forKey:@"room_id"];
    
    if (![FWUtils isBlankString:toUserId])
    {
         [mDict setObject:toUserId forKey:@"to_user_id"];
    }
    
    [[NetHttpsManager manager] POSTWithParameters:mDict SuccessBlock:^(NSDictionary *responseJson) {
        
        NSLog(@"===:%@",responseJson);
        
    } FailureBlock:^(NSError *error) {
        
    }];
}

+ (void)tLiveStopMick:(NSString *)roomId toUserId:(NSString *)toUserId
{
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    [mDict setObject:@"video" forKey:@"ctl"];
    [mDict setObject:@"stop_lianmai" forKey:@"act"];
    
    [mDict setObject:roomId forKey:@"room_id"];
    
    if (![FWUtils isBlankString:toUserId])
    {
        [mDict setObject:toUserId forKey:@"to_user_id"];
    }
    
    [[NetHttpsManager manager] POSTWithParameters:mDict SuccessBlock:^(NSDictionary *responseJson) {
        
        NSLog(@"===:%@",responseJson);
        
    } FailureBlock:^(NSError *error) {
        
    }];
}

#pragma mark  - ----------------------- 公共模块 -----------------------
+ (void)checkVideoStatus:(NSString *)roomId successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock
{
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    [mDict setObject:@"video" forKey:@"ctl"];
    [mDict setObject:@"check_status" forKey:@"act"];
    [mDict setObject:roomId forKey:@"room_id"];
    
    [[NetHttpsManager manager] POSTWithParameters:mDict SuccessBlock:^(NSDictionary *responseJson) {
        
        if (successBlock)
        {
            successBlock(responseJson);
        }
        
    } FailureBlock:^(NSError *error) {
        
        if (failureBlock)
        {
            failureBlock(error);
        }
        
    }];
}

@end
