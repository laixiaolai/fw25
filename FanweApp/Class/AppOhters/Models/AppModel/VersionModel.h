//
//  VersionModel.h
//  ZCTest
//
//  Created by xfg on 16/3/4.
//  Copyright © 2016年 guoms. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VersionModel : NSObject

@property (nonatomic, assign) NSInteger has_upgrade; //1：有新版本 0：没有新版本
@property (nonatomic, assign) NSInteger serverVersion;
@property (nonatomic, assign) NSInteger forced_upgrade; //1：强制升级 0：提示升级
@property (nonatomic, copy) NSString    *ios_down_url; //下载新版的地址

@end
