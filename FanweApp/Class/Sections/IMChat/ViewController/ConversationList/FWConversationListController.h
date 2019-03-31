//
//  FWConversationListController.h
//  FanweApp
//
//  Created by 朱庆彬 on 2017/8/22.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "FWConversationSegmentController.h"
#import <UIKit/UIKit.h>
@class SFriendObj;

@protocol ConversationListViewDelegate <NSObject>

@optional

- (void)clickFriendItem:(SFriendObj *)obj; //点击某行

- (void)reloadChatBadge:(int)selectItem; //删除对话时修改角标

- (void)updateChatFriendBadge:(int)unReadNum; //修改角标

@end

@interface FWConversationListController : FWConversationSegmentController

@property (nonatomic, strong) UITableView *mTableView;

@property (nonatomic, strong) NSMutableArray *conversationArr;

@property (nonatomic, assign) BOOL isHaveLive; //只有一半的情况

@property (nonatomic, weak) id<ConversationListViewDelegate> delegate;

- (void)updateTableViewFrame;

@end
