//
//  FWTLinkMicPublishController.h
//  FanweApp
//
//  Created by xfg on 2017/1/19.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "FWTPublishController.h"
#import "FWTLinkMicPlayItem.h"
#import "TLiveMickListModel.h"

@protocol ITCLivePlayListener <NSObject>

@optional
- (void)onLivePlayEvent:(NSString*)playUrl withEvtID:(int)evtID andParam:(NSDictionary*)param;

@optional
- (void)onLivePlayNetStatus:(NSString*)playUrl withParam:(NSDictionary*)param;

@end


@interface TCLivePlayListenerImpl: NSObject<TXLivePlayListener>

@property (nonatomic, strong) NSString                  *playUrl;
@property (nonatomic, weak) id<ITCLivePlayListener>     delegate;

@end


@protocol FWTLinkMicPublishControllerDelegate <NSObject>
@required

/*
 *  主播端连麦结果
 *  isSucc：是否拉取观众连麦加速流成功
 *  userID：拉取的连麦观众对应的ID
 */
- (void)playMickResult:(BOOL)isSucc userID:(NSString *)userID;

@end

@interface FWTLinkMicPublishController : FWTPublishController

@property (nonatomic, weak) id<FWTLinkMicPublishControllerDelegate> linkMicPublishDelegate;
@property (nonatomic, strong) TLiveMickListModel    *mickListModel;
@property (nonatomic, strong) NSMutableArray        *playItemArray;     // 连麦窗口视图列表
@property (nonatomic, strong) NSMutableSet          *linkMemeberSet;    // 连麦观众列表
@property (nonatomic, copy) NSString                *roomIDStr;         // 房间ID

// 通过用户ID来获取连麦视图
- (FWTLinkMicPlayItem *)getPlayItemByUserID:(NSString*)userID;
// 同意连麦
- (void)agreeLinkMick:(NSString *)streamPlayUrl applicant:(NSString *)userID;
// 断开连麦
- (void)breakLinkMick:(NSString *)userID;
// 调整连麦窗口
- (void)adjustPlayItem:(TLiveMickListModel *)mickListModel;

@end
