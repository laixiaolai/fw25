//
//  FWIMMsgHandler.m
//  FanweLive
//
//  Created by xfg on 16/11/24.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "FWIMMsgHandler.h"

@implementation FWIMMsgHandler

- (void)dealloc
{
    _sharedRunLoopRef = nil;
}

FanweSingletonM(Instance);

- (id)init
{
    @synchronized (self)
    {
        self = [super init];
        if (self)
        {
            _fanweApp = [GlobalVariables sharedInstance];
            _newMsgMArray = [NSMutableArray array];
            // 为了不影响视频，runloop线程优先级较低，可根据自身需要去调整
            _sharedRunLoopRef = [AVIMRunLoop sharedAVIMRunLoop];
            
            _msgCacheLock = OS_SPINLOCK_INIT;
            
            TIMManager *manager = [TIMManager sharedInstance];
            //[manager setMessageListener:self];
            [manager addMessageListener:self];
        }
        return self;
    }
}

#pragma mark - ----------------------- 接收并处理消息 -----------------------
#pragma mark 从缓存中取出maxDo条数据处理
- (void)onHandleMyNewMessage:(NSInteger)maxDo
{
    NSInteger myIndex = 0;
    
    while ([_newMsgMArray count]>0)
    {
        TIMMessage *msg = [_newMsgMArray firstObject];
        [_newMsgMArray removeObject:msg];
        
        [self onRecvMsg:msg msgType:TIM_GROUP];
        myIndex ++;
        if (myIndex == maxDo)
        {
            return;
        }
    }
}

#pragma mark 循环消息处
- (void)onNewMessage:(NSArray *)msgs
{
    [self performSelector:@selector(onHandleNewMessage:) onThread:_sharedRunLoopRef.thread withObject:msgs waitUntilDone:NO];
}

#pragma mark 循环消息处理时收到消息后判断消息类型
- (void)onHandleNewMessage:(NSArray *)msgs
{
    for(TIMMessage *msg in msgs)
    {
        [SIMMsgObj maybeIMChatMsg:msg];
        
        TIMConversationType conType = msg.getConversation.getType;
        
        switch (conType)
        {
            case TIM_C2C:       // 一对一消息
            {
                [self onRecvMsg:msg msgType:TIM_C2C];
            }
                break;
                
            case TIM_GROUP:     // 群消息
            {
                if (_liveItem)  // 直播间内的群消息
                {
                    if([[msg.getConversation getReceiver] isEqualToString:[_liveItem liveIMChatRoomId]])
                    {
                        // 处理群聊天消息
                        [_newMsgMArray addObject:msg];
                    }
                }
                else    // 预留其它群消息
                {
                    [self onRecvMsg:msg msgType:TIM_GROUP];
                }
            }
                break;
                
            case TIM_SYSTEM:    // 系统消息
            {
                [self onRecvMsg:msg msgType:TIM_SYSTEM];
            }
                break;
                
            default:
                break;
        }
    }
}

#pragma mark 解析IM消息
- (void)onRecvMsg:(TIMMessage *)msg msgType:(TIMConversationType)msgType
{
    TIMTextElem *textElem;
    TIMCustomElem *customElem;
    TIMGroupSystemElem *groupSystemElem;
    
    if (msg)
    {
        id<IMUserAble> profile = [msg getSenderProfile];
        if (!profile)
        {
            if (msgType == TIM_C2C)
            {
                NSString *recv = [[msg getConversation] getReceiver];
                profile = [self syncGetC2CUserInfo:recv];
            }
            else if (msgType == TIM_GROUP)
            {
                profile = [msg getSenderGroupMemberProfile];
            }
        }
        
        for(int index = 0; index < [msg elemCount]; index++)
        {
            TIMElem *elem = [msg getElem:index];
            if([elem isKindOfClass:[TIMTextElem class]])
            {
                textElem = (TIMTextElem *)elem;
            }
            else if([elem isKindOfClass:[TIMCustomElem class]])
            {
                customElem = (TIMCustomElem *)elem;
            }
            else if([elem isKindOfClass:[TIMGroupSystemElem class]])
            {
                groupSystemElem = (TIMGroupSystemElem *)elem;
            }
        }
        
        // 脏字库过滤
        if (msgType == TIM_C2C && customElem)               // 一对一消息
        {
            if (textElem)
            {
                [self onRecvC2CSender:profile customMsg:customElem textMsg:textElem.text];
            }
            else
            {
                [self onRecvC2CSender:profile customMsg:customElem textMsg:@""];
            }
        }
        else if (msgType == TIM_GROUP && customElem)        // 群自定义消息
        {
            if (textElem)
            {
                [self onRecvGroupSender:profile groupId:[msg.getConversation getReceiver] customMsg:customElem textMsg:textElem.text];
            }
            else
            {
                [self onRecvGroupSender:profile groupId:[msg.getConversation getReceiver] customMsg:customElem textMsg:@""];
            }
        }
        else if (msgType == TIM_SYSTEM && groupSystemElem)  // 群系统消息
        {
            NSString *sysGroupID = [groupSystemElem group];
            if (![FWUtils isBlankString:sysGroupID])
            {
                if (textElem)
                {
                    [self onRecvSystepGroupSender:profile groupId:sysGroupID customMsg:groupSystemElem textMsg:textElem.text];
                }
                else
                {
                    [self onRecvSystepGroupSender:profile groupId:sysGroupID customMsg:groupSystemElem textMsg:@""];
                }
            }
        }
    }
}

#pragma mark - ----------------------- 发送自定义消息 -----------------------
#pragma mark 组装TIMCustomElem
- (TIMCustomElem *)getCustomElemWith:(CustomMessageModel *)customMessageModel
{
    SenderModel *sender = [[SenderModel alloc]init];
    sender.user_id = [IMAPlatform sharedInstance].host.imUserId;
    sender.nick_name = [IMAPlatform sharedInstance].host.imUserName;
    sender.head_image = [IMAPlatform sharedInstance].host.imUserIconUrl;
    sender.user_level = (int)[[IMAPlatform sharedInstance].host getUserRank];
    sender.sort_num = [IMAPlatform sharedInstance].host.sort_num;
    sender.v_icon = [[IMAPlatform sharedInstance].host.customInfoDict toString:@"v_icon"];
    sender.v_type = [[IMAPlatform sharedInstance].host.customInfoDict toInt:@"v_type"];
    customMessageModel.sender = sender;
    
    NSMutableDictionary *stuDict = customMessageModel.mj_keyValues;
    if ([stuDict objectForKey:@"avimMsgShowSize"])
    {
        [stuDict removeObjectForKey:@"avimMsgShowSize"];
    }
    
    [stuDict removeObjectsForKeys:@[@"debugDescription", @"description", @"hash", @"superclass"]];
    if ([stuDict objectForKey:@"sender"])
    {
        [[stuDict objectForKey:@"sender"] removeObjectsForKeys:@[@"debugDescription", @"description", @"hash", @"superclass"]];
    }
    
    NSString *sendMessage = [FWUtils dataTOjsonString:stuDict];
    
    TIMCustomElem* messageElem = [[TIMCustomElem alloc] init];
    messageElem.data = [sendMessage dataUsingEncoding:NSUTF8StringEncoding];
    
    return messageElem;
}

#pragma mark 发送自定义一对一消息
- (void)sendCustomC2CMsg:(SendCustomMsgModel *)sCMM succ:(TIMSucc)succ fail:(TIMFail)fail
{
    if (sCMM.msgReceiver)
    {
        CustomMessageModel *customMessageModel = [[CustomMessageModel alloc] init];
        customMessageModel.type = sCMM.msgType;
        if (sCMM.msgType == MSG_RECEIVE_MIKE)
        {
            customMessageModel.push_rtmp2 = sCMM.push_rtmp2;
            customMessageModel.play_rtmp_acc = sCMM.play_rtmp_acc;
        }
        else if (sCMM.msgType == MSG_REFUSE_MIKE)
        {
            customMessageModel.msg = sCMM.msg;
        }
        
        TIMCustomElem* messageElem = [self getCustomElemWith:customMessageModel];
        
        TIMMessage* timMsg = [[TIMMessage alloc] init];
        [timMsg addElem:messageElem];
        if (sCMM.msgType == MSG_TEXT && _fanweApp.appModel.has_dirty_words == 1)
        {
            TIMTextElem *textElem = [[TIMTextElem alloc]init];
            textElem.text = sCMM.msg;
            [timMsg addElem:textElem];
        }
        
        TIMConversation *conv = [[TIMManager sharedInstance] getConversation:TIM_C2C receiver:[sCMM.msgReceiver imUserId]];
        
        [conv sendMessage:timMsg succ:succ fail:^(int code, NSString *msg)
         {
             DebugLog(@"发送消息失败：%@", timMsg);
             if (fail)
             {
                 fail(code, msg);
             }
         }];
    }
}

#pragma mark 发送自定义群消息
- (void)sendCustomGroupMsg:(SendCustomMsgModel *)sCMM succ:(TIMSucc)succ fail:(TIMFail)fail
{
    if (_chatRoomConversation)
    {
        CustomMessageModel *customMessageModel = [[CustomMessageModel alloc] init];
        customMessageModel.type = sCMM.msgType;
        customMessageModel.chatGroupID = sCMM.chatGroupID;
        
        if (sCMM.msgType == MSG_LIVING_MESSAGE)
        {   //直播消息
            customMessageModel.desc = sCMM.msg;
        }
        else if(sCMM.msgType == MSG_LIGHT)
        {   //点亮
            customMessageModel.imageName = sCMM.msg;
            if (sCMM.isShowLight)
            {
                customMessageModel.showMsg = 1;
            }
            else
            {
                customMessageModel.showMsg = 0;
            }
        }
        else
        {
            customMessageModel.text = sCMM.msg;
        }
        
        TIMCustomElem* messageElem = [self getCustomElemWith:customMessageModel];
        
        TIMMessage* timMsg = [[TIMMessage alloc] init];
        [timMsg addElem:messageElem];
        if (sCMM.msgType == MSG_TEXT && _fanweApp.appModel.has_dirty_words == 1)
        {
            TIMTextElem *textElem = [[TIMTextElem alloc]init];
            textElem.text = sCMM.msg;
            [timMsg addElem:textElem];
        }
        
        [_chatRoomConversation sendMessage:timMsg succ:^{
            
            // 防止频繁切换房间时把消息发送给了下一个直播间
            if ([customMessageModel.chatGroupID isEqualToString:[_liveItem liveIMChatRoomId]])
            {
                // 需要在直播间聊天列表中显示的消息就加进来
                [self onRecvGroupSender:[IMAPlatform sharedInstance].host groupId:sCMM.chatGroupID customMsg:messageElem textMsg:@""];
            }
            if (succ)
            {
                succ();
            }
        } fail:^(int code, NSString *msg) {
            
            if (code == 80001)
            {
                [FanweMessage alertTWMessage:@"该词被禁用"];
            }else if (code == 10017 || code == 20012)
            {
                [FanweMessage alertTWMessage:@"您已被禁言"];
            }
            DebugLog(@"发送消息失败：%@", timMsg);
            if (fail)
            {
                fail(code, msg);
            }
        }];
    }
    else
    {
        if (fail)
        {
            fail(-1, @"TIMConversation 为空");
        }
    }
}

#pragma mark - ----------------------- 设置是否支持缓存模式 -----------------------
- (void)setIsCacheMode:(BOOL)isCacheMode
{
    _isCacheMode = isCacheMode;
    if (_isCacheMode)
    {
        [self createMsgCache];
    }
    else
    {
        [self releaseMsgCache];
    }
}

@end


#pragma mark - ======================= 供子类重写 =======================
@implementation FWIMMsgHandler (ProtectedMethod)

- (id<IMUserAble>)syncGetC2CUserInfo:(NSString *)identifier
{
    if (_liveItem)
    {
        if ([[[_liveItem liveHost] imUserId] isEqualToString:identifier])
        {
            // 主播发过来的消息
            return [_liveItem liveHost];
        }
        else
        {
            TIMUserProfile *profile = [[TIMUserProfile alloc] init];
            profile.identifier = identifier;
            return profile;
        }
    }
    else
    {
        TIMUserProfile *profile = [[TIMUserProfile alloc] init];
        profile.identifier = identifier;
        return profile;
    }
}

#pragma mark - ----------------------- 解析消息后处理对应的代理事件 -----------------------
#pragma mark 收到C2C自定义消息
- (void)onRecvC2CSender:(id<IMUserAble>)sender customMsg:(TIMCustomElem *)msg textMsg:(NSString *)textMsg
{
    id<AVIMMsgAble> c2cMsg = [self getCustomMsgModel:sender groupId:@"" customMsg:msg textMsg:textMsg];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (c2cMsg && _liveItem)
        {
            [_iMMsgListener onIMHandler:self recvCustomC2C:c2cMsg];
        }
    });
}

#pragma mark 收到群自定义消息处理
- (void)onRecvGroupSender:(id<IMUserAble>)sender groupId:(NSString *)groupId customMsg:(TIMCustomElem *)msg textMsg:(NSString *)textMsg
{
    id<AVIMMsgAble> cachedMsg = [self getCustomMsgModel:sender groupId:groupId customMsg:msg textMsg:textMsg];
    if (cachedMsg && _liveItem)
    {
        if ([cachedMsg msgType] == MSG_TEXT || [cachedMsg msgType] == MSG_VIEWER_JOIN || [cachedMsg msgType] == MSG_SEND_GIFT_SUCCESS)
        {
            [self enCache:cachedMsg noCache:^{}];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_iMMsgListener onIMHandler:self recvCustomGroup:cachedMsg];
        });
    }
}

#pragma mark 收到群系统消息
- (void)onRecvSystepGroupSender:(id<IMUserAble>)sender groupId:(NSString *)groupId customMsg:(TIMGroupSystemElem *)msg textMsg:(NSString *)textMsg
{
    id<AVIMMsgAble> systepGroup = [self getSystemGroupMsgModel:sender groupId:groupId customMsg:msg textMsg:textMsg];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (systepGroup && _liveItem && [[msg group] isEqualToString:[_liveItem liveIMChatRoomId]])
        {
            [_iMMsgListener onIMHandler:self recvCustomGroup:systepGroup];
        }
    });
}

#pragma mark - ----------------------- 解析消息 -----------------------
#pragma mark 解析自定义消息
- (id<AVIMMsgAble>)getCustomMsgModel:(id<IMUserAble>)sender groupId:(NSString *)groupId customMsg:(TIMCustomElem *)msg textMsg:(NSString *)textMsg
{
    return [self getMsgModel:sender groupId:groupId customMsg:msg.data textMsg:textMsg];
}

#pragma mark 解析群系统消息
- (id<AVIMMsgAble>)getSystemGroupMsgModel:(id<IMUserAble>)sender groupId:(NSString *)groupId customMsg:(TIMGroupSystemElem *)msg textMsg:(NSString *)textMsg
{
    
#ifdef DEBUG
    //    NSString *jsonStr = [[NSString alloc]initWithData:msg.userData encoding:NSUTF8StringEncoding];
    //    NetHttpsManager *http = [NetHttpsManager manager];
    //    NSMutableDictionary *dic = [NSMutableDictionary new];
    //    [dic setObject:jsonStr forKey:@"test_system_im"];
    //    [dic setObject:@"pushTest" forKey:@"act"];
    //    [dic setObject:@"games" forKey:@"ctl"];
    //    [http POSTWithParameters:dic SuccessBlock:^(NSDictionary *responseJson) {
    //        NSLog(@"%@",[responseJson toString:@"status"]);
    //    } FailureBlock:^(NSError *error) {
    //        NSLog(@"%@",error);
    //    }];
#endif
    
    return [self getMsgModel:sender groupId:groupId customMsg:msg.userData textMsg:textMsg];
}

#pragma mark 解析消息，获取消息实体
- (id<AVIMMsgAble>)getMsgModel:(id<IMUserAble>)sender groupId:(NSString *)groupId customMsg:(NSData *)data textMsg:(NSString *)textMsg
{
    CustomMessageModel *customMessageModel;
    
    NSDictionary *resposeDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    if (resposeDict && [resposeDict isKindOfClass:[NSDictionary class]])
    {
        if ([resposeDict count])
        {
            customMessageModel = [CustomMessageModel mj_objectWithKeyValues:resposeDict];
            SenderModel *tmpSender = [SenderModel mj_objectWithKeyValues:[resposeDict objectForKey:@"sender"]];
            customMessageModel.sender = tmpSender;
            customMessageModel.chatGroupID = groupId;
            
            if (tmpSender.user_level > [[IMAPlatform sharedInstance].host getUserRank])
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [[IMAPlatform sharedInstance].host getMyInfo:^(AppBlockModel *blockModel) {
                        
                        // 判断当前用户的等级能否发言了
                        [[NSNotificationCenter defaultCenter] postNotificationName:kLiveRoomCanSendMessage object:nil];
                        
                    }];
                    
                });
            }
            
            if (customMessageModel.type == MSG_LIVE_STOP)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 刷新首页（主要为了删除首页已经退出的直播间）
                    [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshHomeItem object:resposeDict];
                });
            }
            
            if (textMsg && ![textMsg isEqualToString:@""])
            {
                customMessageModel.text = textMsg;
            }
        }
    }
    
    [customMessageModel prepareForRender];
    
    return customMessageModel;
}


@end


#pragma mark - ======================= 缓存相关 =======================
@implementation FWIMMsgHandler (CacheMode)

- (void)createMsgCache
{
    if (_msgCache)
    {
        _msgCache = nil;
    }
    _msgCache = [NSMutableDictionary dictionary];
    [_msgCache setObject:[[AVIMCache alloc] initWith:1000] forKey:kRoomTableViewMsgKey];
    
    [_msgCache setObject:[[AVIMCache alloc] initWith:10] forKey:@(MSG_LIGHT)];
}

- (void)resetMsgCache
{
    [self createMsgCache];
}
- (void)releaseMsgCache
{
    _msgCache = nil;
}

- (void)enCache:(id<AVIMMsgAble>)msg noCache:(FWVoidBlock)noCacheblock;
{
    if (!_isCacheMode)
    {
        if (noCacheblock)
        {
            noCacheblock();
        }
    }
    else
    {
        if (msg)
        {
            OSSpinLockLock(&_msgCacheLock);
            
            AVIMCache *cache;
            if ([msg msgType] == MSG_LIGHT)
            {
                cache = [_msgCache objectForKey:@([msg msgType])];
            }
            else
            {
                cache = [_msgCache objectForKey:kRoomTableViewMsgKey];
            }
            if (cache)
            {
                [cache enCache:msg];
            }
            else
            {
                if (noCacheblock)
                {
                    noCacheblock();
                }
            }
            OSSpinLockUnlock(&_msgCacheLock);
        }
    }
    
}

- (NSDictionary *)getMsgCache
{
    OSSpinLockLock(&_msgCacheLock);
    NSDictionary *dic = _msgCache;
    
    OSSpinLockUnlock(&_msgCacheLock);
    
    return dic;
}

@end


#pragma mark - ======================= 直播间调用的方法 =======================
@implementation FWIMMsgHandler (LivingRoom)

#pragma mark 设置群监听
- (void)setGroupChatListener:(id<FWShowLiveRoomAble>)liveItem
{
    DebugLog(@"========：setGroupChatListener");
    _liveItem = liveItem;
    _chatRoomConversation = [[TIMManager sharedInstance] getConversation:TIM_GROUP receiver:[liveItem liveIMChatRoomId]];
    
    self.isCacheMode = kSupportIMMsgCache;
}

#pragma mark 移除群监听
- (void)removeGroupChatListener
{
    DebugLog(@"========：removeGroupChatListener");
    _liveItem = nil;
    _chatRoomConversation = nil;
    
    self.isCacheMode = NO;
    [_newMsgMArray removeAllObjects];
}


@end
