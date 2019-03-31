//
//  LPhoneLoginVC.m
//  FanweApp
//
//  Created by 丁凯 on 2017/6/15.
//  Copyright © 2017年 xfg. All rights reserved.

#import "LPhoneLoginVC.h"
#import "LPhoneRegistVC.h"

@interface LPhoneLoginVC ()<UITextFieldDelegate,MBProgressHUDDelegate>

{
    NSTimer                         *_timer;                //定时器
    int                             _timeCount;             //定时器时间
    NSString                        *_verify_url;           //图形验证码
}

@end

@implementation LPhoneLoginVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = kBackGroundColor;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].keyboardDistanceFromTextField = 5.0f;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    
}

- (void)initFWUI
{
    [super initFWUI];
    _timeCount = 60;
    self.view.backgroundColor = self.secondBottomView.backgroundColor = kBackGroundColor;
    self.navigationItem.leftBarButtonItem=[UIBarButtonItem itemWithTarget:self action:@selector(comeBack) image:@"com_arrow_vc_back" highImage:@"com_arrow_vc_back"];
    if (self.LNSecBPhone||self.LSecBPhone)
    {
        self.navigationItem.title = @"手机绑定";
    }else
    {
        self.navigationItem.title = @"手机登录";
    }
    self.phoneFiled.delegate = self;
    [self.phoneFiled becomeFirstResponder];
    self.firstBottomViewH.constant = 0;
    self.secondBottomViewSpaceH.constant = 0;
    [self.codeBtn setTitleColor:kAppGrayColor1 forState:UIControlStateNormal];;
    self.codeBtn.layer.cornerRadius = 5;
    self.codeBtn.layer.borderWidth = 1;
    self.codeBtn.layer.borderColor = kAppGrayColor1.CGColor;
    self.loginBtn.layer.cornerRadius = self.loginBtn.height/2.0f;
    self.loginBtn.backgroundColor    = kAppMainColor;
    self.phoneCodeFiled.backgroundColor = kWhiteColor;
}

- (void)initFWData
{
    [super initFWData];
    [self loadDataFromNet];
}

- (void)comeBack
{
    [self myFiledResignFirstResP];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 键盘回退
- (void)myFiledResignFirstResP
{
    [_phoneFiled resignFirstResponder];
    [_codeFiled resignFirstResponder];
    [_phoneCodeFiled resignFirstResponder];
}

#pragma mark 网络请求，判断是否有图形验证码
- (void)loadDataFromNet
{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"login" forKey:@"ctl"];
    [parmDict setObject:@"is_user_verify" forKey:@"act"];
    FWWeakify(self)
    [self showMyHud];
    [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson)
     {
         [self hideMyHud];
         FWStrongify(self)
         if ([responseJson toInt:@"status"] == 1)
         {
             if ([[responseJson toString:@"verify_url"] length])
             {
                 self.firstBottomViewH.constant = 40;
                 self.secondBottomViewSpaceH.constant = 10;
                 _verify_url = [responseJson toString:@"verify_url"];
                 [self.codeImgView sd_setImageWithURL:[NSURL URLWithString:[responseJson toString:@"verify_url"]] placeholderImage:kDefaultPreloadHeadImg options:SDWebImageRefreshCached];
             }
         }
     } FailureBlock:^(NSError *error)
     {
         FWStrongify(self)
         [self hideMyHud];
     }];
}

- (IBAction)btnClick:(UIButton *)sender
{
    switch (sender.tag)
    {
        case 0://验证 或者绑定手机
        {
            if (![self.phoneFiled.text isTelephone])
            {
                [FanweMessage alert:@"请输入正确的电话号码"];
                return;
            }
            self.codeBtn.enabled = NO;
            _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timego) userInfo:nil repeats:YES];
            [self timego];
            if (self.LSecBPhone || self.LNSecBPhone)
            {
                FWWeakify(self)
                NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
                [parmDict setObject:@"login" forKey:@"ctl"];
                [parmDict setObject:@"send_mobile_verify" forKey:@"act"];
                [parmDict setObject:@"1" forKey:@"wx_binding"];
                [parmDict setObject:self.phoneFiled.text forKey:@"mobile"];
                [self showMyHud];
                [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson)
                 {
                     FWStrongify(self)
                     [self hideMyHud];
                     if ([responseJson toInt:@"status"] != 1)
                     {
                         self.codeBtn.enabled = YES;
                         [self.codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                         [_timer invalidate];
                         _timer = nil;
                     }
                 } FailureBlock:^(NSError *error) {
                     FWStrongify(self)
                     [self hideMyHud];
                     [self.codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                     [FanweMessage alert:@"发送失败"];
                     self.codeBtn.enabled = YES;
                 }];
            }
            else
            {
                NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
                [parmDict setObject:@"login" forKey:@"ctl"];
                [parmDict setObject:@"send_mobile_verify" forKey:@"act"];
                [parmDict setObject:self.phoneFiled.text forKey:@"mobile"];
                if (_verify_url.length > 1 && self.codeFiled.text.length)
                {
                    [parmDict setObject:self.codeFiled.text forKey:@"image_code"];
                }
                FWWeakify(self)
                [self showMyHud];
                [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson)
                 {
                     FWStrongify(self)
                     [self hideMyHud];
                     if ([responseJson toInt:@"status"] != 1)
                     {
                         self.codeBtn.enabled = YES;
                         [self.codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                         [_timer invalidate];
                         _timer = nil;
                         [self.phoneFiled resignFirstResponder];
                     }
                     
                 } FailureBlock:^(NSError *error)
                 {
                     [self hideMyHud];
                     self.codeBtn.enabled = YES;
                     [self.codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                 }];
            }
        }
            break;
        case 1://登录,绑定手机
        {
            if (![self.phoneFiled.text isTelephone]) {
                [FanweMessage alert:@"请输入正确的电话号码"];
                return;
            }
            if (self.phoneCodeFiled.text.length < 1)
            {
                [FanweMessage alert:@"请输入验证码"];
                return;
            }
            if (self.LNSecBPhone || self.LSecBPhone)
            {
                NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
                [parmDict setObject:@"settings" forKey:@"ctl"];
                if (self.LNSecBPhone)
                {
                  [parmDict setObject:@"mobile_login" forKey:@"act"];
                }
                if (self.LSecBPhone)
                {
                  [parmDict setObject:@"mobile_binding" forKey:@"act"];
                }
               
                [parmDict setObject:self.phoneFiled.text forKey:@"mobile"];
                [parmDict setObject:self.phoneCodeFiled.text forKey:@"verify_code"];
                if (self.loginId.length)
                {
                    [parmDict setObject:self.loginId forKey:@"openid"];
                }
                if (self.loginType.length)
                {
                    [parmDict setObject:self.loginType forKey:@"login_type"];
                }
                if (self.accessToken.length)
                {
                    [parmDict setObject:self.accessToken forKey:@"access_token"];
                }
                FWWeakify(self)
                [self showMyHud];
                [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson)
                 {
                     FWStrongify(self)
                     if ([responseJson toInt:@"status"] == 1)
                     {
                         if (self.LSecBPhone)
                         {
                             [[AppDelegate sharedAppDelegate]popViewController];
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
                     }else
                     {
                        [self hideMyHud];
                     }
                 } FailureBlock:^(NSError *error) {
                     FWStrongify(self)
                     [self hideMyHud];
                     [FanweMessage alert:@"验证码过程出错，请重新尝试"];
                 }];
            }
            else
            {
                NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
                [parmDict setObject:@"login" forKey:@"ctl"];
                [parmDict setObject:@"do_login" forKey:@"act"];
                [parmDict setObject:self.phoneFiled.text forKey:@"mobile"];
                [parmDict setObject:self.phoneCodeFiled.text forKey:@"verify_coder"];
                FWWeakify(self)
                [self showMyHud];
                [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson)
                 {
                     FWStrongify(self)
                     [self hideMyHud];
                     if ([responseJson toInt:@"status"] == 1)
                     {
                         self.fanweApp.appModel.new_level = [responseJson toInt:@"new_level"];
                         self.fanweApp.appModel.first_login = [responseJson toString:@"first_login"];
                         self.fanweApp.appModel.login_send_score = [responseJson toString:@"login_send_score"];
                         if ([responseJson toInt:@"is_lack"] == 1)
                         {
                             LPhoneRegistVC *phoneRegist = [[LPhoneRegistVC alloc]init];
                             phoneRegist.used_id = [responseJson toString:@"user_id"];
                             phoneRegist.userInfoDic = responseJson[@"user_info"];
                             phoneRegist.userName = [responseJson[@"user_info"] toString:@"nick_name"];
                             [[AppDelegate sharedAppDelegate]pushViewController:phoneRegist];
                         }
                         else
                         {
                             [self showMyHud];
                             [FWIMLoginManager sharedInstance].loginParam.identifier = [responseJson toString:@"user_id"];
                             [FWIMLoginManager sharedInstance].loginParam.isAgree = [responseJson toInt:@"is_agree"];
                             [[FWIMLoginManager sharedInstance] getUserSig:^{
                                 [[AppDelegate sharedAppDelegate] enterMainUI];
                                 [self hideMyHud];
                             } failed:^(int errId, NSString *errMsg) {
                                 [self hideMyHud];
                             }];
                         }
                     }
                 } FailureBlock:^(NSError *error)
                 {
                     FWStrongify(self)
                     [self hideMyHud];
                 }];
            }
        }
            break;
            case 2:
        {
            [self loadDataFromNet];
        }
            
        default:
            break;
    }
}

#pragma mark 获取验证码的倒计时
- (void)timego
{
    [self timerDec:_timeCount];
}

- (void)timerDec:(NSInteger)time
{
    if(time > 0)
    {
        [self.codeBtn setTitle:[NSString stringWithFormat:@"重新获取(%lds)",(long)time] forState:UIControlStateDisabled];
        [self.codeBtn setTitleColor:kAppGrayColor1 forState:UIControlStateDisabled];
        _timeCount --;
    }else if(time == 0)
    {
        self.codeBtn.enabled = YES;
        [self.codeBtn setTitle:[NSString stringWithFormat:@"获取验证码"] forState:UIControlStateNormal];
        [_timer invalidate];
        _timeCount = 60;
    }
}

#pragma mark ============UITextFieldDelegate===================
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self myFiledResignFirstResP];
}

- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == self.phoneFiled)
    {
        if (textField.text.length > 11)
        {
            textField.text = [textField.text substringToIndex:11];
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.phoneFiled)
    {
        if (![string isNumber])
        {
            return NO;
        }
        if (string.length == 0) return YES;
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 11)
        {
            return NO;
        }
    }
    if (textField == self.codeFiled)
    {
        if (![string isNumber])
        {
            return NO;
        }
        if (string.length == 0) return YES;
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 10)
        {
            return NO;
        }
    }
    return YES;
}




@end
