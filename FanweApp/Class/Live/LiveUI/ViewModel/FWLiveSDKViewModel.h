//
//  FWLiveSDKViewModel.h
//  FanweApp
//
//  Created by xfg on 2017/4/24.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FWLiveSDKViewModel : FWBaseViewModel

#pragma mark  - ----------------------- 腾讯SDK独有的 -----------------------

/**
 腾讯云直播多路连麦混流接口

 @param roomId 房间ID
 @param toUserId 小主播ID
 */
+ (void)tLiveMixStream:(NSString *)roomId toUserId:(NSString *)toUserId;

/**
 腾讯云直播多路连麦停止连麦接口

 @param roomId 房间ID
 @param toUserId 小主播ID
 */
+ (void)tLiveStopMick:(NSString *)roomId toUserId:(NSString *)toUserId;


#pragma mark  - ----------------------- 公共模块 -----------------------

/**
 检查视频状态
 
 @param roomId 房间ID
 @param successBlock 成功回调
 @param failureBlock 失败回调
 */
+ (void)checkVideoStatus:(NSString *)roomId successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;

@end
