//
//  FWLiveBaseController.h
//  FanweLive
//
//  Created by xfg on 16/11/23.
//  Copyright © 2016年 xfg. All rights reserved.
//  直播基类

#import <UIKit/UIKit.h>
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>
#import "FWBaseViewController.h"
#import "FWIMMsgHandler.h"
#import "CurrentLiveInfo.h"

@interface FWLiveBaseController : FWBaseViewController
{
    
@private
    // 用于音频退出直播时还原现场
    NSString                        *_audioSesstionCategory;        // 进入房间时的音频类别
    NSString                        *_audioSesstionMode;            // 进入房间时的音频模式
    
@protected
    CTCallCenter                    *_callCenter;                   // 电话监听
    BOOL                            _isAtForeground;                // 是否在前台
    BOOL                            _isPhoneInterupt;               // 是否是电话中断
    BOOL                            _hasHandleCall;
    
    FWIMMsgHandler                  *_iMMsgHandler;                 // IM处理单例
    
    NSTimeInterval                  _backGroundTime;                // 进入后台时间(s)
    NSTimeInterval                  _foreGroundTime;                // 进入后台时间(s)
    
    // 切换房间
    id<AVRoomAble>                  _switchingToRoom;               // 切换房间
    id<IMHostAble>                  _currentUser;                   // 当前使用的用户
    CurrentLiveInfo                 *_liveInfo;                     // 当前直播间信息
    
    BOOL                            _isHost;                        // 是否主播
    NSString                        *_roomIDStr;                    // 房间ID
    BOOL                            _hasShowVagueImg;               // 是否已经显示过了模糊图片
    BOOL                            _hasOnMute;                     // 是否静音了
    
    UILabel                         *_lossRateSendTipLabel;         // 主播丢包率严重情况提示（一般是网络差的情况）
    NSInteger                       _enterLiveStatus;

    BOOL                            _isReEnterChatGroup;            // 主播掉线后重新连接上来后，需要重新加入聊天室，而不是创建聊天室
    
}

@property (nonatomic, strong) id<FWShowLiveRoomAble> liveItem;      // 开启、观看直播传入的实体

@property (nonatomic, copy) NSString            *vagueImgUrl;       // 模糊背景图片url
@property (nonatomic, strong) UIImageView       *vagueImgView;      // 模糊背景图片
@property (nonatomic, assign) BOOL              isDirectCloseLive;  // 该参数针对主播、观众，表示是否直播关闭直播，而不显示结束界面
@property (nonatomic, strong) FWIMMsgHandler    *iMMsgHandler;      // IM处理单例
@property (nonatomic, strong) CurrentLiveInfo   *liveInfo;          // 当前直播间信息

@property (nonatomic, strong) NSString          *roomIDStr;         // 房间ID
@property (nonatomic, assign) NSInteger         liveType;           // 视频类型，对应枚举FW_LIVE_TYPE
@property (nonatomic, assign) NSInteger         sdkType;            // SDK类型
@property (nonatomic, assign) NSInteger         mickType;           // 连麦类型
@property (nonatomic, assign) BOOL              isHost;             // 是否主播
@property (nonatomic, assign) BOOL              hasVideoControl;    // 点播时，视频控制操作（是否显示播放进度条等）
@property (nonatomic, assign) NSInteger         enterChatGroupTimes;// 加入聊天组尝试次数
@property (nonatomic, assign) BOOL              hasEnterChatGroup;  // 已经加入了一次聊天组，这里不记录成功与否


// 创建直播传入实体
- (instancetype)initWith:(id<FWShowLiveRoomAble>)liveItem;

/**
 弹出退出或直接退出
 @param isDirectCloseLive 该参数针对主播、观众，表示是否直播关闭直播，而不显示结束界面
 @param isHostShowAlert 该参数针对主播，表示主播是否需要弹出“您当前正在直播，是否退出直播？”，正常情况都需要弹出这个，目前有一种情况不需要弹出，不需要弹出的情况：1、当前直播被后台系统关闭了的情况 2、SDK结束了直播
 @param succ 成功回调
 @param failed 失败回调
 */
- (void)alertExitLive:(BOOL)isDirectCloseLive isHostShowAlert:(BOOL)isHostShowAlert succ:(FWVoidBlock)succ failed:(FWErrorBlock)failed;

// 判断对应类型然后做对应的退出操作
- (void)realExitLive:(FWVoidBlock)succ failed:(FWErrorBlock)failed;

// 退出聊天组：观众退出聊天组前先发退出消息、主播直接退出（主播不用解散聊天组，服务端会做该操作）
- (void)exitChatGroup;

// 视频第一帧加载出来后隐藏模糊背景
- (void)hideVagueImgView;

// 释放该释放的东西
- (void)releaseAll;

@end


// 供子类重写
@interface FWLiveBaseController (ProtectedMethod)

/**
 请求完接口后，刷新直播间相关信息

 @param liveItem 视频Item
 @param liveInfo 接口获取下来的数据实体
 */
- (void)refreshLiveItem:(id<FWShowLiveRoomAble>)liveItem liveInfo:(CurrentLiveInfo *)liveInfo;

/**
 开始进入聊天组
 @param chatGroupID 聊天组ID
 @param succ 成功回调
 @param failed 失败回调
 */
- (void)startEnterChatGroup:(NSString *)chatGroupID succ:(FWVoidBlock)succ failed:(FWErrorBlock)failed;

// 加入聊天组成功
- (void)enterChatGroupSucc:(CurrentLiveInfo *)liveInfo;

/**
 业务上退出直播：退出的时候分SDK退出和业务退出，减少退出等待时间
 @param isDirectCloseLive 该参数针对主播、观众，表示是否直播关闭直播，而不显示结束界面
 @param succ 成功回调
 @param failed 失败回调
 */
- (void)onServiceExitLive:(BOOL)isDirectCloseLive succ:(FWVoidBlock)succ failed:(FWErrorBlock)failed;

// 加入直播前先判断网络环境
- (void)checkNetWorkBeforeLive;

// 添加网络监听
- (void)addNetListener;

// 添加电话监听: 进入直播成功后监听
- (void)addPhoneListener;

// 移除电话监听：退出直播后监听
- (void)removePhoneListener;

// 退出直播界面
- (void)onExitLiveUI;

// app进入前台
- (void)onAppEnterForeground;

// app进入后台
- (void)onAppEnterBackground;

// 是否正在被电话打断
- (void)phoneInterruptioning:(BOOL)interruptioning;

// 声音打断监听
- (void)onAudioInterruption:(NSNotification *)notification;

// 监听耳机插入和拔出
- (void)audioRouteChangeListenerCallback:(NSNotification*)notification;

@end
