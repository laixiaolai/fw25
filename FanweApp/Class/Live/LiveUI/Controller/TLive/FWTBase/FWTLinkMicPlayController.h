//
//  FWTLinkMicPlayController.h
//  FanweApp
//
//  Created by xfg on 16/12/5.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "FWTPlayController.h"
#import "TLiveMickListModel.h"

@protocol ITCLivePushListener <NSObject>

@optional
- (void)onLivePushEvent:(NSString*)pushUrl withEvtID:(int)evtID andParam:(NSDictionary*)param;

@optional
- (void)onLivePushNetStatus:(NSString*)pushUrl withParam:(NSDictionary*)param;

@end


@interface TCLivePushListenerImpl: NSObject<TXLivePushListener>

@property (nonatomic, strong) NSString                  *pushUrl;
@property (nonatomic, weak) id<ITCLivePushListener>     delegate;

@end


@protocol FWTLinkMicPlayControllerDelegate <NSObject>
@required

/*
 *  观众端连麦结果
 *  isSucc：是否上麦
 *  userID：当前用户ID
 */
- (void)pushMickResult:(BOOL)isSucc userID:(NSString *)userID;

@end

@interface FWTLinkMicPlayController : FWTPlayController

@property (nonatomic, weak) id<FWTLinkMicPlayControllerDelegate> linkMicPlayDelegate;

@property (nonatomic, strong) NSMutableArray    *playItemArray;             // 连麦窗口视图列表
@property (nonatomic, copy) NSString            *push_rtmp2;                // 腾讯云直播的小主播的 push_rtmp 推流地址(由大主播传给小主播)
@property (nonatomic, copy) NSString            *play_rtmp_acc;             // 腾讯云直播的大主播的 rtmp_acc 播放地址(由大主播传给小主播)
@property (nonatomic, assign) BOOL              isWaitingResponse;          // 是否正在等待连麦中...
@property (nonatomic, assign) BOOL              isClickedMickBtn;           // 是否点击过连麦按钮（主要判断连麦观众是否中途有闪退过）
@property (nonatomic, strong) NSMutableSet      *linkMemeberSet;            // 连麦观众列表

@property (nonatomic, strong) TXLivePush        *txLivePush;                // SDK推流类

// 开始连麦
- (void)startLinkMic;
// 停止连麦
- (void)stopLinkMic;
// 结束视频
- (void)endVideo;
// 调整连麦窗口
- (void)adjustPlayItem:(TLiveMickListModel *)mickListModel;

@end
