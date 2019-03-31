//
//  TCShowLiveInputView.m
//  TCShow
//
//  Created by AlexiChen on 15/11/16.
//  Copyright © 2015年 AlexiChen. All rights reserved.
//

#import "TCShowLiveInputView.h"

@implementation TCShowLiveInputView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 请求完接口后，刷新直播间相关信息
 
 @param liveItem 视频Item
 @param liveInfo get_video2接口获取下来的数据实体
 */
- (void)refreshLiveItem:(id<FWShowLiveRoomAble>)liveItem liveInfo:(CurrentLiveInfo *)liveInfo
{
    _liveInfo = liveInfo;
}

- (NSString *)text
{
    return _textField.text;
}

- (void)setText:(NSString *)text
{
    _textField.text = text;
}

- (void)setPlacehoholder:(NSString *)placeholder
{
    if (!placeholder || placeholder.length == 0)
    {
        _textField.placeholder = nil;
        return;
    }
    _textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName:kWhiteColor}];
}

- (void)addOwnViews
{
    self.backgroundColor = kClearColor;
    
    _textField = [[UITextField alloc] init];
    _textField.textColor = kAppGrayColor1;
    _textField.font = kAppMiddleTextFont;
    _textField.returnKeyType = UIReturnKeySend;
    _textField.delegate = self;
    _textField.layer.cornerRadius = kCornerRadius;
    _textField.backgroundColor = kWhiteColor;
    _textField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, 10)];
    _textField.leftViewMode = UITextFieldViewModeAlways;
    [self addSubview:_textField];
    
    FWWeakify(self)
    //是否打开弹幕
    _barrageSwitch = [[KLSwitch alloc]initWithFrame:CGRectMake(0, 0, 50, 30) didChangeHandler:^(BOOL isOn) {
        
        FWStrongify(self)
        if (isOn && !self.isHost)
        {
            self.textField.placeholder = [NSString stringWithFormat:@"开启大喇叭，%ld%@/条",(long)[GlobalVariables sharedInstance].appModel.bullet_screen_diamond,self.fanweApp.appModel.diamond_name];
        }
        else
        {
            self.textField.placeholder = @"和大家说点什么";
        }
    }];
    [_barrageSwitch setOnTintColor:kAppMainColor];
    [_barrageSwitch setOnImage:[UIImage imageNamed:@"ic_send_pop_msg_disable"]];
    [_barrageSwitch setOffImage:[UIImage imageNamed:@"ic_send_pop_msg_enable"]];
    [self addSubview:_barrageSwitch];
    
    _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _confirmButton.layer.cornerRadius = kCornerRadius;
    _confirmButton.clipsToBounds = YES;
    [_confirmButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    _confirmButton.titleLabel.font = kAppMiddleTextFont;
    [_confirmButton setTitle:@"发送" forState:UIControlStateNormal];
    [_confirmButton setBackgroundImage:[FWUtils imageWithColor:kAppMainColor] forState:UIControlStateNormal];
    [_confirmButton setBackgroundImage:[FWUtils imageWithColor:[kAppMainColor colorWithAlphaComponent:0.6]] forState:UIControlStateHighlighted];
    [_confirmButton addTarget:self action:@selector(onClickSend) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_confirmButton];
    
    [self changeSendMsgState];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSendMsgState) name:kLiveRoomCanSendMessage object:nil];
}

- (void)onClickSend
{
    if (!_isHost && [[IMAPlatform sharedInstance].host getUserRank] < [GlobalVariables sharedInstance].appModel.send_msg_lv)
    {
        [FanweMessage alertTWMessage:@"您当前等级不能发言！"];
        return;
    }
    
    NSString *tmpSendMsgStr = [_textField.text trim];
    
    if ([FWUtils isBlankString:tmpSendMsgStr])
    {
        return;
    }
    
    // 弹幕不做限制
    if ([_barrageSwitch isOn])
    {
        if (_delegate && [_delegate respondsToSelector:@selector(sendMsg:)])
        {
            [_delegate sendMsg:self];
        }
    }
    else
    {
        if (_canSendMsg)
        {
            if ([_sendMsgStr isEqualToString:tmpSendMsgStr])
            {
                _sendSameMsgTime ++;
            }
            else
            {
                _sendSameMsgTime = 0;
            }
            
            if (_sendSameMsgTime > 2)
            {
                [FanweMessage alertTWMessage:@"请勿刷屏"];
                return;
            }
            
            if (_delegate && [_delegate respondsToSelector:@selector(sendMsg:)])
            {
                _sendMsgStr = tmpSendMsgStr;
                _canSendMsg = NO;
                [self performSelector:@selector(changeSendMsgState) withObject:nil afterDelay:2];
                
                [_delegate sendMsg:self];
            }
        }
        else
        {
            [FanweMessage alertTWMessage:@"请勿频繁发言"];
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (!_isHost && [[IMAPlatform sharedInstance].host getUserRank] < [GlobalVariables sharedInstance].appModel.send_msg_lv)
    {
        [FanweMessage alertTWMessage:@"您当前等级不能发言！"];
        return NO;
    }
    
    if ([FWUtils isBlankString:textField.text])
    {
        return NO;
    }
    if (_canSendMsg)
    {
        [self onClickSend];
        return YES;
    }
    else
    {
        [FanweMessage alertTWMessage:@"请勿频繁发言"];
        return NO;
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (_barrageSwitch.isOn && !_isHost)
    {
        textField.placeholder = [NSString stringWithFormat:@"开启大喇叭，%ld%@/条",(long)[GlobalVariables sharedInstance].appModel.bullet_screen_diamond,self.fanweApp.appModel.diamond_name];
    }
    else
    {
        _textField.placeholder = @"和大家说点什么";
    }
    _isInputViewActive = YES;
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _isInputViewActive = YES;
}

- (void)textFieldDidBeginEditing
{
    _isInputViewActive = YES;
}

- (void)setLimitLength:(NSInteger)limitLength
{
    if (limitLength > 0)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onTextFiledEditChanged:) name:@"UITextFieldTextDidChangeNotification" object:nil];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UITextFieldTextDidChangeNotification" object:nil];
    }
    _limitLength = limitLength;
}

// 监听字符变化，并处理
- (void)onTextFiledEditChanged:(NSNotification *)obj
{
    if (_limitLength > 0)
    {
        UITextField *textField = _textField;
        NSString *toBeString = textField.text;
        
        //获取高亮部分
        UITextRange *selectedRange = [textField markedTextRange];
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position)
        {
            if (toBeString.length > _limitLength)
            {
                [textField shake];
                NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:_limitLength];
                if (rangeIndex.length == 1)
                {
                    textField.text = [toBeString substringToIndex:_limitLength];
                }
                else
                {
                    NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, _limitLength)];
                    textField.text = [toBeString substringWithRange:rangeRange];
                }
            }
        }
    }
}

- (void)relayoutFrameOfSubViews
{
    _barrageSwitch.frame = CGRectMake(0, (CGRectGetHeight(self.frame)-30)/2, 50, 30);
    
    _confirmButton.frame = CGRectMake(CGRectGetWidth(self.frame)-44, (CGRectGetHeight(self.frame)-30)/2, 44, 30);

    _textField.frame = CGRectMake(CGRectGetMaxX(_barrageSwitch.frame)+kDefaultMargin-2, (CGRectGetHeight(self.frame)-30)/2, kScreenW-94-kDefaultMargin*2+4, 30);
}

- (void)setIsHost:(BOOL)isHost
{
    _isHost = isHost;
    
    [self changeSendMsgState];
}

- (void)changeSendMsgState
{
    if (_isHost)
    {
        _canSendMsg = YES;
    }
    else if ([[IMAPlatform sharedInstance].host getUserRank] >= [GlobalVariables sharedInstance].appModel.send_msg_lv)
    {
        _canSendMsg = YES;
    }
}

- (BOOL)isInputViewActive
{
    return _isInputViewActive;
}

- (BOOL)resignFirstResponder
{
    _isInputViewActive = NO;
    [super resignFirstResponder];
    return [_textField resignFirstResponder];
}

- (BOOL)becomeFirstResponder
{
    _isInputViewActive = YES;
    return [_textField becomeFirstResponder];
}

@end
