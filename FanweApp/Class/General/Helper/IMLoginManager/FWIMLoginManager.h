//
//  FWIMLoginManager.h
//  FanweApp
//
//  Created by xfg on 2017/1/11.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "IMALoginParam.h"
#import "FWBaseViewModel.h"
#import "FanweSingleton.h"

@interface FWIMLoginManager : FWBaseViewModel

@property (nonatomic, assign) BOOL              isIMSDKOK;          // IMSDK是否已经登录了
@property (nonatomic, assign) BOOL              isLogingIMSDK;      // 是否正在登陆IMSDK
@property (nonatomic, assign) BOOL              isObtainAESKeyIng;  // 是否正在aeskey，防止多次重复获取
@property (nonatomic, strong) IMALoginParam       *loginParam;        // IM登录参数
@property (nonatomic, strong) MBProgressHUD       *proHud;

// 单例模式
FanweSingletonH(Instance);

/**
 获取UserSig

 @param succ 成功回调
 @param failed 失败回调
 */
- (void)getUserSig:(FWVoidBlock)succ failed:(FWErrorBlock)failed;

/**
 自动登录IMSDK

 @param isShowHud 是否显示hud
 @param succ 成功回调
 @param failed 失败回调
 */
- (void)loginImSDK:(BOOL)isShowHud succ:(FWVoidBlock)succ failed:(FWErrorBlock)failed;

/**
 通过全员广播大群来获取aeskey

 @param succBlock 成功回调
 @param errorBlock 失败回调
 */
- (void)obtainAesKeyFromFullGroup:(FWVoidBlock)succBlock error:(FWErrorBlock)errorBlock;
    
@end
