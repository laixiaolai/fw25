//
//  SendCustomMsgModel.h
//  FanweLive
//
//  Created by xfg on 16/11/24.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SendCustomMsgModel : NSObject

@property (nonatomic, assign) int               msgType;        // 消息类型(必填)
@property (nonatomic, copy) NSString            *msg;           // 消息
@property (nonatomic, copy) NSString            *chatGroupID;   // 如果是群消息必须带上群ID(群消息时必填)
@property (nonatomic, strong) id<IMUserAble>    msgReceiver;    // 消息接收者（C2C消息时必填）
@property (nonatomic, assign) BOOL              isShowLight;    // 是否显示点亮消息（点亮消息时必填）

// 连麦
@property (nonatomic, copy) NSString            *push_rtmp2;    // 小主播的 push_rtmp 推流地址
@property (nonatomic, copy) NSString            *play_rtmp_acc; // 大主播的 rtmp_acc 播放地址

@end
