//
//  FWKSYLinkMicPlayerController.h
//  FanweApp
//
//  Created by xfg on 2017/2/13.
//  Copyright © 2017年 xfg. All rights reserved.
//  金山云连麦辅播、观众类

#import "FWKSYPlayerController.h"

@protocol  FWKSYLinkMicPlayerControllerDelegate <NSObject>
@required

/*
 *  辅播端（即连麦观众）鉴权回调
 *  status：鉴权回调码
 *  applicantId：申请连麦者ID
 */
- (void)registerResult2:(int)status registerUserId:(NSString *)applicantId;

/*
 *  辅播端（即连麦观众）反鉴权回调
 *  status：反鉴权回调码
 *  applicantId：申请连麦者ID
 */
- (void)unRegisterResult2:(int)status registerUserId:(NSString *)applicantId;

/*
 *  观众端连麦结果
 *  isSucc：是否上麦
 *  applicantId：申请连麦者ID
 */
- (void)applicantLinkMickResult:(BOOL)isSucc applicantId:(NSString *)applicantId;

@end

@interface FWKSYLinkMicPlayerController : FWKSYPlayerController

@property (nonatomic, weak) id<FWKSYLinkMicPlayerControllerDelegate> linkMicPlayDelegate;

@property (nonatomic, assign) BOOL                  isWaitingResponse;      // 是否正在等待连麦中
@property (nonatomic, strong) KSYRTCStreamerKit     *gPUStreamerKit;        // 直播推流工具类
@property (nonatomic, strong) NSURL                 *pushUrl;               // 推流地址
@property (nonatomic, strong) NSString              *applicantId;           // 申请连麦者的ID

/*
 *  开始鉴权
 *  applicantId：申请连麦者ID
 */
- (void)startRegister:(NSString *)applicantId;
/*
 *  开始连麦
 *  applicantId：申请连麦者ID
 *  responderId：接收连麦者ID
 */
- (void)startLinkMic:(NSString *)applicantId andResponderId:(NSString *)responderId;
/*
 *  停止连麦
 *  applicantId：申请连麦者ID
 */
- (void)stopLinkMic:(NSString *)applicantId;

@end
