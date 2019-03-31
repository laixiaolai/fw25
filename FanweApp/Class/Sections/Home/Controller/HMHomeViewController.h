//
//  HMHomeViewController.h
//  FanweApp
//
//  Created by xfg on 2017/6/29.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "FWBaseViewController.h"

/**
 首页刷新机制：
 1、kRefreshWithNewaTimeInterval秒刷新机制，该刷新通过kRefreshHome、viewDidAppear机制调起；
 2、首页几个主要页面通过kRefreshHomeItem通知刷新，该刷新采用不请求接口的方式，通过收到IM通知后删除对应关闭了得直播间项的方式；
 */

@interface HMHomeViewController : FWBaseViewController

@end
