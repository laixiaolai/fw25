//
//  IMAHost.h
//  TIMAdapter
//
//  Created by AlexiChen on 16/1/29.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppAble.h"
@class IMAUser;
typedef EQALNetworkType TCQALNetwork;

// 当前是用户信息
@interface IMAHost : NSObject<IMHostAble>

@property (nonatomic, strong) TIMLoginParam         *loginParm;

@property (nonatomic, strong) TIMUserProfile        *profile;

@property (nonatomic, strong) NSMutableDictionary   *customInfoDict; // 用户其他信息

@property (nonatomic, assign) BOOL                  isConnected;     // 当前是否连接上，外部可用此方法判断是否有网

@property (nonatomic, assign) BOOL                  is_robot;

@property (nonatomic, copy) NSString                *sort_num;       // 该观众在当前直播间的排序权重

@property (nonatomic, assign) NSInteger             reloadUserInfoTimes; // 重新加载用户信息的次数，防止请求信息失败后进入死循环

- (NSString *)userId;

// 判断用户是不是自己
- (BOOL)isMe:(IMAUser *)user;

- (void)getMyInfo:(AppCommonBlock)block;

// 获取钻石
- (long)getDiamonds;

// 设置钻石
- (void)setDiamonds:(NSString *)diamonds;

// 获取等级
- (long)getUserRank;

// 设置等级
- (void)setUserRank:(NSString *)rank;

// 获取金币
- (long)getUserCoin;

// 设置金币
- (void)setUserCoin:(NSString *)coin;

@end
