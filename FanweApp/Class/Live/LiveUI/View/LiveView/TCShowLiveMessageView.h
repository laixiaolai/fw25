//
//  TCShowLiveMessageView.h
//  TCShow
//
//  Created by AlexiChen on 16/4/14.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLEmojiLabel.h"
#import "AVIMCache.h"

@class TCShowLiveMsgTableViewCell;

@protocol TCShowLiveMsgTableViewCellDelegate <NSObject>
@required

//点击消息列表中的用户名称
- (void)clickCellNameRange:(TCShowLiveMsgTableViewCell *) cell;
//点击消息列表中的具体消息内容（目前会响应点击事件的是：红包）
- (void)clickCellMessageRange:(TCShowLiveMsgTableViewCell *) cell;

//@optional
- (void)clickCellUserInfo:(TCShowLiveMsgTableViewCell *) cell;

@end

@protocol TCShowLiveMessageViewDelegate <NSObject>
@required

//点击消息列表中的用户名称
- (void)clickNameRange:(CustomMessageModel *) customMessageModel;
//点击消息列表中的具体消息内容（目前会响应点击事件的是：红包）
- (void)clickMessageRange:(CustomMessageModel *) customMessageModel;

- (void)clickUserInfo:(cuserModel *)cuser;

- (void)clickGoodsMessage:(CustomMessageModel *) customMessageModel;

@end


@interface TCShowLiveMsgTableViewCell : UITableViewCell<MLEmojiLabelDelegate>
{
    UIView                  *_msgBack;      // 消息背景
    UIImageView             *_rankImgView;  // 等级图标
    NSString                *_type;         // 类型
}

@property (nonatomic, weak) id<TCShowLiveMsgTableViewCellDelegate>  delegate;
@property (nonatomic, strong) MLEmojiLabel                          *msgLabel;              // 消息显示标签
@property (nonatomic, strong) UIFont                                *myFont;
@property (nonatomic, strong) CustomMessageModel                    *customMessageModel;
@property (nonatomic, strong) cuserModel                            *cuser;

- (void)config:(CustomMessageModel *)item block:(FWVoidBlock)block;

@end



@interface TCShowLiveMessageView : UIView<UITableViewDataSource, UITableViewDelegate,TCShowLiveMsgTableViewCellDelegate>
{
@protected
    UITableView         *_tableView;        // 消息列表
    NSMutableArray      *_liveMessages;     // 缓存的消息数量
    
    NSInteger           _msgCount;          // 统计点评的赞数
    
    BOOL                _canScrollToBottom; // 当前可以滑动到底部
    float               _lastContentOffset; // tableview当前内容位置
    int                 _testIndex;
}

@property (nonatomic, weak) id<TCShowLiveMessageViewDelegate>delegate;

// 位置定时器
@property (nonatomic, strong) NSTimer       *contentOffsetTimer;
// 消息数量，评论数
@property (nonatomic, readonly) NSInteger   msgCount;
// 首次进入某个直播间显示聊天列表中的规则等（后台有设置并且为YES的时候会显示）
@property (nonatomic, assign) BOOL          isNeedShowRule;

- (void)insertMsg:(id<AVIMMsgAble>)msg;
// 延迟显示
- (void)insertCachedMsg:(AVIMCache *)msgCache;

@end
