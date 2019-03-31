//
//  FWTLiveController.h
//  FanweApp
//
//  Created by xfg on 16/12/5.
//  Copyright © 2016年 xfg. All rights reserved.
//  腾讯云直播，只处理与SDK有关的业务

#import "STSuspensionWindow.h"
#import "FWLiveServiceController.h"
#import "FWTLiveBeautyView.h"

/**
 *  该类只处理与SDK有关的业务，如有接入其他SDK时可参考该类；
 *  必须做的操作：1、重写父方法 2、实现FWLiveControllerAble协议
 */

@interface FWTLiveController : FWLiveBaseController<FWLiveControllerAble,FWLiveServiceControllerDelegate,ToolsViewDelegate,TCShowLiveTopViewToSDKDelegate,FWTPlayControllerDelegate,FWTPublishControllerDelegate,livePayDelegate,FWTLinkMicPlayControllerDelegate,FWTLinkMicPublishControllerDelegate,FWTLiveBeautyViewDelegate,TCShowLiveViewForSDKDelegate,STSuspensionWindowDelegate>
{
    
@private
    UISlider            *_playProgress;
    UILabel             *_playStart;
    UIButton            *_btnPlay;
    
    NSInteger           _micMaxNum;                     // 连麦最大数量
    
    MMAlertView         *_applyMickingAlert;            // 观众申请连麦中的弹窗
    MMAlertView         *_hostMickingAlert;             // 主播收到观众申请连麦中的弹窗
    
    FWTLiveBeautyView   *_beautyView;                   // 美颜视图
    ToolsView           *_toolsView;
    
    BOOL                _isMickAudiencePushing;         // 连麦观众是否正在推流
    BOOL                _isMuted;                       // 当前是否静音状态
}

// 点播进度条容器视图
@property (nonatomic, strong) UIView                            *reLiveProgressView;
// 直播业务层
@property (nonatomic, strong) FWLiveServiceController           *liveServiceController;
// 腾讯云直播的主播控制类
@property (nonatomic, strong) FWTLinkMicPublishController       *publishController;
// 腾讯云直播的观众控制类
@property (nonatomic, strong) FWTLinkMicPlayController          *linkMicPlayController;
// 腾讯云直播的观众控制类、点播（回放、回播）
@property (nonatomic, strong) FWTPlayController                 *playController;
// 观众是否连麦申请中
@property (nonatomic, assign) BOOL                              isApplyMicking;
// 主播正在应答连麦申请中
@property (nonatomic, assign) BOOL                              isResponseMicking;
// 返回竖屏按钮
@property (nonatomic, strong) UIButton                          *backVerticalBtn;

// 开始推流、拉流
- (void)startLiveRtmp:(NSString *)playUrlStr;
// 结束推流、拉流
- (void)stopLiveRtmp;
// 获取当前直播质量
- (NSString *)getLiveQuality;
// 获取当前视频容器视图的父视图
- (UIView *)getPlayViewBottomView;
// 设置静音 YES：设置为静音
- (void)setSDKMute:(BOOL)bEnable;

@end
