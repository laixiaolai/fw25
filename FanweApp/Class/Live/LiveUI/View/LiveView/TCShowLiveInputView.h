//
//  TCShowLiveInputView.h
//  TCShow
//
//  Created by AlexiChen on 15/11/16.
//  Copyright © 2015年 AlexiChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KLSwitch.h"

@class TCShowLiveInputView;

@protocol TCShowLiveInputViewDelegate <NSObject>
@required

- (void)sendMsg:(TCShowLiveInputView *)inputView;

@end

@interface TCShowLiveInputView : FWBaseView<UITextFieldDelegate>
{
    UITextField     *_textField;
    UIButton        *_confirmButton;
    BOOL            _canSendMsg;            // 是否能够发送消息
    
    NSString        *_sendMsgStr;           // 上一次发送的消息
    NSInteger       _sendSameMsgTime;       // 发送相同消息的次数
    
    CurrentLiveInfo *_liveInfo;
}

@property (nonatomic, weak) id<TCShowLiveInputViewDelegate> delegate;

@property (nonatomic, strong) UITextField   *textField;
@property (nonatomic, assign) NSInteger     limitLength;        // 限制长度，> 0 时有效
@property (nonatomic, copy) NSString        *text;
@property (nonatomic, strong) KLSwitch      *barrageSwitch;     // 是否打开弹幕
@property (nonatomic, assign) BOOL          isHost;             // 是否主播
@property (nonatomic, assign) BOOL          isInputViewActive;

/**
 请求完接口后，刷新直播间相关信息
 
 @param liveItem 视频Item
 @param liveInfo get_video2接口获取下来的数据实体
 */
- (void)refreshLiveItem:(id<FWShowLiveRoomAble>)liveItem liveInfo:(CurrentLiveInfo *)liveInfo;

- (BOOL)isInputViewActive;

- (void)setPlacehoholder:(NSString *)placeholder;

- (BOOL)resignFirstResponder;

- (BOOL)becomeFirstResponder;

@end
