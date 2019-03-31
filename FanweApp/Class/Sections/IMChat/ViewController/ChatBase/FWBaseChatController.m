//
//  FWBaseChatController.m
//  FanweApp
//
//  Created by 朱庆彬 on 2017/8/18.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "FWBaseChatController.h"
#import "ChatAudioRecordNoticeView.h"
#import "ChatEmojiView.h"
#import "ConversationModel.h"
#import "EmojiObj.h"
#import "M80AttributedLabel.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import "MsgCellLeft.h"
#import "MsgCellRight.h"
#import "MsgGiftCellLeft.h"
#import "MsgGiftCellRight.h"
#import "MsgPicCellLeft.h"
#import "MsgPicCellRight.h"
#import "MsgTimeCell.h"
#import "MsgVoiceCellLeft.h"
#import "MsgVoiceCellRight.h"
#import "UIImageView+WebCache.h"
#import <AVFoundation/AVFoundation.h>

@interface FWBaseChatController () <UITextViewDelegate, UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, AVAudioRecorderDelegate, AVAudioPlayerDelegate, UIGestureRecognizerDelegate, ChatBottomBarDelegate, ChatEmojiViewDelegate, ChatMoreViewDelegate>

@end

@implementation FWBaseChatController
{

    BOOL _cgfok;
    BOOL _doing;
    CGFloat _moreXpoint;
    CGFloat _giftXpoint;
    CGFloat _lastInputH;
    ChatAudioRecordNoticeView *_recshowing;
    AVAudioRecorder *_recorder;
    BOOL _brecwillsend;
    NSTimer *_timer;
    NSTimeInterval _recduration;
    AVAudioPlayer *_player;
    ConversationModel *_nowplayingmsg;
}

- (void)releaseAll
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dealloc
{
    [self releaseAll];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self releaseAll];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}

- (void)backclicked:(id)sender
{
    if ([self.navigationController topViewController] == self)
    { //如果有导航控制器,,并且顶部就是自己,,那么应该 返回
        if (self.navigationController.viewControllers.count == 1)
        { //如果只有一个,,,那么
            if (self.presentingViewController)
            { //如果有,,那么就dismiss

                [self dismissViewControllerAnimated:YES
                                         completion:^{

                                         }];
                return;
            }
            else
            {
            }
        }
        else
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else //其他情况,就再判断是否有 presentingViewController
        if (self.presentingViewController)
    { //如果有,,那么就dismiss
        [self dismissViewControllerAnimated:YES
                                 completion:^{

                                 }];
        return;
    }
    else
    {
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.fanweApp = [GlobalVariables sharedInstance];
    //判断当前是否有直播
    if ([[GlobalVariables sharedInstance].liveState.roomId intValue])
    {
        _haveLiveExist = YES;
    }
    else
    {
        _haveLiveExist = NO;
    }
    UITapGestureRecognizer* tapgusest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(taprootview:)];
    tapgusest.delegate = self;
    [self.view addGestureRecognizer:tapgusest];
    self.mtopview.backgroundColor = [UIColor whiteColor];
    self.mtableview.backgroundColor = RGBA(233, 233, 233, 1);
    self.mmsgdata = NSMutableArray.new;
    if (!self.mCannotLoadHistoryMsg)
    {
        [FWMJRefreshManager refresh:self.mtableview target:self headerRereshAction:@selector(headerStartRefresh) footerRereshAction:nil];
    }
    if (!self.mCannotLoadNewestMsg)
        self.mtableview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerStartRefresh)];

    UINib *nib = [UINib nibWithNibName:@"MsgCellLeft" bundle:nil];
    [self.mtableview registerNib:nib forCellReuseIdentifier:@"leftcell"];
    nib = [UINib nibWithNibName:@"MsgCellRight" bundle:nil];
    [self.mtableview registerNib:nib forCellReuseIdentifier:@"rightcell"];
    nib = [UINib nibWithNibName:@"MsgTimeCell" bundle:nil];
    [self.mtableview registerNib:nib forCellReuseIdentifier:@"timecell"];
    nib = [UINib nibWithNibName:@"MsgVoiceCellRight" bundle:nil];
    [self.mtableview registerNib:nib forCellReuseIdentifier:@"voicerightcell"];
    nib = [UINib nibWithNibName:@"MsgVoiceCellLeft" bundle:nil];
    [self.mtableview registerNib:nib forCellReuseIdentifier:@"voiceleftcell"];
    nib = [UINib nibWithNibName:@"MsgPicCellLeft" bundle:nil];
    [self.mtableview registerNib:nib forCellReuseIdentifier:@"picleftcell"];
    nib = [UINib nibWithNibName:@"MsgPicCellRight" bundle:nil];
    [self.mtableview registerNib:nib forCellReuseIdentifier:@"picrightcell"];
    nib = [UINib nibWithNibName:@"MsgGiftCellRight" bundle:nil];
    [self.mtableview registerNib:nib forCellReuseIdentifier:@"gifrightcell"];
    nib = [UINib nibWithNibName:@"MsgGiftCellLeft" bundle:nil];
    [self.mtableview registerNib:nib forCellReuseIdentifier:@"gifleftcell"];
    self.mtableview.delegate = self;
    self.mtableview.dataSource = self;
    self.mtableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (!self.mDontAutoLoadFrist)
    {
        if (!self.mCannotLoadHistoryMsg)
            [self.mtableview.mj_header beginRefreshing];
        else if (!self.mCannotLoadNewestMsg)
            [self.mtableview.mj_footer beginRefreshing];
    }
    self.userMsgArray = NSMutableArray.new;
    [self.chatBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.equalTo(self.view);
        make.height.mas_greaterThanOrEqualTo(@(kChatBarMinHeight));
    }];
    [self.mtableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(self.mtopview).with.offset(self.mtopview.height);
        make.bottom.equalTo(self.chatBar).with.offset(-kChatBarMinHeight);
    }];
}

- (UITableView *)mtableview
{
    if (!_mtableview)
    {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [self.view addSubview:_mtableview = tableView];
    }
    return _mtableview;
}

- (UIView *)mtopview
{
    if (!_mtopview)
    {
        CGFloat navHeight;
        if (_mbhalf)
        {
            navHeight = 44;
        }
        else
        {
            navHeight = kNavigationBarHeight+kStatusBarHeight;
        }
        UIView *mtopView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, navHeight)];
        mtopView.backgroundColor = [UIColor whiteColor];
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, navHeight - 0.5, kScreenW, 0.5f)];
        lineView.backgroundColor = RGBA(201, 202, 205, 1);
        [mtopView addSubview:lineView];

        UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, navHeight - 44, 22, 44)];
        [backBtn setImage:[UIImage imageNamed:@"com_arrow_vc_back"] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(backclicked:) forControlEvents:UIControlEventTouchUpInside];
        [mtopView addSubview:backBtn];

        _mtoptitle = [[UILabel alloc] initWithFrame:CGRectMake(80, navHeight - 29.5, kScreenW - 160, 15)];
        _mtoptitle.font = [UIFont systemFontOfSize:15];
        _mtoptitle.textColor = [FWUtils colorWithHexString:@"333333"];
        _mtoptitle.textAlignment = NSTextAlignmentCenter;
        [mtopView addSubview:_mtoptitle];
        
        UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenW - 40, navHeight - 33, 20, 20)];
        [rightBtn setImage:[UIImage imageNamed:@"ic_chattophead"] forState:UIControlStateNormal];
        [rightBtn addTarget:self action:@selector(clickedtophead:) forControlEvents:UIControlEventTouchUpInside];
        [mtopView addSubview:rightBtn];
        [self.view addSubview:_mtopview = mtopView];
        
        UITapGestureRecognizer *doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTapScrollToTop:)];
        [doubleTapGestureRecognizer setNumberOfTapsRequired:2];
        [_mtopview addGestureRecognizer:doubleTapGestureRecognizer];
        
    }
    return _mtopview;
}

- (ChatBottomBarView *)chatBar
{
    if (!_chatBar)
    {
        NSMutableArray *allmore = [@[
            @[@"照片", @"ic_private_chat_more_photo"],
            @[@"拍摄", @"ic_private_chat_more_camera"],
            @[@"礼物", @"ic_private_chat_more_gift"],
        ] mutableCopy];
        if (self.fanweApp.appModel.open_send_coins_module == 1)
        {
            [allmore addObject:@[@"赠送游戏币", @"ic_private_chat_more_money"]];
        }
        if (self.fanweApp.appModel.open_send_diamonds_module == 1)
        {
            NSString *diamondsStr = [NSString stringWithFormat:@"赠送%@",self.fanweApp.appModel.diamond_name];
            [allmore addObject:@[diamondsStr, @"ic_private_chat_more_diamonds"]];
        }
        // 修改 pic 数组   去掉相机2
        if (_haveLiveExist)
        {
            [allmore removeObjectAtIndex:1]; // 去掉  相机
        }

        ChatBottomBarView *chatBar = [[ChatBottomBarView alloc] init];
        chatBar.delegate = self;
        [self.view addSubview:(_chatBar = chatBar)];
        [self.view bringSubviewToFront:_chatBar];
        chatBar.textView.delegate = self;
        self.chatBar.emojiView.delegate = self;
        self.chatBar.moreView.delegate = self;
        [self.chatBar.voiceRecordButton addTarget:self action:@selector(onTouchRecordBtnDown:) forControlEvents:UIControlEventTouchDown];
        [self.chatBar.voiceRecordButton addTarget:self action:@selector(onTouchRecordBtnDragInside:) forControlEvents:UIControlEventTouchDragInside];
        [self.chatBar.voiceRecordButton addTarget:self action:@selector(onTouchRecordBtnDragOutside:) forControlEvents:UIControlEventTouchDragOutside];
        [self.chatBar.voiceRecordButton addTarget:self action:@selector(onTouchRecordBtnUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [self.chatBar.voiceRecordButton addTarget:self action:@selector(onTouchRecordBtnUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
        [self.chatBar.moreView initWithBtnArray:allmore];
        self.chatBar.mbhalf = _mbhalf;
        if (self.fanweApp.appModel.has_private_chat == 1)
        {
            if (self.fanweApp.appModel.private_letter_lv)
            {
                if ([[IMAPlatform sharedInstance].host getUserRank] >= self.fanweApp.appModel.private_letter_lv)
                {
                    //允许
                    self.chatBar.maskView.hidden = YES;
                }
                else
                {
                    self.chatBar.maskView.hidden = NO;
                }
            }
            else
            {
                //允许
                self.chatBar.maskView.hidden = YES;
            }
        }
        else
        {
            self.chatBar.maskView.hidden = NO;
        }
    }
    return _chatBar;
}

#pragma mark 消息数据获取主要修改这里开始
//获取消息,修改这里
- (void)headerStartRefresh
{
    ConversationModel *fmsg = nil;
    for (ConversationModel *one in self.mmsgdata)
    {
        if (one.mMsgType != 0)
        {
            fmsg = one;
            break;
        }
    }
    FWWeakify(self)
        [self getMsgBefor:fmsg
                    block:^(NSArray *all) {

                        FWStrongify(self)
                            //如果用户头像更新。则更新所有消息里 头像的
                            [self upDataForMsgHeaderImg:all];

                        [FWMJRefreshManager endRefresh:self.mtableview];
                        if (all.count)
                        {
                            int timecellcount = 0;
                            NSUInteger msgCount = self.mmsgdata.count;
                            for (NSInteger j = all.count - 1; j >= 0; j--)
                            {
                                // ConversationModel* one  = all[ j ];
                                SIMMsgObj *one = all[j];
                                // 子类有用户ID
                                for (SIMMsgObj *j in _userMsgArray)
                                {
                                    if (one.mHeadImgUrl == nil || [one.mHeadImgUrl isEqual:[NSNull null]])
                                    {
                                        one.mHeadImgUrl = @" ";
                                    }
                                    if (j.mSenderId == one.mSenderId && ![one.mHeadImgUrl isEqualToString:j.mHeadImgUrl])
                                    {
                                        one.mHeadImgUrl = j.mHeadImgUrl;
                                    }
                                }
                                [self.mmsgdata insertObject:one atIndex:0];

                                if ((self.mmsgdata.count % 8) == 0)
                                { //每5个就显示一个时间..
                                    ConversationModel *timemsg = [self makeTimeMsgObj:one];
                                    [self.mmsgdata insertObject:timemsg atIndex:1];
                                    timecellcount++;
                                }
                            }

                            [self.mtableview reloadData];
                            if (msgCount == 0)
                            {
                                [self.mtableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:all.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                            }
                            else
                            {
                                NSInteger index = all.count + timecellcount + 1;
                                index = index >= self.mmsgdata.count ? (self.mmsgdata.count - 1) : index;

                                [self.mtableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                            }
                        }

                    }];
}

- (void)upDataForMsgHeaderImg:(NSArray *)all
{
    if (all.count > 0)
    {
        SIMMsgObj *last = [all firstObject];
        for (NSInteger j = 0; j < all.count; j++)
        {
            SIMMsgObj *one = all[j];

            BOOL isNew = YES;
            for (int i = 0; i < _userMsgArray.count; i++)
            {
                SIMMsgObj *b = _userMsgArray[i];
                if (b.mSenderId == one.mSenderId)
                {
                    isNew = NO;
                    if ([b.mMsgDate compare:one.mMsgDate] == -1)
                    {
                        [_userMsgArray replaceObjectAtIndex:i withObject:one];
                    }
                    break;
                }
            }

            if (isNew)
            {
                [_userMsgArray addObject:one];
            }

            last = one;
        }
    }

    for (SIMMsgObj *a in _userMsgArray)
    {
        NSInteger mUser_id = 0;
        NSString *mHead_image = @"";

        if (self.dic)
        {
            mUser_id = [[self.dic objectForKey:@"mUser_id"] integerValue];
            mHead_image = [self.dic objectForKey:@"mHead_image"];
        }
        //yue
        if (a.mHeadImgUrl == nil || [a.mHeadImgUrl isEqual:[NSNull null]])
        {
            a.mHeadImgUrl = @" ";
        }
        if (a.mSenderId == [[IMAPlatform sharedInstance].host.imUserId intValue] && ![a.mHeadImgUrl isEqualToString:[[IMAPlatform sharedInstance].host.customInfoDict objectForKey:@"head_image"]])
        {
            a.mHeadImgUrl = [[IMAPlatform sharedInstance].host.customInfoDict objectForKey:@"head_image"];
        }
        else if (a.mSenderId == mUser_id && ![a.mHeadImgUrl isEqualToString:mHead_image])
        {
            a.mHeadImgUrl = mHead_image;
        }
    }
}

- (void)footerStartRefresh
{
    ConversationModel *findlast = nil;

    for (NSInteger j = self.mmsgdata.count - 1; j >= 0; j--)
    {
        ConversationModel *one = self.mmsgdata[j];
        if (one.mMsgType != 0)
        {
            findlast = one;
            break;
        }
    }

    FWWeakify(self)
        [self getMsgAfter:findlast
                    block:^(NSArray *all) {

                        FWStrongify(self)
                            [FWMJRefreshManager endRefresh:self.mtableview];
                        if (all.count)
                        {
                            int timecellcount = 0;
                            NSUInteger msgCount = self.mmsgdata.count;
                            for (NSInteger j = 0; j < all.count; j++)
                            {
                                ConversationModel *one = all[j];
                                [self.mmsgdata addObject:one];
                                if ((self.mmsgdata.count % 8) == 0)
                                { //每5个就显示一个时间..
                                    ConversationModel *timemsg = [self makeTimeMsgObj:one];
                                    [self.mmsgdata addObject:timemsg];
                                    timecellcount++;
                                }
                            }

                            [self.mtableview reloadData];

                            if (msgCount == 0)
                            {
                                [self.mtableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.mmsgdata.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
                            }
                        }
                    }];
}

//获取 msg 之前的消息,,,
- (void)getMsgBefor:(ConversationModel *)msg block:(void (^)(NSArray *all))block
{
}

//获取 msg 之后的消息
- (void)getMsgAfter:(ConversationModel *)msg block:(void (^)(NSArray *all))block
{
}

- (ConversationModel *)makeTimeMsgObj:(ConversationModel *)msg
{
    ConversationModel *tt = ConversationModel.new;
    tt.mMsgDate = msg.mMsgDate;
    return tt;
}

- (void)willSendThisText:(NSString *)txt
{
    self.chatBar.textView.text = @"";
    if (![self.chatBar.textView isFirstResponder]) {
        [self.chatBar.textView resignFirstResponder];
    }
    [self.chatBar updateChatBarConstraintsIfNeededShouldCacheText:YES];
}

- (void)willSendThisImg:(UIImage *)img
{
}

- (void)willSendThisVoice:(NSURL *)voicepath duration:(NSTimeInterval)duration
{
}

//发送完成,,当异步发送完成之后,调用该函数
- (void)didSendThisMsg:(ConversationModel *)msg
{
    if (msg == nil)
        return;

    if (![self.mmsgdata containsObject:msg])
    { //如果还没有,就添加...
        [self addOneMsg:msg];
        return;
    }
    //就是更新下状态
    [self updateOneMsg:msg];
}

//需要重新发送
- (void)willReSendThisMsg:(ConversationModel *)msg
{
    //开始发送
    msg.mMsgStatus = 1;
    [self updateOneMsg:msg];

    //for testcode
    if ([NSStringFromClass([self class]) isEqualToString:NSStringFromClass([FWBaseChatController class])])
    {
    }
}

- (void)wantFetchMsg:(ConversationModel *)msg block:(void (^)(NSString *errmsg, ConversationModel *msg))block
{
    [msg fetchMsgData:^(NSString *errmsg) {

        block(errmsg, msg);

    }];
}

- (void)addOneMsg:(ConversationModel *)sendMsg
{
    if ([self.mmsgdata containsObject:sendMsg])
        return;

    [self.mmsgdata addObject:sendMsg];
    [self.mtableview beginUpdates];

    [self.mtableview insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.mmsgdata.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.mtableview endUpdates];

    [self updateOnSendMessage:self.mmsgdata];
}

- (void)updateOnSendMessage:(NSArray *)msglist
{
    if (msglist.count)
    {
        NSInteger index = [_mmsgdata indexOfObject:msglist.lastObject];
        [_mtableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}

//删除一条消息
- (void)delOneMsg:(ConversationModel *)delMsg
{
    NSUInteger index = [self.mmsgdata indexOfObject:delMsg];
    if (index == NSNotFound)
        return;

    [self.mmsgdata removeObjectAtIndex:index];
    [self.mtableview beginUpdates];

    [self.mtableview deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.mtableview endUpdates];
}

//更新一条消息
- (void)updateOneMsg:(ConversationModel *)updMsg
{
    NSUInteger index = [self.mmsgdata indexOfObject:updMsg];
    if (index == NSNotFound)
        return;

    [self.mtableview reloadData];
    return;

    [self.mmsgdata replaceObjectAtIndex:index withObject:updMsg];

    CGPoint point = self.mtableview.contentOffset;

    [self.mtableview beginUpdates];
    [self.mtableview reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    [self.mtableview endUpdates];

    [self.mtableview setContentOffset:point];
}

#pragma mark 消息数据获取主要修改这里结束

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.mmsgdata.count;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ConversationModel *msgobj = self.mmsgdata[indexPath.row];

    MsgCellRight *retcell = nil;
    if (msgobj.mMsgType == 1)
    { //文字消息
        ConversationModel *textobj = msgobj;
        if (textobj.mIsSendOut)
        {
            retcell = [tableView dequeueReusableCellWithIdentifier:@"rightcell"];
            if (msgobj.mMsgStatus == 1)
            {
                [retcell.msv startAnimating];
            }
            else
            {
                [retcell.msv stopAnimating];
            }
            retcell.mfailedicon.hidden = !(msgobj.mMsgStatus == 2);
        }
        else
        {
            retcell = [tableView dequeueReusableCellWithIdentifier:@"leftcell"];
        }

        [retcell.mmsglabel dealFace:textobj.mTextMsg];

        CGSize ss = [retcell.mmsglabel sizeThatFits:CGSizeMake(tableView.bounds.size.width - 73 - 50, CGFLOAT_MAX)];
        retcell.mlabelconstH.constant = ss.height;
        retcell.mlabelconstW.constant = ss.width;
    }
    else if (msgobj.mMsgType == 2)
    { //图片
        ConversationModel *picobj = msgobj;

        MsgPicCellRight *piccell = nil;
        if (picobj.mIsSendOut)
        {
            piccell = [tableView dequeueReusableCellWithIdentifier:@"picrightcell"];

            if (msgobj.mMsgStatus == 1)
            {
                [piccell.msv startAnimating];
            }
            else
            {
                [piccell.msv stopAnimating];
            }
            piccell.mfailedicon.hidden = !(msgobj.mMsgStatus == 2);
        }
        else
        {
            piccell = [tableView dequeueReusableCellWithIdentifier:@"picleftcell"];
        }

#pragma mark 图片最宽
        CGFloat picShowW = tableView.bounds.size.width - 280.0f;      //这是最大的
        CGFloat screenW = picobj.mPicW / [UIScreen mainScreen].scale; //真正屏幕宽度
        picShowW = screenW > picShowW ? picShowW : screenW;
        picShowW = picShowW == 0.0f ? (100.0f) : picShowW;

        CGFloat picShowH = (picobj.mPicH / picobj.mPicW) * picShowW;

        picShowH = picShowH == 0.0f ? (100.0f) : picShowH;

        if (picobj.mImgObj)
        {
            piccell.mtagimg.image = picobj.mImgObj;
        }
        else
        {
            [piccell.mtagimg sd_setImageWithURL:[NSURL URLWithString:picobj.mPicURL] placeholderImage:[UIImage imageNamed:@"DefaultImg"]];
        }

        piccell.mimgconstH.constant = picShowH;
        piccell.mimgconstW.constant = picShowW;

        retcell = piccell;
    }
    else if (msgobj.mMsgType == 3)
    { //语音
        ConversationModel *voiceobj = msgobj;
        MsgVoiceCellRight *vcell = nil;
        if (voiceobj.mIsSendOut)
        {
            vcell = [tableView dequeueReusableCellWithIdentifier:@"voicerightcell"];
            if (voiceobj.mIsPlaying)
            {
                vcell.mvoiceicon.image = nil;
                vcell.mvoiceicon.image =
                    [UIImage animatedImageWithImages:@[
                        [UIImage imageNamed:@"ic_play_voice_right0"],
                        [UIImage imageNamed:@"ic_play_voice_right1"],
                        [UIImage imageNamed:@"ic_play_voice_right2"],
                        [UIImage imageNamed:@"ic_play_voice_right3"],
                        [UIImage imageNamed:@"ic_play_voice_right4"],
                        [UIImage imageNamed:@"ic_play_voice_right5"],
                    ]
                                            duration:1.8f];
            }
            else
            {
                vcell.mvoiceicon.image = [UIImage imageNamed:@"ic_play_voice_right0"];
            }
        }
        else
        {
            vcell = [tableView dequeueReusableCellWithIdentifier:@"voiceleftcell"];
            if (voiceobj.mIsPlaying)
            {
                vcell.mvoiceicon.image = nil;
                vcell.mvoiceicon.image =
                    [UIImage animatedImageWithImages:@[
                        [UIImage imageNamed:@"ic_play_voice_left0"],
                        [UIImage imageNamed:@"ic_play_voice_left1"],
                        [UIImage imageNamed:@"ic_play_voice_left2"],
                        [UIImage imageNamed:@"ic_play_voice_left3"],
                        [UIImage imageNamed:@"ic_play_voice_left4"],
                        [UIImage imageNamed:@"ic_play_voice_left5"],
                    ]
                                            duration:1.8f];
            }
            else
            {
                vcell.mvoiceicon.image = [UIImage imageNamed:@"ic_play_voice_left0"];
            }
        }

        vcell.mlonglabel.text = [NSString stringWithFormat:@"%.1f''", voiceobj.mDurlong];
        CGFloat ff = (voiceobj.mDurlong / 60.0f) * 150.0f;
#pragma mark 声音cell最宽,最窄
        ff = ff < 50 ? 50.0f : ff;
        ff = ff > 150.0f ? 150.0f : ff;

        vcell.mlongrateconstW.constant = ff;

        retcell = vcell;
    }
    else if (msgobj.mMsgType == 4)
    {
        ConversationModel *gifobj = msgobj;
        MsgGiftCellRight *giftcell = nil;
        if (gifobj.mIsSendOut)
        {
            giftcell = [tableView dequeueReusableCellWithIdentifier:@"gifrightcell"];
            giftcell.mjy.text = gifobj.mJyStr;

            if (msgobj.mMsgStatus == 1)
            {
                [giftcell.msv startAnimating];
            }
            else
            {
                [giftcell.msv stopAnimating];
            }
            giftcell.mfailedicon.hidden = !(msgobj.mMsgStatus == 2);
        }
        else
        {
            giftcell = [tableView dequeueReusableCellWithIdentifier:@"gifleftcell"];
        }

        //刷新直播间的游戏币
        if (_mbhalf)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateCoin" object:nil];
        }

        [giftcell.mgificon sd_setImageWithURL:[NSURL URLWithString:gifobj.mGiftIconURL] placeholderImage:nil];
        giftcell.mgifdesc.text = gifobj.mGiftDesc;

        retcell = giftcell;
    }
    else
    { //其他什么鬼...其他所有消息都当真时间消息处理了....

        ConversationModel *timeobj = msgobj;
        MsgTimeCell *timecell = [tableView dequeueReusableCellWithIdentifier:@"timecell"];

        timecell.mtimelabel.text = [timeobj getTimeStr];
        timecell.selectionStyle = UITableViewCellSelectionStyleNone;
        return timecell;
    }
    //yue
    if (msgobj.mHeadImgUrl == nil || [msgobj.mHeadImgUrl isEqual:[NSNull null]])
    {
        msgobj.mHeadImgUrl = @" ";
    }
    [retcell.mheadimg sd_setImageWithURL:[NSURL URLWithString:msgobj.mHeadImgUrl] placeholderImage:[UIImage imageNamed:@"ic_default_head"]];
    retcell.selectionStyle = UITableViewCellSelectionStyleNone;
    retcell.backgroundColor = [UIColor clearColor];
    return retcell;
}

- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ConversationModel *msgobj = self.mmsgdata[indexPath.row];
    if (msgobj.mMsgType == 1)
    {
        return YES;
    }
    return NO;
}

//每个cell都会点击出现Menu菜单
- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if (action == @selector(copy:))
    {
        return YES;
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if (action == @selector(copy:))
    {
        ConversationModel *msgobj = self.mmsgdata[indexPath.row];
        [UIPasteboard generalPasteboard].string = msgobj.mTextMsg;
    }
}

- (void)failedIconTouched:(NSIndexPath *)indexPath iconhiden:(BOOL)iconhiden
{
    if (iconhiden)
        return;

    ConversationModel *msgobj = self.mmsgdata[indexPath.row];
    if (msgobj.mMsgStatus == 2)
    {
        [self willReSendThisMsg:msgobj];
        return;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ConversationModel *msgobj = self.mmsgdata[indexPath.row];

    [self msgClicked:msgobj];
}

- (void)msgClicked:(ConversationModel *)msgobj
{
    if (msgobj.mMsgType == 3)
    { //播放语音消息

        [self playVoiceMsg:(ConversationModel *) msgobj
                     block:^(BOOL playing) {

                         if (playing)
                             [self.mtableview reloadData];
                     }];
    }
    else if (msgobj.mMsgType == 2)
    { //查看大图

        MJPhoto *pp = MJPhoto.new;
        pp.url = [NSURL URLWithString:msgobj.mPicURL];
        pp.srcImageView = nil;

        MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
        browser.currentPhotoIndex = 0;
        browser.photos = @[pp];
        [browser show];
    }
}

- (void)playVoiceMsg:(ConversationModel *)msg block:(void (^)(BOOL playing))block
{
    [_player stop];
    _player = nil;
    if (msg == _nowplayingmsg)
    {
        [self stopPlayVoice:msg];
        _nowplayingmsg = nil;
        return; //这种就是停止的意思
    }

    if (msg.mVoiceData == nil)
    {
        //数据没有就填充下,,,具体是用URL下载,还是怎么的,自己处理
        [self wantFetchMsg:msg
                     block:^(NSString *errmsg, ConversationModel *msg) {

                         if (errmsg)
                         {
                             [SVProgressHUD showErrorWithStatus:errmsg];
                         }
                         else
                         {
                             block([self realPlayVoice:msg]);
                         }

                     }];
        return;
    }

    block([self realPlayVoice:msg]);
}

- (BOOL)realPlayVoice:(ConversationModel *)msg
{
    NSError *error = nil;
    _player = [[AVAudioPlayer alloc] initWithData:msg.mVoiceData error:&error];

    _player.delegate = self;
    _nowplayingmsg = msg;
    _nowplayingmsg.mIsPlaying = YES;

    if (_player == nil || ![_player prepareToPlay] || ![_player play])
    {
        [SVProgressHUD showErrorWithStatus:@"播放该消息失败"];
        [self stopPlayVoice:msg];
        _nowplayingmsg = nil;
        return NO;
    }
    return YES;
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self stopPlayVoice:_nowplayingmsg];
    _nowplayingmsg = nil;
}

/* if an error occurs while decoding it will be reported to the delegate. */
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *__nullable)error
{
    [self stopPlayVoice:_nowplayingmsg];
    _nowplayingmsg = nil;
}

- (void)stopPlayVoice:(ConversationModel *)msg
{
    msg.mIsPlaying = NO;
    NSUInteger ii = [self.mmsgdata indexOfObject:msg];
    if (ii == NSNotFound)
    {
    }
    else
    {
        [self.mtableview reloadData];
        return;

        NSIndexPath *iiii = [NSIndexPath indexPathForRow:ii inSection:0];
        [self.mtableview reloadRowsAtIndexPaths:@[iiii] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void)showGiftView
{
    FWWeakify(self)
        [[IMAPlatform sharedInstance].host getMyInfo:^(AppBlockModel *blockModel) {

            FWStrongify(self)

                [(GiftView *) self.mGiftView setDiamondsLabelTxt:[NSString stringWithFormat:@"%ld", [[IMAPlatform sharedInstance].host getDiamonds]]];

        }];

    //隐藏背景的view
    //self.chatBar.moreView.hidden = YES;
    [self.chatBar.moreView setGiftView:NO];

    if (self.mGiftView == nil)
        return;
    if (!self.mGiftView.hidden)
        return;
    if (_doing)
        return;
    _doing = YES;

    CGRect ff = self.mGiftView.frame;
    ff.origin.y = ff.size.height * 1;
    self.mGiftView.frame = ff;

    if (self.mGiftView.superview == nil)
        [self.chatBar.moreView addSubview:self.mGiftView];

    self.mGiftView.hidden = NO;

    [UIView animateWithDuration:0.1f
        animations:^{

            CGRect fff = self.mGiftView.frame;
            fff.origin.y = 0.0f;
            self.mGiftView.frame = fff;

        }
        completion:^(BOOL finished) {

            _doing = NO;

        }];
}

- (void)hidenGiftView
{
    [self.chatBar.moreView setGiftView:YES];
    if (self.mGiftView == nil)
        return;
    if (self.mGiftView.hidden)
        return;
    if (_doing)
        return;
    _doing = YES;

    [UIView animateWithDuration:0.1f
        animations:^{

            CGRect fff = self.mGiftView.frame;
            fff.origin.y = fff.size.height * 1;
            self.mGiftView.frame = fff;

        }
        completion:^(BOOL finished) {

            self.mGiftView.hidden = YES;
            _doing = NO;

        }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *, id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];

    UIImage *tagimg = [info objectForKey:UIImagePickerControllerOriginalImage];

    CGSize imagesize = tagimg.size;
    if (tagimg.size.width>2000) {
        //设置image的尺寸
        imagesize.height = imagesize.height/4;
        imagesize.width = imagesize.width/4;
    }
    //对图片大小进行压缩--
    tagimg = [self imageWithImage:tagimg scaledToSize:imagesize];
    
    UIImageOrientation *imageOrientation = tagimg.imageOrientation;
    if (imageOrientation != UIImageOrientationUp) {
        // 原始图片可以根据照相时的角度来显示，但UIImage无法判定，于是出现获取的图片会向左转９０度的现象。
        // 以下为调整图片角度的部分
        UIGraphicsBeginImageContext(tagimg.size);
        [tagimg drawInRect:CGRectMake(0, 0, tagimg.size.width, tagimg.size.height)];
        tagimg = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        // 调整图片角度完毕
    }
    
    NSData *data;
    data = UIImageJPEGRepresentation(tagimg, 0.5);//压缩图片的比例
    UIImage *newImg = [UIImage imageWithData:data];
    if (newImg == nil)
    {
        [SVProgressHUD showErrorWithStatus:@"图片无效!请重新选择"];
        return;
    }
    [self willSendThisImg:newImg];
}

//对图片尺寸进行压缩
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView == self.chatBar.textView)
    {

        if ([text isEqualToString:@"\n"])
        {

            if (textView.text.length == 0)
            {
                [SVProgressHUD showErrorWithStatus:@"请先输入发送内容"];
                return NO;
            }

            [self willSendThisText:[self.chatBar.textView getSendTextStr]];
            return NO;
        }
    }
    return YES;
}

#pragma mark 录音操作开始
- (void)onTouchRecordBtnDown:(id)sender
{
    [self showRecSV:1];
    [self startRecordeAudio];
}

- (void)onTouchRecordBtnUpInside:(id)sender
{
    // finish Recording
    //self.recordPhase = AudioRecordPhaseEnd;
    [self showRecSV:4];
    _brecwillsend = YES;
    [self stopRecordeAudio];
}

- (void)onTouchRecordBtnUpOutside:(id)sender
{
    //TODO cancel Recording
    //self.recordPhase = AudioRecordPhaseEnd;
    [self showRecSV:4];
    _brecwillsend = NO;
    [self stopRecordeAudio];
}

- (void)onTouchRecordBtnDragInside:(id)sender
{
    //TODO @"手指上滑，取消发送"
    //self.recordPhase = AudioRecordPhaseRecording;
    [self showRecSV:3];
}

- (void)onTouchRecordBtnDragOutside:(id)sender
{
    //TODO @"松开手指，取消发送"
    //self.recordPhase = AudioRecordPhaseCancelling;
    [self showRecSV:2];
}

//status  1 开始了,,2 显示上滑什么,,,3 显示取消 4 移除..
- (void)showRecSV:(int)status
{
    if (status == 4)
    {
        [_recshowing removeFromSuperview];
        _recshowing = nil;
        return;
    }

    if (_recshowing == nil)
    {
        _recshowing = [[ChatAudioRecordNoticeView alloc] init];
        [self.view addSubview:_recshowing];
        if (_mbhalf == YES)
        {
            [_recshowing mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.view).with.offset(70);
                make.left.equalTo(self.view).with.offset(kScreenW / 2 - 80);
            }];
        }
        else
        {
            _recshowing.center = self.view.center;
        }
    }
    _recshowing.mstatus = status;
}

#pragma mark 录音API操作这里可能会影响APP
- (void)startRecordeAudio
{
    if (_recorder.recording)
        return;

    if (![self canRecord])
    {
        [SVProgressHUD showErrorWithStatus:@"获取麦克风权限失败"];
        return;
    }

    AVAudioSession *session = [AVAudioSession sharedInstance];
    if (![session.category isEqualToString:AVAudioSessionCategoryPlayAndRecord] ||
        ![session.category isEqualToString:AVAudioSessionCategoryRecord])
    {
        if (![session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil])
        {
            [SVProgressHUD showErrorWithStatus:@"录音失败"];
            return;
        }
        if (![session setActive:YES error:nil])
        {
            [SVProgressHUD showErrorWithStatus:@"录音失败"];
            return;
        }
    }

    NSMutableDictionary *recordSetting = NSMutableDictionary.new;
    //设置录音格式  AVFormatIDKey==kAudioFormatLinearPCM
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
    //设置录音采样率(Hz) 如：AVSampleRateKey==8000/44100/96000（影响音频的质量）
    [recordSetting setValue:[NSNumber numberWithFloat:44100] forKey:AVSampleRateKey];
    //录音通道数  1 或 2
    [recordSetting setValue:[NSNumber numberWithInt:1] forKey:AVNumberOfChannelsKey];
    //线性采样位数  8、16、24、32
    [recordSetting setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    //录音的质量
    [recordSetting setValue:[NSNumber numberWithInt:AVAudioQualityHigh] forKey:AVEncoderAudioQualityKey];

    NSError *error = nil;
    _recorder = [[AVAudioRecorder alloc] initWithURL:[self makerecfilepath] settings:recordSetting error:&error];
    _recorder.delegate = self;
    if (_recorder == nil || ![_recorder prepareToRecord])
    {
        [SVProgressHUD showErrorWithStatus:@"录音失败"];
        return;
    }

    if (![_recorder recordForDuration:60.0f])
    {
        [SVProgressHUD showErrorWithStatus:@"录音失败"];
        return;
    }

    [_timer invalidate];
    _timer = nil;
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(timersel) userInfo:nil repeats:YES];
    _recduration = 0.0f;
}

- (void)timersel
{
    _recshowing.recordTime = _recorder.currentTime;
    _recduration += _timer.timeInterval;
}

- (BOOL)canRecord
{
    __block BOOL bCanRecord = YES;

    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    if ([audioSession respondsToSelector:@selector(requestRecordPermission:)])
    {
        [audioSession performSelector:@selector(requestRecordPermission:)
                           withObject:^(BOOL granted) {
                               if (granted)
                               {
                                   bCanRecord = YES;
                               }
                               else
                               {
                                   bCanRecord = NO;
                               }
                           }];
    }

    return bCanRecord;
}

- (void)stopRecordeAudio
{
    [_recorder stop];
}

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    if (_brecwillsend)
    {
        [self willSendThisVoice:recorder.url duration:_recduration];
    }

    [_timer invalidate];
    _timer = nil;
}

- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *__nullable)error
{
    [SVProgressHUD showErrorWithStatus:@"录音失败"];

    [_timer invalidate];
    _timer = nil;
}

- (NSURL *)makerecfilepath
{
    NSString *urlStr = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    urlStr = [urlStr stringByAppendingPathComponent:[NSString stringWithFormat:@"recfile_%ld.acc", (NSInteger)[[NSDate date] timeIntervalSince1970]]];
    NSURL *url = [NSURL fileURLWithPath:urlStr];
    return url;
}

#pragma mark 录音操作结束

#pragma mark chatBarDelegate
- (void)chatBarFrameDidChange:(ChatBottomBarView *)chatBar shouldScrollToBottom:(CGFloat)keyBoardHeight showType:(FWChatBarShowType)showType showAnimationTime:(CGFloat)showAnimationTime
{
    if (_haveLiveExist == NO)
    {
        if (showType == FWChatBarShowTypeFace || showType == FWChatBarShowTypeMore)
        {
            UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 234, 0.0);
            _mtableview.scrollEnabled = YES;
            _mtableview.contentInset = contentInsets;
            _mtableview.scrollIndicatorInsets = contentInsets;
            [self scrollToBottomAnimated:YES animatedTime:showAnimationTime];
        }
        else if (showType == FWChatBarShowTypeNothing)
        {
            UIEdgeInsets contentInsets = UIEdgeInsetsZero;
            _mtableview.contentInset = contentInsets;
            _mtableview.scrollIndicatorInsets = contentInsets;
        }
        else if (showType == FWChatBarShowTypeKeyboard)
        {

            UIEdgeInsets contentInsets = UIEdgeInsetsZero;
            _mtableview.contentInset = contentInsets;
            _mtableview.scrollIndicatorInsets = contentInsets;
            [self scrollToBottomAnimated:YES animatedTime:showAnimationTime];
        }
        else if (showType == FWChatBarShowTypeVoice)
        {
            UIEdgeInsets contentInsets = UIEdgeInsetsZero;
            _mtableview.contentInset = contentInsets;
            _mtableview.scrollIndicatorInsets = contentInsets;
        }
    }
    else
    {
        if (showType == FWChatBarShowTypeFace || showType == FWChatBarShowTypeMore)
        {
            UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 234, 0.0);
            _mtableview.scrollEnabled = YES;
            _mtableview.contentInset = contentInsets;
            _mtableview.scrollIndicatorInsets = contentInsets;
            [_chatBar.textView resignFirstResponder];
            [self scrollToBottomAnimated:YES animatedTime:0.5];
            [self faceAndMoreKeyboardBtnClickWith:YES isNotHaveBothKeyboard:NO keyBoardHeight:234];
        }
        else if (showType == FWChatBarShowTypeNothing)
        {
            UIEdgeInsets contentInsets = UIEdgeInsetsZero;
            _mtableview.contentInset = contentInsets;
            _mtableview.scrollIndicatorInsets = contentInsets;
            [_chatBar.textView resignFirstResponder];
            [self faceAndMoreKeyboardBtnClickWith:NO isNotHaveBothKeyboard:NO keyBoardHeight:keyBoardHeight];
        }
        else if (showType == FWChatBarShowTypeKeyboard)
        {
            UIEdgeInsets contentInsets = UIEdgeInsetsZero;
            _mtableview.contentInset = contentInsets;
            _mtableview.scrollIndicatorInsets = contentInsets;
            [self scrollToBottomAnimated:YES animatedTime:showAnimationTime];
            [self faceAndMoreKeyboardBtnClickWith:NO isNotHaveBothKeyboard:YES keyBoardHeight:keyBoardHeight];
            
        }
        else if (showType == FWChatBarShowTypeVoice)
        {
            UIEdgeInsets contentInsets = UIEdgeInsetsZero;
            _mtableview.contentInset = contentInsets;
            _mtableview.scrollIndicatorInsets = contentInsets;
            [self faceAndMoreKeyboardBtnClickWith:NO isNotHaveBothKeyboard:NO keyBoardHeight:keyBoardHeight];
        }
    }
    [self.chatBar updateChatBarConstraintsIfNeededShouldCacheText:YES];
    [self hidenGiftView];
}

- (void)scrollToBottomAnimated:(BOOL)animated animatedTime:(CGFloat)animatedTime
{

    NSInteger rows = [self.mtableview numberOfRowsInSection:0];
    if (rows > 0)
    {
        dispatch_block_t scrollBottomBlock = ^{
            [self.mtableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rows - 1 inSection:0]
                                   atScrollPosition:UITableViewScrollPositionBottom
                                           animated:animated];
        };
        if (animated)
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(animatedTime/30 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                scrollBottomBlock();
            });
        }
        else
        {
            scrollBottomBlock();
        }
    }
}

#pragma mark - chat Emoji View Delegate
- (void)chatEmojiViewSelectEmojiIcon:(EmojiObj *)objIcon
{
    NSCharacterSet *nonDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    int emojiID = [[objIcon.emojiName stringByTrimmingCharactersInSet:nonDigits] intValue];
    [self.chatBar.textView appendFace:emojiID];
    [self.chatBar updateChatBarConstraintsIfNeededShouldCacheText:YES];
}

- (void)chatEmojiViewTouchUpinsideDeleteButton
{
    //点击了删除表情
    if (self.chatBar.textView.text.length > 0)
    {
        NSRange range = self.chatBar.textView.selectedRange;
        NSInteger location = (NSInteger) range.location;
        if (location == 0)
        {
            return;
        }
        range.location = location - 1;
        range.length = 1;

        NSMutableAttributedString *attStr = [self.chatBar.textView.attributedText mutableCopy];
        [attStr deleteCharactersInRange:range];
        self.chatBar.textView.attributedText = attStr;
        self.chatBar.textView.selectedRange = range;
    }
}

- (void)chatEmojiViewTouchDownDeleteButton
{
    self.chatBar.textView.text = nil;
    [self.chatBar updateChatBarConstraintsIfNeededShouldCacheText:YES];
}

- (void)chatEmojiViewTouchUpinsideSendButton
{
    //表情键盘：点击发送表情
    if (self.chatBar.textView.text.length == 0)
    {
        [SVProgressHUD showErrorWithStatus:@"请先输入发送内容"];
    }
    else
    {
        [self willSendThisText:[self.chatBar.textView getSendTextStr]];
    }
}

#pragma mark - chat More View Delegate
- (void)chatMoreViewButton:(NSInteger)btnIndex
{
    NSInteger index;
    if (_haveLiveExist)
    {
        if (btnIndex != 1000)
        {
            index = btnIndex + 1;
        }
        else
        {
            index = btnIndex;
        }
    }
    else
    {
        index = btnIndex;
    }

    if (index == 1000)
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum])
        {
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            picker.delegate = self;
            picker.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        }

        [self presentViewController:picker animated:YES completion:nil];
    }
    else if (index == 1001)
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.delegate = self;
            picker.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        }

        [self presentViewController:picker animated:YES completion:nil];
    }
    else if (index == 1002)
    {
        [self showGiftView];
    }
    else if (index == 1003)
    {
        if (self.fanweApp.appModel.open_send_coins_module == 1)
        {
            [self sendCoin];
        }
        else if (self.fanweApp.appModel.open_send_diamonds_module == 1)
        {
            [self sendDiamonds];
        }
    }
    else if (index == 1004)
    {
        [self sendDiamonds];
    }
}

//ykk825 face  代理方法
- (void)faceAndMoreKeyboardBtnClickWith:(BOOL)isFace isNotHaveBothKeyboard:(BOOL)isHave keyBoardHeight:(CGFloat)height
{
    if (self.mbhalf == YES)
    {
        if ([self.delegate respondsToSelector:@selector(faceAndMoreKeyboardBtnClickWith:isNotHaveBothKeyboard:keyBoardHeight:)])
        {
            [self.delegate faceAndMoreKeyboardBtnClickWith:isFace isNotHaveBothKeyboard:isHave keyBoardHeight:height];
        }
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldReceiveTouch:(UITouch*)touch
{
    
    CGPoint point  = [touch locationInView:self.view];
    if( point.y > self.chatBar.frame.origin.y )
    {//只要点击了在输入框的下面...这种就放过...
        return NO;
    }
    
    if (!self.mGiftView.hidden) {
        [self hidenGiftView];
        return YES;
    }
    
    if (self.chatBar.showType == FWChatBarShowTypeMore || self.chatBar.showType == FWChatBarShowTypeFace) {
        [self hideChatBar];
        return YES;
    }
    //下面的点击 都是在 输入框的上面,,,就是点击了tablewview的范围
    if( self.chatBar.textView.isFirstResponder )
    {//键盘开启的,就关闭键盘,,,
        [self.chatBar.textView resignFirstResponder];
        return YES;
    }
    
    //下面是判断 CELL的点击位置..
    point = [touch locationInView:self.mtableview];
    
    NSIndexPath * indexpath = [self.mtableview indexPathForRowAtPoint:point];
    UITableViewCell* cell =  [self.mtableview cellForRowAtIndexPath:indexpath];
    
    UIView* msgbodyrect = [cell viewWithTag:99];
    point  = [touch locationInView:cell];
    
    if( CGRectContainsPoint(msgbodyrect.frame,point) )
    {//在消息体的范围,就允许响应tableview的 didselectrow...
        return NO;
    }
    
    UIView* failedicon = [cell viewWithTag:98];
    
    if( CGRectContainsPoint(failedicon.frame,point) )
    {
        [self failedIconTouched:indexpath iconhiden:failedicon.hidden];
    }
    return YES;
}

- (void)taprootview:(UITapGestureRecognizer*)sender
{
    
}

- (void)hideChatBar
{
    [_chatBar hideChatBottomBar];
}

- (void)doubleTapScrollToTop:(UIGestureRecognizer*)gestureRecognizer
{
    if (_mmsgdata.count)
    {
        [self.mtableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                               atScrollPosition:UITableViewScrollPositionTop
                                       animated:YES];
    }
}

@end
