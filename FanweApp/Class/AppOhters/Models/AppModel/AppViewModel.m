//
//  AppViewModel.m
//  FanweApp
//
//  Created by xfg on 16/10/25.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "AppViewModel.h"

@implementation AppViewModel

#pragma mark 客户在线情况监测
/**
 提交在线、离线接口

 @param status Login：在线 Logout：离线
 */
+ (void)userStateChange:(NSString *)status
{
    // 如果没有登录，就不需要后续操作
    if (![IMAPlatform isAutoLogin])
    {
        return;
    }
    
    if (![FWUtils isBlankString:[GlobalVariables sharedInstance].appModel.on_line_group_id])
    {
        if ([status isEqualToString:@"Login"])
        {
            [[TIMGroupManager sharedInstance] joinGroup:[GlobalVariables sharedInstance].appModel.on_line_group_id msg:nil succ:^{
                NSLog(@"加入在线用户大群成功");
            } fail:^(int code, NSString *msg) {
                NSLog(@"加入在线用户大群失败，错误码：%d，错误原因：%@",code,msg);
            }];
        }
        else if ([status isEqualToString:@"Logout"])
        {
            [[TIMGroupManager sharedInstance] quitGroup:[GlobalVariables sharedInstance].appModel.on_line_group_id succ:^{
                NSLog(@"退出在线用户大群成功");
            } fail:^(int code, NSString *msg) {
                NSLog(@"退出在线用户大群失败，错误码：%d，错误原因：%@",code,msg);
            }];
        }
    }
    
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    [mDict setObject:@"user" forKey:@"ctl"];
    [mDict setObject:@"state_change" forKey:@"act"];
    [mDict setObject:status forKey:@"action"];
    
    [[NetHttpsManager manager] POSTWithParameters:mDict SuccessBlock:^(NSDictionary *responseJson) {
        
    } FailureBlock:^(NSError *error) {
        
    }];
}

#pragma mark 上传当前用户设备号
+ (void)updateApnsCode
{
    // 如果没有登录，就不需要后续操作
    if (![IMAPlatform isAutoLogin])
    {
        return;
    }
    
    GlobalVariables *fanweApp = [GlobalVariables sharedInstance];
    
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    [mDict setObject:@"user" forKey:@"ctl"];
    [mDict setObject:@"apns" forKey:@"act"];
    if (![FWUtils isBlankString:fanweApp.deviceToken])
    {
        [mDict setObject:fanweApp.deviceToken forKey:@"apns_code"];
        
        [[NetHttpsManager manager] POSTWithParameters:mDict SuccessBlock:^(NSDictionary *responseJson) {
            
            NSLog(@"===:%@",responseJson);
            
        } FailureBlock:^(NSError *error) {
            
        }];
    }
}

#pragma mark 重新加载初始化接口
+ (void)loadInit
{
    GlobalVariables *fanweApp = [GlobalVariables sharedInstance];
    
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"app" forKey:@"ctl"];
    [parmDict setObject:@"init" forKey:@"act"];
    
    NSString *postUrl;
    
#if kSupportH5Shopping
    postUrl = H5InitUrlStr;
#else
    postUrl = fanweApp.currentDoMianUrlStr;
#endif
    
    [[NetHttpsManager manager] POSTWithUrl:postUrl paramDict:parmDict SuccessBlock:^(NSDictionary *responseJson)
     {
         fanweApp.appModel = [AppModel mj_objectWithKeyValues:responseJson];
         if (fanweApp.listMsgMArray)
         {
             [fanweApp.listMsgMArray removeAllObjects];
         }
         
         NSArray *listmsg = [responseJson objectForKey:@"listmsg"];
         if (listmsg && [listmsg isKindOfClass:[NSArray class]])
         {
             for (NSDictionary *tmpDic in listmsg)
             {
                 CustomMessageModel *customMessageModel = [CustomMessageModel mj_objectWithKeyValues:tmpDic];
                 [customMessageModel prepareForRender];
                 [fanweApp.listMsgMArray addObject:customMessageModel];
             }
         }
         
     } FailureBlock:^(NSError *error) {
         
     }];
}

@end
