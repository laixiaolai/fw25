//
//  FWMainWebViewController.h
//  FanweApp
//
//  Created by xfg on 2017/6/3.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "FWBaseWebViewController.h"
#import "Mwxpay.h"

typedef NS_ENUM(NSInteger, CurrentJump)
{
    CurrentJumpError            =   -1,     // 不做操作
    CurrentJumpLiveRoom         =   0,      // 直播间
    CurrentJumpMainUI           =   1,      // 原生的直播页面
    CurrentJumpPublishLive      =   2,      // 发布直播页
};


@interface FWMainWebViewController : FWBaseWebViewController <WKScriptMessageHandler, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end
