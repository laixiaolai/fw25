//
//  FWKSYLiveController.h
//  FanweApp
//
//  Created by xfg on 2017/2/10.
//  Copyright © 2017年 xfg. All rights reserved.
//  金山云直播，只处理与SDK有关的业务

#import "STSuspensionWindow.h"
#import "FWSettingBeautyView.h"
#import <libksyrtclivedy/KSYRTCClient.h>

/**
 *  =========================================================================================================
 *
 *  操作前请详细阅读该说明
 *
 *  该类只处理与SDK有关的业务，如有接入其他SDK时可参考该类；
 *  必须做的操作：1、重写父方法 2、实现FWLiveControllerAble协议
 *
 *  说明：该类主要编写的是金山的推拉流等操作，其中连麦集成了：1、金山连麦 ；2、声网连麦。 注意：该类并没有声网直播，只是用了声网的连麦！
 *
 *  操作须知：由于集成了金山连麦和声网两种连麦方式，而他们各自的SDK推流类并不相同，加上逻辑有些差异，因此当前分了两套推拉流类
 *
 *  FWKSYLinkMicStreamerController          ：   主播控制类（金山连麦）
 *  FWKSYLinkMicPlayerController            ：   观众控制类（金山连麦）
 *
 *  FWKSYAgoraLinkMicStreamerController     ：   主播控制类（声网连麦）
 *  FWKSYAgoraLinkMicPlayerController       ：   观众控制类（声网连麦）
 *
 *  FWKSYPlayerController                   ：   金山云点播（回放、回播）控制类
 *
 *  注意：不同直播SDK可能存在冲突，比如腾讯云直播SDK和金山直播SDK就存在冲突，所以金山SDK用的是动态库
 *
 *  =========================================================================================================
 */


typedef struct _StreamState
{
    double    timeSecond;       // 更新时间
    int       uploadKByte;      // 上传的字节数(KB)
    int       encodedFrames;    // 编码的视频帧数
    int       droppedVFrames;   // 丢弃的视频帧数
} StreamState;


@interface FWKSYLiveController : FWLiveBaseController<FWLiveControllerAble,FWLiveServiceControllerDelegate,ToolsViewDelegate,TCShowLiveTopViewToSDKDelegate,FWKSYPlayerControllerDelegate,livePayDelegate,FWKSYLinkMicStreamerControllerDelegate,FWKSYLinkMicPlayerControllerDelegate,STSuspensionWindowDelegate,TCShowLiveViewForSDKDelegate,FWKSYAgoraStreamerBaseControllerDelegate,FWKSYStreamerControllerDelegate>
{
    
@private
    
    NSInteger               _mikeCount;             // 连麦数
    NSInteger               _micMaxNum;             // 连麦最大数量
    
    MMAlertView             *_applyMickingAlert;    // 观众申请连麦中的弹窗
    MMAlertView             *_hostMickingAlert;     // 主播收到观众申请连麦中的弹窗
    
    StreamState             _lastStD;               // 上一次更新时的数据, 假定每秒更新一次
    StreamState             _curState;
    StreamState             _deltaS;
    
    FWSettingBeautyView     *_beautyView;           // 美颜视图
    ToolsView               *_toolsView;
    
    BOOL                    _isMuted;               // 当前是否静音状态
}

// 金山云点播（回放、回播）控制类
@property (nonatomic, strong) FWKSYPlayerController                     *ksyPlayerController;

// 主播控制类（金山连麦）
@property (nonatomic, strong) FWKSYLinkMicStreamerController            *ksyLinkMicStreamerController;
// 观众控制类（金山连麦）
@property (nonatomic, strong) FWKSYLinkMicPlayerController              *ksyLinkMicPlayerController;

// 主播控制类（声网连麦）
@property (nonatomic, strong) FWKSYAgoraLinkMicStreamerController       *agoraLinkMicStreamerController;
// 观众控制类（声网连麦）
@property (nonatomic, strong) FWKSYAgoraLinkMicPlayerController         *agoraLinkMicPlayerController;

// 点播进度条容器视图
@property (nonatomic, strong) FWReLiveProgressView          *reLiveProgressView;
// 直播业务层
@property (nonatomic, strong) FWLiveServiceController       *liveServiceController;

// 连麦观众
@property (nonatomic, strong) NSMutableArray                *mickUserMArray;
// 金山云连麦鉴权观众列表（鉴权后不一定能真正连麦成功，所以做此记录）
@property (nonatomic, strong) NSMutableArray                *registerMickUserMArray;
// 当前连麦接收者的ID（一般指的是主播）
@property (nonatomic, strong) CustomMessageModel            *customResponderModel;
// 当前连麦接申请者的ID（一般指的是连麦观众）
@property (nonatomic, strong) CustomMessageModel            *customApplicantModel;
// 是否连麦申请中
@property (nonatomic, assign) BOOL                          isApplyMicking;
// 返回竖屏按钮
@property (nonatomic, strong) UIButton                      *backVerticalBtn;


// 开始推流、拉流
- (void)startLiveRtmp:(NSString *)playUrlStr;
// 结束推流、拉流
- (void)stopLiveRtmp;
// 获取当前直播质量
- (NSString *)getLiveQuality;

// yue 创建直播间
+ (UIViewController *)showLiveViewCwith:(TCShowLiveListItem *)liveListItem;

// 获取当前视频容器视图的父视图
- (UIView *)getPlayViewBottomView;
// 设置静音
- (void)setSDKMute:(BOOL)bEnable;

@end
