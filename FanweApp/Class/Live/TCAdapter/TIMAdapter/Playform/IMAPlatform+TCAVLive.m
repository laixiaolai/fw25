//
//  IMAPlatform+TCAVLive.m
//  TCShow
//
//  Created by AlexiChen on 16/4/12.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "IMAPlatform+TCAVLive.h"
#import <IMGroupExt/IMGroupExt.h>
@implementation IMAPlatform (TCAVLive)

- (void)asyncExitHistoryAVChatRoom
{
//    [[TIMGroupManager sharedInstance] GetGroupList:^(NSArray *list) {
//        for(int index = 0; index < list.count; index++)
//        {
//            // AVChatRoom 使用longpoll
//            TIMGroupInfo* info = list[index];
//            if ([info.groupType isEqualToString:kAVChatRoomType])
//            {
//                // 不用处理返回码，会删除自己创建的群
//                DebugLog(@"解散或退出历史直播房间:%@", info.group);
//                [[TIMGroupManager sharedInstance] DeleteGroup:info.group succ:nil fail:nil];
//            }
//        }
//    } fail:nil];
    [[TIMGroupManager sharedInstance] getGroupList:^(NSArray *list) {
        for(int index = 0; index < list.count; index++)
        {
            // AVChatRoom 使用longpoll
            TIMGroupInfo* info = list[index];
            if ([info.groupType isEqualToString:kAVChatRoomType])
            {
                // 不用处理返回码，会删除自己创建的群
                DebugLog(@"解散或退出历史直播房间:%@", info.group);
                [[TIMGroupManager sharedInstance] deleteGroup:info.group succ:nil fail:nil];
            }
        }

    } fail:nil];
}

// 主播 : 主播创建直播聊天室
// 观众 : 观众加入直播聊天室
- (void)asyncEnterAVChatRoom:(id<AVRoomAble>)room isHost:(BOOL)isHost succ:(TCAVLiveChatRoomCompletion)succ fail:(TIMFail)fail
{
    if (!room)
    {
        DebugLog(@"直播房房间信息不正确");
        if (fail)
        {
            fail(-1, @"直播房房间信息不正确");
        }
        return;
    }
    
    
    NSString *title = [room liveTitle];
    if (!title || title.length == 0)
    {
        DebugLog(@"直播房房间信息liveTitle不正确");
        if (fail)
        {
            fail(-1, @"直播房房间信息liveTitle不正确");
        }
        return;
    }
    
    // 外部保证聊天室ID是正确的
    NSString *roomid = [room liveIMChatRoomId];
    
    if (isHost)
    {
        
#if kSupportFixLiveChatRoomID
        // 如果roomid不为空，说明使用roomid作标题来创建直播群
        // 否则使用room liveTitle来作群名创建群
        if (roomid && roomid.length != 0)
        {
            DebugLog(@"----->>>>>主播开始创建直播聊天室:%@ title = %@", roomid, title);
            [[TIMGroupManager sharedInstance] createGroup:kAVChatRoomType members:nil groupName:title groupId:roomid succ:^(NSString *groupId) {
                [room setLiveIMChatRoomId:groupId];
                if (succ)
                {
                    succ(room);
                }
                
            } fail:^(int code, NSString *error) {
                // 返回10025，group id has be used，
                // 10025无法区分当前是操作者是否是原群的操作者（目前业务逻辑不存在拿别人的uid创建聊天室逻辑），
                // 为简化逻辑，暂定创建聊天室时返回10025，就直接等同于创建成功
                if (code == 10025)
                {
                    DebugLog(@"----->>>>>主播开始创建直播聊天室成功");
                    [room setLiveIMChatRoomId:roomid];
                    if (succ)
                    {
                        succ(room);
                    }
                }
                else
                {
                    DebugLog(@"----->>>>>主播开始创建直播聊天室失败 code: %d , msg = %@", code, error);
                    if (fail)
                    {
                        fail(code, error);
                    }
                }
            }];
        }
        else
#endif
        {
#if kSupportAVChatRoom
            if(roomid){ // 主播在一段时间内断开直播重新连接直播的情况
                [[TIMGroupManager sharedInstance] joinGroup:roomid msg:nil succ:^{
                    DebugLog(@"----->>>>>主播重新加入自己的直播聊天室成功");
                    if (succ)
                    {
                        succ(room);
                    }
                    
                    
                } fail:^(int code, NSString *error) {
                    
                    if (code == 10013)
                    {
                        DebugLog(@"----->>>>>主播重新加入自己的直播聊天室成功");
                        if (succ)
                        {
                            succ(room);
                        }
                    }
                    else
                    {
                        DebugLog(@"----->>>>>主播重新加入自己的直播聊天室失败 code: %d , msg = %@", code, error);
                        // 作已在群的处的处理
                        if (fail)
                        {
                            fail(code, error);
                        }
                    }
                    
                }];
            }else{
                [[TIMGroupManager sharedInstance] createAVChatRoomGroup:title succ:^(NSString *chatRoomID) {
#else
                    [[TIMGroupManager sharedInstance] createChatRoomGroup:@[[self.host imUserId]] groupName:title succ:^(NSString *chatRoomID) {
#endif
                        DebugLog(@"----->>>>>主播开始创建IM聊天室成功");
                        [room setLiveIMChatRoomId:chatRoomID];
                        if (succ)
                        {
                            succ(room);
                        }
                        
                    } fail:^(int code, NSString *error) {
                        
                        DebugLog(@"----->>>>>主播开始创建IM聊天室失败 code: %d , msg = %@", code, error);
                        if (fail)
                        {
                            fail(code, error);
                        }
                    }];
                }
                 
                 }
                 }
                 else
                 {
                     
                     if (roomid.length == 0)
                     {
                         DebugLog(@"----->>>>>观众加入直播聊天室ID为空");
                         if (fail)
                         {
                             fail(-1, @"直播聊天室ID为空");
                         }
                         return;
                     }
                     
                     // 观众加群
                     [[TIMGroupManager sharedInstance] joinGroup:roomid msg:nil succ:^{
                         DebugLog(@"----->>>>>观众加入直播聊天室成功");
                         if (succ)
                         {
                             succ(room);
                         }
                         
                         
                     } fail:^(int code, NSString *error) {
                         
                         if (code == 10013)
                         {
                             DebugLog(@"----->>>>>观众加入直播聊天室成功");
                             if (succ)
                             {
                                 succ(room);
                             }
                         }
                         else
                         {
                             DebugLog(@"----->>>>>观众加入直播聊天室失败 code: %d , msg = %@", code, error);
                             // 作已在群的处的处理
                             if (fail)
                             {
                                 fail(code, error);
                             }
                         }
                         
                     }];
                 }
                 }
                 
                 // 主播 : 主播删除直播聊天室
                 // 观众 : 观众退出直播聊天室
                 - (void)asyncExitAVChatRoom:(id<AVRoomAble>)room succ:(TIMSucc)succ fail:(TIMFail)fail
                {
                    if (!room)
                    {
                        DebugLog(@"直播房房间信息不正确");
                        if (fail)
                        {
                            fail(-1, @"直播房房间信息不正确");
                        }
                        return;
                    }
                    
                    id<IMUserAble> roomHost = [room liveHost];
                    NSString *roomid = [room liveIMChatRoomId];
                    
                    if (roomid.length == 0)
                    {
                        DebugLog(@"----->>>>>观众退出的直播聊天室ID为空");
                        if (fail)
                        {
                            fail(-1, @"直播聊天室ID为空");
                        }
                        return;
                    }
                    
                    
                    BOOL isHost = [self.host isEqual:roomHost];
                    if (isHost)
                    {
                        // 主播删群
                        //        [[TIMGroupManager sharedInstance] DeleteGroup:roomid succ:succ fail:fail];
                        if(succ)
                        {
                            succ();
                        }
                    }
                    else
                    {
                        // 观众退群
                        [[TIMGroupManager sharedInstance] quitGroup:roomid succ:succ fail:fail];
                    }
                }
                 @end
