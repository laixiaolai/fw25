//
//  PublishLiveViewModel.m
//  FanweApp
//
//  Created by xfg on 2017/6/8.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "PublishLiveViewModel.h"

@implementation PublishLiveViewModel

+ (void)beginLive:(NSMutableDictionary *)dict vc:(UIViewController *)vc block:(AppCommonBlock)block
{
    [[LiveCenterAPIManager sharedInstance] liveCenterAPIOfShowHostLiveOfDic:dict block:^(NSDictionary *responseJson, BOOL finished, NSError *error) {
        
        if (finished && !error && responseJson)
        {
            if (block)
            {
                AppBlockModel *blockModel = [AppBlockModel manager];
                blockModel.retDict = responseJson;
                blockModel.status = 1;
                block(blockModel);
            }
            
            if (!vc)
            {
                [PublishLiveViewModel beginLiveCenter:responseJson];
            }
            else
            {
                UIViewController *rootVC = vc.presentingViewController;
                while (rootVC.presentingViewController)
                {
                    rootVC = rootVC.presentingViewController;
                }
                [rootVC dismissViewControllerAnimated:YES completion:^{
                    
                    [PublishLiveViewModel beginLiveCenter:responseJson];
                }];
            }
        }
        else
        {
            if (block)
            {
                block([AppBlockModel manager]);
            }
            
            [FanweMessage alertHUD:[responseJson toString:@"error"]];
        }
    }];
}

+ (void)beginLiveCenter:(NSDictionary *)dict
{
    // 开启直播（先API拿直播后台类型）  非悬浮 非小屏幕
    BOOL isSusWindow = false;
    BOOL isSmallScreen = false;
    // 根据实际需求 设置
//    isSusWindow = [[GlobalVariables sharedInstance].appModel.open_pai_module intValue] == 1 ? YES : NO;
    isSusWindow = NO;
    [[LiveCenterManager sharedInstance] showLiveOfAPIResponseJson:dict.mutableCopy isSusWindow:isSusWindow isSmallScreen:isSmallScreen block:^(BOOL finished) {
        
    }];
}

@end
