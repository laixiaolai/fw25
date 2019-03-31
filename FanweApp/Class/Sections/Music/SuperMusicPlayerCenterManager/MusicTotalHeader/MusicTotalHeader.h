//
//  MusicTotalHeader.h
//  FanweApp
//
//  Created by 岳克奎 on 16/12/16.
//  Copyright © 2016年 xfg. All rights reserved.
//

#ifndef MusicTotalHeader_h
#define MusicTotalHeader_h
//音乐总头文件
#import "MusicCenterManager.h"                    // 音乐管理中心
#import "MusicSuperPlayer.h"                      //封装C++播放器
#import "LrcLabel.h"                              //自定义 根据进度渲染歌词的lab
#import "LrcShowView.h"                           //承载两行歌词的底层View
#import "LrcModel.h"                              // 每一行歌词默认是个model
#import "choseMuiscVC.h"                          //音乐选择 VC
#import "XXNibBridge.h"                           //桥接头文件
#import "SuperPlayerSoundEffectVC.h"              //音效控制VC
#import "SuperPlayerSoundEffectTitleView.h"       //音效调节 标题栏View
#import "SuperPlayerSoundEffectSliderView.h"      //音效调节 slider View
#import "SuperPlayerSoundEffectPitchView.h"       //音效调节 音调 View
#import "SuperPlayerSoundEffectBtnsView.h"        //音效调节 音效View
//#define LRC_RENDER_COLOR   [UIColor greenColor]   //LrcLabel 歌词渲染的颜色(绿色)
#define SUPER_PLAYER_UIVC_FRAME_HEIGHT  120       //承载播放器的VC frame的高度
#define SUPER_PLAYER_UIVC_FRAME_Y       100       //承载播放器的VC frame 的Y
#define MUSIC_SAMPLERATE                44100     //采样率（默认这个吧）

// 取色值相关的方法
#define MUSIC_RGB(r,g,b)          [UIColor colorWithRed:(r)/255.f \
green:(g)/255.f \
blue:(b)/255.f \
alpha:1.f]
//歌词 海蓝色
#define MUSIC_LRC_BLUE            MUSIC_RGB(89,186,225)

//音乐控制中心
#define MUSIC_CENTER_MANAGER         [MusicCenterManager shareManager]
// 音效的宏定义
#define NUMFXUNITS 8
#define TIMEPITCHINDEX 0
#define PITCHSHIFTINDEX 1
#define ROLLINDEX 2
#define FILTERINDEX 3
#define EQINDEX 4
#define FLANGERINDEX 5
#define DELAYINDEX 6
#define REVERBINDEX 7

#pragma mark - YunMusic ---------------------------------------- 云音乐 区域----------------------------------
#import "YunMusicPlayVC.h"


#endif /* MusicTotalHeader_h */


