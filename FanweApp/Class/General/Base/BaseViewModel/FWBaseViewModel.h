//
//  FWBaseViewModel.h
//  FanweApp
//
//  Created by xfg on 2017/5/3.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NetHttpsManager;

@interface FWBaseViewModel : NSObject

/**
 网络请求
 */
@property (nonatomic, strong) NetHttpsManager *httpsManager;

/**
 全局参数控制
 */
@property (nonatomic, strong) GlobalVariables *fanweApp;

@end
