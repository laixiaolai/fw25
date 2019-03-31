//
//  FWIMMsgHandler.h
//  FanweLive
//
//  Created by xfg on 16/11/24.
//  Copyright © 2016年 xfg. All rights reserved.
//  IM消息监听

#import <Foundation/Foundation.h>
#import "AVIMRunLoop.h"
#import "FWLiveBaseController.h"

@class FWIMMsgHandler;

@protocol FWIMMsgListener <NSObject>

@required

// 收到自定义C2C消息
- (void)onIMHandler:(FWIMMsgHandler *)receiver recvCustomC2C:(id<AVIMMsgAble>)msg;

// 收到自定义的Group消息
- (void)onIMHandler:(FWIMMsgHandler *)receiver recvCustomGroup:(id<AVIMMsgAble>)msg;


@end


@interface FWIMMsgHandler : NSObject<TIMMessageListener>
{
    
@protected
    __weak AVIMRunLoop          *_sharedRunLoopRef;         // 消息处理线程的引用
    
    NSMutableDictionary         *_msgCache;                 // 以key为id<AVIMMsgAble> msgtype的, value不AVIMCache，在runloop线程中执行
    OSSpinLock                    _msgCacheLock;
    
    NSMutableArray              *_newMsgMArray;             // 获取到的缓存消息列表
    
    GlobalVariables             *_fanweApp;
    
    __weak id<FWShowLiveRoomAble> _liveItem;
    
}

@property (nonatomic, weak) id<FWIMMsgListener> iMMsgListener;

@property (nonatomic, strong)TIMConversation    *chatRoomConversation;      // 群会话上下文
// 运行过程中，如果先是YES，再置为NO，设置前使用者注意将_msgCache的取出，内部自动作清空处理
@property (nonatomic, assign) BOOL              isCacheMode;                // 是否是缓存模式

@property (nonatomic, assign) BOOL              isEnterRooming;             // 是否正在进入直播间
@property (nonatomic, assign) BOOL              isExitRooming;              // 是否正在退出直播间

@property (nonatomic, assign) BOOL              isCurrentInSDK;             // 当前已经进入了SDK
@property (nonatomic, assign) BOOL              isEnterSDKing;              // 是否正在进入SDK
@property (nonatomic, assign) BOOL              isExitSDKing;               // 是否正在退出SDK

// 单例模式
FanweSingletonH(Instance);

// 从缓存中取出maxDo条数据处理
- (void)onHandleMyNewMessage:(NSInteger)maxDo;

// 发送自定义一对一消息
- (void)sendCustomC2CMsg:(SendCustomMsgModel *)sCMM succ:(TIMSucc)succ fail:(TIMFail)fail;
// 发送自定义群消息
- (void)sendCustomGroupMsg:(SendCustomMsgModel *)sCMM succ:(TIMSucc)succ fail:(TIMFail)fail;

@end


// 供子类重写
@interface FWIMMsgHandler (ProtectedMethod)

- (id<IMUserAble>)syncGetC2CUserInfo:(NSString *)identifier;

- (void)onRecvC2CSender:(id<IMUserAble>)sender customMsg:(TIMCustomElem *)msg textMsg:(NSString *)textMsg;

- (void)onRecvGroupSender:(id<IMUserAble>)sender groupId:(NSString *)groupId customMsg:(TIMCustomElem *)msg textMsg:(NSString *)textMsg;

- (void)onRecvSystepGroupSender:(id<IMUserAble>)sender groupId:(NSString *)groupId customMsg:(TIMGroupSystemElem *)msg textMsg:(NSString *)textMsg;

@end


@interface FWIMMsgHandler (CacheMode)

// 用户通过设置此方法，监听要处理的消息类型
- (void)createMsgCache;

- (void)resetMsgCache;

- (void)releaseMsgCache;

// 如果cache不成功，会继续上报
- (void)enCache:(id<AVIMMsgAble>)msg noCache:(FWVoidBlock)noCacheblock;

- (NSDictionary *)getMsgCache;

@end


// 互动直播间的加入、退出操作（已废弃）
@interface FWIMMsgHandler (LivingRoom)

// 设置群聊监听
- (void)setGroupChatListener:(id<FWShowLiveRoomAble>)liveItem;
// 移除群聊监听
- (void)removeGroupChatListener;

@end
