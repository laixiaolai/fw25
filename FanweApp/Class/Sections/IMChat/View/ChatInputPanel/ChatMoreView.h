//
//  ChatMoreView.h
//  FanweApp
//
//  Created by 朱庆彬 on 2017/8/15.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kChatOtherViewHight 234.0f

@protocol ChatMoreViewDelegate <NSObject>

@optional

- (void)chatMoreViewButton:(NSInteger)btnIndex; //点击了某个按钮

@end

/**
 *  更多view
 */
@interface ChatMoreView : UIView

@property (nonatomic, strong) NSMutableArray *btnArray;

@property (nonatomic, weak) id<ChatMoreViewDelegate> delegate;

- (void)initWithBtnArray:(NSMutableArray *)array;

- (void)setGiftView:(BOOL)hidden;

@end
