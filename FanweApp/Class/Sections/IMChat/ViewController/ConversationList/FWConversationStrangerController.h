//
//  FWConversationStrangerController.h
//  FanweApp
//
//  Created by 朱庆彬 on 2017/8/23.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "FWConversationSegmentController.h"
@class SFriendObj;

@protocol FWConversationStrangerViewDelegate <NSObject>

- (void)reloadChatBadge:(int)selectItem; //删除对话时修改角标

- (void)updateChatStrangerBadge:(int)unReadNum; //修改角标

@optional

- (void)clickFriendItem:(SFriendObj *)obj; //点击某行

@end

@interface FWConversationStrangerController : FWConversationSegmentController

@property (nonatomic, strong) UITableView *mTableView;

@property (nonatomic, assign) BOOL isHaveLive; //只有一半的情况

@property (nonatomic, strong) NSMutableArray *conversationArr;

@property (nonatomic, weak) id<FWConversationStrangerViewDelegate> delegate;

- (void)updateTableViewFrame;

@end
