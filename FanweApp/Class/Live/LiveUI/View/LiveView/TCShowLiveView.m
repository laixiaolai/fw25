//
//  TCShowLiveView.m
//  TCShow
//
//  Created by AlexiChen on 16/4/14.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "TCShowLiveView.h"

@implementation TCShowLiveView

#pragma mark - ----------------------- 直播生命周期 -----------------------
- (void)releaseAll
{
    _liveController = nil;
    [_liveInputView removeFromSuperview];
    [_bottomView removeFromSuperview];
    [_topView removeFromSuperview];
    
    if (_msgView.contentOffsetTimer)
    {
        [_msgView.contentOffsetTimer invalidate];
        _msgView.contentOffsetTimer = nil;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dealloc
{
    [self releaseAll];
}

#pragma mark 开始直播
- (void)startLive
{
    [_topView startLive];
    [_bottomView startLive];
}

#pragma mark 暂停直播
- (void)pauseLive
{
    [_topView pauseLive];
    [_bottomView pauseLive];
    // [self changeGameView];
}

#pragma mark 重新开始直播
- (void)resumeLive
{
    [_topView resumeLive];
    [_bottomView resumeLive];
}

#pragma mark 结束直播
- (void)endLive
{
    [_topView endLive];
    [_bottomView endLive];
    [_topView endLive];
    
    [self releaseAll];
    
    if (_goldFlowerView)
    {
        [_goldFlowerView closeGameAboutTimer];
    }
}


#pragma mark - ----------------------- 界面初始化等 -----------------------
#pragma mark 初始化房间信息等
- (instancetype)initWith:(id<FWShowLiveRoomAble>)liveItem liveController:(id<FWLiveControllerAble>)liveController
{
    if (self = [super initWithFrame:CGRectZero])
    {
        _liveItem = liveItem;
        _isHost = [liveItem isHost];
        _liveController = liveController;
        _roomIDStr = StringFromInt([_liveItem liveAVRoomId]);
        
        _currentDiamonds = [[IMAPlatform sharedInstance].host getDiamonds];
        
        [self addOwnViews];
        
        [self addSomeListener];
        
        if (!_isHost)
        {
            [self showCloseLiveBtn];
        }
    }
    return self;
}

#pragma mark 请求完接口后，刷新直播间相关信息
- (void)refreshLiveItem:(id<FWShowLiveRoomAble>)liveItem liveInfo:(CurrentLiveInfo *)liveInfo
{
    _liveItem = liveItem;
    _currentLiveInfo = liveInfo;
    
    _isHost = [liveItem isHost];
    _roomIDStr = StringFromInt([_liveItem liveAVRoomId]);
    
    [_topView refreshLiveItem:liveItem liveInfo:liveInfo];
    [_liveInputView refreshLiveItem:liveItem liveInfo:liveInfo];
    [_bottomView refreshLiveItem:liveItem liveInfo:liveInfo];
    
    _live_in = liveInfo.live_in;
    _share_type = liveInfo.share_type;
    _private_share = liveInfo.private_share;
    
    if ([_liveItem liveType] == FW_LIVE_TYPE_RELIVE)
    {
        CGFloat tmpY = 0;
        if (liveInfo.has_video_control)
        {
            tmpY = kScreenH - kSendGiftContrainerHeight - 50 - CGRectGetHeight(_msgView.frame);
        }
        else
        {
            tmpY = kScreenH - kSendGiftContrainerHeight - 10 - CGRectGetHeight(_msgView.frame);
        }
        _msgView.frame = CGRectMake(CGRectGetMinX(_msgView.frame), tmpY, CGRectGetWidth(_msgView.frame), CGRectGetHeight(_msgView.frame));
    }
    
    if (liveInfo.game_log_id != 0 && liveInfo.live_in == FW_LIVE_STATE_ING)
    {
        // 当前直播间是否在进行游戏
        if ( self.game_log_id != liveInfo.game_log_id)
        {
            self.coinWindowNumber = 0;
        }
        if (liveInfo.game_log_id > self.game_log_id)
        {
            [self.gameDataArray removeAllObjects];
            self.canNotLoadData = NO;
        }
        self.game_log_id = liveInfo.game_log_id;
        self.game_log_id = liveInfo.game_log_id;
        [self loadGameData];
    }
    else
    {
        self.shouldReloadGame = NO;
    }
}

#pragma mark 添加子视图
- (void)addOwnViews
{
    // 头部视图
    _topView = [[TCShowLiveTopView alloc] initWith:_liveItem liveController:_liveController];
    [self addSubview:_topView];
    
    // 消息列表
    _msgView = [[TCShowLiveMessageView alloc] init];
    [self addSubview:_msgView];
    
    // 游戏视图高度
    _goldFlowerViewHeiht = 2*kPokerH+15+20+40;
    // 底部视图
    _bottomView = [[TCShowLiveBottomView alloc] init];
    _bottomView.isHost = _isHost;
    _bottomView.delegate = self;
    _bottomView.heartRect = CGRectMake(kScreenW-kDefaultMargin*2-kMyBtnWidth1*2+5, kScreenH-kDefaultMargin-kMyBtnWidth1+5, kMyBtnWidth1-10, kMyBtnWidth1-10);
    [self addSubview:_bottomView];
    
    // 发送消息框
    _liveInputView = [[TCShowLiveInputView alloc] init];
    _liveInputView.delegate = self;
    _liveInputView.limitLength = kLiveInputViewLimitLength;
    _liveInputView.hidden = YES;
    _liveInputView.isHost = _isHost;
    [self addSubview:_liveInputView];
    
    // 创建礼物视图及礼物动画视图
    [self loadGiftView:[GiftListManager sharedInstance].giftMArray];
}

- (void)addSomeListener
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeMoney) name:@"moneyHaveChange" object:nil];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapBlank:)];
    tap.delegate=self;
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:tap];
}

#pragma mark 是否显示关闭推流按钮
- (void)showCloseLiveBtn
{
    if (!_closeLiveBtn)
    {
        FWWeakify(self)
        UIImage *closeImage = [UIImage imageNamed:@"bm_daily_task"];
        
        _closeLiveBtn = [[MenuButton alloc] initWithTitle:nil icon:closeImage action:^(MenuButton *menu) {
            FWStrongify(self)
            [self addSubview:self.dailyTaskPop];
        }];
        [_closeLiveBtn setImage:closeImage forState:UIControlStateSelected];
        _closeLiveBtn.hidden = YES;
        [self addSubview:_closeLiveBtn];
    }
}

- (BMPopBaseView *)dailyTaskPop
{
    _dailyTaskPop = [[[NSBundle mainBundle]loadNibNamed:@"BMPopBaseView" owner:self options:nil]lastObject];
    _dailyTaskPop.frame = CGRectMake(0, 0, kScreenW, kScreenH);
    [_dailyTaskPop updateUIframeWithWidth:532/2.0f*kScaleWidth andHeight:466*kScaleHeight andTitleStr:@"" andmyEunmType:BMEachDaytask];
    return _dailyTaskPop;
}

#pragma mark 钻石值的改变,刷新用户信息
- (void)changeMoney
{
    FWWeakify(self)
    [[IMAPlatform sharedInstance].host getMyInfo:^(AppBlockModel *blockModel) {
        FWStrongify(self)
        self.currentDiamonds = [[IMAPlatform sharedInstance].host getDiamonds];
        [self.giftView setDiamondsLabelTxt:[NSString stringWithFormat:@"%ld",(long)self.currentDiamonds]];
        
    }];
}

#pragma mark 创建礼物视图及礼物动画视图
- (void)loadGiftView:(NSArray *)list
{
    NSMutableArray *giftMArray = [NSMutableArray array];
    if (list && [list isKindOfClass:[NSArray class]])
    {
        for (NSDictionary *key in list)
        {
            GiftModel *giftModel = [GiftModel mj_objectWithKeyValues:key];
            [giftMArray addObject:giftModel];
        }
    }
    
    if ([giftMArray count]>4)
    {
        _giftViewHeight = kScreenW*0.56+kSendGiftContrainerHeight+4*kDefaultMargin;
    }
    else
    {
        _giftViewHeight = kScreenW*0.28+kSendGiftContrainerHeight+4*kDefaultMargin;
    }
    
    // 礼物视图
    _giftView = [[GiftView alloc]initWithFrame:CGRectMake(0, kScreenH, kScreenW, _giftViewHeight)];
    _giftView.delegate = self;
    _giftView.hidden = YES;
    [_giftView setGiftView:giftMArray];
    [self addSubview:_giftView];
    
    [self changeMoney];
}

- (void)relayoutFrameOfSubViews
{
    CGRect rect = self.bounds;
    self.clipsToBounds = YES;
    
    [_topView setFrameAndLayout:CGRectMake(0, kStatusBarHeight, rect.size.width, kLogoContainerViewHeight+66)];
    
    if ([_liveItem liveType] == FW_LIVE_TYPE_RELIVE)
    {
        [_goldFlowerView removeFromSuperview];
        
        _bottomView.frame = CGRectMake(0, kScreenH-kMyBtnWidth1-kDefaultMargin, rect.size.width, kMyBtnWidth1);
        
        _liveInputView.frame = _bottomView.frame;
        
        CGFloat tmpY = 0;
        if (_currentLiveInfo.has_video_control)
        {
            tmpY = kScreenH - kSendGiftContrainerHeight - 50 - COMMENT_TABLEVIEW_HEIGHT;
        }
        else
        {
            tmpY = kScreenH - kSendGiftContrainerHeight - 10 - COMMENT_TABLEVIEW_HEIGHT;
        }
        _msgView.frame = CGRectMake(kDefaultMargin, tmpY, rect.size.width * 0.8, COMMENT_TABLEVIEW_HEIGHT);
    }
    else
    {
        if (_goldViewCanNotSee == NO && _goldFlowerView)
        {
            _bottomView.frame = CGRectMake(0, kScreenH-kMyBtnWidth1-kDefaultMargin-_goldFlowerViewHeiht, rect.size.width, kMyBtnWidth1);
            
            _liveInputView.frame = _bottomView.frame;
            
            CGFloat tmpY = kScreenH - kSendGiftContrainerHeight - 10 - COMMENT_TABLEVIEW_HEIGHT - _goldFlowerViewHeiht;
            _msgView.frame = CGRectMake(kDefaultMargin, tmpY, rect.size.width * 0.8, COMMENT_TABLEVIEW_HEIGHT);
        }
        else if (_guessSizeViewCanNotSee == NO && _guessSizeView)
        {
            _bottomView.frame = CGRectMake(0, kScreenH-kMyBtnWidth1-kDefaultMargin-kGuessSizeViewHeight, rect.size.width, kMyBtnWidth1);
            
            _liveInputView.frame = _bottomView.frame;
            
            CGFloat tmpY = kScreenH - kSendGiftContrainerHeight - 10 - COMMENT_TABLEVIEW_HEIGHT - kGuessSizeViewHeight;
            _msgView.frame = CGRectMake(kDefaultMargin, tmpY, rect.size.width * 0.8, COMMENT_TABLEVIEW_HEIGHT);
        }
        else
        {
            _bottomView.frame = CGRectMake(0, kScreenH-kMyBtnWidth1-kDefaultMargin, rect.size.width, kMyBtnWidth1);
            
            _liveInputView.frame = _bottomView.frame;
            
            CGFloat tmpY = kScreenH - kSendGiftContrainerHeight - 10 - COMMENT_TABLEVIEW_HEIGHT;
            _msgView.frame = CGRectMake(kDefaultMargin, tmpY, rect.size.width * 0.8, COMMENT_TABLEVIEW_HEIGHT);
        }
    }
    
    [_bottomView relayoutFrameOfSubViews];
    [_liveInputView relayoutFrameOfSubViews];
    [_msgView relayoutFrameOfSubViews];
    
    _closeLiveBtn.frame = CGRectMake(kScreenW - kDefaultMargin - 41, CGRectGetMaxY(self.topView.accountLabel.frame)+1.5*kDefaultMargin+kStatusBarHeight, 41 , 41);
}

#pragma mark - ----------------------- 其他 -----------------------
- (void)onRecvLight:(NSString *)lightName
{
    NSInteger praise = [_liveItem livePraise];
    [_liveItem setLivePraise:praise + 1];
    _bottomView.heartImgViewName = lightName;
    [_bottomView showLikeHeart];
}

#if kSupportIMMsgCache
- (void)onRecvPraise:(AVIMCache *)cache
{
    NSInteger praise = [_liveItem livePraise];
    [_liveItem setLivePraise:praise + cache.count];
    
    [_bottomView showLikeHeart:cache];
}
#endif

#pragma mark 隐藏输入框
- (void)hideInputView
{
    if (_liveInputView.hidden)
    {
        return;
    }
    
    [_liveInputView resignFirstResponder];
    
    _liveInputView.hidden = YES;
    _bottomView.hidden = NO;
}

#pragma mark - ----------------------- 发送消息、礼物消息 -----------------------
#pragma mark 点击发送按钮发送消息
- (void)sendMessage
{
    NSString *msg = [_liveInputView.text trim];
    if (msg.length == 0)
    {
        return;
    }
    
    if (_liveInputView.barrageSwitch.isOn)
    { //弹幕消息
        [self sendBarrageMsg:msg];
        [_liveInputView setText:nil];
    }
    else
    { //普通消息
        SendCustomMsgModel *scmm = [[SendCustomMsgModel alloc] init];
        scmm.msgType = MSG_TEXT;
        scmm.msg = _liveInputView.text;
        scmm.chatGroupID = [_liveItem liveIMChatRoomId];
        [[FWIMMsgHandler sharedInstance] sendCustomGroupMsg:scmm succ:nil fail:nil];
        
        [_liveInputView setText:nil];
    }
}

- (void)showRechargeAlert:(NSString *)message
{
    FWWeakify(self)
    [FanweMessage alert:@"余额不足" message:message destructiveAction:^{
        
        FWStrongify(self)
        if (_liveInputView.barrageSwitch.isOn &&!_liveInputView.isHost)
        { // 打开了 弹幕
            [self showRechargeView:_giftView];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self.liveInputView.textField resignFirstResponder];
                
            });
        }
        else
        {
            [self showRechargeView:_giftView];
        }
        
    } cancelAction:^{
        
        if (_liveInputView.barrageSwitch.isOn && !_liveInputView.isHost)
        {// 打开了 弹幕
            _liveInputView.hidden = NO;
            _bottomView.hidden = YES;
            [_liveInputView becomeFirstResponder];
        }
        
    }];
}

#pragma mark 发送弹幕消息
- (void)sendBarrageMsg:(NSString*)message
{
    _currentDiamonds = [[IMAPlatform sharedInstance].host getDiamonds];
    if (_currentDiamonds < self.fanweApp.appModel.bullet_screen_diamond && !_isHost)
    {
        [self showRechargeAlert:@"当前余额不足，充值才能继续发送弹幕，是否去充值？"];
        
        return;
    }
    
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    [mDict setObject:@"deal" forKey:@"ctl"];
    [mDict setObject:@"pop_msg" forKey:@"act"];
    [mDict setObject:_roomIDStr forKey:@"room_id"];
    [mDict setObject:message forKey:@"msg"];
    
    FWWeakify(self)
    [self.httpsManager POSTWithParameters:mDict SuccessBlock:^(NSDictionary *responseJson) {
        
        FWStrongify(self)
        if ([responseJson toInt:@"status"] == 1)
        {
            // 本地金额递减
            self.currentDiamonds -= self.fanweApp.appModel.bullet_screen_diamond;
            if (self.currentDiamonds >= 0)
            {
                [self.giftView setDiamondsLabelTxt:[NSString stringWithFormat:@"%ld",(long)self.currentDiamonds]];
                
                if (self.fanweApp.appModel.open_diamond_game_module == 1)
                {
                    // 更新游戏余额
                    if (self.goldFlowerView)
                    {
                        self.goldFlowerView.coinView.gameRechargeView.accountLabel.text =[NSString stringWithFormat:@"%ld",(long)self.currentDiamonds];
                    }
                }
                
                [[IMAPlatform sharedInstance].host setDiamonds:[NSString stringWithFormat:@"%ld",(long)self.currentDiamonds]];
            }
        }
        
    } FailureBlock:^(NSError *error) {
        
    }];
}

#pragma mark 点击发送礼物
- (void)senGift:(GiftView *)giftView AndGiftModel:(GiftModel *)giftModel
{
    _currentDiamonds = [[IMAPlatform sharedInstance].host getDiamonds];
    if (_currentDiamonds < giftModel.diamonds)
    {
        _giftView.sendBtn.hidden = NO;
        _giftView.continueContainerView.hidden = YES;
        
        [self showRechargeAlert:@"当前余额不足，充值才能继续送礼，是否去充值？"];
        
        return;
    }
    
    if (_live_in == FW_LIVE_STATE_OVER)
    {
        SFriendObj* chattag = [[SFriendObj alloc]initWithUserId:[[[_liveItem liveHost]imUserId] intValue]];
        
        FWWeakify(self)
        [chattag sendGiftMsg:giftModel block:^(SResBase *resb, SIMMsgObj *thatmsg) {
            
            FWStrongify(self)
            if( !resb.msuccess )
            {
                [FanweMessage alert:resb.mmsg];
            }
            else
            {   //如果成功了,刷新钻石
                self.currentDiamonds -= giftModel.diamonds;
                if (self.currentDiamonds >= 0)
                {
                    [self.giftView setDiamondsLabelTxt:[NSString stringWithFormat:@"%ld",(long)self.currentDiamonds]];
                    
                    if (self.fanweApp.appModel.open_diamond_game_module == 1)
                    {
                        //更新游戏余额
                        if (self.goldFlowerView)
                        {
                            self.goldFlowerView.coinView.gameRechargeView.accountLabel.text =[NSString stringWithFormat:@"%ld",(long)self.currentDiamonds];
                        }
                        else if (self.guessSizeView)
                        {
                            self.guessSizeView.gameRechargeView.accountLabel.text =[NSString stringWithFormat:@"%ld",(long)self.currentDiamonds];
                        }
                    }
                    [[IMAPlatform sharedInstance].host setDiamonds:[NSString stringWithFormat:@"%ld",(long)self.currentDiamonds]];
                }
                [self showSendGiftSuccessWithModel:giftModel];
            }
        }];
    }
    else
    {
        NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
        
        [mDict setObject:@"deal" forKey:@"ctl"];
        [mDict setObject:@"pop_prop" forKey:@"act"];
        
        [mDict setObject:[NSString stringWithFormat:@"%ld",(long)giftModel.ID] forKey:@"prop_id"];
        [mDict setObject:@"1" forKey:@"num"];
        [mDict setObject:_roomIDStr forKey:@"room_id"];
        [mDict setObject:[NSString stringWithFormat:@"%ld",(long)giftModel.is_plus] forKey:@"is_plus"];
        
        FWWeakify(self)
        [self.httpsManager POSTWithParameters:mDict SuccessBlock:^(NSDictionary *responseJson) {
            
            FWStrongify(self)
            if ([responseJson toInt:@"status"] == 1)
            {
                self.currentDiamonds -= giftModel.diamonds;
                if (self.currentDiamonds >= 0)
                {
                    [self.giftView setDiamondsLabelTxt:[NSString stringWithFormat:@"%ld",(long)self.currentDiamonds]];
                    
                    if (self.fanweApp.appModel.open_diamond_game_module == 1)
                    {
                        // 更新游戏余额
                        if (self.goldFlowerView)
                        {
                            self.goldFlowerView.coinView.gameRechargeView.accountLabel.text =[NSString stringWithFormat:@"%ld",(long)self.currentDiamonds];
                        }
                        else if (self.guessSizeView)
                        {
                            self.guessSizeView.gameRechargeView.accountLabel.text =[NSString stringWithFormat:@"%ld",(long)self.currentDiamonds];
                        }
                    }
                    
                    [[IMAPlatform sharedInstance].host setDiamonds:[NSString stringWithFormat:@"%ld",(long)self.currentDiamonds]];
                }
                [self showSendGiftSuccessWithModel:giftModel];
            }
            
        } FailureBlock:^(NSError *error) {
            
        }];
    }
    
//    if (giftModel.is_much == 0 && ![[[IMAPlatform sharedInstance].host imUserId] isEqualToString:[[_liveItem liveHost] imUserId]])
//    {
//        [FanweMessage alertTWMessage:[NSString stringWithFormat:@"%@ 已发送",giftModel.name]];
//    }
}

- (void)showSendGiftSuccessWithModel:(GiftModel *)giftModel
{
    if (giftModel.is_much == 0 && ![[[IMAPlatform sharedInstance].host imUserId] isEqualToString:[[_liveItem liveHost] imUserId]])
    {
        [FanweMessage alertTWMessage:[NSString stringWithFormat:@"%@ 已发送",giftModel.name]];
    }
}

#pragma mark 显示充值界面
- (void)showRechargeView:(GiftView *)giftView
{
    [self hiddenGiftView];
    
    if (_serveceDelegate && [_serveceDelegate respondsToSelector:@selector(rechargeView:)])
    {
        [_serveceDelegate rechargeView:self];
    }
}

#pragma mark - ----------------------- 代理方法 -----------------------
#pragma mark 底部菜单视图代理（TCShowLiveBottomViewDelegate）
- (void)onBottomViewClickMenus:(TCShowLiveBottomView *)bottomView fromButton:(UIButton *)button
{
    if (button.tag == EFunc_GIFT)
    { // 发送礼物
        __weak typeof(self) ws =self;
        
        [self changeMoney];
        
        _bottomView.hidden = YES;
        _giftView.hidden = NO;
        if (_goldFlowerView)
        {
            _goldViewCanNotSee = YES;
            _goldFlowerView.frame = CGRectMake(0, kScreenH, kScreenW, _goldFlowerViewHeiht);
            _bottomView.heartRect = CGRectMake(kScreenW-kDefaultMargin*2-kMyBtnWidth1*2+5, kScreenH-kDefaultMargin-kMyBtnWidth1+5, kMyBtnWidth1-10, kMyBtnWidth1-10);
            [self relayoutFrameOfSubViews];
            _bottomView.switchGameViewBtn.transform = CGAffineTransformMakeRotation(M_PI);
        }
        if (_guessSizeView)
        {
            _guessSizeViewCanNotSee = YES;
            _guessSizeView.frame = CGRectMake(0, kScreenH, kScreenW, kGuessSizeViewHeight);
            _bottomView.heartRect = CGRectMake(kScreenW-kDefaultMargin*2-kMyBtnWidth1*2+5, kScreenH-kDefaultMargin-kMyBtnWidth1+5, kMyBtnWidth1-10, kMyBtnWidth1-10);
            [self relayoutFrameOfSubViews];
            _bottomView.switchGameViewBtn.transform = CGAffineTransformMakeRotation(M_PI);
        }
        
        if (_sdkDelegate && [_sdkDelegate respondsToSelector:@selector(hideReLiveSlide:)])
        {
            [_sdkDelegate hideReLiveSlide:YES];
        }
        
        [UIView animateWithDuration:0.1 animations:^{
            ws.giftView.frame = CGRectMake(0, kScreenH-_giftViewHeight, _giftView.frame.size.width, _giftView.frame.size.height);
            //            ws.closeLiveBtn.hidden = YES;
        }completion:^(BOOL finished) {
            ws.msgView.hidden = YES;
        }];
    }
    else if (button.tag == EFunc_CONNECT_MIKE)
    { // 连麦
        if (_serveceDelegate && [_serveceDelegate respondsToSelector:@selector(clickMikeBtn:)])
        {
            [_serveceDelegate clickMikeBtn:self];
        }
    }
    else if (button.tag == EFunc_SHARE)
    { // 分享
        if (_serveceDelegate && [_serveceDelegate respondsToSelector:@selector(clickShareBtn:)])
        {
            [_serveceDelegate clickShareBtn:self];
        }
    }
    else if (button.tag == EFunc_CHART)
    { // 私聊
        _bankerViewCanSee = NO;
        if (_serveceDelegate && [_serveceDelegate respondsToSelector:@selector(clickIM:)])
        {
            [_serveceDelegate clickIM:self];
        }
    }
    else if (button.tag == EFunc_INPUT)
    { // 显示消息输入
        _bankerViewCanSee = NO;
        [_liveInputView becomeFirstResponder];
        _liveInputView.hidden = NO;
        _bottomView.hidden = YES;
    }
    else if (button.tag == EFunc_AUCTION && [self.fanweApp.appModel.open_pai_module integerValue] == 1)
    { // 竞拍
        if (_serveceDelegate && [_serveceDelegate respondsToSelector:@selector(clickAuction:)])
        {
            [_serveceDelegate clickAuction:self];
        }
    }
#if kSupportH5Shopping
    else if (button.tag == EFunc_STARSHOP)
    { //星店
        if (_serveceDelegate && [_serveceDelegate respondsToSelector:@selector(clickStarShop:)])
        {
            [_serveceDelegate clickStarShop:self];
        }
    }
    
#endif
#if kSupportH5Shopping
    else if (button.tag == EFunc_SALES_SUSWINDOW)
    { // 缩放按钮
        return;
        AppDelegate *delegate = [AppDelegate sharedAppDelegate];
        if (delegate.sus_window.rootViewController)
        {
            [delegate.sus_window setSmallLiveScreen:YES vc:delegate.sus_window.rootViewController.childViewControllers[0] block:^(BOOL finished) {
                
            }];
        }
    }
#endif
    
    else if (button.tag == EFunc_GAMES)
    { //游戏
        if (_serveceDelegate && [_serveceDelegate respondsToSelector:@selector(clickGameBtn:)])
        {
            [_serveceDelegate clickGameBtn:self];
        }
    }
    else if (button.tag == EFunc_BEGINGAMES)
    {
        if (_goldFlowerView || _guessSizeView)
        {
            //开始发牌
            NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
            [mDict setObject:@"games" forKey:@"ctl"];
            [mDict setObject:@"start" forKey:@"act"];
            [mDict setObject:@(_gameId) forKey:@"id"];
            [self changeBeginButtonWithCanBeginNext:NO];
            [self beginGame];
            
            FWWeakify(self)
            [self.httpsManager POSTWithParameters:mDict SuccessBlock:^(NSDictionary *responseJson) {
                
                FWStrongify(self)
                if ([responseJson toInt:@"status"] == 1)
                {
                    self.canNotLoadData = NO;
                    if (self.goldFlowerView)
                    {
                        self.goldFlowerView.game_log_id = [responseJson toString:@"game_log_id"];
                    }
                    else if (self.guessSizeView)
                    {
                        self.guessSizeView.game_log_id = [responseJson toString:@"game_log_id"];
                    }
                }
                else
                {
                    [self changeBeginButtonWithCanBeginNext:YES];
                }
                
            } FailureBlock:^(NSError *error) {
                
                FWStrongify(self)
                [self changeBeginButtonWithCanBeginNext:YES];
                
            }];
        }
    }
    else if (button.tag == EFunc_SWITCHGAMEVIEW)
    {
        [self closeOrOpenGameView];
    }
    else if (button.tag == EFunc_LIVEPAY)//切换付费
    {
        if (_uiDelegate && [_uiDelegate respondsToSelector:@selector(clickChangePay:)])
        {
            [_uiDelegate clickChangePay:self];
        }
    }
    else if (button.tag == EFunc_MENTION)//提档
    {
        if (_uiDelegate && [_uiDelegate respondsToSelector:@selector(clickMention:)])
        {
            [_uiDelegate clickMention:self];
        }
    }
    else if (button.tag == EFunc_SWITCH_BANNER)//上庄下庄控制按钮
    {
        if (_goldFlowerView || _guessSizeView)
        {
            if (_banker_status == 0 || _banker_status == 2)
            {
                NSString * str = _banker_status == 0 ? @"是否开启上庄？" : @"确定要移除该庄家？";
                
                FWWeakify(self)
                [FanweMessage alert:@"提示" message:str destructiveAction:^{
                    
                    FWStrongify(self)
                    [self loadBankerRequest];
                    
                } cancelAction:^{
                    
                }];
            }
            else if (_banker_status == 1)
            {
                [self loadBankerRequest];
            }
        }
    }
    else if (button.tag == EFunc_GRAB_BANNER)
    {
        _bankerViewCanSee = YES;
        NSMutableDictionary *parmDict = [[NSMutableDictionary alloc]init];
        [parmDict setObject:@"games" forKey:@"ctl"];
        [parmDict setObject:@"userDiamonds" forKey:@"act"];
        
        FWWeakify(self)
        [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
            
            FWStrongify(self)
            if ([responseJson toInt:@"status"] == 1)
            {
                NSString *coinStr = [responseJson toString:@"user_diamonds"];
                self.bankerView.coin = coinStr;
                if (self.fanweApp.appModel.open_diamond_game_module == 1)
                {
                    NSString *coinStr = [responseJson toString:@"user_diamonds"];
                    //存入钻石
                    [[IMAPlatform sharedInstance].host setDiamonds:[responseJson toString:@"user_diamonds"]];
                    self.bankerView.myCoinLabel.text = [NSString stringWithFormat:@"余额:%@",coinStr];
                }
                else
                {
                    NSString *coinStr = [responseJson toString:@"coin"];
                    //存入游戏币
                    [[IMAPlatform sharedInstance].host setUserCoin:[responseJson toString:@"coin"]];
                    self.bankerView.myCoinLabel.text = [NSString stringWithFormat:@"余额:%@",coinStr];
                }
            }
            else
            {
                self.bottomView.grabBankerBtn.hidden = NO;
            }
            
        } FailureBlock:^(NSError *error) {
            
            FWStrongify(self)
            self.bottomView.grabBankerBtn.hidden = NO;
            
        }];
        
        [self displayBankerView];
    }
    else if (button.tag == EFunc_MORETOOLS)
    {
        //观众点击更多的插件按钮，目前放的是购物，我的小店
        self.moreToolsView.hidden = NO;
        SUS_WINDOW.window_Tap_Ges.enabled = NO;
        SUS_WINDOW.window_Pan_Ges.enabled = NO;
        
        FWWeakify(self)
        [UIView animateWithDuration:0.5 animations:^{
            
            FWStrongify(self)
            self.moreToolsView.transform = CGAffineTransformMakeTranslation(0, -kScreenH);
            
        } completion:^(BOOL finished) {
            
        }];
    }
    else if (button.tag == EFunc_FULL_SCREEN)
    {
        // 全屏
        if (_sdkDelegate && [_sdkDelegate respondsToSelector:@selector(clickFullScreen)])
        {
            [_sdkDelegate clickFullScreen];
        }
    }
}

- (void)loadBankerRequest
{
    //开始发牌
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    [mDict setObject:@"games" forKey:@"ctl"];
    if (_banker_status == 0)
    {
        //开启上庄
        [mDict setObject:@"openBanker" forKey:@"act"];
    }
    else if (_banker_status ==1)
    {
        //查看玩家申请上庄的信息
        [mDict setObject:@"getBankerList" forKey:@"act"];
        
        FWWeakify(self)
        [UIView animateWithDuration:0.3 animations:^{
            
            FWStrongify(self)
            self.selectctBankerView.frame = CGRectMake((kScreenW - 280)/2, (kScreenH - 290)/2, 280, 290);
            
        }];
    }
    else if (_banker_status ==2)
    {
        //展示下庄按钮的功能
        [mDict setObject:@"stopBanker" forKey:@"act"];
    }
    _bottomView.switchBankerBtn.userInteractionEnabled = NO;
    _bottomView.switchBankerBtn.hidden = NO;
    _bottomView.switchBankerBtn.icon = [UIImage imageNamed:@"gm_game_wait"];
    [_bottomView.switchBankerBtn setImage:[UIImage imageNamed:@"gm_game_wait"]  forState:UIControlStateNormal];
    [_bottomView.switchBankerBtn setImage:[UIImage imageNamed:@"gm_game_wait"] forState:UIControlStateHighlighted];
    
    FWWeakify(self)
    [self.httpsManager POSTWithParameters:mDict SuccessBlock:^(NSDictionary *responseJson) {
        
        FWStrongify(self)
        if ([responseJson toInt:@"status"] == 1)
        {
            if (_banker_status==1)
            {
                NSArray *bankerList = responseJson[@"banker_list"];
                [self.bankerListArr removeAllObjects];
                for (NSDictionary * bankerDic in bankerList)
                {
                    GameBankerModel * model = [GameBankerModel mj_objectWithKeyValues:bankerDic];
                    model.isSelect = NO;
                    [self.bankerListArr addObject:model];
                }
                self.bottomView.bankMessage = 0;
                self.bottomView.bjsbadge.badgeText = nil;
                self.selectctBankerView.dataArray = self.bankerListArr;
            }
            else if (_banker_status==2)
            {
                //状态为2，说明其点击按钮时处于上庄状态，点击按钮做下庄操作
                self.gameBankerView.hidden = YES;
            }
            
            if([[responseJson allKeys] containsObject:@"banker_status"])
            {
                self.banker_status = [responseJson toInt:@"banker_status"];
            }
            else
            {
                //如果请求接口成功，但返回的数据没有上庄状态值，则自己改变上庄的状态值
                if (self.banker_status == 0)
                {
                    self.banker_status = 1;
                }
                else if (self.banker_status == 2)
                {
                    self.banker_status = 0;
                }
            }
            [self changeSwitchBankerBtn];
        }
        else
        {
            [self changeSwitchBankerBtn];
        }
        
    } FailureBlock:^(NSError *error) {
        
        FWStrongify(self)
        [self changeSwitchBankerBtn];
        
    }];
}


#pragma mark TCShowLiveInputViewDelegate
- (void)sendMsg:(TCShowLiveInputView *)inputView
{
    [self sendMessage];
}


#pragma mark - ----------------------- 手势相关 -----------------------
#pragma mark 单击空白处
- (void)onTapBlank:(UITapGestureRecognizer *)tap
{
    if (tap.state == UIGestureRecognizerStateEnded)
    {
        BOOL isShowLight = YES; //是否显示点亮动画
        
        if (_serveceDelegate && [_serveceDelegate respondsToSelector:@selector(clickBlank:)])
        {
            [_serveceDelegate clickBlank:self];
        }
        
        if (_serveceDelegate && [_serveceDelegate respondsToSelector:@selector(closeGoodsView:)])
        {
            [_serveceDelegate closeGoodsView:self];
        }
        if (_serveceDelegate && [_serveceDelegate respondsToSelector:@selector(closeRechargeView:)])
        {
            [_serveceDelegate closeRechargeView:self];
        }
        if (_serveceDelegate && [_serveceDelegate respondsToSelector:@selector(moveAddFriendView)])
        {
            [_serveceDelegate moveAddFriendView];
        }
        if (_serveceDelegate && [_serveceDelegate respondsToSelector:@selector(closeGamesView:)])
        {
            [_serveceDelegate closeGamesView:self];
        }
        if (self.moreToolsView.hidden == NO)
        {
            isShowLight = NO;
            
            FWWeakify(self)
            [UIView animateWithDuration:0.5 animations:^{
                
                FWStrongify(self)
                self.moreToolsView.transform = CGAffineTransformIdentity;
                
            } completion:^(BOOL finished) {
                
                FWStrongify(self)
                self.moreToolsView.hidden = YES;
                
            }];
        }
        if ([_liveInputView isInputViewActive])
        {
            [_liveInputView resignFirstResponder];
            isShowLight = NO;
        }
        else
        {
            if (!_liveInputView.hidden)
            {
                [self hideInputView];
            }
        }
        
        //判断是否正在显示礼物列表
        if (_giftView.isHidden == NO)
        {
            isShowLight = NO;
            [self hiddenGiftView];
        }
        
        //发送点亮消息
        if (isShowLight && !_isHost && _bottomView.canSendLightMsg && _bottomView.lightCount <= 7 && self.fanweApp.appModel.is_no_light != 1)
        {
            int index = arc4random() % 6;
            NSString* imageName = [NSString stringWithFormat:@"heart%d",index];
            
            _bottomView.heartImgViewName = imageName;
            [_bottomView showLight];
            
            SendCustomMsgModel *scmm = [[SendCustomMsgModel alloc] init];
            scmm.msgType = MSG_LIGHT;
            scmm.isShowLight = _canShowLightMessage;
            scmm.msg = imageName;
            scmm.chatGroupID = [_liveItem liveIMChatRoomId];
            [[FWIMMsgHandler sharedInstance] sendCustomGroupMsg:scmm succ:nil fail:nil];
            
            // 进入房间后，第一次点赞时，调用；用于计算：热门排序
            if (_canShowLightMessage)
            {
                NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
                [mDict setObject:@"video" forKey:@"ctl"];
                [mDict setObject:@"like" forKey:@"act"];
                [mDict setObject:_roomIDStr forKey:@"room_id"];
                
                [self.httpsManager POSTWithParameters:mDict SuccessBlock:^(NSDictionary *responseJson){
                    
                } FailureBlock:^(NSError *error) {
                    
                }];
            }
            _canShowLightMessage = NO;
        }
    }
}

#pragma mark   隐藏giftView
- (void)hiddenGiftView
{
    //    self.closeLiveBtn.hidden = NO;
    _bottomView.hidden = NO;
    _msgView.hidden = NO;
    
    if (_sdkDelegate && [_sdkDelegate respondsToSelector:@selector(hideReLiveSlide:)])
    {
        [_sdkDelegate hideReLiveSlide:NO];
    }
    
    FWWeakify(self)
    [UIView animateWithDuration:0.1 animations:^{
        
        FWStrongify(self)
        self.giftView.frame = CGRectMake(0, self.frame.size.height, _giftView.frame.size.width, _giftView.frame.size.height);
        
    }completion:^(BOOL finished) {
        
        FWStrongify(self)
        self.giftView.hidden = YES;
        
    }];
    if (_goldFlowerView && _goldViewCanNotSee == YES)
    {
        _goldViewCanNotSee = NO;
        _goldFlowerView.frame = CGRectMake(0, kScreenH-_goldFlowerViewHeiht, kScreenW, _goldFlowerViewHeiht);
        _bottomView.heartRect = CGRectMake(kScreenW-kDefaultMargin*2-kMyBtnWidth1*2+5, kScreenH-kDefaultMargin-kMyBtnWidth1+5-_goldFlowerViewHeiht, kMyBtnWidth1-10, kMyBtnWidth1-10);
        [self relayoutFrameOfSubViews];
        _bottomView.switchGameViewBtn.transform = CGAffineTransformIdentity;
    }
    else if (_guessSizeView && _guessSizeViewCanNotSee == YES)
    {
        _guessSizeViewCanNotSee = NO;
        _guessSizeView.frame = CGRectMake(0, kScreenH-kGuessSizeViewHeight, kScreenW, kGuessSizeViewHeight);
        _bottomView.heartRect = CGRectMake(kScreenW-kDefaultMargin*2-kMyBtnWidth1*2+5, kScreenH-kDefaultMargin-kMyBtnWidth1+5-kGuessSizeViewHeight, kMyBtnWidth1-10, kMyBtnWidth1-10);
        [self relayoutFrameOfSubViews];
        _bottomView.switchGameViewBtn.transform = CGAffineTransformIdentity;
    }
}

#pragma mark 用来解决跟tableview等的手势冲突问题
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[TCShowLiveView class]] && _isHost && _sdkDelegate && [_sdkDelegate respondsToSelector:@selector(hostReceiveTouch:)])
    {
        [_sdkDelegate hostReceiveTouch:touch];
    }
    
    if ([touch.view isKindOfClass:[UITextView class]] || [touch.view isKindOfClass:[TCShowLiveView class]])
    {
        return YES;
    }
    else if([touch.view isKindOfClass:[UIView class]] && (touch.view.tag == kPlane1Tag || touch.view.tag == kPlane2Tag || touch.view.tag == kFerrariTag || touch.view.tag == kLambohiniTag || touch.view.tag == kRocket1Tag))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

#pragma mark    ------------------------游戏相关---------------------------------
- (void)loadGameData
{
    if (_canNotLoadData && !_shouldReloadGame)
    {
        _canNotLoadData = NO;
        return;
    }
    _sureOnceGame = NO;
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    [mDict setObject:@"games" forKey:@"ctl"];
    [mDict setObject:@"get_video" forKey:@"act"];
    if (_isHost || [_liveItem liveType] == 0)
    {
        // 主播前后台切换调用
        [mDict setObject:@(_liveItem.liveAVRoomId) forKey:@"video_id"];
    }
    else if (_game_log_id)
    {
        [mDict setObject:@(_game_log_id) forKey:@"id"];
    }
    else
    {
        //防止gameLogID在外部被修改为0时请求游戏数据调用
        [mDict setObject:@(_liveItem.liveAVRoomId) forKey:@"video_id"];
    }
    
    FWWeakify(self)
    
    [self.httpsManager POSTWithParameters:mDict SuccessBlock:^(NSDictionary *responseJson) {
        
        FWStrongify(self)
        
        if ([responseJson toInt:@"status"] == 1)
        {
            [self addGameDataWithDic:responseJson];
            if (self.giftView.hidden == YES)
            {
                self.bottomView.hidden = NO;
            }
        }
        else
        {
            [[FWHUDHelper sharedInstance] tipMessage:[responseJson toString:@"error"]];
            if (self.giftView.hidden == YES)
            {
                self.bottomView.hidden = NO;
            }
            [self hidenAboutGameBtn];
        }
        
    } FailureBlock:^(NSError *error) {
        
        FWStrongify(self)
        if (self.giftView.hidden == YES)
        {
            self.bottomView.hidden = NO;
        }
        [self hidenAboutGameBtn];
        
    }];
}

- (void)hidenAboutGameBtn
{
    _bottomView.switchBankerBtn.hidden = YES;
    _bottomView.switchGameViewBtn.hidden = YES;
    _bottomView.beginGameBtn.hidden = YES;
    _bottomView.grabBankerBtn.hidden = YES;
}

- (void)sendDataWithDic:(NSDictionary *)dic
{
    
#ifdef DEBUG
    NSMutableDictionary * dicData = [NSMutableDictionary dictionary];
    [dicData setObject:dic forKey:@"test_system_im"];
    [dicData setObject:@"pushTest" forKey:@"act"];
    [dicData setObject:@"games" forKey:@"ctl"];
    [self.httpsManager POSTWithParameters:dicData SuccessBlock:^(NSDictionary *responseJson) {
        NSLog(@"%@",[responseJson toString:@"status"]);
    } FailureBlock:^(NSError *error) {
        
    }];
#endif
    
}

//主播调
- (void)addGameView
{
    if (_gameId != 4 && !_goldFlowerView)
    {
        _goldFlowerView = [[GoldFlowView alloc] initWithFrame:CGRectMake(0, kScreenH-_goldFlowerViewHeiht ,kScreenW, _goldFlowerViewHeiht) withBetArray:nil withIsHost:YES];
        _goldFlowerView.isArc = _isArc;
        _goldFlowerView.isHost = YES;
        _goldFlowerView.delegate = self;
        [self addSubview:_goldFlowerView];
        [self sendSubviewToBack:_goldFlowerView];
        _goldViewCanNotSee = NO;
        _bottomView.switchGameViewBtn.transform = CGAffineTransformIdentity;
        [self relayoutFrameOfSubViews];
        [self showInPutView];
    }
    else if (_gameId == 4 && !_guessSizeView )
    {
        _guessSizeView = [[NSBundle mainBundle] loadNibNamed:@"GuessSizeView" owner:nil options:nil].lastObject;
        _guessSizeView.frame = CGRectMake(0, kScreenH-kGuessSizeViewHeight, kScreenW, kGuessSizeViewHeight);
        _guessSizeView.isArc = _isArc;
        _guessSizeView.isHost = YES;
        _guessSizeView.delegate = self;
        [_guessSizeView creatLabel];
        [_guessSizeView createButtomView];
        [self addSubview:_guessSizeView];
        [self sendSubviewToBack:_guessSizeView];
        _guessSizeViewCanNotSee = NO;
        _bottomView.switchGameViewBtn.transform = CGAffineTransformIdentity;
        [self relayoutFrameOfSubViews];
        [self showInPutView];
    }
    
    _bottomView.switchGameViewBtn.hidden = NO;
    _bottomView.switchGameViewBtn.userInteractionEnabled = YES;
    [self changeBeginButtonWithCanBeginNext:NO];
    CGFloat height = _gameId == 4 ?  kGuessSizeViewHeight : _goldFlowerViewHeiht;
    _bottomView.heartRect = CGRectMake(kScreenW-kDefaultMargin*2-kMyBtnWidth1*2+5, kScreenH-kDefaultMargin-kMyBtnWidth1+5-height, kMyBtnWidth1-10, kMyBtnWidth1-10);
    [self createGameHistoryView];
}

//观众调
- (void)loadGoldFlowerViewWithBetArray:(NSArray *) betArray withGameID:(NSInteger)gameID
{
    _gameId = gameID;
    if (_gameId != 4 && !_goldFlowerView)
    {
        _goldFlowerView = [[GoldFlowView alloc] initWithFrame:CGRectMake(0, kScreenH-_goldFlowerViewHeiht ,kScreenW, _goldFlowerViewHeiht) withBetArray:betArray withIsHost:NO];
        _goldFlowerView.isHost = NO;
        _goldFlowerView.delegate = self;
        [self addSubview:_goldFlowerView];
        [self sendSubviewToBack:_goldFlowerView];
        _goldViewCanNotSee = NO;
        _bottomView.switchGameViewBtn.transform = CGAffineTransformIdentity;
        [self relayoutFrameOfSubViews];
        [self showInPutView];
    }
    else if (_gameId == 4 && !_guessSizeView)
    {
        _guessSizeView = [[NSBundle mainBundle] loadNibNamed:@"GuessSizeView" owner:nil options:nil].lastObject;
        _guessSizeView.frame = CGRectMake(0, kScreenH-kGuessSizeViewHeight, kScreenW, kGuessSizeViewHeight);
        _guessSizeView.isHost = NO;
        _guessSizeView.delegate = self;
        _guessSizeView.betOptionArray = betArray;
        [_guessSizeView creatLabel];
        [_guessSizeView createButtomView];
        [self addSubview:_guessSizeView];
        [self sendSubviewToBack:_guessSizeView];
        _guessSizeViewCanNotSee = NO;
        _bottomView.switchGameViewBtn.transform = CGAffineTransformIdentity;
        [self relayoutFrameOfSubViews];
        [self showInPutView];
    }
    _bottomView.switchGameViewBtn.hidden = NO;
    _bottomView.switchGameViewBtn.userInteractionEnabled = YES;
    CGFloat height = gameID == 4 ?  kGuessSizeViewHeight : _goldFlowerViewHeiht;
    _bottomView.heartRect = CGRectMake(kScreenW-kDefaultMargin*2-kMyBtnWidth1*2+5, kScreenH-kDefaultMargin-kMyBtnWidth1+5-height, kMyBtnWidth1-10, kMyBtnWidth1-10);
    
    [self createGameHistoryView];
}

#pragma mark -- 创建游戏记录视图和获胜奖励视图
- (void)createGameHistoryView
{
    if (!_gamehistoryView)
    {
        _historyBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
        _historyBgView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.4];
        _historyBgView.hidden = YES;
        [self addSubview:_historyBgView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(historyViewDown)];
        [_historyBgView addGestureRecognizer:tap];
        
        //游戏历史视图
        _gamehistoryView = [[GameHistoryView alloc]initWithFrame:CGRectMake((kScreenW - 265)/2, kScreenH, 265, 400) withGameID:[NSString stringWithFormat:@"%ld",(long)_gameId]];
        _gamehistoryView.layer.cornerRadius = 10;
        _gamehistoryView.layer.masksToBounds = YES;
        _gamehistoryView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_gamehistoryView];
        
        _winBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
        _winBgView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.4];
        _winBgView.hidden = YES;
        [self addSubview:_winBgView];
        
        //游戏获胜视图
        _gameWinView = [GameWinView EditNibFromXib];
        _gameWinView.frame = CGRectMake((kScreenW - 320)/2, kScreenH, 320, 220);
        _gameWinView.winBgView.layer.cornerRadius = 10;
        _gameWinView.winBgView.layer.masksToBounds = YES;
        _gameWinView.gameWinLab.textColor = kAppGrayColor1;
        _gameWinView.delegate = self;
        //字体加粗
        [_gameWinView.gameWinLab setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
        [self addSubview:_gameWinView];
        //        UITapGestureRecognizer *gameWinViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gameWinViewDown)];
        //        UITapGestureRecognizer *winBgViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gameWinViewDown)];
        //[_gameWinView addGestureRecognizer:gameWinViewTap];
        // [_winBgView addGestureRecognizer:winBgViewTap];
        
        _bankerBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
        _bankerBgView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.4];
        _bankerBgView.hidden = YES;
        [self addSubview:_bankerBgView];
        UITapGestureRecognizer *bankerViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBankerView)];
        [_bankerBgView addGestureRecognizer:bankerViewTap];
        //申请上庄视图
        _bankerView = [ApplyBankerView EditNibFromXib];
        [_bankerView createStyle];
        _bankerView.delegate = self;
        _bankerView.hidden = YES;
        _bankerView.frame = CGRectMake((kScreenW - 255)/2, kScreenH, 255, 195);
        _bankerView.video_id = [NSString stringWithFormat:@"%d",[_liveItem liveAVRoomId]];
        [self addSubview:_bankerView];
        
        [self createExchangeCoinView];
    }
    else
    {
        [_gamehistoryView changePositionWithGameID:[NSString stringWithFormat:@"%ld",(long)_gameId]];
    }
}

#pragma mark    创建兑换视图
- (void)createExchangeCoinView
{
    if (!_exchangeView)
    {
        _exchangeView                      = [ExchangeCoinView EditNibFromXib];
        _exchangeView.exchangeType         = 1;
        _exchangeView.delegate             = self;
        _exchangeView.frame                = CGRectMake((kScreenW - 300)/2, kScreenH, 300, 230);
        _exchangeView.hidden               = YES;
        [_exchangeView createSomething];
        [self addSubview:_exchangeView];
    }
}

#pragma mark    弹出游戏历史视图
- (void)displayGameHistory
{
    [self bringSubviewToFront:_historyBgView];
    [self bringSubviewToFront:_gamehistoryView];
    
    FWWeakify(self)
    [UIView animateWithDuration:1.0 delay:0 usingSpringWithDamping:0.95 initialSpringVelocity:10 options: UIViewAnimationOptionCurveLinear  animations:^{
        
        FWStrongify(self)
        self.historyBgView.hidden = NO;
        self.gamehistoryView.frame = CGRectMake((kScreenW - 265)/2, (kScreenH - 400)/2 , 265, 400);
        [self.gamehistoryView loadDataWithGameID:[NSString stringWithFormat:@"%ld",(long)self.gameId] withPodcastID:[[_liveItem liveHost] imUserId] withPage:@"50"];//加载游戏记录列表
        
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark    弹出兑换视图
- (void)displayExchangeView
{
    [self changeMoney];
    [_exchangeView obtainCoinProportion];
    _bankerBgView.hidden = NO;
    _exchangeView.hidden = NO;
    [self bringSubviewToFront:_bankerBgView];
    [self bringSubviewToFront:_exchangeView];
    [_exchangeView.diamondLeftTextfield becomeFirstResponder];
    
    FWWeakify(self)
    [UIView animateWithDuration:0.3 animations:^{
        
        FWStrongify(self)
        self.exchangeView.frame = CGRectMake((kScreenW - 300)/2, (kScreenH - 350)/2, 300, 230);
        
    }];
    
}

#pragma mark    弹出游戏获胜视图
- (void)displayGameWinWithGainModel:(GameGainModel *)gainModel
{
    if (gainModel) {
        _gameWinView.model = gainModel;
    }
    NSInteger giftCount = gainModel.gift_list.count;
    _gameWinView.giftViewHeight.constant = giftCount > 0 ? 190 : 0;
    _gameWinView.height = giftCount > 0 ? 410 : 220;
    _gameWinView.model = gainModel;
    [self bringSubviewToFront:_winBgView];
    [self bringSubviewToFront:_gameWinView];
    
    FWWeakify(self)
    [UIView animateWithDuration:1.0 delay:0 usingSpringWithDamping:0.95 initialSpringVelocity:10 options: UIViewAnimationOptionCurveLinear  animations:^{
        
        FWStrongify(self)
        self.winBgView.hidden = NO;
        if (giftCount == 0) {
            self.gameWinView.frame = CGRectMake((kScreenW - 320)/2, (kScreenH - 220)/2, 320, 220);
            self.gameWinView.giftView.hidden = YES;
        }
        else
        {
            self.gameWinView.frame = CGRectMake((kScreenW - 320)/2, (kScreenH - 410)/2, 320, 410);
            self.gameWinView.giftView.hidden = NO;
        }
        if (self.fanweApp.appModel.open_diamond_game_module == 1)
        {
            self.gameWinView.gameWinLab.text = [NSString stringWithFormat:@"%@%@",gainModel.gain,self.fanweApp.appModel.diamond_name];
        }
        else
        {
            self.gameWinView.gameWinLab.text = [NSString stringWithFormat:@"%@游戏币",gainModel.gain];
        }
        
        //先获取gameWinLab在gameWinView上的相对位置
        CGPoint point1 = [_gameWinView.winBgView convertPoint:_gameWinView.gameWinLab.center toView:_gameWinView];
        //再获取point1在self上的位置
        _goldPoint = [_gameWinView convertPoint:point1 toView:self];
        _coinPoint = CGPointMake(17.5, kScreenH - 20);
        
    } completion:^(BOOL finished) {
        
        FWStrongify(self)
        //延迟一秒执行
        if (giftCount == 0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (self.winBgView.hidden == NO && self.winBgView)
                {
                    [self manyCoinDown];
                }
            });
        }
    }];
    
}

#pragma mark    弹出申请上庄视图
- (void)displayBankerView
{
    _bankerBgView.hidden = NO;
    _bankerView.hidden   = NO;
    [self bringSubviewToFront:_bankerBgView];
    [self bringSubviewToFront:_bankerView];
    [_bankerView.coinTextfield becomeFirstResponder];
    
    FWWeakify(self)
    [UIView animateWithDuration:0.3 animations:^{
        
        FWStrongify(self)
        self.bankerView.frame = CGRectMake((kScreenW - 255)/2, (kScreenH - 280)/2, 255, 195);       //中心195
        
    }];
}

#pragma mark    选择上庄视图消失
- (void)selectBankerViewDown
{
    FWWeakify(self)
    [UIView animateWithDuration:0.3 animations:^{
        
        FWStrongify(self)
        self.selectctBankerView.frame = CGRectMake((kScreenW - 280)/2, kScreenH, 280, 290);
        
    }];
}

#pragma mark    游戏历史视图下落
- (void)historyViewDown
{
    FWWeakify(self)
    [UIView animateWithDuration:0.3 animations:^{
        
        FWStrongify(self)
        self.historyBgView.hidden = YES;
        self.gamehistoryView.frame = CGRectMake((kScreenW - 265)/2, kScreenH , 265, 400);
        
    }];
}

#pragma mark    游戏获胜视图下落
- (void)gameWinViewDown
{
    FWWeakify(self)
    [UIView animateWithDuration:0.3 animations:^{
        
        FWStrongify(self)
        self.winBgView.hidden = YES;
        self.gameWinView.frame = CGRectMake((kScreenW - 320)/2, kScreenH, 320, 220);
        self.gameWinView.giftView.hidden = YES;
        
    }];
}

- (void)tapBankerView
{
    [self bankerViewDown];
}

#pragma mark    申请上庄视图下落
- (void)bankerViewDown
{
    [_bankerView.coinTextfield resignFirstResponder];
    [_exchangeView.diamondLeftTextfield resignFirstResponder];
    _bankerView.coinTextfield.text = nil;
    _exchangeView.diamondLeftTextfield.text = nil;
    
    FWWeakify(self)
    [UIView animateWithDuration:0.3 animations:^{
        
        FWStrongify(self)
        self.bankerView.frame = CGRectMake((kScreenW - 255)/2, kScreenH, 255, 195);
        self.exchangeView.frame = CGRectMake((kScreenW - 300)/2, (kScreenH - 350)/2, 300, 230);
        
    }completion:^(BOOL finished) {
        
        FWStrongify(self)
        self.bankerBgView.hidden = YES;
        self.exchangeView.hidden = YES;
        self.bankerView.hidden = YES;
        
    }];
}

- (void)hiddenGrabBankerBtnWithCoin:(NSString *)coin
{
    //    _bottomView.grabBankerBtn.hidden = YES;
    //    _goldFlowerView.coinView.personCoinLab.text = coin;
    //    [_goldFlowerView judgmentBetView:[coin integerValue]];
}

#pragma mark    移除游戏历史和游戏获胜视图
- (void)removeGameHistoryAndGameWin
{
    [_gamehistoryView removeFromSuperview];
    [_historyBgView removeFromSuperview];
    [_winBgView removeFromSuperview];
    [_gameWinView removeFromSuperview];
    [_selectctBankerView removeFromSuperview];
    [_bankerBgView removeFromSuperview];
    [_bankerView removeFromSuperview];
    [_exchangeView removeFromSuperview];
    _exchangeView = nil;
    _gamehistoryView = nil;
}

#pragma mark 点击“充值”的代理
- (void)clickRecharge
{
    if (_serveceDelegate && [_serveceDelegate respondsToSelector:@selector(rechargeView:)])
    {
        [_serveceDelegate rechargeView:self];
    }
}

#pragma mark    兑换视图消失
- (void)exchangeViewDownWithExchangeCoinView:(ExchangeCoinView *)exchangeCoinView
{
    if (_exchangeView == exchangeCoinView)
    {
        FWWeakify(self)
        [UIView animateWithDuration:0.3 animations:^{
            
            FWStrongify(self)
            [self.exchangeView.diamondLeftTextfield resignFirstResponder];
            self.exchangeView.diamondLeftTextfield.text = nil;
            self.exchangeView.coinLabel.text = @"0游戏币";
            self.exchangeView.frame = CGRectMake((kScreenW - 300)/2, kScreenH, 300, 230);
            
        } completion:^(BOOL finished) {
            
            FWStrongify(self)
            self.bankerBgView.hidden = YES;
            self.exchangeView.hidden = YES;
            
        }];
    }
}

#pragma mark    游戏获胜金币下落
- (void)manyCoinDown
{
    FWWeakify(self)
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        FWStrongify(self)
        [self gameWinViewDown];
        
    });
}

#pragma mark    庄家是否隐藏押注按钮
- (void)hiddenBetView:(BOOL)hidden
{
    [_goldFlowerView.betViewArray enumerateObjectsUsingBlock:^(BetView * betView, NSUInteger idx, BOOL * _Nonnull stop){
        
        if (idx < _goldFlowerView.betViewArray.count - 1)
        {
            betView.hidden = hidden;
        }
        
    }];
}

#pragma mark    金币移动动画(传入起始位置和终点位置)
- (void)coinMoveWithEnd:(CGPoint)end withBegin:(CGPoint)begin
{
    UIImageView *breathImg = [[UIImageView alloc]init];
    breathImg.width = 25;
    breathImg.height = 25;
    breathImg.center = begin;
    breathImg.image = [UIImage imageNamed:@"coin"];
    [self addSubview:breathImg];
    [_coinImgArray addObject:breathImg];
    [breathImg.layer addAnimation:[CAAnimation coinMoveAntimationWithBegin:breathImg.center
                                                                   WithEnd:end
                                                               andMoveTime:kMoveAnimationDuration
                                                             andNarrowTime:kNarrowAnimationDuration
                                                        andNarrowFromValue:1.0f
                                                          andNarrowToValue:0.0f]
                           forKey:@"coinDown"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kCoinMoveAnimationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (breathImg)
        {
            [breathImg removeFromSuperview];
        }
    });
    
}

#pragma mark    主播下庄请求
- (void)closeBanker
{
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    [mDict setObject:@"games" forKey:@"ctl"];
    [mDict setObject:@"stopBanker" forKey:@"act"];
    [self.httpsManager POSTWithParameters:mDict SuccessBlock:^(NSDictionary *responseJson) {
        
        if ([responseJson toInt:@"status"] ==1)
        {
            
        }
        
    } FailureBlock:^(NSError *error) {
        
    }];
}

#pragma mark    主播上庄请求
- (void)beginBanker
{
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    [mDict setObject:@"games" forKey:@"ctl"];
    [mDict setObject:@"openBanker" forKey:@"act"];
    [self.httpsManager POSTWithParameters:mDict SuccessBlock:^(NSDictionary *responseJson) {
        
        if ([responseJson toInt:@"status"] ==1)
        {
            
        }
        
    } FailureBlock:^(NSError *error) {
        
    }];
}

#pragma mark 获取上庄玩家底金
- (void)obtainBankerCoin
{
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    [mDict setObject:@"games" forKey:@"ctl"];
    [mDict setObject:@"getBankerCoin" forKey:@"act"];
    [mDict setObject:_roomIDStr forKey:@"video_id"];
    
    FWWeakify(self)
    [self.httpsManager POSTWithParameters:mDict SuccessBlock:^(NSDictionary *responseJson) {
        
        FWStrongify(self)
        if ([responseJson toInt:@"status"] == 1)
        {
            GameBankerModel *model = [GameBankerModel mj_objectWithKeyValues:[responseJson objectForKey:@"data"]];
            self.gameBankerView.bankerDesLabel.text = [NSString stringWithFormat:@"剩余底金%@",model.coin];
        }
        
    } FailureBlock:^(NSError *error) {
        
    }];
}

#pragma mark 打开或关闭游戏视图
- (void)closeOrOpenGameView
{
    if (_goldViewCanNotSee == NO && _goldFlowerView)
    {
        _goldViewCanNotSee = YES;
        
        FWWeakify(self)
        [UIView animateWithDuration:0.2 animations:^{
            
            FWStrongify(self)
            self.goldFlowerView.frame = CGRectMake(0, kScreenH, kScreenW, _goldFlowerViewHeiht);
            self.bottomView.heartRect = CGRectMake(kScreenW-kDefaultMargin*2-kMyBtnWidth1*2+5, kScreenH-kDefaultMargin-kMyBtnWidth1+5, kMyBtnWidth1-10, kMyBtnWidth1-10);
            [self relayoutFrameOfSubViews];
            self.bottomView.switchGameViewBtn.transform = CGAffineTransformMakeRotation(M_PI);
            
        } completion:^(BOOL finished) {
            
        }];
    }
    else if (_goldViewCanNotSee == YES && _goldFlowerView)
    {
        //判断是否正在显示礼物列表
        if (_giftView.isHidden == NO)
        {
            _bottomView.hidden = NO;
            _msgView.hidden = NO;
            _giftView.frame = CGRectMake(0, self.frame.size.height, _giftView.frame.size.width, _giftView.frame.size.height);
            _giftView.hidden = YES;
        }
        _goldViewCanNotSee = NO;
        
        FWWeakify(self)
        [UIView animateWithDuration:0.2 animations:^{
            
            FWStrongify(self)
            self.goldFlowerView.frame = CGRectMake(0, kScreenH-_goldFlowerViewHeiht, kScreenW, _goldFlowerViewHeiht);
            self.bottomView.heartRect = CGRectMake(kScreenW-kDefaultMargin*2-kMyBtnWidth1*2+5, kScreenH-kDefaultMargin-kMyBtnWidth1+5-_goldFlowerViewHeiht, kMyBtnWidth1-10, kMyBtnWidth1-10);
            [self relayoutFrameOfSubViews];
            self.bottomView.switchGameViewBtn.transform = CGAffineTransformIdentity;
            
        } completion:^(BOOL finished) {
            
        }];
    }
    else if (_guessSizeViewCanNotSee == NO && _guessSizeView)
    {
        _guessSizeViewCanNotSee = YES;
        
        [UIView animateWithDuration:0.2 animations:^{
            _guessSizeView.frame = CGRectMake(0, kScreenH, kScreenW, kGuessSizeViewHeight);
            _bottomView.heartRect = CGRectMake(kScreenW-kDefaultMargin*2-kMyBtnWidth1*2+5, kScreenH-kDefaultMargin-kMyBtnWidth1+5, kMyBtnWidth1-10, kMyBtnWidth1-10);
            [self relayoutFrameOfSubViews];
            _bottomView.switchGameViewBtn.transform = CGAffineTransformMakeRotation(M_PI);
        } completion:^(BOOL finished) {
            
        }];
    }
    else if (_guessSizeViewCanNotSee == YES && _guessSizeView)
    {
        //判断是否正在显示礼物列表
        if (_giftView.isHidden == NO)
        {
            _bottomView.hidden = NO;
            _msgView.hidden = NO;
            _giftView.frame = CGRectMake(0, self.frame.size.height, _giftView.frame.size.width, _giftView.frame.size.height);
            _giftView.hidden = YES;
        }
        _guessSizeViewCanNotSee = NO;
        
        [UIView animateWithDuration:0.2 animations:^{
            _guessSizeView.frame = CGRectMake(0, kScreenH-kGuessSizeViewHeight, kScreenW, kGuessSizeViewHeight);
            _bottomView.heartRect = CGRectMake(kScreenW-kDefaultMargin*2-kMyBtnWidth1*2+5, kScreenH-kDefaultMargin-kMyBtnWidth1+5-kGuessSizeViewHeight, kMyBtnWidth1-10, kMyBtnWidth1-10);
            [self relayoutFrameOfSubViews];
            _bottomView.switchGameViewBtn.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            
        }];
    }
}

#pragma mark 更新游戏显示的coin
- (void)updateCoinLable:(long)coin
{
    if (self.fanweApp.appModel.open_diamond_game_module == 1)
    {
        // 更新游戏余额
        if (self.goldFlowerView)
        {
            self.goldFlowerView.coinView.gameRechargeView.accountLabel.text =[NSString stringWithFormat:@"%ld",(long)coin];
        }
        else if (_guessSizeView)
        {
            self.guessSizeView.gameRechargeView.accountLabel.text = [NSString stringWithFormat:@"%ld",(long)coin];
        }
    }
}


#pragma mark - ----------------------- 购物相关 -----------------------

- (void)clickStarShopButton
{
    _bottomView.hidden = NO;
    _closeLiveBtn.hidden = NO;
    if (!_hadClickStarShop)
    {
        if (_serveceDelegate && [_serveceDelegate respondsToSelector:@selector(clickStarShop:)])
        {
            [_serveceDelegate clickStarShop:self];
        }
        _hadClickStarShop = YES;
        
        FWWeakify(self)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            FWStrongify(self)
            self.hadClickStarShop = NO;
            
        });
    }
}

- (MoreToolsView *)moreToolsView
{
    if (_moreToolsView == nil)
    {
        _moreToolsView = [[MoreToolsView alloc] initWithFrame:CGRectMake(kDefaultMargin, kScreenH, kScreenW-2*kDefaultMargin, kScreenH)];
        _moreToolsView.delegate = self;
        _moreToolsView.hidden = YES;
        [self addSubview:_moreToolsView];
    }
    return _moreToolsView;
}

- (void)clickMoreToolsView:(MoreToolsView *)moreToolsView andToolsModel:(ToolsModel *)model
{
    self.toolsTitle = model.title;
    if ([model.title isEqual:@"星店"])
    {
        [self clickStarShopButton];
    }
    else if ([model.title isEqual:@"小店"])
    {
        if (_serveceDelegate && [_serveceDelegate respondsToSelector:@selector(clickMyShop:)])
        {
            [_serveceDelegate clickMyShop:self];
        }
    }
}

- (void)clickCancleWithMoreToolsView:(MoreToolsView *)moreToolsView
{
    
}

#pragma mark - ----------------------- 游戏推送相关处理 -----------------------
//游戏结束推送
- (void)gameOverWithCustomMessageModel:(CustomMessageModel *)customMessageModel
{
    //如果接收到的推送时间戳小于当前时间戳则该游戏推送不执行
    if ([customMessageModel.timestamp doubleValue] < _timestamp)
    {
        return;
    }
    _timestamp = [customMessageModel.timestamp doubleValue];
    if (_isHost || [_liveItem liveType] == 0)
    {
        _bottomView.beginGameBtn.hidden = YES;
    }
    _bottomView.switchGameViewBtn.hidden = YES;
    _bottomView.switchBankerBtn.hidden = YES;
    _bottomView.grabBankerBtn.hidden = YES;
    _bottomView.switchGameViewBtn.userInteractionEnabled = NO;
    _bottomView.heartRect = CGRectMake(kScreenW-kDefaultMargin*2-kMyBtnWidth1*2+5, kScreenH-kDefaultMargin-kMyBtnWidth1+5, kMyBtnWidth1-10, kMyBtnWidth1-10);
    _bottomView.bankMessage = 0;
    _bottomView.bjsbadge.badgeText = nil;
    [_goldFlowerView closeGameAboutTimer];
    [_goldFlowerView removeFromSuperview];
    [_guessSizeView disClockTime];
    [_guessSizeView removeFromSuperview];
    [self removeGameHistoryAndGameWin];
    _isArc = NO;
    //    _goldFlowerView.isArc = NO;
    _goldFlowerView = nil;
    //    _guessSizeView.isArc = NO;
    _guessSizeView = nil;
    [self relayoutFrameOfSubViews];
    _game_log_id = 0;
    [self.bankerListArr removeAllObjects];
    self.gameBankerView.hidden = YES;
    [self.selectctBankerView removeFromSuperview];
    _selectctBankerView = nil;
    [self changePayViewFrame];
    [self showInPutView];
}

//游戏总的推送
- (void)gameAllMessageWithCustomMessageModel:(CustomMessageModel *)customMessageModel
{
    //NSInteger  actionInt = [customMessageModel.game_action integerValue];
    //游戏操作，不同游戏略有不同：开始：1；下注：2；停止：3；结算：4；翻牌：5；
    if (![self isShouldPlayer:customMessageModel.user_id] && [customMessageModel.user_id integerValue] != 0)
    {
        return;
    }
    if (_shouldReloadGame == YES )
    {
        if ([customMessageModel.game_action isEqualToString:@"1"])
        {
            _coinWindowNumber = 0;
        }
        else
        {
            [self.gameArray addObject:customMessageModel];
        }
        return;
    }
    //如果接收到的推送时间戳小于当前时间戳则该游戏推送不执行
    if ([customMessageModel.timestamp doubleValue] < _timestamp)
    {
        return;
    }
    _timestamp = [customMessageModel.timestamp doubleValue];
    if ([customMessageModel.game_log_id integerValue] > _game_log_id)
    {
        for (CustomMessageModel * model in self.gameDataArray)
        {
            //已经开始下一局游戏
            if ([model.game_action integerValue] == 4 && [customMessageModel.game_action integerValue] == 1)
            {
                _hadBeginNext = YES;
            }
        }
        [self.gameDataArray removeAllObjects];
        _canNotLoadData = NO;
        if (_goldFlowerView)
        {
            [_goldFlowerView.userBetArr removeAllObjects];
            [_goldFlowerView.betArr removeAllObjects];
        }
        else if (_guessSizeView)
        {
            [_guessSizeView.userBetArr removeAllObjects];
            [_guessSizeView.betArr removeAllObjects];
        }
    }
    if ([customMessageModel.game_log_id integerValue] >= _game_log_id)
    {
        for (CustomMessageModel * model in self.gameDataArray)
        {
            if ([model isEqual:customMessageModel] )
            {
                return;
            }
            if (![customMessageModel.game_action isEqualToString:@"2"])
            {
                if ([model.game_action isEqual:customMessageModel.game_action] && [model.game_log_id isEqual:customMessageModel.game_log_id])
                {
                    return;
                }
            }
        }
        [self.gameDataArray addObject:customMessageModel];
        _game_log_id = [customMessageModel.game_log_id integerValue];
        _gameAction = [customMessageModel.game_action intValue];
        _gameId = [customMessageModel.game_id integerValue];
        if (_goldFlowerView)
        {
            _goldFlowerView.gameAction = _gameAction;
        }
        if ([customMessageModel.game_action isEqualToString:@"1"])
        {
            _banker_status = [customMessageModel.banker_status integerValue];
            if (_goldFlowerView.showPokerTimer)
            {
                [_goldFlowerView.showPokerTimer invalidate];
                _goldFlowerView.showPokerTimer = nil;
            }
            if (_guessSizeView.showDiceTimer)
            {
                [_guessSizeView.showDiceTimer invalidate];
                _guessSizeView.showDiceTimer = nil;
            }
            _bottomView.bankMessage = 0;
            _bottomView.bjsbadge.badgeText = nil;
            _coinWindowNumber = 0;
            if (_isHost || [_liveItem liveType] == 0)
            {
                [self addGameView];
                [self changeBeginButtonWithCanBeginNext:NO];
            }
            else
            {
                [self loadGoldFlowerViewWithBetArray:customMessageModel.bet_option withGameID:[customMessageModel.game_id integerValue]];
                [self hideGameView];
            }
            _bottomView.switchGameViewBtn.hidden = NO;
            if (_goldFlowerView)
            {
                _goldFlowerView.betOptionArray = customMessageModel.bet_option;
                _goldFlowerView.game_log_id = customMessageModel.game_log_id;
                //_game_log_id = [customMessageModel.game_log_id integerValue];
                [self disAboutClick];
                [_goldFlowerView overPokerKJTime:[customMessageModel.time intValue]];
                [_goldFlowerView gameToPrepareTypeGoldenFlowerOrBull:customMessageModel.game_id card:customMessageModel.game_data.public_cards];
                [_goldFlowerView loadOptionArray:customMessageModel.option];
            }
            else if (_guessSizeView)
            {
                _guessSizeView.betOptionArray = customMessageModel.bet_option;
                _guessSizeView.game_log_id = customMessageModel.game_log_id;
                [_guessSizeView disClockTime];
                [_guessSizeView showTime:[customMessageModel.time intValue]];
                [_guessSizeView loadOptionArray:customMessageModel.option];
                _guessSizeView.canBet = YES;
            }
            [self loadBankerDataWithModel:customMessageModel withHadLeft:_shouldReloadGame];
            _bottomView.switchBankerBtn.hidden = YES;
        }
        else if ([customMessageModel.game_action isEqualToString:@"2"])
        {
            NSArray * betArray = customMessageModel.game_data.bet;
            if (_goldFlowerView)
            {
                [_goldFlowerView loadBetDataWithBetArray:betArray andUserBetArray:nil];
            }
            else if(_guessSizeView)
            {
                [_guessSizeView loadBetDataWithBetArray:betArray andUserBetArray:nil];
            }
        }
        else if ([customMessageModel.game_action isEqualToString:@"3"])
        {
            if (_isHost || [_liveItem liveType] == 0)
            {
                [self changeBeginButtonWithCanBeginNext:YES];
            }
            _bottomView.switchGameViewBtn.hidden = YES;
            _bottomView.switchGameViewBtn.userInteractionEnabled = NO;
            [_goldFlowerView closeGameAboutTimer];
            [_goldFlowerView removeFromSuperview];
            [_guessSizeView removeFromSuperview];
            _guessSizeView = nil;
            [self removeGameHistoryAndGameWin];
            _goldFlowerView = nil;
            [self relayoutFrameOfSubViews];
            _game_log_id = 0;
        }
        else if ([customMessageModel.game_action isEqualToString:@"4"])
        {
            _banker_status = [customMessageModel.banker_status integerValue];
            NSArray * pokerArray = customMessageModel.game_data.cards_data;
            NSInteger result = [customMessageModel.game_data.win integerValue];
            NSArray * dicArr = customMessageModel.game_data.dices;
            if (_gameId != 4)
            {
                for (id dic in pokerArray)
                {
                    if (![dic isKindOfClass:[NSDictionary class]])
                    {
                        return;
                    }
                }
                if (pokerArray.count==3)
                {
                    [self disAboutClick];
                    //            [_goldFlowerView endAnmination];
                    [_goldFlowerView whetherBet:NO];
                    if (_goldFlowerView.smallArray.count == 0)
                    {
                        [_goldFlowerView creatPokerhiden:NO gameType:customMessageModel.game_id card:customMessageModel.game_data.public_cards];//记载发牌视图
                        [_goldFlowerView creatBetAmount:NO type:customMessageModel.game_id];//加载下注视图
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [_goldFlowerView startOpenCard:pokerArray[0] between:pokerArray[1] rigth:pokerArray[2] andResult:result gameId:customMessageModel.game_id];                        });
                    }
                    else
                    {
                        
                        [_goldFlowerView startOpenCard:pokerArray[0] between:pokerArray[1] rigth:pokerArray[2] andResult:result gameId:customMessageModel.game_id];
                    }
                }
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    //用户更新余额
                    [_goldFlowerView updateCoinWithID:customMessageModel.game_log_id];
                    [self gameEndAction];
                    //                    if (_isArc && kSupportArcGame) {
                    //                        [self onBottomViewClickMenus:_bottomView fromButton:_bottomView.beginGameBtn];
                    //                    }
                });
            }
            else
            {
                _guessSizeView.canBet = NO;
                [_guessSizeView disClockTime];
                [_guessSizeView loadDiceWithDicesArr:dicArr andResultWinPostion:result];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    //用户更新余额
                    [_guessSizeView updateCoinWithID:customMessageModel.game_log_id];
                    [self gameEndAction];
                });
            }
            _bottomView.switchBankerBtn.hidden = NO;
            [self loadBankerDataWithModel:customMessageModel withHadLeft:_shouldReloadGame];
        }
        else if ([customMessageModel.game_action isEqualToString:@"5"])
        {
            
        }
        else if ([customMessageModel.game_action isEqualToString:@"6"])
        {
            if (_sureOnceGame)
            {
                return;
            }
            if (_liveGameModel)
            {
                if ([customMessageModel.game_log_id isEqual:_liveGameModel.game_log_id])
                {
                    //进入此判断说明先接收到了post请求中的数据返回后接收到推送的数据
                    _sureOnceGame = YES;
                    return;
                }
            }
            //观众，主播调用进入直播间获取游戏数据的接口发送请求后收到的推送实现的方法
            [self intoLiveRoomWithCustomMessageModel:customMessageModel];
        }
    }
}

- (void)gameEndAction
{
    if (_gameBankerView.hidden == NO)
    {
        [self obtainBankerCoin];
    }
    if (_isHost || [_liveItem liveType] == 0)
    {
        if (_gameAction == 4)
        {
            [self changeBeginButtonWithCanBeginNext:YES];
        }
    }
}

- (void)showInPutView
{
    if ([_liveInputView isInputViewActive])
    {
        [_liveInputView resignFirstResponder];
        // 显示消息输入
        _bankerViewCanSee = NO;
        [_liveInputView becomeFirstResponder];
        _liveInputView.hidden = NO;
        _bottomView.hidden = YES;
    }
}

- (BOOL)isShouldPlayer:(id) user
{
    return [[IMAPlatform sharedInstance].host isCurrentHost:user];
}

//观众，主播调用进入直播间获取游戏数据的接口发送请求后收到的推送实现的方法
- (void)intoLiveRoomWithCustomMessageModel:(CustomMessageModel *)customMessageModel
{
    if (![self isShouldPlayer:customMessageModel.user_id] && [customMessageModel.user_id integerValue] != 0)
    {
        return;
    }
    if (_goldFlowerView.showPokerTimer)
    {
        [_goldFlowerView.showPokerTimer invalidate];
        _goldFlowerView.showPokerTimer = nil;
    }
    [_goldFlowerView removeFromSuperview];
    _goldFlowerView = nil;
    if (_guessSizeView.showDiceTimer)
    {
        [_guessSizeView.showDiceTimer invalidate];
        _guessSizeView.showDiceTimer = nil;
    }
    [_guessSizeView removeFromSuperview];
    _guessSizeView = nil;
    NSInteger  gameId = [customMessageModel.game_id integerValue];
    _isArc = customMessageModel.auto_start == 1 ? YES : NO;
    if(gameId != 0)
    {
        _gameId = [customMessageModel.game_id integerValue];
        if(_isHost || [_liveItem liveType] == 0)
        {
            [self addGameView];
        }
        else if([_liveItem liveType] != 1)
        {
            [self loadGoldFlowerViewWithBetArray:customMessageModel.bet_option withGameID:gameId];
        }
        [self hideGameView];
        if (_goldFlowerView) {
            _goldFlowerView.game_log_id = customMessageModel.game_log_id;
            //                    _goldFlowerView.betOptionArray = dic[@"bet_option"];
            _goldFlowerView.betOptionArray = customMessageModel.bet_option;
            [self disAboutClick];
            [_goldFlowerView creatPokerhiden:NO gameType:customMessageModel.game_id card:customMessageModel.game_data.public_cards];//记载发牌视图
            [_goldFlowerView creatBetAmount:NO type:customMessageModel.game_id];//加载下注视图
            //倍率
            [_goldFlowerView loadOptionArray:customMessageModel.option];
        }
        else if (_guessSizeView)
        {
            _guessSizeView.game_log_id = customMessageModel.game_log_id;
            _guessSizeView.betOptionArray = customMessageModel.bet_option;
            [_guessSizeView disClockTime];
            [_guessSizeView loadOptionArray:customMessageModel.option];
        }
    }
    if ([customMessageModel.game_status integerValue] == 1)//    游戏状态，1：游戏开始，2：游戏结束
    {
        _bottomView.grabBankerBtn.hidden = YES;
        if (_goldFlowerView)
        {
            if ([_liveItem liveType] == 3 && !_isHost)
            {
                [_goldFlowerView whetherBet:YES];
            }
            else if ([_liveItem liveType] == 2)
            {
                [_goldFlowerView whetherBet:YES];
            }
            [_goldFlowerView timeCountDown:[customMessageModel.time intValue]];//开始倒计时
            //加载更新下注的数据
            [_goldFlowerView loadBetDataWithBetArray:customMessageModel.game_data.bet andUserBetArray:customMessageModel.game_data.user_bet];
        }
        else if (_guessSizeView)
        {
            _guessSizeView.canBet = YES;
            [_guessSizeView showTime:[customMessageModel.time intValue]];
            [_guessSizeView loadBetDataWithBetArray:customMessageModel.game_data.bet andUserBetArray:customMessageModel.game_data.user_bet];
        }
    }
    else if([customMessageModel.game_status integerValue] == 2)//2：开牌中，3：游戏结束;注：投注中game_date不会有win、cards、type数据
    {
        _gameAction = 4;
        if (_goldFlowerView)
        {
            _goldFlowerView.gameAction = _gameAction;
            [self disAboutClick];
            [_goldFlowerView whetherBet:NO];
            NSArray * cardsArray = customMessageModel.game_data.cards_data;
            [_goldFlowerView loadBetDataWithBetArray:customMessageModel.game_data.bet andUserBetArray:customMessageModel.game_data.user_bet];
            [_goldFlowerView showPokerWithData:cardsArray andResult:customMessageModel.game_data.win];
        }
        else if (_guessSizeView)
        {
            _guessSizeView.canBet = NO;
            [_guessSizeView disClockTime];
            [_guessSizeView loadBetDataWithBetArray:customMessageModel.game_data.bet andUserBetArray:customMessageModel.game_data.user_bet];
            [_guessSizeView loadDiceWithDicesArr:customMessageModel.game_data.dices andResultWinPostion:[customMessageModel.game_data.win integerValue]];
        }
        if (_isHost || [_liveItem liveType] == 0)
        {
            [self changeBeginButtonWithCanBeginNext:YES];
        }
        [self.gameArray removeAllObjects];
    }
    //创建游戏历史视图
    [self createGameHistoryView];
    
    _banker_status = [customMessageModel.banker_status integerValue];
    _gameBankerModel = [GameBankerModel mj_objectWithKeyValues:customMessageModel.data[@"banker"]];
    //处理游戏下庄相关的视图(用于调用get_video时)
    [self loadBankerDataWithModel:customMessageModel withHadLeft:_shouldReloadGame];
    
    NSInteger tmpCoin = [[IMAPlatform sharedInstance].host getUserCoin];
    
    if (_goldFlowerView)
    {
        _goldFlowerView.coinView.gameRechargeView.accountLabel.text =[NSString stringWithFormat:@"%ld",(long)tmpCoin];
        if ([_liveItem liveType] == 3 && !_isHost)
        {
            [_goldFlowerView judgmentBetView:tmpCoin];
        }
        else if ([_liveItem liveType] == 2 && !_isHost)
        {
            [_goldFlowerView judgmentBetView:tmpCoin];
        }
    }
    else if (_guessSizeView)
    {
        _guessSizeView.gameRechargeView.accountLabel.text =[NSString stringWithFormat:@"%ld",(long)tmpCoin];
    }
    NSInteger index = 0;
    if(self.bankerDataArr.count>0)
    {
        CustomMessageModel * firstModel = self.bankerDataArr[0];
        double maxMicrotime = [firstModel.timestamp doubleValue];
        //获取到时间戳最大的消息
        for (NSInteger i=1; i<self.bankerDataArr.count; ++i)
        {
            CustomMessageModel * model = self.bankerDataArr[i];
            double microtime = [model.timestamp doubleValue];
            if (maxMicrotime<microtime)
            {
                maxMicrotime = microtime;
                index = i;
            }
        }
    }
    if (_shouldReloadGame == YES)
    {
        _shouldReloadGame = NO;
        if (_gameArray.count > 0 && _gameArray)
        {
            for (CustomMessageModel *msg in _gameArray)
            {
                [self gameAllMessageWithCustomMessageModel:msg];
            }
        }
        if (_bankerDataArr.count>index )
        {
            [self gameBankerMessageWithCustomMessageModel:self.bankerDataArr[index]];
        }
    }
}

- (void)addGameDataWithDic:(NSDictionary *) responseJson
{
    NSDictionary * dic = [responseJson objectForKey:@"data"];
    if (dic && [dic isKindOfClass:[NSDictionary class]])
    {
        _liveGameModel = [LiveGameModel mj_objectWithKeyValues:dic];
        if ([_liveGameModel.game_log_id integerValue]< _game_log_id)
        {
            return;
        }
        if (_sureOnceGame)
        {
            //进入此判断说明先接收到了接收到推送的数据数据返回后接收到请求返回的数据
            return;
        }
        for (CustomMessageModel * model in self.gameDataArray)
        {
            if ([model.game_log_id isEqual:_liveGameModel.game_log_id] && [model.game_action isEqual:@"6"])
            {
                _sureOnceGame = YES;
                return;
            }
        }
        if (_goldFlowerView.showPokerTimer)
        {
            [_goldFlowerView.showPokerTimer invalidate];
            _goldFlowerView.showPokerTimer = nil;
        }
        [_goldFlowerView removeFromSuperview];
        _goldFlowerView = nil;
        if (_guessSizeView.showDiceTimer)
        {
            [_guessSizeView.showDiceTimer invalidate];
            _guessSizeView.showDiceTimer = nil;
        }
        if([dic toInt:@"game_id"] != 0)
        {
            _isArc = _liveGameModel.auto_start == 1 ? YES : NO;
            _gameAction = 0;
            _gameId = [_liveGameModel.game_id integerValue];
            if(_isHost || [_liveItem liveType] == 0)
            {
                [self addGameView];
            }
            else if([_liveItem liveType] != 1)
            {
                [self loadGoldFlowerViewWithBetArray:_liveGameModel.bet_option withGameID:[dic toInt:@"game_id"]];
            }
            [self hideGameView];
            if (_goldFlowerView) {
                _goldFlowerView.game_log_id = _liveGameModel.game_log_id;
                _goldFlowerView.game_id = _liveGameModel.game_id;
                //                    _goldFlowerView.betOptionArray = dic[@"bet_option"];
                _goldFlowerView.betOptionArray = _liveGameModel.bet_option;
                [self disAboutClick];
                [_goldFlowerView creatPokerhiden:NO gameType:_liveGameModel.game_id card:_liveGameModel.game_data.public_cards];//记载发牌视图
                [_goldFlowerView creatBetAmount:NO type:_liveGameModel.game_id];//加载下注视图
                //倍率
                [_goldFlowerView loadOptionArray:_liveGameModel.option];
            }
            else if (_guessSizeView)
            {
                _guessSizeView.game_log_id = _liveGameModel.game_log_id;
                _guessSizeView.betOptionArray = _liveGameModel.bet_option;
                [_guessSizeView loadOptionArray:_liveGameModel.option];
                [_guessSizeView disClockTime];
            }
        }
        if ([_liveGameModel.game_status integerValue] == 1)//    游戏状态，1：游戏开始，2：游戏结束
        {
            if (_goldFlowerView)
            {
                if ([_liveItem liveType] == 3 && !_isHost)
                {
                    [_goldFlowerView whetherBet:YES];
                }
                else if ([_liveItem liveType] == 2)
                {
                    [_goldFlowerView whetherBet:YES];
                }
                [_goldFlowerView timeCountDown:[_liveGameModel.time intValue]];//开始倒计时
                //加载更新下注的数据
                [_goldFlowerView loadBetDataWithBetArray:_liveGameModel.game_data.bet andUserBetArray:_liveGameModel.game_data.user_bet];
            }
            else if (_guessSizeView)
            {
                _guessSizeView.canBet = YES;
                [_guessSizeView showTime:[_liveGameModel.time intValue]];
                [_guessSizeView loadBetDataWithBetArray:_liveGameModel.game_data.bet andUserBetArray:_liveGameModel.game_data.user_bet];
            }
        }
        else if([_liveGameModel.game_status integerValue] == 2)//2：开牌中，3：游戏结束;注：投注中game_date不会有win、cards、type数据
        {
            _gameAction = 4;
            if (_goldFlowerView)
            {
                _goldFlowerView.gameAction = _gameAction;
                [self disAboutClick];
                [_goldFlowerView whetherBet:NO];
                NSArray * cardsArray = _liveGameModel.game_data.cards_data;
                [_goldFlowerView loadBetDataWithBetArray:_liveGameModel.game_data.bet andUserBetArray:_liveGameModel.game_data.user_bet];
                [_goldFlowerView showPokerWithData:cardsArray andResult:_liveGameModel.game_data.win];
            }
            else if (_guessSizeView)
            {
                _guessSizeView.canBet = NO;
                [_guessSizeView disClockTime];
                [_guessSizeView loadBetDataWithBetArray:_liveGameModel.game_data.bet andUserBetArray:_liveGameModel.game_data.user_bet];
                [_guessSizeView loadDiceWithDicesArr:_liveGameModel.game_data.dices andResultWinPostion:[_liveGameModel.game_data.win integerValue]];
            }
            if (_isHost || [_liveItem liveType] == 0) {
                [self changeBeginButtonWithCanBeginNext:YES];
            }
            [self.gameArray removeAllObjects];
        }
        //创建游戏历史视图
        [self createGameHistoryView];
        
        NSInteger tmpCoin = [[IMAPlatform sharedInstance].host getUserCoin];
        
        if (_goldFlowerView)
        {
            _goldFlowerView.coinView.gameRechargeView.accountLabel.text =[NSString stringWithFormat:@"%ld",(long)tmpCoin];
            if ([_liveItem liveType] == 3 && !_isHost)
            {
                [_goldFlowerView judgmentBetView:tmpCoin];
            }
            else if ([_liveItem liveType] == 2 && !_isHost)
            {
                [_goldFlowerView judgmentBetView:tmpCoin];
            }
        }
        else if (_guessSizeView)
        {
            _guessSizeView.gameRechargeView.accountLabel.text =[NSString stringWithFormat:@"%ld",(long)tmpCoin];
        }
        _banker_status = [_liveGameModel.banker_status integerValue];
        _gameBankerModel = _liveGameModel.banker;
        if (_banker_status == 2)
        {
            _bottomView.switchBankerBtn.hidden = NO;
            [self changeSwitchBankerBtn];
            _bottomView.grabBankerBtn.hidden = YES;
            self.gameBankerView.hidden = NO;
            [self.gameBankerView.bankerImageView sd_setImageWithURL:[NSURL URLWithString:_liveGameModel.banker.banker_img] placeholderImage:[UIImage imageNamed:@"DefaultImg"]];
            self.gameBankerView.bankerName.text = _liveGameModel.banker.banker_name;
            self.gameBankerView.bankerDesLabel.text = [NSString stringWithFormat:@"剩余底金%@",_liveGameModel.banker.coin];
            [self changeGameBankerView];
            //庄家不能投注
            if ([self isShouldPlayer:_liveGameModel.banker.banker_id])
            {
                [_goldFlowerView whetherBet:NO];
                _guessSizeView.canBet = NO;
                [self hiddenBetView:YES];
            }
        }
        else if (_banker_status == 1)
        {
            _bottomView.grabBankerBtn.hidden = NO;
            self.gameBankerView.hidden = YES;
            _bankerView.leastCoinLabel.text = [NSString stringWithFormat:@"底金:%@",_liveGameModel.principal];
        }
        else
        {
            _bottomView.grabBankerBtn.hidden = YES;
            self.gameBankerView.hidden = YES;
        }
        [self changePayViewFrame];
        NSInteger index = 0;
        if(self.bankerDataArr.count>0)
        {
            CustomMessageModel * firstModel = self.bankerDataArr[0];
            double maxMicrotime = [firstModel.timestamp doubleValue];
            //获取到时间戳最大的消息
            for (NSInteger i=1; i<self.bankerDataArr.count; ++i)
            {
                CustomMessageModel * model = self.bankerDataArr[i];
                double microtime = [model.timestamp doubleValue];
                if (maxMicrotime<microtime)
                {
                    maxMicrotime = microtime;
                    index = i;
                }
            }
        }
        //用于处理前后台切换时的推送
        if (_shouldReloadGame == YES)
        {
            _shouldReloadGame = NO;
            if (_gameArray.count > 0 && _gameArray)
            {
                for (CustomMessageModel *msg in _gameArray)
                {
                    [self gameAllMessageWithCustomMessageModel:msg];
                }
            }
            if (_bankerDataArr.count>index )
            {
                [self gameBankerMessageWithCustomMessageModel:self.bankerDataArr[index]];
            }
        }
    }
}

- (void)hideGameView
{
    if(_giftView.isHidden == NO)
    {
        if (_guessSizeView)
        {
            _guessSizeViewCanNotSee = YES;
            _guessSizeView.frame = CGRectMake(0, kScreenH, kScreenW, kGuessSizeViewHeight);
        }
        else if (_goldFlowerView)
        {
            _goldViewCanNotSee = YES;
            _goldFlowerView.frame = CGRectMake(0, kScreenH, kScreenW, _goldFlowerViewHeiht);
        }
        [self relayoutFrameOfSubViews];
        _bottomView.hidden = YES;
        _bottomView.heartRect = CGRectMake(kScreenW-kDefaultMargin*2-kMyBtnWidth1*2+5, kScreenH-kDefaultMargin-kMyBtnWidth1+5, kMyBtnWidth1-10, kMyBtnWidth1-10);
        _bottomView.switchGameViewBtn.transform = CGAffineTransformMakeRotation(M_PI);
    }
}

//如果收到游戏开始的推送之后在规定时间没有收到游戏结算推送时的处理方法
- (void)reloadGameData
{
    if (_hadBeginNext)
    {
        _canNotLoadData = YES;
        _hadBeginNext = NO;
    }
    for (CustomMessageModel * model in self.gameDataArray)
    {
        if ([model.game_action integerValue] == 4)
        {
            _canNotLoadData = YES;
        }
    }
    if (!_canNotLoadData)
    {
        [self loadGameData];
    }
}

//如果主播选择开始游戏之后五秒内没收到游戏开始推送的处理方法
- (void)beginGame
{
    FWWeakify(self)
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        FWStrongify(self)
        for (CustomMessageModel * model in self.gameDataArray)
        {
            if ([model.game_action integerValue] == 1)
            {
                self.canNotLoadData = YES;
            }
        }
        if (!_canNotLoadData)
        {
            [self loadGameData];
        }
        
    });
}

- (void)changeBeginButtonWithCanBeginNext:(BOOL )canBeginNext
{
    if (canBeginNext)
    {
        _bottomView.beginGameBtn.userInteractionEnabled = YES;
        _bottomView.beginGameBtn.icon = [UIImage imageNamed:@"gm_game_licensing"];
        [_bottomView.beginGameBtn setImage:[UIImage imageNamed:@"gm_game_licensing"] forState:UIControlStateNormal];
        [_bottomView.beginGameBtn setImage:[UIImage imageNamed:@"gm_game_licensing"] forState:UIControlStateHighlighted];
    }
    else
    {
        _bottomView.beginGameBtn.userInteractionEnabled = NO;
        _bottomView.beginGameBtn.hidden = NO;
        _bottomView.beginGameBtn.icon = [UIImage imageNamed:@"gm_game_wait"];
        [_bottomView.beginGameBtn setImage:[UIImage imageNamed:@"gm_game_wait"]  forState:UIControlStateNormal];
        [_bottomView.beginGameBtn setImage:[UIImage imageNamed:@"gm_game_wait"] forState:UIControlStateHighlighted];
    }
}

//删除游戏倒计时的定时器和闹钟
- (void)disAboutClick
{
    [_goldFlowerView closeGameAboutTimer];
    if (_goldFlowerView.alarmClock)
    {
        [_goldFlowerView.alarmClock removeFromSuperview];
        _goldFlowerView.alarmClock = nil;
    }
}

- (NSMutableArray *)gameArray
{
    if (_gameArray == nil)
    {
        _gameArray = [NSMutableArray array];
    }
    return _gameArray;
}

- (NSMutableArray *)gameDataArray
{
    if (_gameDataArray == nil)
    {
        _gameDataArray = [NSMutableArray array];
    }
    return _gameDataArray;
}

#pragma mark ------------------------游戏上庄相关推送--------------------------------
- (void)gameBankerMessageWithCustomMessageModel:(CustomMessageModel *)customMessageModel
{
    if (_shouldReloadGame == YES )
    {
        [self.bankerDataArr addObject:customMessageModel];
        return;
    }
    if ([customMessageModel.timestamp doubleValue] < _timestamp)
    {
        return;
    }
    _timestamp = [customMessageModel.timestamp doubleValue];
    NSString *principal = [customMessageModel.data objectForKey:@"principal"];
    customMessageModel.banker_list = [customMessageModel.data objectForKey:@"banker_list"];
    NSInteger action = [customMessageModel.action integerValue];
    _banker_status = [customMessageModel.banker_status integerValue];
    
    //上庄模块推送操作号，1：开启上庄，2：申请上庄，3：选择庄家，4：下庄
    if (action == 1)
    {
        //主播
        if (_isHost || [_liveItem liveType] == FW_LIVE_TYPE_HOST)
        {
            
            //            _bottomView.switchBankerBtn.hidden = NO;
            //            _bottomView.switchBankerBtn.userInteractionEnabled = NO;
        }
        else
        {
            _bankerView.video_id = customMessageModel.room_id;
            _bankerView.principal = principal;
            _bankerView.leastCoinLabel.text = [NSString stringWithFormat:@"底金:%@",principal];
            _bottomView.grabBankerBtn.hidden = NO;
        }
    }
    else if (action ==2)
    {
        //只对主播做玩家上庄请求信息的展示
        if (_isHost || [_liveItem liveType] == 0)
        {
            [self changeSwitchBankerBtn];
            self.selectctBankerView.hidden = NO;
            NSLog(@"~~~~~~~~%@",customMessageModel.banker_list);
            if ([customMessageModel.banker_list isKindOfClass:[NSArray class]] && customMessageModel.banker_list.count>0)
            {
                [self.bankerListArr removeAllObjects];
                for (NSDictionary * bankerDic in customMessageModel.banker_list)
                {
                    GameBankerModel * model = [GameBankerModel mj_objectWithKeyValues:bankerDic];
                    model.isSelect = NO;
                    [self.bankerListArr addObject:model];
                }
                _bottomView.bankMessage = self.bankerListArr.count;
                _bottomView.bjsbadge.badgeText = @"···";
                self.selectctBankerView.dataArray = self.bankerListArr;
                // [UIView animateWithDuration:0.3 animations:^{
                //     _selectctBankerView.frame = CGRectMake((kScreenW - 280)/2, (kScreenH - 290)/2, 280, 290);
                // }];
            }
        }
    }
    else if (action == 3)
    {
        //选择玩家之后
        customMessageModel.banker = [GameBankerModel mj_objectWithKeyValues:customMessageModel.data[@"banker"]];
        [self loadBankerDataWithModel:customMessageModel withHadLeft:_shouldReloadGame];
    }
    else if (action == 4)
    {
        [self changeSwitchBankerBtn];
        self.gameBankerView.hidden = YES;
        [self.bankerListArr removeAllObjects];
        customMessageModel.banker = [GameBankerModel mj_objectWithKeyValues:customMessageModel.data[@"banker"]];
        if ([self isShouldPlayer:customMessageModel.banker.banker_id])
        {
            _goldFlowerView.banker = NO;
            [self hiddenBetView:NO];
            [_goldFlowerView updateCoinWithID:nil];
            [_guessSizeView updateCoinWithID:nil];
        }
        _bottomView.grabBankerBtn.hidden = YES;
        [self changePayViewFrame];
    }
}

- (void)loadBankerDataWithModel:(CustomMessageModel *)customMessageModel withHadLeft:(BOOL) hadLeft
{
    if (_banker_status == 2)
    {
        _bottomView.switchBankerBtn.hidden = NO;
        self.gameBankerView.hidden = NO;
        [self.gameBankerView.bankerImageView sd_setImageWithURL:[NSURL URLWithString:customMessageModel.banker.banker_img] placeholderImage:[UIImage imageNamed:@"DefaultImg"]];
        self.gameBankerView.bankerName.text = customMessageModel.banker.banker_name;
        self.gameBankerView.bankerDesLabel.text = [NSString stringWithFormat:@"剩余底金%@",customMessageModel.banker.coin];
        [self changeGameBankerView];
        self.bottomView.grabBankerBtn.hidden = YES;
        _bottomView.bankMessage = 0;
        _bottomView.bjsbadge.badgeText = nil;
        if (!hadLeft)
        {
            //庄家不能投注
            if ([self isShouldPlayer:customMessageModel.banker.banker_id])
            {
                _goldFlowerView.banker = YES;
                _guessSizeView.canBet = NO;
                [self hiddenBetView:YES];
                [_goldFlowerView updateCoinWithID:nil];
                [_guessSizeView updateCoinWithID:nil];
            }
        }
        else
        {
            //庄家不能投注
            if ([self isShouldPlayer:customMessageModel.banker.banker_id])
            {
                [_goldFlowerView whetherBet:NO];
                _guessSizeView.canBet = NO;
                [self hiddenBetView:YES];
            }
        }
        //庄家不能投注
        if ([self isShouldPlayer:customMessageModel.banker.banker_id])
        {
            _goldFlowerView.banker = YES;
            _guessSizeView.canBet = NO;
            [self hiddenBetView:YES];
            [_goldFlowerView updateCoinWithID:nil];
            [_guessSizeView updateCoinWithID:nil];
        }
    }
    else if (_banker_status == 1)
    {
        _bottomView.grabBankerBtn.hidden = NO;
        self.gameBankerView.hidden = YES;
        if ([[customMessageModel.data allValues] containsObject:@"principal"]) {
            _bankerView.leastCoinLabel.text = [NSString stringWithFormat:@"底金:%@",[customMessageModel.data objectForKey:@"principal"]];
        }
    }
    else
    {
        _bottomView.grabBankerBtn.hidden = YES;
        self.gameBankerView.hidden = YES;
    }
    [self changeSwitchBankerBtn];
    [self changePayViewFrame];
}

- (GameBankerView *)gameBankerView
{
    if (_gameBankerView == nil)
    {
        _gameBankerView = [[NSBundle mainBundle]loadNibNamed:@"GameBankerView" owner:nil options:nil].lastObject;
        _gameBankerView.frame = CGRectMake(kDefaultMargin, CGRectGetMaxY(_topView.frame)+kDefaultMargin, 240, 50);
        _gameBankerView.layer.cornerRadius = 25;
        _gameBankerView.layer.masksToBounds = YES;
        _gameBankerView.hidden = YES;
        [self addSubview:_gameBankerView];
    }
    return _gameBankerView;
}

- (void)changeGameBankerView
{
    CGSize titleSize = [self.gameBankerView.bankerName.text boundingRectWithSize:CGSizeMake(110, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
    CGSize nameSize = [self.gameBankerView.bankerDesLabel.text boundingRectWithSize:CGSizeMake(110, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
    CGFloat width = MAX(titleSize.width, nameSize.width);
    width += 65;
    if (_topView.priceView.hidden)
    {
        _gameBankerView.frame = CGRectMake(kDefaultMargin, CGRectGetMaxY(_topView.frame)+kDefaultMargin-30, width, 50);
    }
    else
    {
        _gameBankerView.frame = CGRectMake(kDefaultMargin, CGRectGetMaxY(_topView.frame)+kDefaultMargin, width, 50);
    }
}

- (NSMutableArray *)bankerListArr
{
    if (_bankerListArr == nil)
    {
        _bankerListArr = [NSMutableArray array];
    }
    return _bankerListArr;
    
}

- (NSMutableArray *)bankerDataArr
{
    if (_bankerDataArr == nil)
    {
        _bankerDataArr = [NSMutableArray array];
    }
    return _bankerDataArr;
}

- (SelectBankerView *)selectctBankerView
{
    if (_selectctBankerView == nil)
    {
        _selectctBankerView = [SelectBankerView EditNibFromXib];
        _selectctBankerView.delegate = self;
        _selectctBankerView.frame = CGRectMake((kScreenW - 280)/2, kScreenH, 280, 290);
        [_selectctBankerView createStyle];
        [self addSubview:_selectctBankerView];
    }
    return _selectctBankerView;
}

- (NSArray *)bankerSwitchArray
{
    if (_bankerSwitchArray == nil)
    {
        //上庄状态，0：未开启上庄，1：玩家申请上庄，2：玩家上庄
        //0 //显示上庄按钮图片 //1 显示查看玩家上庄请求消息的按钮图片 //2 显示下庄按钮的图片
        _bankerSwitchArray = @[@"gm_open_banker",@"gm_apply_number",@"gm_close_banker"];
    }
    return _bankerSwitchArray;
}

- (void)changeSwitchBankerBtn
{
    //上庄状态，0：未开启上庄，1：玩家申请上庄，2：玩家上庄
    _bottomView.switchBankerBtn.userInteractionEnabled = YES;
    _bottomView.switchBankerBtn.icon = [UIImage imageNamed:self.bankerSwitchArray[_banker_status]];
    [_bottomView.switchBankerBtn setImage:[UIImage imageNamed:self.bankerSwitchArray[_banker_status]]  forState:UIControlStateNormal];
    [_bottomView.switchBankerBtn setImage:[UIImage imageNamed:self.bankerSwitchArray[_banker_status]] forState:UIControlStateHighlighted];
}

- (void)changePayViewFrame
{
    if (_uiDelegate && [_uiDelegate respondsToSelector:@selector(changePayViewFrame:)])
    {
        [_uiDelegate changePayViewFrame:self];
    }
}

- (void)closeGitfView
{
    _bottomView.hidden = NO;
    _msgView.hidden = NO;
    _giftView.hidden = YES;
    _giftView.frame = CGRectMake(0, self.frame.size.height, _giftView.frame.size.width, _giftView.frame.size.height);
}

- (void)choseArcOrMrcGameWithView:(UIView *)gameView
{
    NSString * str = _isArc ? @"是否切换为手动发牌" : @"是否切换为自动发牌";
    
    FWWeakify(self)
    [FanweMessage alert:@"提示" message:str destructiveAction:^{
        
        FWStrongify(self)
        
        NSNumber * autoStart = !_isArc ? @1 : @0;
        NSMutableDictionary * mDict = [NSMutableDictionary dictionary];
        [mDict setObject:@"games" forKey:@"ctl"];
        [mDict setObject:@"autoStart" forKey:@"act"];
        [mDict setObject:autoStart forKey:@"auto_start"];
        
        [self.httpsManager POSTWithParameters:mDict SuccessBlock:^(NSDictionary *responseJson) {
            
            if ([responseJson toInt:@"status"] == 1)
            {
                //取反，手动发牌点击之后变成自动发牌，自动发牌点击之后变成手动发牌
                self.isArc = !self.isArc;
                if ([gameView isKindOfClass:[GoldFlowView class]])
                {
                    self.goldFlowerView.isArc = self.isArc;
                }
                else if ([gameView isKindOfClass:[GuessSizeView class]])
                {
                    self.guessSizeView.isArc = self.isArc;
                }
            }
            
        } FailureBlock:^(NSError *error) {
            
            [[FWHUDHelper sharedInstance] tipMessage:[NSString stringWithFormat:@"%@",error]];
        }];
        
    } cancelAction:^{
        
    }];
}

- (void)arcGame
{
    if (_gameAction == 4 && _isArc )
    {
        if (_goldFlowerView.betArr.count>0)
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self onBottomViewClickMenus:_bottomView fromButton:_bottomView.beginGameBtn];
            });
        }
        else
        {
            [self onBottomViewClickMenus:_bottomView fromButton:_bottomView.beginGameBtn];
        }
    }
}

@end
