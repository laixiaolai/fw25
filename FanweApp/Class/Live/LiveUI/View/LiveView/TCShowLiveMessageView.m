//
//  TCShowLiveMessageView.m
//  TCShow
//
//  Created by AlexiChen on 16/4/14.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "TCShowLiveMessageView.h"

@implementation TCShowLiveMsgTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = kClearColor;
        
        _type = @"0";
        _myFont = [UIFont systemFontOfSize:17.0];
        
        _msgBack = [[UIView alloc] init];
        _msgBack.backgroundColor = kClearColor;
        [self.contentView addSubview:_msgBack];
        
        _msgLabel = [[MLEmojiLabel alloc] initWithFrame:CGRectZero];
        _msgLabel.numberOfLines = 0;
        _msgLabel.font = _myFont;
        _msgLabel.delegate = self;
        _msgLabel.textAlignment = NSTextAlignmentLeft;
        _msgLabel.backgroundColor = [UIColor clearColor];
        _msgLabel.disableThreeCommon = YES; //禁用电话，邮箱，连接三者
        _msgLabel.disableEmoji = NO; //禁用表情
        [_msgBack addSubview:_msgLabel];
        
        _rankImgView = [[UIImageView alloc]init];
        [_msgBack addSubview:_rankImgView];
        _rankImgView.hidden = YES;
    }
    return self;
}

- (BOOL)isHostLive:(NSString *)currentUserId
{
    return [[IMAPlatform sharedInstance].host.profile.identifier isEqualToString:currentUserId];
}

#pragma mark 设置聊天列表信息
- (void)config:(CustomMessageModel *)item block:(FWVoidBlock)block
{
    CustomMessageModel *customMessageModel = (CustomMessageModel *)item;
    
    FWWeakify(self)
    if(customMessageModel.text.length == 0 && customMessageModel.desc.length == 0 && customMessageModel.desc2.length == 0 && customMessageModel.msg.length)
    {
        return;
    }
    
    _customMessageModel = customMessageModel;
    
    GlobalVariables *fanweApp = [GlobalVariables sharedInstance];
    
    if ([customMessageModel.sender.user_id isEqualToString:[[IMAPlatform sharedInstance].host imUserId]] && [[IMAPlatform sharedInstance].host getUserRank] < customMessageModel.sender.user_level)
    {
        [[IMAPlatform sharedInstance].host setUserRank:[NSString stringWithFormat:@"%ld",(long)customMessageModel.sender.user_level]];
    }
    
    NSInteger type = customMessageModel.type;
    
    __block UIColor *messageLabelColor;
    
    // 设置颜色
    if (customMessageModel.fonts_color.length>0)
    {
        NSMutableString *statusbar_color = [NSMutableString stringWithString:customMessageModel.fonts_color];
        if ([statusbar_color hasPrefix:@"#"])
        {
            [statusbar_color deleteCharactersInRange:NSMakeRange(0,1)];
        }
        unsigned int hexValue = 0;
        NSScanner *scanner = [NSScanner scannerWithString:statusbar_color];
        [scanner setScanLocation:0]; // depends on your exact string format you may have to use location 1
        [scanner scanHexInt:&hexValue];
        
        messageLabelColor = RGBOF(hexValue);;
    }
    else
    {
        if (type == MSG_TEXT || type == MSG_POP_MSG)
        {
            messageLabelColor = myTextColorCommonMessage;
        }
        else if(type == MSG_SEND_GIFT_SUCCESS)
        {
            messageLabelColor = myTextColorSendGift;
        }
        else if(type == MSG_LIGHT)
        {
            messageLabelColor = kTextColorSendLight;
        }
        else if (type == MSG_RED_PACKET)
        {
            messageLabelColor = myTextColorRedPackage;
        }
        else if (type == MSG_VIEWER_JOIN)
        {
            messageLabelColor = myTextColorLivingMessage;
        }
        else if (type == MSG_PAI_SUCCESS || type == MSG_PAI_PAY_TIP || type == MSG_PAI_FAULT || type == MSG_ADD_PRICE || type == MSG_PAY_SUCCESS || type == MSG_RELEASE_SUCCESS || type == MSG_STARGOODS_SUCCESS)
        {
            messageLabelColor = kAppSecondaryColor;
        }
        else
        {
            messageLabelColor = myTextColorLivingMessage;
        }
    }
    
    // 整条消息
    NSString *messageStr = @"";
    
    // 设置消息的前半部分显示的内容，当前只有两种形式：1、直播消息 2、等级图标+用户名
    NSString *nameStr = @""; //消息的名字（直播消息或者是用户名字）
    NSString *nickName = customMessageModel.sender.nick_name;
    if ([FWUtils isBlankString:nickName])
    {
        nickName = customMessageModel.user.nick_name;
        if ([FWUtils isBlankString:nickName])
        {
            nickName = @" ";
        }
    }
    
    if(type == MSG_FORBID_SEND_MSG || type == MSG_VIEWER_JOIN || type == MSG_LIVING_MESSAGE || type == MSG_ANCHOR_LEAVE || type == MSG_ANCHOR_BACK || type == MSG_STARGOODS_SUCCESS || type == MSG_RELEASE_SUCCESS)
    {
        //直播消息
        _rankImgView.hidden = YES;
        nameStr = @"直播消息:";
    }
    else if(type == MSG_PAI_SUCCESS || type == MSG_PAI_PAY_TIP || type == MSG_PAI_FAULT || type == MSG_ADD_PRICE || type == MSG_PAY_SUCCESS || type == MSG_BUYGOODS_SUCCESS /*|| type == MSG_RELEASE_SUCCESS*/)
    {
        //竞拍消息 观众购物支付成功消息
        messageStr = [NSString stringWithFormat:@"       %@",messageStr];
        _rankImgView.hidden = NO;
        if (customMessageModel.user.user_level)
        {
            [_rankImgView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"rank_%d",[customMessageModel.user.user_level intValue]]]];
        }
        else
        {
            [_rankImgView setImage:[UIImage imageNamed:@"rank_1"]];
        }
        nameStr = [NSString stringWithFormat:@"%@:", nickName];
    }
    else
    {
        messageStr = [NSString stringWithFormat:@"       %@",messageStr];
        if (customMessageModel.sender.user_level)
        {
            [_rankImgView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"rank_%ld",(long)customMessageModel.sender.user_level]]];
        }
        else
        {
            [_rankImgView setImage:[UIImage imageNamed:@"rank_1"]];
        }
        _rankImgView.hidden = NO;
    
        nameStr = [NSString stringWithFormat:@"%@:", nickName];
    }
    
    // 拼接消息的前半部分
    messageStr = [messageStr stringByAppendingString:nameStr];
    
    // 设置消息的后半部分显示的内容
    NSString *contentStr = @"";
    if (type == MSG_TEXT)
    {
        contentStr = customMessageModel.text;
    }
    else if (type == MSG_POP_MSG)
    {
        contentStr = customMessageModel.desc;
    }
    else if (type == MSG_SEND_GIFT_SUCCESS || type == MSG_RED_PACKET)
    {
        if ([self isHostLive:customMessageModel.sender.imUserId])
        {
            contentStr = customMessageModel.desc2;
        }
        else
        {
            contentStr = customMessageModel.desc;
        }
    }
    else if (type == MSG_ANCHOR_LEAVE || type == MSG_ANCHOR_BACK)
    {
        contentStr = customMessageModel.text;
    }
    else if (type == MSG_LIGHT)
    {
        contentStr = @"我点亮了";
    }
    else if (type == MSG_VIEWER_JOIN)
    {
        if (customMessageModel.sender.user_level >= fanweApp.appModel.jr_user_level)
        {
            contentStr = [NSString stringWithFormat:@"金光一闪，%@ 加入了...",nickName];
        }
        else
        {
            contentStr = [NSString stringWithFormat:@"%@ 来了",nickName];
        }
    }
    else if (type == MSG_PAI_SUCCESS || type == MSG_PAI_PAY_TIP || type == MSG_PAI_FAULT || type == MSG_ADD_PRICE || type == MSG_PAY_SUCCESS )
    {
        if (customMessageModel.desc)
        {
            contentStr = customMessageModel.desc;
        }
    }
    else
    {
        if (customMessageModel.desc)
        {
            contentStr = customMessageModel.desc;
        }
        else if (customMessageModel.text)
        {
            contentStr = customMessageModel.text;
        }
        else
        {
            contentStr = @"";
        }
    }
    
    // 整条消息拼接，message不可能为空，如果为空就意味着判断出错了
    if (contentStr && ![contentStr isEqualToString:@""])
    {
        messageStr = [messageStr stringByAppendingString:[NSString stringWithFormat:@"%@", contentStr]];
    }
    
    @try {
        
        //消息后面跟的图片
        NSString *typeImgStr = LIVE_MSG_TAG;
        if (customMessageModel.icon && [customMessageModel.icon isKindOfClass:[NSString class]])
        {
            if (customMessageModel.icon.length)
            {
                if (!customMessageModel.iconImage)
                {
                    UIImage *cachedImage = [[SDWebImageManager sharedManager].imageCache imageFromDiskCacheForKey:customMessageModel.icon];
                    if (cachedImage)
                    {
                        _msgLabel.customEmojiImage = cachedImage;
                    }
                    else
                    {
                        [[SDWebImageManager sharedManager].imageDownloader downloadImageWithURL:[NSURL URLWithString:customMessageModel.icon] options:SDWebImageDownloaderLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                            
                        } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                            
                            FWStrongify(self)
                            customMessageModel.iconImage = image;
                            self.msgLabel.customEmojiImage = customMessageModel.iconImage;
                            
                            if (block)
                            {
                                block();
                            }
                            
                        }];
                        
                        self.msgLabel.customEmojiImage = [UIImage imageNamed:@"lr_small_gift_no_chat_img"];
                    }
                }
                else
                {
                    _msgLabel.customEmojiImage = customMessageModel.iconImage;
                }
                
                messageStr = [messageStr stringByAppendingString:[NSString stringWithFormat:@"%@", typeImgStr]];
            }
        }
        
        NSString *typeImgStr2 = LIVE_MSG_TAG2;
        if (customMessageModel.imageName && [customMessageModel.imageName isKindOfClass:[NSString class]])
        {
            if (customMessageModel.imageName.length)
            {
                if (!customMessageModel.iconImage)
                {
                    customMessageModel.iconImage = [UIImage imageNamed:customMessageModel.imageName];
                }
                _msgLabel.customImage = customMessageModel.iconImage;
                messageStr = [messageStr stringByAppendingString:[NSString stringWithFormat:@"%@", typeImgStr2]];
            }
        }
        
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:messageStr];
        
        __weak __typeof(self) ws = self;
        
        if (messageStr.length)
        {
            [_msgLabel setText:attr afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
                
                // http://blog.csdn.net/ys410900345/article/details/25976179
                NSShadow *shadow = [[NSShadow alloc] init];
                shadow.shadowOffset = CGSizeMake(3, 3);
                shadow.shadowColor = [UIColor blackColor];
                shadow.shadowBlurRadius = 5;
                [mutableAttributedString setAttributes:@{NSFontAttributeName : ws.myFont, NSForegroundColorAttributeName : messageLabelColor, NSShadowAttributeName : shadow , NSVerticalGlyphFormAttributeName : @(0)} range:NSMakeRange(0, messageStr.length)];
                
                [mutableAttributedString setAttributes:@{NSFontAttributeName : ws.myFont, NSForegroundColorAttributeName : myTextColorUser} range:[messageStr rangeOfString:nameStr]]; //设置会员名称的字体颜色
                return mutableAttributedString;
            }];
        }
        else
        {
            NSLog(@"==========消息设置出错了");
        }
        
        //设置红包的点击
        NSDictionary *redPackageAttributes = @{NSFontAttributeName : _myFont,
                                               NSForegroundColorAttributeName : messageLabelColor,
                                               NSBackgroundColorAttributeName : kClearColor,
                                               NSStrokeColorAttributeName : messageLabelColor,
                                               };
        if (type == MSG_RED_PACKET)
        {
            _type = @"0";
            [_msgLabel addLinkWithTextCheckingResult:[NSTextCheckingResult spellCheckingResultWithRange:[messageStr rangeOfString:contentStr]] attributes:redPackageAttributes];
        }
        
        //设置用户名称的点击
        NSDictionary *attributes = @{NSFontAttributeName : _myFont,
                                     NSForegroundColorAttributeName : myTextColorUser,
                                     NSBackgroundColorAttributeName : kClearColor,
                                     NSStrokeColorAttributeName : myTextColorUser,
                                     };
        if (type == MSG_TEXT || type == MSG_SEND_GIFT_SUCCESS || type == MSG_LIGHT || type == MSG_RED_PACKET)
        {
            _type = @"0";
            [_msgLabel addLinkWithTextCheckingResult:[NSTextCheckingResult spellCheckingResultWithRange:[messageStr rangeOfString:nameStr]] attributes:attributes];
        }
        if (type == MSG_PAI_SUCCESS || type == MSG_PAI_PAY_TIP || type == MSG_PAI_FAULT || type == MSG_ADD_PRICE || type == MSG_PAY_SUCCESS)
        {
            _type = @"2";
            [_msgLabel addLinkWithTextCheckingResult:[NSTextCheckingResult spellCheckingResultWithRange:[messageStr rangeOfString:nameStr]] attributes:attributes];
        }
        
        _msgLabel.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        _msgLabel.shadowOffset = CGSizeMake(1, 1);
        
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self relayoutFrameOfSubViews];
}

- (void)relayoutFrameOfSubViews
{
    CGRect frame = self.contentView.frame;
    frame.size.width = COMMENT_TABLEVIEW_HEIGHT;
    
    CGSize size = _customMessageModel.avimMsgShowSize;
    
    CGRect rect = frame;
    rect.size.height = size.height;
    rect.size.width = size.width;
    _msgBack.frame = rect;
    _msgBack.frame = CGRectMake(CGRectGetMinX(_msgBack.frame), (self.frame.size.height-CGRectGetHeight(_msgBack.frame))/2, CGRectGetWidth(_msgBack.frame), CGRectGetHeight(_msgBack.frame));
    
    rect = _msgBack.bounds;
    if (rect.size.height)
    {
        _msgLabel.frame = rect;
    }
    
    //_rankImgView的Y值
    if (_rankImgView.isHidden == NO)
    {
        CGFloat rankImgViewY = 0;
        if ((_customMessageModel && _customMessageModel.icon) || (_customMessageModel && _customMessageModel.imageName))
        {
            if ([_customMessageModel.icon length] || [_customMessageModel.imageName length])
            {
                rankImgViewY = 8;
            }
            else
            {
                rankImgViewY = 4;
            }
        }
        else
        {
            rankImgViewY = 4;
        }
        CGSize messageLabelSize = _customMessageModel.avimMsgShowSize;
        
        if (messageLabelSize.height >= 26 && messageLabelSize.height < 30)
        {
            rankImgViewY = 8;
        }else if (messageLabelSize.height >= 30)
        {
            rankImgViewY = 4;
        }
        _rankImgView.frame = CGRectMake(0, rankImgViewY, 28, 13);
    }
}


- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithTextCheckingResult:(NSTextCheckingResult *)result
{
    if ([_type isEqualToString:@"2"])
    {
        if (_delegate && [_delegate respondsToSelector:@selector(clickCellUserInfo:)]) {
            [_delegate clickCellUserInfo:self];
        }
    }else
    {
        if (result.range.location == 7)
        {
            if (_delegate && [_delegate respondsToSelector:@selector(clickCellNameRange:)])
            {
                [_delegate clickCellNameRange:self];
            }
        }
        else
        {
            if (_delegate && [_delegate respondsToSelector:@selector(clickCellMessageRange:)])
            {
                [_delegate clickCellMessageRange:self];
            }
        }
    }
}

@end


//============================================================================================================================================================================

#pragma mark - TCShowLiveMessageView
@interface TCShowLiveMessageView ()
{
    BOOL _isScrolling;
}

@end

@implementation TCShowLiveMessageView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.clipsToBounds = YES;
        _canScrollToBottom = YES;
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, COMMENT_TABLEVIEW_WIDTH, COMMENT_TABLEVIEW_HEIGHT)];
        _tableView.delegate = self;
        _tableView.backgroundColor = kClearColor;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        
        [self addSubview:_tableView];
        
        _liveMessages = [[NSMutableArray alloc] init];
        
        // 观众首次进入直播室显示的消息
        for (CustomMessageModel *customMessageModel in [GlobalVariables sharedInstance].listMsgMArray)
        {
            [self insertMsg:customMessageModel];
        }
    }
    return self;
}


#pragma mark - ----------------------- 插入消息 -----------------------
#pragma mark 直接显示
- (void)insertMsg:(id<AVIMMsgAble>)item
{
    if (item && [item isKindOfClass:[CustomMessageModel class]])
    {
        @synchronized(_liveMessages)
        {
            CustomMessageModel *customMessageModel = (CustomMessageModel *)item;
            if (!customMessageModel.avimMsgShowSize.height)
            {
                [customMessageModel prepareForRender];
            }
            
            _msgCount++;
            
            [_tableView beginUpdates];
            
            if (_liveMessages.count >= kMaxMsgCount)
            {
                NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
                [_tableView deleteRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationTop];
                [_liveMessages removeObjectAtIndex:0];
            }
            
            NSIndexPath *index = [NSIndexPath indexPathForRow:_liveMessages.count inSection:0];
            [_tableView insertRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationBottom];
            [_liveMessages addObject:item];
            
            [_tableView endUpdates];
            
            if (_canScrollToBottom)
            {
                [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_liveMessages.count - 1  inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            }
        }
    }
}

#pragma mark 延迟显示
- (void)insertCachedMsg:(AVIMCache *)msgCache
{
    NSInteger msgCacheCount = [msgCache count];
    if (msgCacheCount == 0) {
        return;
    }
    
    @synchronized(_liveMessages)
    {
        _msgCount += msgCacheCount;
        
        while (msgCache.count > 0)
        {
            CustomMessageModel *customMessageModel = [msgCache deCache];
            if (!customMessageModel.avimMsgShowSize.height)
            {
                [customMessageModel prepareForRender];
            }
            
            if (customMessageModel)
            {
                [_liveMessages addObject:customMessageModel];
                if (_liveMessages.count > kMaxMsgCount)
                {
                    [_liveMessages removeObjectAtIndex:0];
                }
            }
        }
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(reloadMyTableView) object:nil];
        
        [self reloadMyTableView];
        
        if (_canScrollToBottom)
        {
            [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_liveMessages.count - 1  inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
    }
}

- (void)reloadMyTableView
{
    //    NSLog(@"==============load count:%d",++_testIndex);
    [_tableView reloadData];
}

#pragma mark - ----------------------- tableView的相关操作 -----------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _liveMessages.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomMessageModel *customMessageModel = [_liveMessages objectAtIndex:indexPath.row];
    return customMessageModel.avimMsgShowSize.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TCShowLiveMsgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCShowLiveMsgTableViewCell"];
    if (!cell)
    {
        cell = [[TCShowLiveMsgTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TCShowLiveMsgTableViewCell"];
        cell.delegate = self;
    }
    
    CustomMessageModel *customMessageModel = [_liveMessages objectAtIndex:indexPath.row];
    [cell config:customMessageModel block:^{
        
        [self performSelector:@selector(reloadMyTableView) withObject:nil afterDelay:1];
        
    }];
    
    return cell;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
//    CGPoint translation = [scrollView.panGestureRecognizer translationInView:scrollView.superview];
    
    _canScrollToBottom = NO;
    
    if ([_contentOffsetTimer isValid])
    {
        [_contentOffsetTimer invalidate];
        _contentOffsetTimer = nil;
    }
    
    _contentOffsetTimer = [NSTimer scheduledTimerWithTimeInterval:kLiveMessageContentOffsetTime target:self selector:@selector(changeScrollToBottomState) userInfo:nil repeats:NO];
}

- (void)changeScrollToBottomState
{
    _canScrollToBottom = !_canScrollToBottom;
}

#pragma mark 点击消息列表中的用户名称
- (void)clickCellNameRange:(TCShowLiveMsgTableViewCell *) cell
{
    if (_delegate && [_delegate respondsToSelector:@selector(clickNameRange:)])
    {
        [_delegate clickNameRange:cell.customMessageModel];
    }
}

#pragma mark 点击消息列表中的具体消息内容（目前会响应点击事件的是：红包）
- (void)clickCellMessageRange:(TCShowLiveMsgTableViewCell *) cell
{
    if (_delegate && [_delegate respondsToSelector:@selector(clickMessageRange:)])
    {
        [_delegate clickMessageRange:cell.customMessageModel];
    }
}

- (void)clickCellUserInfo:(TCShowLiveMsgTableViewCell *)cell
{
    if (_delegate && [_delegate respondsToSelector:@selector(clickUserInfo:)])
    {
        [_delegate clickUserInfo:cell.customMessageModel.user];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomMessageModel *customMessageModel = [_liveMessages objectAtIndex:indexPath.row];
    
    if (customMessageModel.type== MSG_STARGOODS_SUCCESS)
    {
        if (_delegate && [_delegate respondsToSelector:@selector(clickGoodsMessage:)])
        {
            [_delegate clickGoodsMessage:customMessageModel];
        }
    }
}

- (void)dealloc
{
    if ([_contentOffsetTimer isValid])
    {
        [_contentOffsetTimer invalidate];
        _contentOffsetTimer = nil;
    }
}

@end

