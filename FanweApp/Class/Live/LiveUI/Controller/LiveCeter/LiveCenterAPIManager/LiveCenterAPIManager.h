//
//  LiveCenterAPIManager.h
//  FanweApp
//
//  Created by 岳克奎 on 16/12/13.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^LiveAddBlock)(NSDictionary *responseJson, BOOL finished, NSError *error);

@interface LiveCenterAPIManager : NSObject

// 单例模式
FanweSingletonH(Instance);

/**
 * @brief:主播开直播
 *
 * @use:
 */
- (void)liveCenterAPIOfShowHostLiveOfDic:(NSMutableDictionary *)dic block:(LiveAddBlock)block;

@end
