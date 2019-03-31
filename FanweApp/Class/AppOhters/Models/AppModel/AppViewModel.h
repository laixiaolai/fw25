//
//  AppViewModel.h
//  FanweApp
//
//  Created by xfg on 16/10/25.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppViewModel : NSObject

/**
 提交在线、离线接口
 
 @param status Login：在线 Logout：离线
 */
+ (void)userStateChange:(NSString *)status;

/**
 上传设备号
 */
+ (void)updateApnsCode;

/**
 重新加载初始化接口
 */
+ (void)loadInit;

@end
