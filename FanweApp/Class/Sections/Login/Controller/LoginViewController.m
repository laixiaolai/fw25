//
//  LoginViewController.m
//  FanweApp
//
//  Created by fanwe2014 on 16/7/5.
//  Copyright © 2016年 xfg. All rights reserved.


#import "LoginViewController.h"
#import "LPhoneLoginVC.h"
#import "JSONKit.h"
#import "WeiboSDK.h"
#import <TencentOpenAPI/TencentOAuth.h>

@interface LoginViewController ()<NLgDelegate>

@property (strong, nonatomic) UIButton         *visitorsLoginBtn;              //游客登入的btn
@property (strong, nonatomic) NSMutableArray   *Marray;                        //登入方式的数组
@property (strong, nonatomic) UIImageView      *selectedImageView;             //协议是否选择的图标
@property (assign, nonatomic) BOOL             isSelectProtocol;               //是否选择了协议

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showVisitorsBtn) name:@"getDeviceTokenComplete" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)initFWVariables
{
    [super initFWVariables];
    
    self.view.backgroundColor = kAppMainColor;
    _isSelectProtocol = YES;
    _Marray = [[NSMutableArray alloc]init];
    _has_qq_login = (int)self.fanweApp.appModel.has_qq_login;
    _has_wx_login = (int)self.fanweApp.appModel.has_wx_login;
    _has_mobile_login = (int)self.fanweApp.appModel.has_mobile_login;
    _has_sina_login = (int)self.fanweApp.appModel.has_sina_login;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(wxloginback:) name:kWXLoginBack object:nil];
}

- (void)initFWUI
{
    [super initFWUI];
    [self creatView];
}

#pragma mark 主UI
- (void)creatView
{
    UIImageView *backImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, kScreenW, kScreenH)];
    backImgView.contentMode = UIViewContentModeScaleToFill;
    backImgView.image = [UIImage imageNamed:@"lg_bg"];
    [self.view addSubview:backImgView];
    
    UILabel *loginLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenW/2-40, kScreenH*0.6, 80, 30)];
    loginLabel.text = @"登录";
    loginLabel.font = [UIFont systemFontOfSize:22];
    loginLabel.textColor = [UIColor whiteColor];
    loginLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:loginLabel];
    
    UIView *lefeView = [[UIView alloc]initWithFrame:CGRectMake(kScreenW*0.35-45, kScreenH*0.6+14, kScreenW*0.15, 1)];
    lefeView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:lefeView];
    
    UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(kScreenW*0.5+45, kScreenH*0.6+14, kScreenW*0.15, 1)];
    rightView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:rightView];
    
    if (self.fanweApp.appModel.auto_login)
    {
        loginLabel.hidden = YES;
        lefeView.hidden = YES;
        rightView.hidden = YES;
    }
    
    [self loginWay];
    
    UIView *buttomView = [[UIView alloc]init];
    buttomView.backgroundColor = kClearColor;
    [self.view addSubview:buttomView];
    
    _selectedImageView= [[UIImageView alloc]initWithFrame:CGRectMake(10, 7.5, 20, 20)];
    _selectedImageView.image = [UIImage imageNamed:@"lg_radio_selected"];
    [buttomView addSubview:_selectedImageView];
    
    UIButton *imgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    imgBtn.frame = CGRectMake(0, 0, 37, 35);
    imgBtn.backgroundColor = kClearColor;
    imgBtn.tag = 106;
    [imgBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [buttomView addSubview:imgBtn];
    
    CGFloat width = [@"《用户隐私政策》" boundingRectWithSize:CGSizeMake(kScreenW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:18]} context:nil].size.width;
    UIButton  *registButton = [UIButton buttonWithType:UIButtonTypeCustom];
    registButton.frame = CGRectMake(30,0, width+5, 35);
    [registButton setTitle:@"《用户隐私政策》" forState:UIControlStateNormal];
    [registButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [registButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    registButton.tag = 105;
    [buttomView addSubview:registButton];
    
    if (self.fanweApp.appModel.auto_login)
    {
        registButton.hidden = YES;
        buttomView.hidden = YES;
    }
    
    if ([GlobalVariables sharedInstance].appModel.has_visitors_login)
    {
        buttomView.frame = CGRectMake(kScreenW/2-(width+5+40)/2, kScreenH*0.75+75, (width+5+40), 35);
        
        // 游客登录按钮
        self.visitorsLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.visitorsLoginBtn.frame = CGRectMake(kDefaultMargin, CGRectGetMaxY(buttomView.frame) - 75, kScreenW - kDefaultMargin*2, 35);
        [self.visitorsLoginBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        [self.visitorsLoginBtn addTarget:self action:@selector(visitorsLogin) forControlEvents:UIControlEventTouchUpInside];
        if (!self.fanweApp.deviceToken.length)
        {
            self.visitorsLoginBtn.hidden = YES;
        }
        [self.view addSubview:self.visitorsLoginBtn];
        
        // underline Terms and condidtions
        NSMutableAttributedString* tncString = [[NSMutableAttributedString alloc] initWithString:@"游客登录"];
        
        //设置下划线...
        /*
         NSUnderlineStyleNone                                    = 0x00, 无下划线
         NSUnderlineStyleSingle                                  = 0x01, 单行下划线
         NSUnderlineStyleThick NS_ENUM_AVAILABLE(10_0, 7_0)      = 0x02, 粗的下划线
         NSUnderlineStyleDouble NS_ENUM_AVAILABLE(10_0, 7_0)     = 0x09, 双下划线
         */
        [tncString addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:(NSRange){0,[tncString length]}];
        //此时如果设置字体颜色要这样
        [tncString addAttribute:NSForegroundColorAttributeName value:kWhiteColor  range:NSMakeRange(0,[tncString length])];
        
        //设置下划线颜色...
        [tncString addAttribute:NSUnderlineColorAttributeName value:kWhiteColor range:(NSRange){0,[tncString length]}];
        [self.visitorsLoginBtn setAttributedTitle:tncString forState:UIControlStateNormal];
    }
    else
    {
        buttomView.frame = CGRectMake(kScreenW/2-(width+5+40)/2, kScreenH*0.7+75, (width+5+40), 35);
    }
}

- (void)showVisitorsBtn
{
  self.visitorsLoginBtn.hidden = NO;
}

#pragma mark 登入方式 0qq 1微信 2微博 3手机
- (void)loginWay
{
    if (self.has_qq_login == 1)//QQ
    {
        [_Marray addObject:@"1"];
    }
    
    if (self.has_wx_login == 1)//微信
    {
        [_Marray addObject:@"2"];
    }
    
    if (self.has_sina_login == 1)//微博
    {
        [_Marray addObject:@"3"];
    }
    
    if (self.has_mobile_login == 1)//手机
    {
        [_Marray addObject:@"4"];
    }
    
    //如果各种登入方式都没有就将手机的登入方式都显示出来
    if (_Marray.count < 1)
    {
        _Marray = [[NSMutableArray alloc]initWithObjects:@"4", nil];
    }
    self.LView = [[ULGView alloc]initWithFrame:CGRectMake(0, kScreenH*0.7, kScreenW, 47) Array:_Marray];
    self.LView.LDelegate = self;
    [self.view addSubview:self.LView];
}

#pragma mark 第三方登入回调
- (void)enterLoginWithCount:(int)count
{
    if (!_isSelectProtocol)
    {
        [FanweMessage alertTWMessage:@"您还未同意用户隐私政策"];
        return;
    }
    
    switch (count)
    {
        case 1:
            if (![TencentOAuth iphoneQQInstalled])
            {
                [FanweMessage alertTWMessage:@"QQ未安装"];
            }
            else
            {
                [self loginByQQ];
            }
            break;
        case 2:
            if (![WXApi isWXAppInstalled])
            {
                [FanweMessage alertTWMessage:@"微信未安装"];
            }
            else
            {
                [self loginByWechat];
            }
            break;
        case 3:
            if (![WeiboSDK isWeiboAppInstalled])
            {
                [FanweMessage alertTWMessage:@"新浪微博未安装"];
            }
            else
            {
                [self loginByXinlang];
            }
            break;
        case 4:
            [self loginByPhone];
            break;
        default:
            break;
    }
}

#pragma mark 用户隐私以及它是否选择
- (void)buttonClick:(UIButton *)button
{
    if (button.tag == 106)
    {
        _isSelectProtocol = !_isSelectProtocol;
        if (_isSelectProtocol)
        {
            _selectedImageView.image = [UIImage imageNamed:@"lg_radio_selected"];
        }else
        {
            _selectedImageView.image = [UIImage imageNamed:@"lg_radio_no_selected"];
        }
    }
    else if (button.tag == 105)
    {
        FWMainWebViewController *tmpController = [FWMainWebViewController webControlerWithUrlStr:self.fanweApp.appModel.privacy_link isShowIndicator:YES isShowNavBar:YES isShowBackBtn:YES];
        [[AppDelegate sharedAppDelegate] pushViewController:tmpController];
    }
}

#pragma mark 获取UserSig等参数
- (void)getLoginParam:(NSMutableDictionary *)param
{
    [self showMyHud];
    
    FWWeakify(self)
    
    [self.httpsManager POSTWithParameters:param SuccessBlock:^(NSDictionary *responseJson)
     {
         FWStrongify(self)
         
         if ([responseJson toInt:@"status"] == 1)
         {
             if ([responseJson toInt:@"need_bind_mobile"] == 1)//是否需要绑定手机1需要 0为不需要
             {
                 [self hideMyHud];
                 LPhoneLoginVC *loginVC = [[LPhoneLoginVC alloc]init];
                 loginVC.loginId = self.loginId;
                 loginVC.loginType = self.loginType;
                 loginVC.accessToken = self.accessToken;
                 loginVC.LNSecBPhone = YES;
                 [[AppDelegate sharedAppDelegate] pushViewController:loginVC];
                 
             }else
             {
                 [FWIMLoginManager sharedInstance].loginParam.identifier = [responseJson toString:@"data"];
                 [FWIMLoginManager sharedInstance].loginParam.isAgree = [responseJson toInt:@"is_agree"];
                 
                 self.fanweApp.appModel.first_login = [responseJson toString:@"first_login"];
                 self.fanweApp.appModel.new_level = [responseJson toInt:@"new_level"];
                 self.fanweApp.appModel.login_send_score = [responseJson toString:@"login_send_score"];
                 
                 [[FWIMLoginManager sharedInstance] getUserSig:^{
                     
                     [[AppDelegate sharedAppDelegate] enterMainUI];
                     
                     [self hideMyHud];
                     
                 } failed:^(int errId, NSString *errMsg) {
                     [self hideMyHud];
                     
                 }];
             }
         }
         else
         {
             [self hideMyHud];
         }
         
     } FailureBlock:^(NSError *error)
     {
         [self hideMyHud];
         
         [FanweMessage alertHUD:@"获取登录参数失败，请稍后尝试"];
     }];
}

#pragma mark 微信登录
- (void)loginByWechat
{
    [self getUserInfoForPlatform:UMSocialPlatformType_WechatSession];
    
    /*
     // 构造SendAuthReq结构体
     SendAuthReq* req =[[SendAuthReq alloc ] init ];
     req.scope = @"snsapi_userinfo" ;
     req.state = @"123" ;
     // 第三方向微信终端发送一个SendAuthReq消息结构
     [WXApi sendReq:req];
     */
}

#pragma mark 微信登录获取code后oc调用js把code等传上去
- (void)wxloginback:(NSNotification *)text
{
    /*
     NSString *string = text.object;
     NSDictionary *dict = [string objectFromJSONString];
     NSString *code = [dict toString:@"code"];
     NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
     [parmDict setObject:@"login" forKey:@"ctl"];
     [parmDict setObject:@"wx_login" forKey:@"act"];
     [parmDict setObject:code forKey:@"code"];
     
     [self getLoginParam:parmDict];
     */
}

#pragma mark qq登录
- (void)loginByQQ
{
    [self getUserInfoForPlatform:UMSocialPlatformType_QQ];
}

#pragma mark 新浪登录
- (void)loginByXinlang
{
    [self getUserInfoForPlatform:UMSocialPlatformType_Sina];
}

#pragma mark 根据对应类型进行登录操作
- (void)getUserInfoForPlatform:(UMSocialPlatformType)platformType
{
    __weak typeof(self) ws = self;
    
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:platformType currentViewController:self completion:^(id result, NSError *error) {
        
        UMSocialUserInfoResponse *resp = result;
        
        if (resp)
        {
            NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
            [parmDict setObject:@"login" forKey:@"ctl"];
            
            if (platformType == UMSocialPlatformType_QQ)
            {
                [parmDict setObject:@"qq_login" forKey:@"act"];
                [parmDict setObject:resp.openid forKey:@"openid"];
                [parmDict setObject:resp.accessToken forKey:@"access_token"];
                self.loginType = @"qq_login";
                self.loginId = resp.openid;
            }
            else if (platformType == UMSocialPlatformType_WechatSession)
            {
                [parmDict setObject:@"wx_login" forKey:@"act"];
                [parmDict setObject:resp.openid forKey:@"openid"];
                [parmDict setObject:resp.accessToken forKey:@"access_token"];
                self.loginType = @"wx_login";
                self.loginId = resp.openid;
            }
            else if (platformType == UMSocialPlatformType_Sina)
            {
                [parmDict setObject:@"sina_login" forKey:@"act"];
                [parmDict setObject:resp.uid forKey:@"sina_id"];
                [parmDict setObject:resp.accessToken forKey:@"access_token"];
                self.loginType = @"sina_login";
                self.loginId = resp.uid;
            }
            self.accessToken = resp.accessToken;
            [ws getLoginParam:parmDict];
        }
    }];
}

#pragma mark 手机登录
- (void)loginByPhone
{
    LPhoneLoginVC *phoneVC = [[LPhoneLoginVC alloc]init];
    [[AppDelegate sharedAppDelegate]pushViewController:phoneVC];
}

#pragma mark 游客登录
- (void)visitorsLogin
{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"login" forKey:@"ctl"];
    [parmDict setObject:@"visitors_login" forKey:@"act"];
    [parmDict setObject:[GlobalVariables sharedInstance].deviceToken forKey:@"um_reg_id"];
    [self showMyHud];
    FWWeakify(self)
    [[NetHttpsManager manager] POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
        
        FWStrongify(self)
        if ([responseJson toInt:@"status"] == 1)
        {
            [FWIMLoginManager sharedInstance].loginParam.identifier = [[responseJson objectForKey:@"user_info"] toString:@"user_id"];
            [FWIMLoginManager sharedInstance].loginParam.isAgree = [[responseJson objectForKey:@"user"] toInt:@"is_agree"];
            
            self.fanweApp.appModel.first_login = [responseJson toString:@"first_login"];
            self.fanweApp.appModel.new_level = [responseJson toInt:@"new_level"];
            self.fanweApp.appModel.login_send_score = [responseJson toString:@"login_send_score"];
            
            [[FWIMLoginManager sharedInstance] getUserSig:^{
                
                [[AppDelegate sharedAppDelegate] enterMainUI];
                
                [self hideMyHud];
                
            } failed:^(int errId, NSString *errMsg) {
                
                [self hideMyHud];
            }];
        }
        else
        {
            [self hideMyHud];
        }
        
    } FailureBlock:^(NSError *error) {
        
        FWStrongify(self)
        [self hideMyHud];
        
    }];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


@end
