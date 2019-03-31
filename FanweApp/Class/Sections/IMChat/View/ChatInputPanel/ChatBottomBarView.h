//
//  ChatBottomBarView.h
//  FanweApp
//
//  Created by 朱庆彬 on 2017/8/15.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "ChatBarTextView.h"
#import "ChatEmojiView.h"
#import "ChatMoreView.h"
#import <Masonry/Masonry.h>
#import <UIKit/UIKit.h>

static CGFloat const kChatBarViewHeight = 234.0f;
static CGFloat const kChatBarBottomOffset = 8.f;
static CGFloat const kChatBarTextViewBottomOffset = 6;
static CGFloat const kChatBarTextViewFrameMinHeight = 37.f;
static CGFloat const kChatBarTextViewFrameMaxHeight = 82.f;
static CGFloat const kChatBarMaxHeight = kChatBarTextViewFrameMaxHeight + 2 * kChatBarTextViewBottomOffset;
static CGFloat const kChatBarMinHeight = kChatBarTextViewFrameMinHeight + 2 * kChatBarTextViewBottomOffset;

/**
 *  chatBar显示类型
 */
typedef NS_ENUM(NSUInteger, FWChatBarShowType) {
    FWChatBarShowTypeNothing /**不显示chatbar */,
    FWChatBarShowTypeFace /**显示表情View */,
    FWChatBarShowTypeVoice /**显示录音view */,
    FWChatBarShowTypeMore /**显示更多view */,
    FWChatBarShowTypeKeyboard /**显示键盘 */,
};

@protocol ChatBottomBarDelegate;

@interface ChatBottomBarView : UIView

@property (nonatomic, strong) UIView *inputBarBackgroundView; //输入栏目背景视图
@property (nonatomic, strong) UIView *maskView; //无私信权限
@property (strong, nonatomic) UIButton *voiceButton;          //切换录音模式按钮
@property (strong, nonatomic) UIButton *voiceRecordButton;    //录音按钮
@property (strong, nonatomic) UIButton *faceButton;           //表情按钮
@property (strong, nonatomic) UIButton *moreButton;           //更多按钮
@property (strong, nonatomic) ChatBarTextView *textView;      //输入框
@property (strong, nonatomic) ChatEmojiView *emojiView;
@property (nonatomic, assign) FWChatBarShowType showType;
@property (nonatomic, assign) BOOL mbhalf;
//@property (weak, nonatomic) ChatFaceView *faceView;
@property (weak, nonatomic) UIView *faceView;
@property (weak, nonatomic) ChatMoreView *moreView;
@property (weak, nonatomic) id<ChatBottomBarDelegate> delegate;

@property (assign, nonatomic) CGSize keyboardSize;
@property (assign, nonatomic) CGFloat oldTextViewHeight;
@property (assign, nonatomic) CGFloat animationDuration;
@property (nonatomic, assign, getter=isClosed) BOOL close;
@property (nonatomic, assign, getter=shouldAllowTextViewContentOffset) BOOL allowTextViewContentOffset;

- (void)hideChatBottomBar;

- (void)updateChatBarConstraintsIfNeededShouldCacheText:(BOOL)shouldCacheText;

@end

@protocol ChatBottomBarDelegate <NSObject>

@optional

/**
 改变聊天界面tableView 高度
 @param chatBar 底部菜单
 */
- (void)chatBarFrameDidChange:(ChatBottomBarView *)chatBar shouldScrollToBottom:(CGFloat)keyBoardHeight showType:(FWChatBarShowType)showType showAnimationTime:(CGFloat)showAnimationTime;

/**
 发送普通的文字信息,可能带有表情
 @param chatBar chatBar
 @param message 发送的消息
 */
- (void)chatBar:(ChatBottomBarView *)chatBar sendMessage:(NSString *)message;

/**
 *  输入了 @ 的时候
 *
 */
- (void)didInputAtSign:(ChatBottomBarView *)chatBar;

- (NSArray *)regulationForBatchDeleteText;

@end
