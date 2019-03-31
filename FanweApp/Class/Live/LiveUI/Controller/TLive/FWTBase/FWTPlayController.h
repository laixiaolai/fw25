//
//  FWTPlayController.h
//  FanweApp
//
//  Created by xfg on 16/12/5.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TXLiteAVSDK_Professional/TXLivePlayer.h>
#import <TXLiteAVSDK_Professional/TXLivePush.h>
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <TXLiteAVSDK_Professional/TXLivePushListener.h>


@class FWTPlayController;

@protocol FWTPlayControllerDelegate <NSObject>
@required

// 结束回播，用来判断是否还有下一段回播
- (void)stopReLive;
// 首帧回调
- (void)firstFrame:(FWTPlayController*)playVC;
// 网络断连,且经多次重连抢救无效后退出app
- (void)exitPlayAndApp:(FWTPlayController*)publishVC;
// 网络断连,重连
- (void)playAgain:(FWTPlayController*)publishVC isHideLeaveTip:(BOOL)isHideLeaveTip;

@end


@interface FWTPlayController : UIViewController
{
    UITextView*         _statusView;
    UITextView*         _logViewEvt;
    unsigned long long  _startTime;
    unsigned long long  _lastTime;
    
    UIView*             _cover;
    
    BOOL                _screenPortrait;
    BOOL                _renderFillScreen;
    BOOL                _log_switch;
    AVCaptureSession *  _VideoCaptureSession;
    
    NSString*           _logMsg;
    NSString*           _tipsMsg;
    NSString*           _testPath;
    NSInteger           _cacheStrategy;
    
    UIButton*           _btnCacheStrategy;
    UIControl*          _vCacheStrategy;
    UIButton*           _radioBtnFast;
    UIButton*           _radioBtnSmooth;
    UIButton*           _radioBtnAUTO;
    
    NSInteger       _rePlayTime;
}

@property (nonatomic, weak) id<FWTPlayControllerDelegate>delegate;

@property (nonatomic, strong) TXLivePlayer  *txLivePlayer;
@property (nonatomic, strong) UIView        *videoContrainerView;   // 放置视频的view
@property (nonatomic, assign) NSInteger     liveType;               // 视频类型，对应枚举FW_LIVE_TYPE
@property (nonatomic, assign) NSInteger     create_type;            // 
@property (nonatomic, copy) NSString        *playUrlStr;            // 播放地址
@property (nonatomic, assign) BOOL          isLivePlay;             // YES：直播的观众（拉流） NO：点播（回播、回看）
@property (nonatomic, assign) BOOL          play_switch;            // NO：第一次播放 YES：播放、暂停

@property (nonatomic, strong) UISlider      *playProgress;          // 进度条
@property (nonatomic, strong) UILabel       *playStart;             // 播放时间
@property (nonatomic, strong) UIButton      *btnPlay;               // 开始按钮

@property (nonatomic, copy) NSString        *kbpsSendStr;           // 发送码率
@property (nonatomic, copy) NSString        *kbpsRecvStr;           // 接收码率
@property (nonatomic, strong) NSDictionary  *qualityDict;           // 直播质量相关参数

// 开始拉流
- (BOOL)startRtmp:(NSInteger)create_type;
// 停止拉流
- (void)stopRtmp;

// app进入后台
- (void)onAppDidEnterBackGround;
// app将要进入前台
- (void)onAppWillEnterForeground;
// 声音打断监听
- (void)onAudioInterruption:(NSNotification *)notification;

- (void)onPlayEvent:(int)EvtID withParam:(NSDictionary*)param;

- (void)onNetStatus:(NSDictionary*) param;

- (void)toastTip:(NSString*)toastInfo;

// ----------------回播专用-----------------
// 点击开始回播按钮
- (void)clickPlay:(UIButton *)sender create_type:(NSInteger)create_type;
// 改变进度条
- (void)onSeek:(UISlider *)slider;
// 点击进度条
- (void)onSeekBegin:(UISlider *)slider;
// 拖动进度条
- (void)onDrag:(UISlider *)slider;
// 结束拖动
- (void)dragSliderDidEnd:(UISlider *)slider;

@end
