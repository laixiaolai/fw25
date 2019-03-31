//
//  WebModels.h
//  TCShow
//
//  Created by AlexiChen on 15/11/12.
//  Copyright © 2015年 AlexiChen. All rights reserved.
//

#import <Foundation/Foundation.h>

//==================================================
// 用户基本信息
@interface TCShowUser : NSObject<AVMultiUserAble>

@property (nonatomic, copy) NSString        *avatar;
@property (nonatomic, copy) NSString        *username;
@property (nonatomic, copy) NSString        *uid;

@property (nonatomic, assign) NSInteger     avCtrlState;

@property (nonatomic, assign) NSInteger     avMultiUserState;       // 多人互动时IM配置

// 互动时，用户画面显示的屏幕上的区域（opengl相关的位置）
@property (nonatomic, assign) CGRect        avInteractArea;

// 互动时，因opengl放在最底层，之上是的自定义交互层，通常会完全盖住opengl
// 用户要想与小画面进行交互的时候，必须在交互层上放一层透明的大小相同的控件，能过操作此控件来操作小窗口画面
@property (nonatomic, weak) UIView          *avInvisibleInteractView;

- (BOOL)isVailed;

@end


// ==================================================

@interface TCShowLiveListItem : NSObject<FWShowLiveRoomAble>

@property (nonatomic, strong) TCShowUser        *host;

// 直播聊天室
@property (nonatomic, copy) NSString            *chatRoomId;
// 直播房间号
@property (nonatomic, assign) int               avRoomId;
// 模糊遮盖图片的URL
@property (nonatomic, copy) NSString            *vagueImgUrl;
// 视频类型，对应枚举FW_LIVE_TYPE
@property (nonatomic, assign) NSInteger         liveType;
// SDK类型
@property (nonatomic, assign) NSInteger         sdkType;
// 连麦类型
@property (nonatomic, assign) NSInteger         mickType;
// 点赞统计
@property (nonatomic, assign) NSInteger         admireCount;
// 直播标题
@property (nonatomic, copy) NSString            *title;
// 是否主播
@property (nonatomic, assign) BOOL              isLiveHost;

@end
