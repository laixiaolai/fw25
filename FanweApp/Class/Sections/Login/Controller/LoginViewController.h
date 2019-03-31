//
//  LoginViewController.h
//  FanweApp
//
//  Created by fanwe2014 on 16/7/5.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "FWBaseViewController.h"
#import "ULGView.h"

@interface LoginViewController : FWBaseViewController<MBProgressHUDDelegate>

@property (nonatomic, assign) int has_qq_login;           // qq登录，0表示没有这个登录，1表示有这个登录
@property (nonatomic, assign) int has_sina_login;         // 新浪登录
@property (nonatomic, assign) int has_wx_login;           // 微信登录
@property (nonatomic, assign) int has_mobile_login;       // 手机登录
@property (nonatomic, strong) ULGView *LView;             // 三方登录的View

@property (nonatomic, copy) NSString          *loginType;   //登入类型
@property (nonatomic, copy) NSString          *loginId;     //登入id
@property (nonatomic, copy) NSString          *accessToken; //登入accessToken

@end
