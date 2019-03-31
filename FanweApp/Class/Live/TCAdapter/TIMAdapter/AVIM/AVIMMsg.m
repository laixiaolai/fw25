//
//  AVIMMsg.m
//  TCShow
//
//  Created by AlexiChen on 16/4/15.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "AVIMMsg.h"

@implementation AVIMMsg

- (instancetype)initWith:(id<IMUserAble>)sender message:(NSString *)text
{
    if (self = [super init])
    {
        _sender = sender;
        _msgText = text;
    
    }
    return self;
}

- (instancetype)initWith:(id<IMUserAble>)sender customElem:(TIMCustomElem *)elem
{
    if (self = [super init])
    {
        _sender = sender;
        
        
        // TODO：子类处理自定义内容
        
    }
    return self;
}

- (void)prepareForRender
{
// TODO:子类将用于显示的内容在此方法中数据缓存起来，不要在主线程中去计算（当IM消息量很大时，在主线程中去计算，主线程会抢占AVSDK采集线程，导致直播效果差）
}

- (NSInteger)msgType
{
    return MSG_TEXT;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"sender = %@ text = %@", [_sender imUserId], _msgText];
}

@end
