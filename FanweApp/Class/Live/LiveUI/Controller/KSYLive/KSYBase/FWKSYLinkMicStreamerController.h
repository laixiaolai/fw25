//
//  FWKSYLinkMicStreamerController.h
//  FanweApp
//
//  Created by xfg on 2017/2/20.
//  Copyright © 2017年 xfg. All rights reserved.
//  金山云连麦主播类

#import "FWKSYStreamerController.h"

@protocol FWKSYLinkMicStreamerControllerDelegate <NSObject>
@required

/*
 *  主播端鉴权回调
 *  status：鉴权回调码
 *  responderId：接收连麦者ID
 */
- (void)registerResult:(int)status registerUserId:(NSString *)responderId;

/*
 *  主播端反鉴权回调
 *  status：反鉴权回调码
 *  responderId：接收连麦者ID
 */
- (void)unRegisterResult:(int)status registerUserId:(NSString *)responderId;

/*
 *  主播端连麦结果
 *  isSucc：YES：连麦 NO：断开连麦
 *  applicantId：申请连麦者ID
 */
- (void)responderLinkMickResult:(BOOL)isSucc applicantId:(NSString *)applicantId;

@end

@interface FWKSYLinkMicStreamerController : FWKSYStreamerController

@property (nonatomic, weak) id<FWKSYLinkMicStreamerControllerDelegate> linkMicPublishDelegate;
@property (nonatomic, assign) BOOL                  isExited;
@property (nonatomic, strong) NSString              *applicantId;           // 申请连麦者的ID
/*
 *  开始鉴权
 *  applicantId：申请连麦者ID
 */
- (void)startRegister:(NSString *)applicantId;

/*
 *  断开连麦
 *  applicantId：申请连麦者ID
 */
- (void)breakLinkMick:(NSString *)applicantId;

@end
