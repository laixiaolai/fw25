//
//  FanweMessage.h
//  FanweApp
//
//  Created by xfg on 16/2/15.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "MMAlertView.h"

/**
 弹出框类型

 - FanweMessageTypeAlertOneBtn: 一个按钮的弹框
 - FanweMessageTypeAlertTwoBtn: 两个按钮的弹框
 - FanweMessageTypeInputAlertTwoBtn: 两个按钮的带输入框的弹框
 - FanweMessageTypeSheet: Sheet类型弹框
 - FanweMessageTypeHud: HUD类型弹框（无按钮）
 - FanweMessageTypeTWMessageBar: TWMessageBar类型弹框（无按钮）
 - FanweMessageTypeCustom: 自定义弹框
 */
typedef NS_ENUM(NSUInteger, FanweMessageType)
{
    FanweMessageTypeAlertOneBtn,
    FanweMessageTypeAlertTwoBtn,
    FanweMessageTypeInputAlertTwoBtn,
    FanweMessageTypeSheet,
    FanweMessageTypeHud,
    FanweMessageTypeTWMessageBar,
    FanweMessageTypeCustom,
};

@interface FanweMessage : NSObject

#pragma mark - ----------------------- 一个按钮的弹框 -----------------------

/**
 消息提示框：“知道了”

 @param message 提示框显示内容，默认标题“温馨提示”
 @return MMAlertView
 */
+ (MMAlertView *)alert:(NSString *)message;

/**
 消息提示框：“知道了”
 
 @param title 标题，当title长度为0或者title为nil时不显示默认标题“温馨提示”
 @param message 提示框显示内容
 @param isHideTitle 是否隐藏默认标题
 @param destructiveAction 点击“知道了”回调
 @return MMAlertView
 */
+ (MMAlertView *)alert:(NSString *)title message:(NSString *)message isHideTitle:(BOOL)isHideTitle destructiveAction:(FWVoidBlock)destructiveAction;

/**
 消息提示框：“知道了”
 
 @param title 标题，当title长度为0或者title为nil时不显示默认标题“温馨提示”
 @param message 提示框显示内容
 @param isHideTitle 是否隐藏默认标题
 @param destructiveTitle “知道了”按钮重命名
 @param destructiveAction 点击“知道了”回调
 @return MMAlertView
 */
+ (MMAlertView *)alert:(NSString *)title message:(NSString *)message isHideTitle:(BOOL)isHideTitle destructiveTitle:(NSString *)destructiveTitle destructiveAction:(FWVoidBlock)destructiveAction;


#pragma mark - ----------------------- 两个按钮的弹框 -----------------------

/**
 消息提示框：“确定”、“取消”
 
 @param title 标题，当title长度为0或者title为nil时不显示默认标题“温馨提示”
 @param message 提示框显示内容
 @param destructiveAction 确定回调
 @param cancelAction 取消回调
 @return MMAlertView
 */
+ (MMAlertView *)alert:(NSString *)title message:(NSString *)message destructiveAction:(FWVoidBlock)destructiveAction cancelAction:(FWVoidBlock)cancelAction;

/**
 消息提示框：“确定”、“取消”

 @param title 标题，当title长度为0或者title为nil时不显示默认标题“温馨提示”
 @param message 提示框显示内容
 @param destructiveTitle “确定”按钮名称
 @param destructiveAction 确定回调
 @param cancelTitle “取消”按钮名称
 @param cancelAction 取消回调
 @return MMAlertView
 */
+ (MMAlertView *)alert:(NSString *)title message:(NSString *)message destructiveTitle:(NSString *)destructiveTitle destructiveAction:(FWVoidBlock)destructiveAction cancelTitle:(NSString *)cancelTitle cancelAction:(FWVoidBlock)cancelAction;

/**
 消息提示框：“确定”、“取消”（UIAlertController），暂不推荐使用
 
 @param message 提示框显示内容
 @param viewController 在viewController中显示，如果viewController传nil则默认用当前window的rootViewController
 @return UIAlertController
 */
+ (UIAlertController *)alertController:(NSString *)message viewController:(UIViewController *)viewController;

/**
 消息提示框：“确定”、“取消”（UIAlertController），暂不推荐使用
 
 @param message 提示框显示内容
 @param viewController 在viewController中显示，如果viewController传nil则默认用当前window的rootViewController
 @param destructiveAction 确定，传nil则不添加确定按钮
 @param cancelAction 取消，传nil则不添加取消按钮
 @return UIAlertController
 */
+ (UIAlertController *)alertController:(NSString *)message viewController:(UIViewController *)viewController destructiveAction:(FWVoidBlock)destructiveAction cancelAction:(FWVoidBlock)cancelAction;


#pragma mark - ----------------------- 两个按钮的带输入框的弹框 -----------------------

/**
 消息提示框：带输入框，“确定”、“取消”

 @param title 标题，当title长度为0或者title为nil时不显示默认标题“温馨提示”
 @param message 提示框显示内容
 @param placeholder 输入框的默认显示
 @param keyboardType 键盘类型
 @param destructiveTitle “确定”按钮名称
 @param destructiveAction 确定回调
 @param cancelTitle “取消”按钮名称
 @param cancelAction 取消回调
 @return MMAlertView
 */
+ (MMAlertView *)alertInput:(NSString *)title message:(NSString *)message placeholder:(NSString *)placeholder keyboardType:(UIKeyboardType)keyboardType destructiveTitle:(NSString *)destructiveTitle destructiveAction:(MMPopupInputHandler)destructiveAction cancelTitle:(NSString *)cancelTitle cancelAction:(FWVoidBlock)cancelAction;


#pragma mark - ----------------------- HUD类型弹框（无按钮） -----------------------

/**
 消息提示框：HUD

 @param message 提示框显示内容
 */
+ (void)alertHUD:(NSString *)message;

/**
 消息提示框：HUD
 
 @param message 提示框显示内容
 @param seconds 显示时长
 */
+ (void)alertHUD:(NSString *)message delay:(CGFloat)seconds;


#pragma mark - ----------------------- TWMessageBar类型弹框（无按钮） -----------------------

/**
 消息提示框：TWMessageBarManager

 @param message 提示框显示内容
 */
+ (void)alertTWMessage:(NSString *)message;

@end
