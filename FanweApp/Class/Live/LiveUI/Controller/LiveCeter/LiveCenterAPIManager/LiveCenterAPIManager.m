//
//  LiveCenterAPIManager.m
//  FanweApp
//
//  Created by 岳克奎 on 16/12/13.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "LiveCenterAPIManager.h"

@implementation LiveCenterAPIManager

FanweSingletonM(Instance);

#pragma mark -public  methods ------------------------------------------ 公有方法区域  -----------------------------------------
#pragma mark - 主播开直播API
/**
 *  主播发起开直播的请求
 *
 * @discussion：请求的目的是获取 开直播的权限，判断直播时用的SDK等
 */
- (void)liveCenterAPIOfShowHostLiveOfDic:(NSMutableDictionary *)dic block:(LiveAddBlock)block
{
    [[NetHttpsManager manager] POSTWithParameters:dic SuccessBlock:^(NSDictionary *responseJson) {
        
        if ([responseJson toInt:@"status"] == 1 && [[responseJson allKeys] containsObject:@"room_id"])
        {
            int sdk_type = [responseJson toInt:@"sdk_type"];
            
            SUS_WINDOW.liveType = FW_LIVE_TYPE_HOST;
            SUS_WINDOW.sdkType = sdk_type;
            SUS_WINDOW.isHost = YES;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kInvalidateHomeTimer object:nil];
            
            if (block)
            {
                block(responseJson,YES,nil);
            }
        }
        else
        {
            if(block)
            {
                block(responseJson,NO,nil);
            }
        }
        
    } FailureBlock:^(NSError *error) {
        
        if (block)
        {
            block(nil,NO,error);
        }
        
    }];
}

@end
