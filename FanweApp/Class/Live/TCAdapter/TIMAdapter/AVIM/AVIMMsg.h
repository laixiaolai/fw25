//
//  AVIMMsg.h
//  TCShow
//
//  Created by AlexiChen on 16/4/15.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CustomMessageModel.h"
#import "cuserModel.h"

// 直播过程中，消息列表中显示的聊天消息类型
@interface AVIMMsg : NSObject<AVIMMsgAble>
{
@protected
    id<IMUserAble>  _sender;            // 发送者
    
@protected
    NSString        *_msgText;         // 消息内容
}

@property (nonatomic, readonly) id<IMUserAble> sender;
@property (nonatomic, readonly) NSString *msgText;

- (instancetype)initWith:(id<IMUserAble>)sender message:(NSString *)text;
- (instancetype)initWith:(id<IMUserAble>)sender customElem:(TIMCustomElem *)elem;

@end
