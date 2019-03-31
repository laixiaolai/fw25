//
//  LiveCenterTotalHeader.h
//  FanweApp
//
//  Created by 岳克奎 on 16/12/13.
//  Copyright © 2016年 xfg. All rights reserved.
//

#ifndef LiveCenterTotalHeader_h
#define LiveCenterTotalHeader_h

#import "SusBaseWindow.h"
#import "LiveCenterAPIManager.h"
#import "SuspenionWindow.h"
#import "LiveCenterManager.h"
#import "LiveCenterAPIManager.h"
#import "STSuspensionWindow.h"

#define APP_DELEGATE                           [AppDelegate sharedAppDelegate]
#define SUS_WINDOW                             APP_DELEGATE.sus_window
#define LIVE_CENTER_MANAGER                    [LiveCenterManager sharedInstance]

// 悬浮视频窗口
#define kSuspendLiveWindowScale                 1.5                                                             // 悬浮视频窗口的高、宽比
#define kSuspendLiveWindowWidth                 kScreenW*0.4                                                    // 悬浮视频窗口的宽
#define kSuspendLiveWindowHeight                kSuspendLiveWindowWidth*kSuspendLiveWindowScale                 // 悬浮视频窗口的高

#endif /* LiveCenterTotalHeader_h */
