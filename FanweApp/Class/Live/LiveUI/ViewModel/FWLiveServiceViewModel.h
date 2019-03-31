//
//  FWLiveServiceViewModel.h
//  FanweApp
//
//  Created by xfg on 2017/8/14.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "FWBaseViewModel.h"

@interface FWLiveServiceViewModel : FWLiveBaseViewModel

/**
 主播开播时分享直播间

 @param shareModel 分享的实体
 @param shareType 分享类型
 @param vc vc
 @param block 分享后的回调
 */
+ (void)hostShareCurrentLive:(ShareModel *)shareModel shareType:(NSString *)shareType vc:(UIViewController *)vc block:(FWVoidBlock)block;

/**
 礼物信息的key

 @param msg 消息Model
 @return NSMutableDictionary
 */
+ (NSMutableDictionary *)getGiftMsgKey:(CustomMessageModel *)msg;

@end
