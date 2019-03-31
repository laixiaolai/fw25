//
//  TIMAdapter.h
//  TIMAdapter
//
//  Created by AlexiChen on 16/1/29.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <QALSDK/QalSDKProxy.h>

#import <ImSDK/ImSDK.h>

#import <TLSSDK/TLSHelper.h>

#define kSupportCustomConversation 1

typedef NS_ENUM(NSInteger, IMAConType)
{
    IMA_Unknow,                     // 未知
    IMA_C2C = TIM_C2C,              // C2C类型
    IMA_Group = TIM_GROUP,          // 群聊类型
    IMA_System = TIM_SYSTEM,        // 系统消息
    // 定制会话类型
    IMA_Connect,                    // 网络联接
    
    //    kSupportCustomConversation 为 1时有效
    IMA_Sys_NewFriend,              // 新朋友系统消息
    IMA_Sys_GroupTip,               // 群系统消息通知
    
};


#define kGetConverSationList        0
#define kSupportCustomConversation  1

//==============================
// 聊天图片缩约图最大高度
#define kChatPicThumbMaxHeight      190.f
// 聊天图片缩约图最大宽度
#define kChatPicThumbMaxWidth       66.f

//==============================
#define kSaftyWordsCode 80001
// IMAMsg扩展参数的键
#define kIMAMSG_Image_ThumbWidth    @"kIMA_ThumbWidth"
#define kIMAMSG_Image_ThumbHeight   @"kIMA_ThumbHeight"
#define kIMAMSG_Image_OrignalPath   @"kIMA_OrignalPath"
#define kIMAMSG_Image_ThumbPath     @"kIMA_ThumbPath"

//==============================

#define IMALocalizedError(intCode, enStr) NSLocalizedString(([NSString stringWithFormat:@"%d", (int)intCode]), enStr)


// 演求个人资料里面的如何增加扩展字段
#if kIsTCShowSupportIMCustom
#define kIMCustomFlag               @"Tag_Profile_Custom_1400009129_Param"
#endif

// IMA中用到的消息相关通知
#define kIMAMSG_RevokeNotification @"kIMAMSG_RevokeNotification"
#define kIMAMSG_DeleteNotification @"kIMAMSG_DeleteNotification"
#define kIMAMSG_ResendNotification @"kIMAMSG_ResendNotification"
#define kIMAMSG_ChangedNotification @"kIMAMSG_ChangedNotification"

#define kSaftyWordsCode 80001

#import "IMAShow.h"

#import "IMAModel.h"

#import "IMAPlatformHeaders.h"

