//
//  FWKSYAgoraLinkMicPlayerController.m
//  FanweApp
//
//  Created by xfg on 2017/2/13.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "FWKSYAgoraLinkMicPlayerController.h"

@interface FWKSYAgoraLinkMicPlayerController ()

@end

@implementation FWKSYAgoraLinkMicPlayerController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _linkMicBaseController = [[FWKSYAgoraStreamerBaseController alloc] init];
    _linkMicBaseController.isApplicant = YES;
    [self addChild:_linkMicBaseController inRect:self.view.bounds];
    [self.view sendSubviewToBack:_linkMicBaseController.view];
    _linkMicBaseController.view.hidden = YES;
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
    [_linkMicBaseController startLinkMic:applicantId andResponderId:responderId roomId:roomId];

    self.videoContrainerView.hidden = YES;
    _linkMicBaseController.view.hidden = NO;
    [self.moviePlayer pause];
    
    __weak typeof(self) ws = self;
    
    _linkMicBaseController.onMyCallStart = ^(int status){
    
        if(status == 200)   // 建立连接
        {
            
        }
        else if(status == 408 || status == 404)  // 408:对方无应答 404:呼叫未注册号码,主动停止
        {
            
        }
        
    };
    
    _linkMicBaseController.onMyCallStop = ^(int status){
        
        ws.linkMicBaseController.view.hidden = YES;
        
    };
    
    _linkMicBaseController.onMyChannelJoin = ^(int status){
        
    };
}

- (void)reloadPlay
{
    [self.moviePlayer reload:self.playUrl];
}

#pragma mark 停止连麦
/*
 *  停止连麦
 *  applicantId：申请连麦者ID
 */
- (void)stopLinkMic:(NSString *)applicantId
{
    if (_linkMicBaseController.gPUStreamerKit)
    {
        [_linkMicBaseController stopLinkMic:applicantId];
        
        self.videoContrainerView.hidden = NO;
        [self performSelector:@selector(reloadPlay) withObject:nil afterDelay:1];
    }
}

#pragma mark 结束播放
- (void)stopPlay
{
    [super stopPlay];
    [self stopLinkMic:_linkMicBaseController.applicantId];
    [_linkMicBaseController stopLinkMic:_linkMicBaseController.applicantId];
}

@end
