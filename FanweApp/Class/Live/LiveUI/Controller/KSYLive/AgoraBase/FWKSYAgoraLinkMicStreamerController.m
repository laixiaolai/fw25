//
//  FWKSYAgoraLinkMicStreamerController.m
//  FanweApp
//
//  Created by xfg on 2017/2/20.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "FWKSYAgoraLinkMicStreamerController.h"

@interface FWKSYAgoraLinkMicStreamerController ()

@end

@implementation FWKSYAgoraLinkMicStreamerController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.isApplicant = NO;
}

#pragma mark 开始连麦
/*
 *  开始连麦
 *  applicantId：申请连麦者ID
 *  responderId：接收连麦者ID
 *  roomId：房间ID
 */
- (void)startLinkMic:(NSString *)applicantId andResponderId:(NSString *)responderId roomId:(NSString *)roomId
{
    [super startLinkMic:applicantId andResponderId:responderId roomId:roomId];
}

#pragma mark 停止连麦
/*
 *  停止连麦
 *  applicantId：申请连麦者ID
 */
- (void)stopLinkMic:(NSString *)applicantId
{
    [super stopLinkMic:applicantId];
}

#pragma mark 停止推流
- (void)stopRtmp
{
    [self stopLinkMic:self.applicantId];
    
    [super stopRtmp];
}


@end
