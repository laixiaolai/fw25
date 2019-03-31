//
//  IMAPlatform+Login.m
//  TIMChat
//
//  Created by AlexiChen on 16/2/26.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "IMAPlatform+Login.h"

@implementation IMAPlatform (Login)

//互踢下线错误码

#define kEachKickErrorCode 6208
- (void)login:(TIMLoginParam *)param succ:(TIMLoginSucc)succ fail:(TIMFail)fail
{
    if (!param)
    {
        return;
    }
    
    __weak IMAPlatform *ws = self;
    
    [[TIMManager sharedInstance] login:param succ:^{
        
        DebugLog(@"登录成功:%@ tinyid:%llu sig:%@", param.identifier, [[IMSdkInt sharedInstance] getTinyId], param.userSig);
        [IMAPlatform setAutoLogin:YES];
        
        if (succ)
        {
            succ();
        }
    } fail:^(int code, NSString *msg) {
        
        DebugLog(@"TIMLogin Failed: code=%d err=%@", code, msg);
        if (code == kEachKickErrorCode)
        {
            // 互踢重联
            // 重新再登录一次
            [ws offlineKicked:param succ:succ fail:fail];
        }
        else
        {
            if (fail)
            {
                fail(code, msg);
            }
        }
    }];
}

//离线被踢
//用户离线时，在其它终端登录过，再次在本设备登录时，会提示被踢下线，需要重新登录
- (void)offlineKicked:(TIMLoginParam *)param succ:(TIMLoginSucc)succ fail:(TIMFail)fail
{
    //    UIAlertView *alert = [UIAlertView bk_showAlertViewWithTitle:@"下线通知" message:@"您的帐号于另一台手机上登录。" cancelButtonTitle:@"退出" otherButtonTitles:@[@"重新登录"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
    //        if (buttonIndex == 0)
    //        {
    //            // 退出
    //            [self logout:^{
    //                [[AppDelegate sharedAppDelegate] enterLoginUI];
    //            } fail:^(int code, NSString *msg) {
    //                [[AppDelegate sharedAppDelegate] enterLoginUI];
    //            }];
    //        }
    //        else
    //        {
    [self offlineLogin];
    // 重新登录
    [self login:param succ:succ fail:fail];
    //        }
    //    }];
    //    [alert show];
}

- (void)configOnEnterMainUIWith:(TIMLoginParam *)param
{
    // 配置, 获取个人名片
    [self configHost:param];
    
    // TODO：用户可结合自身逻辑，看是否处理退历器直播间消息
    [self asyncExitHistoryAVChatRoom];
}


@end
