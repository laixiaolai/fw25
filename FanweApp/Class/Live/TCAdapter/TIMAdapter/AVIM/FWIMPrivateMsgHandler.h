//
//  FWIMPrivateMsgHandler.h
//  FanweApp
//
//  Created by 朱庆彬 on 2017/8/2.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "ConversationModel.h"
#import "GiftModel.h"
#import "dataModel.h"
#import <Foundation/Foundation.h>

extern NSString *g_notif_chatmsg;

@class FWIMPrivateMsgHandler;

@protocol FWIMPrivateMsgHandlerDelegate <NSObject>

@end

@interface FWIMPrivateMsgHandler : NSObject

FanweSingletonH(Instance);

@property (nonatomic, weak) id<FWIMPrivateMsgHandlerDelegate> delegate;

@end

@interface SIMMsgObj : ConversationModel

@property (nonatomic, strong) TIMMessage *mCoreTMsg;
@property (nonatomic, assign) int mSenderId; //发送者的用户ID
@property (nonatomic, assign) BOOL is_robot;

//是不是私聊的消息,如果是返回YES,并且发送一个通知出去,聊天界面自己接收该通知,
+ (BOOL)maybeIMChatMsg:(TIMMessage *)itmsg;

+ (NSString *)makeMsgDesc:(SIMMsgObj *)msg;

+ (BOOL)saveData:(id)data forkey:(NSString *)key;

@end

@interface SFriendObj : SAutoEx

- (id)initWithUserId:(int)userid;

@property (nonatomic, assign) int mUser_id;
@property (nonatomic, strong) NSString *mNick_name;
@property (nonatomic, strong) NSString *mHead_image;
@property (nonatomic, assign) int mUser_level;   //等级
@property (nonatomic, strong) NSString *mV_icon; //等级ICON
@property (nonatomic, assign) int mSex;

@property (nonatomic, assign) BOOL is_robot;
@property (nonatomic, strong) NSString *mLastMsg;
@property (nonatomic, strong) NSDate *mLastMsgDate;

- (void)setLMsg:(TIMMessage *)msg;

- (NSString *)getTimeStr;

//获取未读消息
- (int)getUnReadCount;

//忽略这个未读
- (void)ignoreThisUnReadCount;

//删除会话
- (void)delThis:(void (^)(SResBase *resb))block;

//获取消息 before = YES 获取 posmsg 之前的消息,否则之后的消息 posmsg == nil 就是最新的消息
- (void)getMsgList:(BOOL)before posmsg:(SIMMsgObj *)posmsg block:(void (^)(SResBase *resb, NSArray *all))block;

//发送文字消息
- (SIMMsgObj *)sendTextMsg:(NSString *)text block:(void (^)(SResBase *resb, SIMMsgObj *thatmsg))block;

//发送图片消息
- (SIMMsgObj *)sendPicMsg:(UIImage *)img block:(void (^)(SResBase *resb, SIMMsgObj *thatmsg))block;

//发送礼物消息
- (SIMMsgObj *)sendVoiceMsg:(NSURL *)voicepath duration:(NSTimeInterval)duration block:(void (^)(SResBase *resb, SIMMsgObj *thatmsg))block;

//重发消息
- (void)reSendMsg:(SIMMsgObj *)resmsg block:(void (^)(SResBase *resb, SIMMsgObj *thatmsg))block;

//忽略未读
+ (void)ignoreMsg:(NSArray *)allFriends block:(void (^)(SResBase *resb))block;

//获取我的列表,,消息的列表
+ (void)getMyFriendMsgList:(int)bFollowed lastObj:(SFriendObj *)lastObj block:(void (^)(SResBase *resb, NSArray *all, int unReadNum))block;

//发送礼物
- (void)sendGiftMsg:(GiftModel *)findgifobj block:(void (^)(SResBase *resb, SIMMsgObj *thatmsg))block;

//赠送游戏币
- (void)sendCoinMsgWithCoin:(NSString *)coin block:(void (^)(SResBase *resb, SIMMsgObj *thatmsg))block;

- (void)sendDiamondsMsgWithDiamonds:(NSString *)diamonds block:(void (^)(SResBase *resb, SIMMsgObj *thatmsg))block;

//有多少未读消息
//+ (int)getAllUnReadCount;
+ (void)getAllUnReadCountComplete:(void (^)(int num))block;

//获取 好友／未关注的 未读消息数目
+ (void)getMyFocusFriendUnReadMsgNumIsFriend:(int)isFriend block:(void (^)(int unReadNum))block;

+ (NSString *)makepicsavepath;
+ (NSString *)makevoicesavepath:(NSString *)filename;
+ (NSString *)makevoicefilename;

@end
