//
//  SIdentificationVC.h
//  FanweApp
//
//  Created by 丁凯 on 2017/8/4.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "FWBaseViewController.h"

typedef NS_ENUM(NSInteger ,AuthenticationTableView)
{
    AuthenticationZeroSection,                 //基本资料
    AuthenticationOneSection,                  //认证消息
    AuthenticationTwoSection,                  //身份认证
    AuthenticationThreeSection,                //选择推荐
    AuthenticationFourSection,                 //公会邀请码
    AuthenticationFiveSection,                 //提交
    AuthenticationTab_Count,
};

@interface SIdentificationVC : FWBaseViewController

@property ( nonatomic, copy) NSString    *nameString;
@property ( nonatomic, copy) NSString    *sexString;
@property ( nonatomic, copy) NSString    *user_id;

@end
