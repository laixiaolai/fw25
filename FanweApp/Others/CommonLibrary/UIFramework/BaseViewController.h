//
//  BaseViewController.h
//  CommonLibrary
//
//  Created by Alexi on 14-1-15.
//  Copyright (c) 2014年 CommonLibrary. All rights reserved.
//

#import "CommonBaseViewController.h"
#import "GlobalVariables.h"
#import "NetHttpsManager.h"

@class FBKVOController;

@interface BaseViewController : CommonBaseViewController<UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>{
    
    GlobalVariables     *_fanweApp;
    NetHttpsManager     *_httpsManager;
    
}

@property (nonatomic, strong) GlobalVariables   *fanweApp;          // 存储app相关参数的单例
@property (nonatomic, strong) NetHttpsManager   *httpsManager;      // 网络请求封装

- (void)callImagePickerActionSheet;

// 对于界面上有输入框的，可以选择性调用些方法进行收起键盘
- (void)addTapBlankToHideKeyboardGesture;

@end

