//
//  FWConversationServiceController.h
//  FanweApp
//
//  Created by 朱庆彬 on 2017/8/18.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "FWBaseChatController.h"

@class SFriendObj;

typedef void (^BackOrGoNextVCBlock)(int tag);

@interface FWConversationServiceController : FWBaseChatController

@property (copy, nonatomic) BackOrGoNextVCBlock backOrGoNextVCBlock;

@property (nonatomic, strong) SFriendObj *mChatFriend;

+ (FWConversationServiceController *)makeChatVCWith:(SFriendObj *)chattag;

+ (FWConversationServiceController *)makeChatVCWith:(SFriendObj *)chattag isHalf:(BOOL)mbhalf;

+ (FWConversationServiceController *)createIMMsgVCWithHalfWith:(SFriendObj *)friend_Obj form:(UIViewController *)full_VC isRelive:(BOOL)sender;

@end
