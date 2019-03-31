//
//  AppAble.h
//  FanweLive
//
//  Created by xfg on 16/11/21.
//  Copyright © 2016年 xfg. All rights reserved.
//

@protocol IMUserAble <NSObject>

@required

// 两个用户是否相同，可通过比较imUserId来判断
// 用户IMSDK的identigier
- (NSString *)imUserId;

// 用户昵称
- (NSString *)imUserName;

// 用户头像地址
- (NSString *)imUserIconUrl;

@end


#pragma mark --------------------------------------

// 直播中用户的配置
// 直播中要用到的
// 简单的个人
@protocol AVUserAble <IMUserAble>

@required
@property (nonatomic, assign) NSInteger avCtrlState;

@end


#pragma mark --------------------------------------

@protocol AVMultiUserAble <AVUserAble>

@required

@property (nonatomic, assign) NSInteger avMultiUserState;       //多人互动时IM配置

// 互动时，用户画面显示的屏幕上的区域（opengl相关的位置）
@property (nonatomic, assign) CGRect avInteractArea;

// 互动时，因opengl放在最底层，之上是的自定义交互层，通常会完全盖住opengl
// 用户要想与小画面进行交互的时候，必须在交互层上放一层透明的大小相同的控件，能过操作此控件来操作小窗口画面
// 全屏交互的用户该值为空
// 业务中若不存在交互逻辑，则不用填
@property (nonatomic, weak) UIView *avInvisibleInteractView;

@end


#pragma mark --------------------------------------

// 当前登录IMSDK的用户信息
@protocol IMHostAble <AVMultiUserAble>

@required

// 当前App对应的AppID
- (NSString *)imSDKAppId;

// 当前App的AccountType
- (NSString *)imSDKAccountType;

@end


#pragma mark --------------------------------------

@protocol AVRoomAble <NSObject>

@required

// 聊天室Id
@property (nonatomic, copy) NSString *liveIMChatRoomId;

// 当前主播信息
- (id<IMUserAble>)liveHost;

// 直播房间Id
- (int)liveAVRoomId;

// 直播标题，可用于创建直播IM聊天室（具体还需要看使用哪种方式创建）
// 另外推流以及录制时，使用默认配置时，是需要liveTitle参数
- (NSString *)liveTitle;

@end


#pragma mark --------------------------------------

// 直播中用到的IM消息类型
// 直播过程中只能显示简单的文本消息
// 关于消息的显示尽量做简单，以减少直播过程中IM消息量过大时直播视频不流畅
@protocol AVIMMsgAble <NSObject>

@required
// 在渲染前，先计算渲染的内容(比如消息列表)
- (void)prepareForRender;

- (NSInteger)msgType;

@end


#pragma mark --------------------------------------

@protocol FWShowLiveRoomAble <AVRoomAble>

@required

// 模糊遮盖图片的URL
@property (nonatomic, copy) NSString            *vagueImgUrl;
// 视频类型，对应枚举FW_LIVE_TYPE
@property (nonatomic, assign) NSInteger         liveType;
// SDK类型
@property (nonatomic, assign) NSInteger         sdkType;
// 连麦类型
@property (nonatomic, assign) NSInteger         mickType;
// 点赞数
@property (nonatomic, assign) NSInteger         livePraise;
// 是否主播
@property (nonatomic, assign) BOOL              isHost;

@end


#pragma mark --------------------------------------

@protocol FWLiveControllerAble <NSObject>

@required

// 获取当前视频容器视图的父视图
- (UIView *)getPlayViewBottomView;
// 获取当前直播质量
- (NSString *)getLiveQuality;
// 设置静音 YES：设置为静音
- (void)setSDKMute:(BOOL)bEnable;
// 开始推流、拉流
- (void)startLiveRtmp:(NSString *)playUrlStr;
// 结束推流、拉流
- (void)stopLiveRtmp;

@end



