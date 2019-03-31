//
//  FWIMLoginManager.m
//  FanweApp
//
//  Created by xfg on 2017/1/11.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "FWIMLoginManager.h"

@implementation FWIMLoginManager

FanweSingletonM(Instance);

- (id)init
{
    @synchronized (self)
    {
        self = [super init];
        if (self)
        {
            BOOL isAutoLogin = [IMAPlatform isAutoLogin];
            if (!_loginParam && isAutoLogin)
            {
                _loginParam = [IMALoginParam loadFromLocal];
            }
            else
            {
                _loginParam = [[IMALoginParam alloc] init];
            }
        }
        return self;
    }
}


/**
 获取UserSig
 
 @param succ 成功回调
 @param failed 失败回调
 */
- (void)getUserSig:(FWVoidBlock)succ failed:(FWErrorBlock)failed
{
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    [mDict setObject:@"user" forKey:@"ctl"];
    [mDict setObject:@"usersig" forKey:@"act"];
    
    FWWeakify(self)
    
    [self.httpsManager POSTWithParameters:mDict SuccessBlock:^(NSDictionary *responseJson) {
        
        FWStrongify(self)
        
        self.loginParam.userSig = [responseJson objectForKey:@"usersig"];
        self.loginParam.tokenTime = [[NSDate date] timeIntervalSince1970];
        
        if (![FWUtils isBlankString:self.loginParam.userSig])
        {
            [self loginImSDK:NO succ:^{
                
                if (succ)
                {
                    succ();
                }
                
            } failed:^(int errId, NSString *errMsg) {
                
                if (failed)
                {
                    failed(FWCode_Normal_Error, @"登录IMSDK失败");
                }
                
            }];
        }
        else
        {
            [FanweMessage alertTWMessage:@"获取签名为空"];
            if (failed)
            {
                failed(FWCode_Normal_Error, @"获取签名为空");
            }
        }
        
    } FailureBlock:^(NSError *error) {
        
        [FanweMessage alertTWMessage:@"获取签名失败，请稍后尝试"];
        if (failed)
        {
            failed(FWCode_Normal_Error, @"请求网络失败");
        }
        
    }];
}

#pragma mark - 登录IMSDK
- (void)loginImSDK:(BOOL)isShowHud succ:(FWVoidBlock)succ failed:(FWErrorBlock)failed
{
    BOOL isAutoLogin = [IMAPlatform isAutoLogin];
    if (!_loginParam && isAutoLogin)
    {
        _loginParam = [IMALoginParam loadFromLocal];
    }
    
    [IMAPlatform configWith:_loginParam.config];
    
    if ([_loginParam isVailed])
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self doLogin:isShowHud succ:succ failed:failed];
        });
    }
}

#pragma mark 登录IMSDK
- (void)doLogin:(BOOL)isShowHud succ:(FWVoidBlock)succ failed:(FWErrorBlock)failed
{
    if ([_loginParam isExpired])
    {
        [[AppDelegate sharedAppDelegate] enterLoginUI];
        
        if (failed)
        {
            failed(1, @"过期，重新登录");
        }
        return;
    }
    
    if (_isIMSDKOK || _isLogingIMSDK)
    {
        if (failed)
        {
            failed(0, @"已经登录或者正在登录");
        }
        return;
    }
    
    _isLogingIMSDK = YES;
    
    if (isShowHud)
    {
        [self showMyHud];
        
        [self performSelector:@selector(hideMyHud) withObject:nil afterDelay:5];
    }
    
    FWWeakify(self)
    [[IMAPlatform sharedInstance] login:_loginParam succ:^{
        
        FWStrongify(self)
        
        self.isLogingIMSDK = NO;
        self.isIMSDKOK = YES;
        
        [self.loginParam saveToLocal];
        [[IMAPlatform sharedInstance] configOnEnterMainUIWith:self.loginParam];
        
        [AppViewModel userStateChange:@"Login"];
        [AppViewModel updateApnsCode];
        [self enterBigGroup];
        
        [self hideMyHud];
        
        if (succ)
        {
            succ();
        }
        
    } fail:^(int code, NSString *msg) {
        
        FWStrongify(self)
        
        self.isLogingIMSDK = NO;
        
        [self hideMyHud];
        
        if (failed)
        {
            failed(code, msg);
        }
        
#ifdef DEBUG
        [FanweMessage alert:[NSString stringWithFormat:@"登录IMSDK错误码： %d %@",code,msg]];
#endif
        
    }];
}

#pragma mark 加入大群
- (void)enterBigGroup
{
    if (![FWUtils isBlankString:self.fanweApp.appModel.full_group_id])
    {
        FWWeakify(self)
        [[TIMGroupManager sharedInstance] joinGroup:self.fanweApp.appModel.full_group_id msg:nil succ:^{
            NSLog(@"加入全员广播大群成功");
            
            FWStrongify(self)
            [self obtainAesKeyFromFullGroup:nil error:nil];
            
        } fail:^(int code, NSString *msg) {
            NSLog(@"加入全员广播大群失败，错误码：%d，错误原因：%@",code,msg);
        }];
    }
}
    
- (void)obtainAesKeyFromFullGroup:(FWVoidBlock)succBlock error:(FWErrorBlock)errorBlock
{
    if (!self.isIMSDKOK)
    {
        if (errorBlock)
        {
            errorBlock(FWCode_Normal_Error, @"IM还未登录成功");
        }
        return;
    }
    
    if ([FWUtils isBlankString:self.fanweApp.appModel.full_group_id])
    {
        if (errorBlock)
        {
            errorBlock(FWCode_Normal_Error, @"还未获取到全员广播大群ID");
        }
        return;
    }
    
    if (_isObtainAESKeyIng)
    {
        if (errorBlock)
        {
            errorBlock(FWCode_Normal_Error, @"请求中。。。");
        }
        return;
    }
    else
    {
        _isObtainAESKeyIng = YES;
        
        [self showMyHud];
    }
    
    TIMGroupManager *groupManager = [TIMGroupManager sharedInstance];
    [self performSelector:@selector(hideMyHud) withObject:nil afterDelay:5];
    
    FWWeakify(self)
    [groupManager getGroupInfo:@[self.fanweApp.appModel.full_group_id] succ:^(NSArray *arr) {
        
        FWStrongify(self)
        self.isObtainAESKeyIng = NO;
        
        TIMGroupInfo *tmpGroupInfo = [arr firstObject];
        NSString *introduction = tmpGroupInfo.introduction;
        
        if (![FWUtils isBlankString:introduction])
        {
            if (![introduction isEqualToString:[GlobalVariables sharedInstance].aesKeyStr])
            {
                [[GlobalVariables sharedInstance] storageAppAESKey:introduction];
                [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshHome object:nil userInfo:nil];
            }
        }
        
        [self hideMyHud];
        
        if (succBlock)
        {
            succBlock();
        }
        
    } fail:^(int code, NSString *msg) {
        
        FWStrongify(self)
        self.isObtainAESKeyIng = NO;
        
        [self hideMyHud];
        
        if (errorBlock)
        {
            errorBlock(FWCode_Normal_Error, @"获取到全员广播大群信息失败");
        }
        
    }];
}

#pragma mark 
- (MBProgressHUD *)proHud
{
    if (!_proHud)
    {
        _proHud = [MBProgressHUD showHUDAddedTo:[AppDelegate sharedAppDelegate].window animated:YES];
        _proHud.mode = MBProgressHUDModeIndeterminate;
    }
    return _proHud;
}

- (void)hideMyHud
{
    if (_proHud)
    {
        [_proHud hideAnimated:YES];
        _proHud = nil;
    }
}

- (void)showMyHud
{
    [self.proHud showAnimated:YES];
}

@end
