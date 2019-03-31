//
//  FWKSYAgoraLinkMicStreamerController.h
//  FanweApp
//
//  Created by xfg on 2017/2/20.
//  Copyright © 2017年 xfg. All rights reserved.
//  金山云、声网连麦主播端

#import "FWKSYStreamerController.h"

@interface FWKSYAgoraLinkMicStreamerController : FWKSYAgoraStreamerBaseController

/*
 *  开始连麦
 *  applicantId：申请连麦者ID
 *  responderId：接收连麦者ID
 *  roomId：房间ID
 */
- (void)startLinkMic:(NSString *)applicantId andResponderId:(NSString *)responderId roomId:(NSString *)roomId;
/*
 *  停止连麦
 *  applicantId：申请连麦者ID
 */
- (void)stopLinkMic:(NSString *)applicantId;

@end
