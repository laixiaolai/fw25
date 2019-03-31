//
//  WebModels.m
//  TCShow
//
//  Created by AlexiChen on 15/11/12.
//  Copyright © 2015年 AlexiChen. All rights reserved.
//

#import "WebModels.h"

// ==================================================
@implementation TCShowUser : NSObject


- (BOOL)isEqual:(id)object
{
    BOOL isEqual = [super isEqual:object];
    if (!isEqual)
    {
        if ([object isMemberOfClass:[self class]])
        {
            TCShowUser *uo = (TCShowUser *)object;
            
            isEqual = ![NSString isEmpty:uo.uid] && [uo.uid isEqualToString:self.uid];
        }
    }
    
    return isEqual;
}

- (BOOL)isVailed
{
    return ![NSString isEmpty:_uid];
}


- (NSString *)imUserId
{
    return _uid;
}

- (NSString *)imUserName
{
    return ![NSString isEmpty:_username] ? _username : _uid;
}

- (NSString *)imUserIconUrl
{
    return _avatar;
}

@end


// ==================================================
@implementation TCShowLiveListItem

- (NSString *)liveIMChatRoomId
{
    return self.chatRoomId;
}

- (void)setLiveIMChatRoomId:(NSString *)liveIMChatRoomId
{
    self.chatRoomId = liveIMChatRoomId;
}

// 当前主播信息
- (id<IMUserAble>)liveHost
{
    return _host;
}

// 直播房间Id
- (int)liveAVRoomId
{
    return _avRoomId;
}

// 视频类型，对应的枚举：FW_LIVE_TYPE
- (NSInteger)liveType
{
    return _liveType;
}

- (NSString *)vagueImgUrl
{
    return _vagueImgUrl;
}

- (void)setLivePraise:(NSInteger)livePraise
{
    if (livePraise < 0)
    {
        livePraise = 0;
    }
    
    _admireCount = livePraise;
}

- (NSInteger)livePraise
{
    return _admireCount;
}

// 直播标题
- (NSString *)liveTitle
{
    return self.title;
}

- (BOOL)isHost
{
    return _isLiveHost;
}

- (void)setIsHost:(BOOL)isHost
{
    _isLiveHost = isHost;
}

@end

