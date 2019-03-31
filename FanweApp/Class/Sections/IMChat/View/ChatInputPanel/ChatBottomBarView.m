//
//  ChatBottomBarView.m
//  FanweApp
//
//  Created by 朱庆彬 on 2017/8/15.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "ChatBottomBarView.h"
@interface ChatBottomBarView () <UITextViewDelegate>

@end

@implementation ChatBottomBarView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setup];
    }
    return self;
}

- (void)setupConstraints
{
    CGFloat offset = 5;
    [self.inputBarBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.mas_equalTo(self);
        make.bottom.mas_equalTo(self).priorityLow();
    }];

    [self.voiceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.inputBarBackgroundView.mas_left).with.offset(offset);
        make.bottom.equalTo(self.inputBarBackgroundView.mas_bottom).with.offset(-kChatBarBottomOffset);
        make.width.equalTo(self.voiceButton.mas_height);
    }];

    [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.inputBarBackgroundView.mas_right).with.offset(-offset);
        make.bottom.equalTo(self.inputBarBackgroundView.mas_bottom).with.offset(-kChatBarBottomOffset);
        make.width.equalTo(self.moreButton.mas_height);
    }];

    [self.faceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.moreButton.mas_left).with.offset(-offset);
        make.bottom.equalTo(self.inputBarBackgroundView.mas_bottom).with.offset(-kChatBarBottomOffset);
        make.width.equalTo(self.faceButton.mas_height);
    }];

    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.voiceButton.mas_right).with.offset(offset);
        make.right.equalTo(self.faceButton.mas_left).with.offset(-offset);
        make.top.equalTo(self.inputBarBackgroundView).with.offset(kChatBarTextViewBottomOffset);
        make.bottom.equalTo(self.inputBarBackgroundView).with.offset(-kChatBarTextViewBottomOffset);
        make.height.mas_greaterThanOrEqualTo(kChatBarTextViewFrameMinHeight);
    }];

    CGFloat voiceRecordButtonInsets = 0.f;
    [self.voiceRecordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.textView).insets(UIEdgeInsetsMake(voiceRecordButtonInsets, voiceRecordButtonInsets, voiceRecordButtonInsets, voiceRecordButtonInsets));
    }];

    [self.emojiView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.left.mas_equalTo(self);
        make.height.mas_equalTo(kChatBarViewHeight);
        make.top.mas_equalTo(self.mas_bottom);
    }];

    [self.moreView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.left.mas_equalTo(self);
        make.height.mas_equalTo(kChatBarViewHeight);
        make.top.mas_equalTo(self.mas_bottom);
    }];

    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.mas_equalTo(self);
        make.bottom.mas_equalTo(self).priorityLow();
    }];
}

- (UIView *)inputBarBackgroundView
{
    if (_inputBarBackgroundView == nil)
    {
        UIView *inputBarBackgroundView = [[UIView alloc] init];
        _inputBarBackgroundView = inputBarBackgroundView;
    }
    return _inputBarBackgroundView;
}

- (UIView *)maskView
{
    if (_maskView == nil)
    {
        UIView *maskView = [[UIView alloc] init];
        _maskView = maskView;
        UITapGestureRecognizer *maskTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(maskTapAction:)];
        [_maskView addGestureRecognizer:maskTap];
    }
    return _maskView;
}

- (void)setup
{

    self.oldTextViewHeight = kChatBarTextViewFrameMinHeight;
    [self addSubview:self.inputBarBackgroundView];
    [self.inputBarBackgroundView setBackgroundColor:RGBA(232, 233, 235, 1)];
    [self.inputBarBackgroundView addSubview:self.voiceButton];
    [self.inputBarBackgroundView addSubview:self.moreButton];
    [self.inputBarBackgroundView addSubview:self.faceButton];
    [self.inputBarBackgroundView addSubview:self.textView];
    [self.inputBarBackgroundView addSubview:self.voiceRecordButton];

    UIImageView *topLine = [[UIImageView alloc] init];
    topLine.backgroundColor = [UIColor colorWithRed:0.788 green:0.792 blue:0.804 alpha:1.000];
    [self.inputBarBackgroundView addSubview:topLine];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.equalTo(self.inputBarBackgroundView);
        make.height.mas_equalTo(.5f);
    }];

    [self addSubview:self.maskView];
    [self setupConstraints];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}

- (ChatBarTextView *)textView
{
    if (!_textView)
    {
        _textView = [[ChatBarTextView alloc] init];
        _textView.font = [UIFont systemFontOfSize:16.0f];
        _textView.delegate = self;
        _textView.layer.cornerRadius = 4.0f;
        _textView.textColor = [FWUtils colorWithHexString:@"333333"];
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.layer.borderColor = [UIColor colorWithRed:0.788 green:0.792 blue:0.804 alpha:1.000].CGColor;
        _textView.returnKeyType = UIReturnKeySend;
        _textView.layer.borderWidth = 1.0f;
        _textView.layer.cornerRadius = 3.0f;
        _textView.layer.masksToBounds = YES;
        _textView.scrollsToTop = NO;
    }
    return _textView;
}

- (UIButton *)voiceButton
{
    if (!_voiceButton)
    {
        _voiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _voiceButton.tag = FWChatBarShowTypeVoice;
        [_voiceButton setTitleColor:kAppGrayColor1 forState:UIControlStateNormal];
        [_voiceButton setTitleColor:kAppGrayColor4 forState:UIControlStateHighlighted];
        [_voiceButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"face.bundle/%@", @"ToolViewInputVoice"]] forState:UIControlStateNormal];
        [_voiceButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"face.bundle/%@", @"ToolViewKeyboard"]] forState:UIControlStateSelected];
        [_voiceButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_voiceButton sizeToFit];
    }
    return _voiceButton;
}

- (UIButton *)voiceRecordButton
{
    if (!_voiceRecordButton)
    {
        _voiceRecordButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _voiceRecordButton.hidden = YES;
        _voiceRecordButton.frame = _textView.bounds;
        _voiceRecordButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [_voiceRecordButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//        UIEdgeInsets edgeInsets = UIEdgeInsetsMake(9, 9, 9, 9);
//        UIImage *voiceRecordButtonNormalBackgroundImage = [[UIImage imageNamed:@""] resizableImageWithCapInsets:edgeInsets resizingMode:UIImageResizingModeStretch];
//        UIImage *voiceRecordButtonHighlightedBackgroundImage = [[UIImage imageNamed:[NSString stringWithFormat:@"face.bundle/%@", @"VoiceBtn_BlackHL"]] resizableImageWithCapInsets:edgeInsets resizingMode:UIImageResizingModeStretch];
        [_voiceRecordButton setBackgroundImage:[self createImageWithColor:RGBA(232, 233, 235, 0.5)] forState:UIControlStateNormal];
        [_voiceRecordButton setBackgroundImage:[self createImageWithColor:[UIColor clearColor]] forState:UIControlStateSelected];
        _voiceRecordButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [_voiceRecordButton setTitle:@"按住 说话" forState:UIControlStateNormal];
        [_voiceRecordButton setTitle:@"松开 结束" forState:UIControlStateHighlighted];
        _voiceRecordButton.layer.borderColor = [UIColor colorWithRed:0.788 green:0.792 blue:0.804 alpha:1.000].CGColor;
        _voiceRecordButton.layer.borderWidth = 1.0f;
        _voiceRecordButton.layer.cornerRadius = 3.0f;
        [_voiceRecordButton.layer setMasksToBounds:YES];
    }
    return _voiceRecordButton;
}

- (UIButton *)moreButton
{
    if (!_moreButton)
    {
        _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _moreButton.tag = FWChatBarShowTypeMore;
        [_moreButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"face.bundle/%@", @"TypeSelectorBtn_Black"]] forState:UIControlStateNormal];
        [_moreButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"face.bundle/%@", @"TypeSelectorBtnHL_Black"]] forState:UIControlStateSelected];
        [_moreButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_moreButton sizeToFit];
    }
    return _moreButton;
}

- (UIButton *)faceButton
{
    if (!_faceButton)
    {
        _faceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _faceButton.tag = FWChatBarShowTypeFace;
        [_faceButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"face.bundle/%@", @"ToolViewEmotion"]] forState:UIControlStateNormal];
        [_faceButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"face.bundle/%@", @"ToolViewKeyboard"]] forState:UIControlStateSelected];
        [_faceButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_faceButton sizeToFit];
    }
    return _faceButton;
}

- (UIView *)faceView
{
    if (!_faceView)
    {
        UIView *faceView = [[UIView alloc] init];
        faceView.hidden = YES;
        faceView.backgroundColor = [UIColor whiteColor];
        [self addSubview:(_faceView = faceView)];
    }
    return _faceView;
}

- (ChatMoreView *)moreView
{
    if (!_moreView)
    {
        ChatMoreView *moreView = [[ChatMoreView alloc] init];
        moreView.hidden = YES;
        moreView.backgroundColor = [UIColor whiteColor];
        [self addSubview:(_moreView = moreView)];
    }
    return _moreView;
}

- (ChatEmojiView *)emojiView
{
    if (!_emojiView)
    {
        ChatEmojiView *emojiView = [[ChatEmojiView alloc] init];
        emojiView.hidden = YES;
        emojiView.backgroundColor = [UIColor whiteColor];
        [self addSubview:(_emojiView = emojiView)];
    }
    return _emojiView;
}

- (void)buttonAction:(UIButton *)button
{
    FWChatBarShowType showType = button.tag;
    //更改对应按钮的状态
    if (button == self.faceButton)
    {
        [self.faceButton setSelected:!self.faceButton.selected];
        [self.moreButton setSelected:NO];
        [self.voiceButton setSelected:NO];
    }
    else if (button == self.moreButton)
    {
        [self.faceButton setSelected:NO];
        [self.moreButton setSelected:!self.moreButton.selected];
        [self.voiceButton setSelected:NO];
    }
    else if (button == self.voiceButton)
    {
        [self.faceButton setSelected:NO];
        [self.moreButton setSelected:NO];
        [self.voiceButton setSelected:!self.voiceButton.selected];
    }
    if (!button.selected)
    {
        showType = FWChatBarShowTypeNothing;
    }
    if (!button.selected && button == self.voiceButton)
    {
        showType = FWChatBarShowTypeKeyboard;
        [self beginInputing];
    }
    self.showType = showType;
}

- (void)beginInputing
{
    [self.textView becomeFirstResponder];
}

- (void)setShowType:(FWChatBarShowType)showType
{
    if (_showType == showType)
    {
        return;
    }
    _showType = showType;
    //显示对应的View
    [self showMoreView:showType == FWChatBarShowTypeMore && self.moreButton.selected];
    [self showVoiceView:showType == FWChatBarShowTypeVoice && self.voiceButton.selected];
    [self showFaceView:showType == FWChatBarShowTypeFace && self.faceButton.selected];

    switch (showType)
    {
        case FWChatBarShowTypeNothing:
        {
            [self.faceButton setSelected:NO];
            [self.moreButton setSelected:NO];
            [self.textView resignFirstResponder];
        }
        break;
        case FWChatBarShowTypeVoice:
        {
            self.textView.text = nil;
            [self.textView resignFirstResponder];
        }
        break;
        case FWChatBarShowTypeMore:
        {
            [self.textView resignFirstResponder];
        }
        break;
        case FWChatBarShowTypeFace:
        {
            [self.textView resignFirstResponder];
        }
        break;
        case FWChatBarShowTypeKeyboard:
            [self.faceButton setSelected:NO];
            [self.moreButton setSelected:NO];
            break;
    }
    [self updateChatBarConstraintsIfNeeded];
}

- (void)showVoiceView:(BOOL)show
{
    self.voiceButton.selected = show;
    self.voiceRecordButton.selected = show;
    self.voiceRecordButton.hidden = !show;
    self.textView.hidden = !self.voiceRecordButton.hidden;
}

- (void)showFaceView:(BOOL)show
{
    if (show)
    {
        self.emojiView.hidden = NO;
        [UIView animateWithDuration:0.25f
                         animations:^{
                             [self.emojiView mas_updateConstraints:^(MASConstraintMaker *make) {
                                 make.top.mas_equalTo(self.superview.mas_bottom).offset(-kChatBarViewHeight);
                             }];
                             [self.emojiView layoutIfNeeded];
                         }
                         completion:nil];

        [self.emojiView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.inputBarBackgroundView.mas_bottom);
        }];
    }
    else if (self.emojiView.superview)
    {
        self.emojiView.hidden = YES;
        [self.emojiView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.and.left.mas_equalTo(self);
            make.height.mas_equalTo(kChatBarViewHeight);
            make.top.mas_equalTo(self.mas_bottom);
        }];
        [self.emojiView layoutIfNeeded];
        
    }
}

- (void)showMoreView:(BOOL)show
{
    if (show)
    {
        self.faceView.hidden = NO;
        self.moreView.hidden = NO;
        [UIView animateWithDuration:0.25f
                         animations:^{
                             [self.moreView mas_updateConstraints:^(MASConstraintMaker *make) {
                                 make.top.mas_equalTo(self.superview.mas_bottom).offset(-kChatBarViewHeight);
                             }];
                             [self.moreView layoutIfNeeded];
                         }
                         completion:nil];

        [self.moreView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.inputBarBackgroundView.mas_bottom);
        }];
    }
    else if (self.moreView.superview)
    {
        self.moreView.hidden = YES;
        [self.moreView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.and.left.mas_equalTo(self);
            make.height.mas_equalTo(kChatOtherViewHight);
            make.top.mas_equalTo(self.mas_bottom);
        }];
        [self.moreView layoutIfNeeded];
    }
}

- (void)updateChatBarConstraintsIfNeeded
{

    BOOL shouldCacheText = NO;
    BOOL shouldScrollToBottom = YES;
    FWChatBarShowType chatBarShowType = self.showType;
    switch (chatBarShowType)
    {
        case FWChatBarShowTypeNothing:
        {
            shouldScrollToBottom = NO;
            shouldCacheText = YES;
        }
        break;
        case FWChatBarShowTypeFace:
        case FWChatBarShowTypeMore:
        case FWChatBarShowTypeKeyboard:
        {
            shouldCacheText = YES;
            [self updateChatBarConstraintsIfNeededShouldCacheText:shouldCacheText];
        }
        break;
        case FWChatBarShowTypeVoice:
            shouldCacheText = NO;
            break;
    }
    
    [self chatBarFrameDidChangeShouldScrollToBottom:self.keyboardSize.height showType:chatBarShowType showAnimationTime:_animationDuration];
}

- (void)updateChatBarConstraintsIfNeededShouldCacheText:(BOOL)shouldCacheText
{
    [self textViewDidChange:self.textView shouldCacheText:shouldCacheText];
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(ChatBarTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (range.location == [textView.text length])
    {
        self.allowTextViewContentOffset = YES;
    }
    else
    {
        self.allowTextViewContentOffset = NO;
    }
    if ([text isEqualToString:@"\n"])
    {
        [self sendTextMessage:textView.text];
        return NO;
    }
    else if (text.length == 0)
    {
    }
    else if ([text isEqualToString:@"@"])
    {
    }
    return YES;
}

- (void)textViewDidChange:(ChatBarTextView *)textView
{
    [self textViewDidChange:textView shouldCacheText:YES];
}

- (BOOL)textView:(ChatBarTextView *)textView shouldChangeTextInRange:(NSRange)range deleteBatchOfTextWithPrefix:(NSString *)prefix
                         suffix:(NSString *)suffix
{
    NSString *substringOfText = [textView.text substringWithRange:range];
    if ([substringOfText isEqualToString:suffix])
    {
        NSUInteger location = range.location;
        NSUInteger length = range.length;
        NSString *subText;
        while (YES)
        {
            if (location == 0)
            {
                return YES;
            }
            location--;
            length++;
            subText = [textView.text substringWithRange:NSMakeRange(location, length)];
            if (([subText hasPrefix:prefix] && [subText hasSuffix:suffix]))
            {
                //这里注意，批量删除的字符串，除了前缀和后缀，中间不能有空格出现
                NSString *string = [textView.text substringWithRange:NSMakeRange(location, length - 1)];
                if (![string containsString:@" "])
                {
                    break;
                }
            }
        }

        textView.text = [textView.text stringByReplacingCharactersInRange:NSMakeRange(location, length) withString:@""];
        [textView setSelectedRange:NSMakeRange(location, 0)];
        [self textViewDidChange:self.textView];
        return NO;
    }
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    self.faceButton.selected = self.moreButton.selected = self.voiceButton.selected = NO;
    [self showFaceView:NO];
    [self showMoreView:NO];
    [self showVoiceView:NO];
    return YES;
}

/**
 *  发送普通的文本信息,通知代理
 *
 *  @param text 发送的文本信息
 */
- (void)sendTextMessage:(NSString *)text
{
    if (!text || text.length == 0 || [text isEmpty])
    {
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatBar:sendMessage:)])
    {
        [self.delegate chatBar:self sendMessage:text];
    }
    self.textView.text = @"";
    //self.cachedText = @"";
    self.showType = FWChatBarShowTypeKeyboard;
}

- (void)maskTapAction:(id)tap
{
    [FanweMessage alert:@"无私信权限，请联系客服"];
}

#pragma mark - Private Methods

- (void)keyboardWillHide:(NSNotification *)notification
{

    if (self.isClosed)
    {
        return;
    }
    self.keyboardSize = CGSizeZero;
    if (_showType == FWChatBarShowTypeKeyboard)
    {
        _showType = FWChatBarShowTypeNothing;
    }
    [self updateChatBarKeyBoardConstraints];
    [self updateChatBarConstraintsIfNeeded];
}

- (void)keyboardWillShow:(NSNotification *)notification
{

    if (self.isClosed)
    {
        return;
    }
    CGFloat oldHeight = self.keyboardSize.height;
    self.keyboardSize = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    //兼容搜狗输入法：一次键盘事件会通知两次，且键盘高度不一。
    if (self.keyboardSize.height != oldHeight)
    {
        _showType = FWChatBarShowTypeNothing;
    }
    if (self.keyboardSize.height == 0)
    {
        _showType = FWChatBarShowTypeNothing;
        return;
    }
    // 获取键盘弹出动画时间
    _animationDuration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    self.allowTextViewContentOffset = YES;
    [self updateChatBarKeyBoardConstraints];
    self.showType = FWChatBarShowTypeKeyboard;
}

- (void)updateChatBarKeyBoardConstraints
{
    if (!_mbhalf)
    {
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-self.keyboardSize.height);
        }];
        [UIView animateWithDuration:_animationDuration/4
                         animations:^{
                             [self layoutIfNeeded];
                         }
                         completion:nil];
    }
}

/*!
 * updateChatBarConstraintsIfNeeded: WhenTextViewHeightDidChanged
 * 只要文本修改了就会调用，特殊情况，也会调用：刚刚进入对话追加草稿、键盘类型切换、添加表情信息
 */
- (void)textViewDidChange:(ChatBarTextView *)textView
          shouldCacheText:(BOOL)shouldCacheText
{
    if (shouldCacheText)
    {
    }
    CGRect textViewFrame = self.textView.frame;
    CGSize textSize = [self.textView sizeThatFits:CGSizeMake(CGRectGetWidth(textViewFrame), 1000.0f)];
    // from iOS 7, the content size will be accurate only if the scrolling is enabled.
    textView.scrollEnabled = (textSize.height > kChatBarTextViewFrameMinHeight);
    // textView 控件的高度在 kChatBarTextViewFrameMinHeight 和 kChatBarMaxHeight-offset 之间
    CGFloat newTextViewHeight = MAX(kChatBarTextViewFrameMinHeight, MIN(kChatBarTextViewFrameMaxHeight, textSize.height));
    BOOL textViewHeightChanged = (self.oldTextViewHeight != newTextViewHeight);
    if (textViewHeightChanged)
    {
        //FIXME:如果有草稿，且超出了最低高度，会产生约束警告。
        NSLog(@"%f,,,,,new%f",self.oldTextViewHeight,newTextViewHeight)
        self.oldTextViewHeight = newTextViewHeight;
        [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
            CGFloat height = newTextViewHeight;
            make.height.mas_equalTo(height);
        }];
        //[self chatBarFrameDidChangeShouldScrollToBottom:0.0f showType:self.showType showAnimationTime:0.0f];
    }

    void (^setContentOffBlock)() = ^() {
        if (textView.scrollEnabled && self.allowTextViewContentOffset)
        {
            if (newTextViewHeight == kChatBarTextViewFrameMaxHeight)
            {
                [textView setContentOffset:CGPointMake(0, textView.contentSize.height - newTextViewHeight) animated:YES];
            }
            else
            {
                [textView setContentOffset:CGPointZero animated:YES];
            }
        }
    };

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        setContentOffBlock();
    });
}

#pragma mark - FWChatFaceViewDelegate

- (void)faceViewSendFace:(NSString *)faceName
{
    if ([faceName isEqualToString:@"[删除]"])
    {
        [self textView:self.textView shouldChangeTextInRange:NSMakeRange(self.textView.text.length - 1, 1) replacementText:@""];
    }
    else if ([faceName isEqualToString:@"发送"])
    {
        NSString *text = self.textView.text;
        if (!text || text.length == 0)
        {
            return;
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(chatBar:sendMessage:)])
        {
            [self.delegate chatBar:self sendMessage:text];
        }
        self.textView.text = @"";
        self.showType = FWChatBarShowTypeFace;
    }
    else
    {
        [self appendString:faceName beginInputing:NO];
    }
}

- (void)appendString:(NSString *)string beginInputing:(BOOL)beginInputing
{
    self.allowTextViewContentOffset = YES;
    if (self.textView.text.length > 0 && [string hasPrefix:@"@"] && ![self.textView.text hasSuffix:@" "])
    {
        self.textView.text = [self.textView.text stringByAppendingString:@" "];
    }
    NSString *textViewText;
    NSString *appendedString = [textViewText stringByAppendingString:string];
    self.textView.text = appendedString;
    if (beginInputing && self.keyboardSize.height == 0)
    {
        [self beginInputing];
    }
    else
    {
        [self updateChatBarConstraintsIfNeeded];
    }
}

- (void)chatBarFrameDidChangeShouldScrollToBottom:(CGFloat)keyBoardHeight showType:(FWChatBarShowType)showType showAnimationTime:(CGFloat)showAnimationTime
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatBarFrameDidChange:shouldScrollToBottom:showType:showAnimationTime:)])
    {
        [self.delegate chatBarFrameDidChange:self shouldScrollToBottom:keyBoardHeight showType:showType showAnimationTime:showAnimationTime];
    }
}

- (void)hideChatBottomBar
{
    self.showType = FWChatBarShowTypeNothing;
    [self chatBarFrameDidChangeShouldScrollToBottom:0.0f showType:self.showType showAnimationTime:0.0f];
}

#pragma mark - 根据颜色获取图片
- (UIImage *)createImageWithColor:(UIColor *)color
{
    //图片尺寸
    CGRect rect = CGRectMake(0, 0, 10, 10);
    //填充画笔
    UIGraphicsBeginImageContext(rect.size);
    //根据所传颜色绘制
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    //显示区域
    CGContextFillRect(context, rect);
    // 得到图片信息
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    //消除画笔
    UIGraphicsEndImageContext();
    return image;
}

@end
