//
//  ChatEmojiView.h
//  FanweApp
//
//  Created by 朱庆彬 on 2017/8/15.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ChatEmojiViewIconType) {
    ChatEmojiViewIconTypeCommon = 0, //经典表情
    ChatEmojiViewIconTypeOther       //******************自定义表情:后期版本拓展**********
};

@class EmojiObj;

@protocol ChatEmojiViewDelegate <NSObject>

@required
- (void)chatEmojiViewSelectEmojiIcon:(EmojiObj *)objIcon; //选择了某个表情
- (void)chatEmojiViewTouchUpinsideDeleteButton;           //点击了删除表情
- (void)chatEmojiViewTouchDownDeleteButton;               //长按删除表情

@optional
- (void)chatEmojiViewTouchUpinsideSendButton; //点击了发送表情

@end

#define ChatEmojiView_Hight 234.0f //表情View的高度
#define ChatEmojiView_Bottom_H 40.0f
#define ChatEmojiView_Bottom_W 52.0f

@interface ChatEmojiView : UIView

@property (nonatomic, weak) id<ChatEmojiViewDelegate> delegate;
@end
