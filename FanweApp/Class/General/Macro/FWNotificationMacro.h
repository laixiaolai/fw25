//
//  FWNotificationMacro.h
//  FanweApp
//
//  Created by 岳克奎 on 16/8/25.
//  Copyright © 2016年 xfg. All rights reserved.
//

#ifndef FWNotificationMacro_h
#define FWNotificationMacro_h

// 通知中心
#define Noti_Default                        [NSNotificationCenter defaultCenter]
// 发通知参数
#define Noti_Post_Param(n,s)                [[NSNotificationCenter defaultCenter]postNotificationName:n object:nil userInfo:s]
// 发送通知
#define kNotifPost(n, o)                    [[NSNotificationCenter defaultCenter] postNotificationName:n object:o]
// 监听通知
#define kNotifAdd(n, f)                     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(f) name:n object:nil]
// 通知移除
#define kNotifRemove()                      [[NSNotificationCenter defaultCenter] removeObserver:self]

// 文本键盘弹起
#define kHalf_IMMsgVC_Text_Keyboard_Up      @"textKeyboardUp"
// 控制半屏幕表情键盘 up／down
#define kHalf_IMMsgVC_Enmoji_Keyboard_Up    @"enmojiKeyboardUp"
#define kHalf_IMMsgVC_Enmoji_Keyboard_Down  @"enmojiKeyboardDown"
// 控制半屏幕礼物键盘 up／down
#define kHalf_IMMsgVC_Gift_Keyboard_Up      @"giftKeyboardUp"
#define kHalf_IMMsgVC_Gift_Keyboard_Down    @"giftKeyboardDown"
// 键盘恢复半VC
#define kHalf_IMMsgVC_Keyboard_Resume       @"KeyboardResume"
// 半VC退出
#define kHalf_VC_All_Quit                   @"halfVCAllQuit"


// 直播间可以等级升级后判断是否可以发言了
#define kLiveRoomCanSendMessage             @"liveRoomCanSendMessage"

// 微信登陆回调
#define kWXLoginBack                        @"wXLoginBack"

// 停止首页定时器
#define kInvalidateHomeTimer                @"invalidateHomeTimer"
// 首页刷新
#define kRefreshHome                        @"refreshHome"
// 删除首页关闭了得直播间
#define kRefreshHomeItem                    @"refreshHomeItem"

#endif /* FWNotificationMacro_h */
