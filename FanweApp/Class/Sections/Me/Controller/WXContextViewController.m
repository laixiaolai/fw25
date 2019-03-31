//
//  WXContextViewController.m
//  FanweApp
//
//  Created by yy on 16/7/22.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "WXContextViewController.h"
#import "LPhoneLoginVC.h"

@interface WXContextViewController ()
{
    NetHttpsManager *_httpManager;
    GlobalVariables *_fanweApp;

}
@end

@implementation WXContextViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"微信提现";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(returnProtitVC2) image:@"com_arrow_vc_back" highImage:@"com_arrow_vc_back"];
    
    _httpManager =[NetHttpsManager manager];
    _TieWxButton.backgroundColor = kAppMainColor;
    _TieWxNumberButton.backgroundColor = kAppMainColor;
    _TieMobileButton.backgroundColor = kAppMainColor;
    _fanweApp = [GlobalVariables sharedInstance];

    if ([_WxIsTie intValue] ==1)
    {
        [_TieWxButton setTitle:@"微信已绑定" forState:UIControlStateNormal];
    }
    else
    {
        [_TieWxButton setTitle:@"微信未绑定" forState:UIControlStateNormal];
        [_TieWxButton addTarget:self action:@selector(tieWXAction) forControlEvents:UIControlEventTouchUpInside];
    }
    if ([_MobileIsTie intValue] ==1)
    {
         [_TieMobileButton setTitle:@"手机已绑定" forState:UIControlStateNormal];
    }
    else
    {
         [_TieMobileButton setTitle:@"手机未绑定" forState:UIControlStateNormal];
          [_TieMobileButton addTarget:self action:@selector(tieMobileAction) forControlEvents:UIControlEventTouchUpInside];
    }
    if ([_WxNumberIsTie intValue] ==1)
    {
        [_TieWxNumberButton setTitle:@"公众号未关注" forState:UIControlStateNormal];
    }
    else
    {
        [_TieWxNumberButton setTitle:@"关注公众号" forState:UIControlStateNormal];
          [_TieWxNumberButton addTarget:self action:@selector(tieWxNumberAction) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)returnProtitVC2
{
    [self.navigationController popViewControllerAnimated:YES];
}

//绑定微信
- (void)tieWXAction
{
    [self loginByWechat];
}

//绑定手机
- (void)tieMobileAction
{
    LPhoneLoginVC *phoneLogin = [[LPhoneLoginVC alloc]init];
    phoneLogin.LSecBPhone =YES;
    [self.navigationController pushViewController:phoneLogin animated:YES];
}

//关注公众号
- (void)tieWxNumberAction
{
    [FanweMessage alert:[NSString stringWithFormat:@"微信搜索关注“%@”公众号领取红包", _fanweApp.appModel.short_name]];
}

#pragma mark 微信登录
- (void)loginByWechat
{
    //构造SendAuthReq结构体
    SendAuthReq* req =[[SendAuthReq alloc ] init ];
    req.scope = @"snsapi_userinfo" ;
    req.state = @"123456";
    //第三方向微信终端发送一个SendAuthReq消息结构
    [WXApi sendReq:req];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
