//
//  AVIMAble.h
//  TCShow
//
//  Created by AlexiChen on 16/4/11.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import <Foundation/Foundation.h>



// 前缀解释:
// IM: IMSDK相关
// AV: AVSDK相关
// TC: Tencent Clound

typedef void (^TCAVCompletion)(BOOL succ, NSString *tip);


typedef NS_ENUM(NSInteger, AVCtrlState)
{
    // 常用事件
    EAVCtrlState_Speaker = 0x01,                // 是否开启了扬声器
    EAVCtrlState_Mic = 0x01 << 1,               // 是否开启了麦克风
    EAVCtrlState_Camera = 0x01 << 2,            // 是否打开了相机
    EAVCtrlState_Beauty = 0x01 << 3,            // 是否打开了美颜：注意打开相机之后才可以设置美颜
    
    // 是否打开推流，因推流非常占用云后台资源，需要向后台申请资源，如果推流中出现问题，请到( https://www.qcloud.com/doc/product/268/旁路直播开发 )了解详细内容
    // 不建议进入时默认打开，会影响进房速度
    // 只有主播可以设置
    // 如果有推流，退出直播时，一定要将推流先关掉，再执行退房流程
    // 目前建议使用HLS,RTMP
    // 以下四个是互斥的一次只能传一个
    // 导致推流不成功的原因：推流的时候异常退出，业务后台去要强行关闭推流，如果不，则下次再使用相同的channelInfo.channelName进行推流，则会不成功，提示正在推流
    EAVCtrlState_HLSStream = 0x01 << 4,         // HLS
    EAVCtrlState_RTMPStream = 0x01 << 5,        // RTMP
    EAVCtrlState_RAWStream = 0x01 << 6,         // RAW
    EAVCtrlState_HLS_RTMP = EAVCtrlState_HLSStream | EAVCtrlState_RTMPStream,
    
    
    // 添加录制
    // https://www.qcloud.com/doc/product/268/%E5%BD%95%E5%88%B6%E5%8A%9F%E8%83%BD%E5%BC%80%E5%8F%91
    EAVCtrlState_Record = 0x01 << 7,            // 录制功能
    
    // AVSDK在 1.8.1.300才支持美白功能
    EAVCtrlState_White = 0x01 << 8,             // 是否开启美白
    
    EAVCtrlState_HDAudio = 0x01 << 9,             // 是否使用高品质音频
    EAVCtrlState_AutoRotateVideo = 0x01 << 10,    // 是否自动矫正视频
    
    // 主播进入房间时的推荐配置
    
    EAVCtrlState_All = EAVCtrlState_Mic | EAVCtrlState_Speaker | EAVCtrlState_Camera,
};

typedef NS_ENUM(NSInteger, AVIMCommand)
{
    MSG_NONE                    =   -1,     // 无操作
    MSG_TEXT                    =   0,      // 正常文字聊天消息
    MSG_SEND_GIFT_SUCCESS       =   1,      // 收到发送礼物成功消息
    MSG_POP_MSG                 =   2,      // 收到弹幕消息
    MSG_CREATER_EXIT_ROOM       =   3,      // 主播退出直播间
    MSG_FORBID_SEND_MSG         =   4,      // 禁言消息
    MSG_VIEWER_JOIN             =   5,      // 观众进入直播间消息
    MSG_VIEWER_QUIT             =   6,      // 观众退出直播间消息
    MSG_END_VIDEO               =   7,      // 直播结束消息
    MSG_RED_PACKET              =   8,      // 红包
    MSG_LIVING_MESSAGE          =   9,      // 直播消息
    MSG_ANCHOR_LEAVE            =   10,     // 主播离开
    MSG_ANCHOR_BACK             =   11,     // 主播回来
    MSG_LIGHT                   =   12,     // 点亮
    MSG_APPLY_MIKE              =   13,     // 观众申请连麦（主播收到观众连麦请求消息）
    MSG_RECEIVE_MIKE            =   14,     // 主播接受连麦（观众收到主播接受连麦消息）
    MSG_REFUSE_MIKE             =   15,     // 主播拒绝连麦（观众收到主播拒绝连麦消息）
    MSG_BREAK_MIKE              =   16,     // 断开连麦（观众收到主播断开连麦消息）
    MSG_SYSTEM_CLOSE_LIVE       =   17,     // 违规直播，立即关闭直播；私密直播被主播踢出直播间
    MSG_LIVE_STOP               =   18,     // 某个直播结束
    
    MSG_PRIVATE_TEXT            =   20,     // 私聊文字消息
    MSG_PRIVATE_VOICE           =   21,     // 私聊语音消息
    MSG_PRIVATE_IMAGE           =   22,     // 私聊图片消息
    MSG_PRIVATE_GIFT            =   23,     // 礼物消息
    
    MSG_PAI_SUCCESS             =   25,     // 拍卖成功
    MSG_PAI_PAY_TIP             =   26,     // 推送支付提醒
    MSG_PAI_FAULT               =   27,     // 流拍
    MSG_ADD_PRICE               =   28,     // 加价推送
    MSG_PAY_SUCCESS             =   29,     // 支付成功
    MSG_RELEASE_SUCCESS         =   30,     // 主播发起竞拍成功
    MSG_STARGOODS_SUCCESS       =   31,     // 主播发起商品推送成功
    
    MSG_PAYMONEY_SUCCESS        =   32,     // 主播发起付费直播成功(按时间)

    MSG_GOLDENGAME_COUNT        =   33,     // 炸金花统计下注,随机牌型,计算结果,更新game_log
    MSG_GAME_OVER               =   34,     // 结束游戏推送
    MSG_GOLDENGAME_START        =   35,     // 选择开始游戏
    MSG_GOLDENGAME_BET          =   36,     // 炸金花下注
    
    MSG_BUYGOODS_SUCCESS        =   37,     // 观众购买商品成功
    
    MSG_GAME_INCOME             =   38,     // 游戏收益推送
    MSG_GAME_ALL                =   39,     // 游戏总的推送
    MSG_PAYMONEYSEASON_SUCCESS  =   40,     // 主播发起付费直播成功(按场次)
    MSG_BACKGROUND_MONITORING   =   41,     // 后台监控
    
    MSG_REFRESH_AUDIENCE_LIST   =   42,     // 刷新观众列表

    MSG_GAME_BANKER             =   43,     // 游戏上庄相关推送
    
    MSG_BIG_GIFT_NOTICE_ALL     =   50,     // 直播间飞屏模式(送大型礼物-全服飞屏通告)
};



