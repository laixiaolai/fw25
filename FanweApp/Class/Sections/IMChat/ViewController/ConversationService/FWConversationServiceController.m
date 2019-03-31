//
//  FWConversationServiceController.m
//  FanweApp
//
//  Created by 朱庆彬 on 2017/8/18.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "FWConversationServiceController.h"
#import "ExchangeCoinView.h"
#import "ExchangeView.h"
#import "GiftView.h"
#import "IncomeViewController.h"
#import "OtherChangeView.h"
#import "RechargeView.h"
#import "SHomePageVC.h"
#import "dataModel.h"
@interface FWConversationServiceController () <GiftViewDelegate, ExchangeCoinViewDelegate, RechargeViewDelegate, ExchangeViewDelegate, OtherChangeViewDelegate>
{
    ExchangeCoinView *_exchangeView;
    UIWindow *_bgWindow;
    UIView *_exchangeBgView;
    ExchangeCoinView *_sendDiamondView;
    UIWindow *_sendDiamondbgWindow;
    UIView *_sendDiamondBgView;
}
@property (nonatomic, strong) RechargeView *rechargeView;
@property (nonatomic, strong) ExchangeView *exchangeCoinView;
@property (nonatomic, strong) OtherChangeView *otherChangeView;

@end

@implementation FWConversationServiceController

+ (FWConversationServiceController *)makeChatVCWith:(SFriendObj *)chattag isHalf:(BOOL)mbhalf
{
    FWConversationServiceController *chatvc = [[FWConversationServiceController alloc] initWithNibName:@"FWBaseChatController" bundle:nil];
    chatvc.mbhalf = mbhalf;
    chatvc.hidesBottomBarWhenPushed = YES;
    chatvc.mChatFriend = chattag;
    return chatvc;
}

+ (FWConversationServiceController *)makeChatVCWith:(SFriendObj *)chattag
{
    FWConversationServiceController *chatvc = [[FWConversationServiceController alloc] initWithNibName:@"FWBaseChatController" bundle:nil];
    chatvc.hidesBottomBarWhenPushed = YES;
    chatvc.mChatFriend = chattag;
    return chatvc;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{

    self.mCannotLoadNewestMsg = YES;

    [super viewDidLoad];

    self.mtoptitle.text = self.mChatFriend.mNick_name;
    [self cfgmoremoregiftview];

    if (self.fanweApp.appModel.open_send_coins_module == 1)
    {
        [self createExchangeCoinView];
    }
    if (self.fanweApp.appModel.open_send_diamonds_module == 1)
    {
        [self createSendDiamondView];
    }

    [SFriendObj ignoreMsg:@[self.mChatFriend]
                    block:^(SResBase *resb){

                    }];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(IMChatMsgNotfication:) name:g_notif_chatmsg object:nil];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.mbhalf == NO) {
        self.navigationController.navigationBarHidden = NO;
    }
}

- (void)IMChatMsgNotfication:(NSNotification *)notifcation
{
    if (![NSThread isMainThread])
    {
        [self performSelectorOnMainThread:@selector(IMChatMsgNotfication:) withObject:notifcation waitUntilDone:NO];
        return;
    }

    SIMMsgObj *thatmsg = (SIMMsgObj *) notifcation.object;
    if (thatmsg.mSenderId == self.mChatFriend.mUser_id)
    { //如果是这个人的消息,就显示出来

        //并且还要清除 未读
        [self.mChatFriend ignoreThisUnReadCount];
        [self addOneMsg:thatmsg];
    }
}

- (void)getMsgBefor:(ConversationModel *)msg block:(void (^)(NSArray *all))block
{
    [self.mChatFriend getMsgList:YES
                          posmsg:(SIMMsgObj *) msg
                           block:^(SResBase *resb, NSArray *all) {

                               if (!resb.msuccess)
                               {
                                   [SVProgressHUD showErrorWithStatus:resb.mmsg];
                               }
                               block(all);
                           }];
}

- (void)clickedtophead:(UIButton *)sender
{
    SHomePageVC *tmpController = [[SHomePageVC alloc] init];
    tmpController.user_id = [NSString stringWithFormat:@"%d", self.mChatFriend.mUser_id];
    tmpController.user_nickname = self.mChatFriend.mNick_name;
    tmpController.type = 0;
    [self.navigationController pushViewController:tmpController animated:NO];
}

- (void)willSendThisText:(NSString *)txt
{
    [super willSendThisText:txt];

    SIMMsgObj *obj =
        [self.mChatFriend sendTextMsg:txt
                                block:^(SResBase *resb, SIMMsgObj *newObj) {

                                    if (!resb.msuccess)
                                    {
                                        [SVProgressHUD showErrorWithStatus:resb.mmsg];
                                    }
                                    [self didSendThisMsg:newObj];

                                }];

    if (obj)
        [self addOneMsg:obj];
}
- (void)willSendThisImg:(UIImage *)img
{
    [super willSendThisImg:img];

    SIMMsgObj *ss =
        [self.mChatFriend sendPicMsg:img
                               block:^(SResBase *resb, SIMMsgObj *thatmsg) {

                                   if (!resb.msuccess)
                                   {
                                       [SVProgressHUD showErrorWithStatus:resb.mmsg];
                                   }

                                   [self didSendThisMsg:thatmsg];

                               }];

    if (ss)
        [self addOneMsg:ss];
}

- (void)willSendThisVoice:(NSURL *)voicepath duration:(NSTimeInterval)duration
{
    if (duration < 1)
    {

        [SVProgressHUD showErrorWithStatus:@"说话时间太短，取消发送！"];
        return;
    }

    [super willSendThisVoice:voicepath duration:duration];

    SIMMsgObj *ss =
        [self.mChatFriend sendVoiceMsg:voicepath
                              duration:duration
                                 block:^(SResBase *resb, SIMMsgObj *thatmsg) {

                                     if (!resb.msuccess)
                                     {
                                         [SVProgressHUD showErrorWithStatus:resb.mmsg];
                                     }

                                     [self didSendThisMsg:thatmsg];

                                 }];

    if (ss)
        [self addOneMsg:ss];
}
- (void)willReSendThisMsg:(ConversationModel *)msg
{
    [super willReSendThisMsg:msg];

    [self.mChatFriend reSendMsg:(SIMMsgObj *) msg
                          block:^(SResBase *resb, SIMMsgObj *thatmsg) {

                              if (!resb.msuccess)
                              {
                                  [SVProgressHUD showErrorWithStatus:resb.mmsg];
                              }

                              [self didSendThisMsg:thatmsg];

                          }];
}
- (void)wantFetchMsg:(ConversationModel *)msg block:(void (^)(NSString *, ConversationModel *))block
{
    [super wantFetchMsg:msg block:block];
}
- (void)msgClicked:(ConversationModel *)msgobj
{
    [super msgClicked:msgobj];

    if (msgobj.mMsgType == 4)
    {
        if (!msgobj.mIsSendOut)
        {
            if (!self.mbhalf)
            {
                //如果不包含游戏币就能跳转
                if (![msgobj.mGiftDesc containsString:@"游戏币"] && ![msgobj.mGiftDesc containsString:self.fanweApp.appModel.diamond_name])
                {
                    IncomeViewController *incomeVC = [[IncomeViewController alloc] init];
                    [self.navigationController pushViewController:incomeVC animated:YES];
                }
            }
        }
    }
}

- (void)cfgmoremoregiftview
{
    NSArray *list = [GiftListManager sharedInstance].giftMArray;

    NSMutableArray *giftMArray = [NSMutableArray array];
    if (list && [list isKindOfClass:[NSArray class]])
    {
        for (NSDictionary *key in list)
        {
            GiftModel *giftModel = [GiftModel mj_objectWithKeyValues:key];
            [giftMArray addObject:giftModel];
        }
    }

    CGFloat _giftViewHeight = MorePanH;

    //礼物视图
    GiftView *_giftView = [[GiftView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, _giftViewHeight)];
    _giftView.delegate = self;
    _giftView.hidden = YES;
    [_giftView setGiftView:giftMArray];

    //[self addSubview:_giftView];
    //    long _currentDiamonds = [[IMAPlatform sharedInstance].host getDiamonds];
    //    [_giftView setDiamondsLabelTxt:[NSString stringWithFormat:@"%ld",_currentDiamonds]];
    //
    self.mGiftView = _giftView;
    //刷新砖石数目
    [self refreshDiamonds];
}

- (void)showRechargeView:(GiftView *)giftView
{
    self.rechargeView.hidden = NO;
    [self.rechargeView loadRechargeData];
    [UIView animateWithDuration:0.5 animations:^{
        //_rechargeView.frame = CGRectMake(10, (kScreenH-kRechargeViewHeight)/2, kScreenW-20, kRechargeViewHeight);
        _rechargeView.transform = CGAffineTransformMakeTranslation(0, (kScreenH-kRechargeViewHeight)/2-kScreenH);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)senGift:(GiftView *)giftView AndGiftModel:(GiftModel *)giftModel
{
    //[SVProgressHUD showWithStatus:@"正在发送礼物..."];
    [self.mChatFriend sendGiftMsg:giftModel
                            block:^(SResBase *resb, SIMMsgObj *thatmsg) {

                                if (!resb.msuccess)
                                {
                                    // 刷新钻石
                                    [self refreshDiamonds];
                                    //[SVProgressHUD showErrorWithStatus:resb.mmsg];
                                    [SVProgressHUD dismiss];
                                }
                                else
                                { // 如果成功了,刷新钻石
                                    FWWeakify(self)
                                        [[IMAPlatform sharedInstance].host getMyInfo:^(AppBlockModel *blockModel) {

                                            FWStrongify(self)

                                                long currentDiamonds = [[IMAPlatform sharedInstance].host getDiamonds];
                                            [(GiftView *) self.mGiftView setDiamondsLabelTxt:[NSString stringWithFormat:@"%ld", currentDiamonds]];

                                        }];

                                    [SVProgressHUD dismiss];
                                }

                                [self didSendThisMsg:thatmsg];

                            }];
}

#pragma mark -返回按键 方法
//ykk  重写父类的返回方法
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
                [self backOrGoNextVCBlock:1];
            }
        }
        else
            [self.navigationController popViewControllerAnimated:YES];
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
        [self backOrGoNextVCBlock:1];
    }
}
#pragma mark -goNextVC
//ykk
- (void)backOrGoNextVCBlock:(int)tag
{
    NSLog(@"%s", __func__);
    //1返回 2 去下个界面
    if (self.backOrGoNextVCBlock)
    {
        self.backOrGoNextVCBlock(tag);
    }
}
#pragma 加载半imMsgVC
//ykk 加载banVC
+ (FWConversationServiceController *)createIMMsgVCWithHalfWith:(SFriendObj *)friend_Obj form:(UIViewController *)full_VC
                                                      isRelive:(BOOL)sender
{
    //1.0
    FWConversationServiceController *imMsgChat_VC = [[FWConversationServiceController alloc] initWithNibName:@"FWBaseChatController"
                                                                                                      bundle:nil];
    //1.2
    imMsgChat_VC.mbhalf = YES;
    imMsgChat_VC.mChatFriend = friend_Obj;
    //1.1
    imMsgChat_VC.view.frame = CGRectMake(kScreenW, kScreenH / 2, kScreenW, kScreenH / 2);

    //1.3
    [UIView animateWithDuration:kHalfVCViewanimation
                     animations:^{
                         imMsgChat_VC.view.x = 0;
                     }
                     completion:^(BOOL finished){

                     }];
    //2.
    FWLiveServiceController *live_VC = (FWLiveServiceController *) full_VC;
    //
    [live_VC addChildViewController:imMsgChat_VC];
    [live_VC.view addSubview:imMsgChat_VC.view];
    [live_VC.view bringSubviewToFront:imMsgChat_VC.view];
    return imMsgChat_VC;
}

#pragma mark 刷新钻石数量
- (void)refreshDiamonds
{
    FWWeakify(self)
        [[IMAPlatform sharedInstance].host getMyInfo:^(AppBlockModel *blockModel) {

            FWStrongify(self)

                long currentDiamonds = [[IMAPlatform sharedInstance].host getDiamonds];
            [(GiftView *) self.mGiftView setDiamondsLabelTxt:[NSString stringWithFormat:@"%ld", currentDiamonds]];

        }];
}

#pragma mark-----------------------------赠送游戏币相关---------------------------
#pragma mark 创建赠送游戏币视图
- (void)createExchangeCoinView
{
    //    [SUS_WINDOW.rootViewController presentViewController:alertC animated:YES completion:nil];

    if (!SUS_WINDOW.isSusWindow)
    {
        _bgWindow = [[UIApplication sharedApplication].delegate window];
    }
    else
    {
        _bgWindow = SUS_WINDOW;
    }

    if (!_exchangeView)
    {
        _exchangeBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
        _exchangeBgView.backgroundColor = kGrayTransparentColor4;
        _exchangeBgView.hidden = YES;
        [_bgWindow addSubview:_exchangeBgView];

        UITapGestureRecognizer *bgViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(exchangeBgViewTap)];
        [_exchangeBgView addGestureRecognizer:bgViewTap];

        _exchangeView = [ExchangeCoinView EditNibFromXib];
        _exchangeView.exchangeType = 3;
        _exchangeView.delegate = self;
        _exchangeView.frame = CGRectMake((kScreenW - 300) / 2, kScreenH, 300, 230);
        [_exchangeView createSomething];
        [_bgWindow addSubview:_exchangeView];
        NSLog(@"++++****%@", _exchangeView);
    }
}

- (void)createSendDiamondView
{
    //    [SUS_WINDOW.rootViewController presentViewController:alertC animated:YES completion:nil];

    if (!SUS_WINDOW.isSusWindow)
    {
        _sendDiamondbgWindow = [[UIApplication sharedApplication].delegate window];
    }
    else
    {
        _sendDiamondbgWindow = SUS_WINDOW;
    }

    if (!_sendDiamondView)
    {

        _sendDiamondBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
        _sendDiamondBgView.backgroundColor = kGrayTransparentColor4;
        _sendDiamondBgView.hidden = YES;
        [_sendDiamondbgWindow addSubview:_sendDiamondBgView];

        UITapGestureRecognizer *bgViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sendDiamondViewTap)];
        [_sendDiamondBgView addGestureRecognizer:bgViewTap];

        _sendDiamondView = [ExchangeCoinView EditNibFromXib];
        _sendDiamondView.exchangeType = 4;
        _sendDiamondView.delegate = self;
        _sendDiamondView.frame = CGRectMake((kScreenW - 300) / 2, kScreenH, 300, 230);
        [_sendDiamondView createSomething];
        [_sendDiamondbgWindow addSubview:_sendDiamondView];
        NSLog(@"++++****%@", _sendDiamondView);
    }
}

#pragma mark ExchangeCoinViewDelegate代理
- (void)comfirmClickWithExchangeCoinView:(ExchangeCoinView *)exchangeCoinView
{
    if (_exchangeView == exchangeCoinView)
    {
        [self sendCoinRequest:_exchangeView.diamondLeftTextfield.text];
    }
    else if (_sendDiamondView == exchangeCoinView)
    {
        [self sendDiamondsRequest:_sendDiamondView.diamondLeftTextfield.text];
    }
}

- (void)exchangeViewDownWithExchangeCoinView:(ExchangeCoinView *)exchangeCoinView
{
    if (self.mbhalf)
    {
        //[self clickedfacemore:NO];
    }
    if (_exchangeView == exchangeCoinView)
    {
        [_exchangeView.diamondLeftTextfield resignFirstResponder];
        _exchangeView.diamondLeftTextfield.text = nil;
        [UIView animateWithDuration:0.3
            animations:^{
                _exchangeView.frame = CGRectMake((kScreenW - 300) / 2, kScreenH, 300, 230);
            }
            completion:^(BOOL finished) {
                _exchangeBgView.hidden = YES;
            }];
    }
    else if (_sendDiamondView == exchangeCoinView)
    {
        [_sendDiamondView.diamondLeftTextfield resignFirstResponder];
        _sendDiamondView.diamondLeftTextfield.text = nil;
        [UIView animateWithDuration:0.3
            animations:^{
                _sendDiamondView.frame = CGRectMake((kScreenW - 300) / 2, kScreenH, 300, 230);
            }
            completion:^(BOOL finished) {
                _sendDiamondBgView.hidden = YES;
            }];
    }
}

- (void)exchangeBgViewTap
{
    [self exchangeViewDownWithExchangeCoinView:_exchangeView];
}

- (void)sendDiamondViewTap
{
    [self exchangeViewDownWithExchangeCoinView:_sendDiamondView];
}

- (void)sendCoin
{
    NSLog(@"%d", self.mChatFriend.mUser_id);

    //    [self createAlertController];

    [self displayExchangeView];
}

- (void)displayExchangeView
{
    [self updateCoinWithExchangeCoinView:_exchangeView];
    [_bgWindow bringSubviewToFront:_exchangeBgView];
    [_bgWindow bringSubviewToFront:_exchangeView];
    [UIView animateWithDuration:0.3
                     animations:^{
                         _exchangeBgView.hidden = NO;
                         [_exchangeView.diamondLeftTextfield becomeFirstResponder];
                         if (self.mbhalf)
                         {
                             _exchangeView.frame = CGRectMake((kScreenW - 300) / 2, (kScreenH - 350) / 2, 300, 230);
                         }
                         else
                         {
                             _exchangeView.frame = CGRectMake((kScreenW - 300) / 2, (kScreenH - 450) / 2, 300, 230);
                         }
                     }];
}

- (void)sendDiamonds
{
    NSLog(@"%d", self.mChatFriend.mUser_id);

    [self displaySendDiamondView];
}

- (void)displaySendDiamondView
{
    [self updateCoinWithExchangeCoinView:_sendDiamondView];
    [_sendDiamondbgWindow bringSubviewToFront:_sendDiamondBgView];
    [_sendDiamondbgWindow bringSubviewToFront:_sendDiamondView];
    [UIView animateWithDuration:0.3
                     animations:^{
                         _sendDiamondBgView.hidden = NO;
                         [_sendDiamondView.diamondLeftTextfield becomeFirstResponder];
                         if (self.mbhalf)
                         {
                             _sendDiamondView.frame = CGRectMake((kScreenW - 300) / 2, (kScreenH - 350) / 2, 300, 230);
                         }
                         else
                         {
                             _sendDiamondView.frame = CGRectMake((kScreenW - 300) / 2, (kScreenH - 450) / 2, 300, 230);
                         }
                     }];
}

- (void)createAlertController
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"赠送游戏币"
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    //确定:UIAlertActionStyleDefault
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定"
                                                       style:UIAlertActionStyleDestructive
                                                     handler:^(UIAlertAction *_Nonnull action) {

                                                         _coinTextField = alertController.textFields.firstObject;

                                                         if ([_coinTextField.text integerValue] > 0)
                                                         {
                                                             //                                                             [self postSendCoinRequest:_coinTextField.text];
                                                             [self sendCoinRequest:_coinTextField.text];
                                                         }
                                                         else
                                                         {
                                                             [SVProgressHUD showInfoWithStatus:@"请输入金额"];
                                                         }

                                                         [self clickedfacemore:NO];
                                                     }];
    [alertController addAction:okAction];

    [alertController addTextFieldWithConfigurationHandler:^(UITextField *_Nonnull textField) {
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.placeholder = @"请输入金额";
    }];

    //取消:UIAlertActionStyleDestructive
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction *_Nonnull action) {
                                                             [self clickedfacemore:NO];
                                                         }];
    [alertController addAction:cancelAction];

    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark--  获取游戏币余额
- (void)updateCoinWithExchangeCoinView:(ExchangeCoinView *)sendView
{
    NSMutableDictionary *parmDict = [[NSMutableDictionary alloc] init];
    [parmDict setObject:@"games" forKey:@"ctl"];
    [parmDict setObject:@"userDiamonds" forKey:@"act"];

    [[NetHttpsManager manager] POSTWithParameters:parmDict
                                     SuccessBlock:^(NSDictionary *responseJson) {

                                         if ([responseJson toInt:@"status"] == 1)
                                         {
                                             if (sendView == _exchangeView)
                                             {
                                                 NSString *coinStr = [responseJson toString:@"coin"];
                                                 _exchangeView.ticket = coinStr;
                                                 _exchangeView.diamondLabel.text = [NSString stringWithFormat:@"游戏币余额:%@", _exchangeView.ticket];
                                             }
                                             else if (sendView == _sendDiamondView)
                                             {
                                                 NSString *coinStr = [responseJson toString:@"user_diamonds"];
                                                 _sendDiamondView.ticket = coinStr;
                                                 _sendDiamondView.diamondLabel.text = [NSString stringWithFormat:@"钻石余额:%@", _sendDiamondView.ticket];
                                             }
                                         }
                                     }
                                     FailureBlock:^(NSError *error){

                                     }];
}

#pragma mark 赠送金币请求
- (void)sendCoinRequest:(NSString *)coin
{
    //    [SVProgressHUD showWithStatus:@"正在赠送游戏币..."];
    [self.mChatFriend sendCoinMsgWithCoin:coin
                                    block:^(SResBase *resb, SIMMsgObj *thatmsg) {
                                        if (!resb.msuccess)
                                        {

                                            [[FWHUDHelper sharedInstance] tipMessage:resb.mmsg];
                                        }

                                        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateCoin" object:nil];

                                        [self didSendThisMsg:thatmsg];
                                    }];
}

#pragma mark 赠送钻石请求
- (void)sendDiamondsRequest:(NSString *)diamonds
{
    [self.mChatFriend sendDiamondsMsgWithDiamonds:diamonds
                                            block:^(SResBase *resb, SIMMsgObj *thatmsg) {
                                                if (!resb.msuccess)
                                                {
                                                    // 刷新钻石
                                                    [self refreshDiamonds];
                                                    //[SVProgressHUD showErrorWithStatus:resb.mmsg];
                                                    [SVProgressHUD dismiss];
                                                }
                                                else
                                                { // 如果成功了,刷新钻石
                                                    FWWeakify(self)
                                                        [[IMAPlatform sharedInstance].host getMyInfo:^(AppBlockModel *blockModel) {

                                                            FWStrongify(self)

                                                                long currentDiamonds = [[IMAPlatform sharedInstance].host getDiamonds];
                                                            [(GiftView *) self.mGiftView setDiamondsLabelTxt:[NSString stringWithFormat:@"%ld", currentDiamonds]];

                                                        }];

                                                    [SVProgressHUD dismiss];
                                                }

                                                [self didSendThisMsg:thatmsg];
                                            }];
}

- (RechargeView *) rechargeView
{
    if (_rechargeView == nil)
    {
        _rechargeView = [[RechargeView alloc] initWithFrame:CGRectMake(kRechargeMargin, kScreenH, kScreenW-2*kRechargeMargin, kRechargeViewHeight) andUIViewController:self];
        _rechargeView.hidden = YES;
        _rechargeView.delegate = self;
        //[self.liveUIViewController.liveView addSubview:_rechargeView];
        [self.view addSubview:_rechargeView];
    }
    return _rechargeView;
}

- (OtherChangeView *)otherChangeView
{
    if (_otherChangeView == nil)
    {
        _otherChangeView = [[OtherChangeView alloc] initWithFrame:CGRectMake(kRechargeMargin, kScreenH, kScreenW-2*kRechargeMargin, 300) andUIViewController:self];
        _otherChangeView.hidden = YES;
        _otherChangeView.delegate = self;
        //[self.liveUIViewController.liveView addSubview:_otherChangeView];
        [self.view addSubview:_otherChangeView];
    }
    return _otherChangeView;
}

- (ExchangeView *)exchangeCoinView
{
    if (_exchangeCoinView == nil)
    {
        _exchangeCoinView = [[ExchangeView alloc] initWithFrame:CGRectMake(kRechargeMargin, kScreenH, kScreenW-2*kRechargeMargin, 260)];
        _exchangeCoinView.hidden = YES;
        _exchangeCoinView.delegate = self;
        //[self.liveUIViewController.liveView addSubview:_exchangeView];
        [self.view addSubview:_exchangeCoinView];
    }
    return _exchangeCoinView;
}

- (void)choseRecharge:(BOOL)recharge orExchange:(BOOL)exchange
{
    if (recharge) {
        self.rechargeView.hidden = NO;
        //        [self.liveUIViewController.liveView bringSubviewToFront:self.rechargeView];
        [UIView animateWithDuration:0.5 animations:^{
            //_rechargeView.frame = CGRectMake(10, (kScreenH-kRechargeViewHeight)/2, kScreenW-20, kRechargeViewHeight);
            self.rechargeView.transform = CGAffineTransformMakeTranslation(0, (kScreenH-kRechargeViewHeight)/2-kScreenH);
        } completion:^(BOOL finished) {
            
        }];
    }
    else if(exchange)
    {
        [self.view endEditing:YES];
        self.exchangeCoinView.hidden = NO;
        self.exchangeCoinView.model = self.rechargeView.model;
        [UIView animateWithDuration:0.5 animations:^{
            //_exchangeCoinView.frame = CGRectMake(10,  kScreenH-230-kNumberBoardHeight, kScreenW-20, 230);
            self.exchangeCoinView.transform = CGAffineTransformMakeTranslation(0, -260-kNumberBoardHeight);
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)choseOtherRechargeWithRechargeView:(RechargeView *)rechargeView
{
    [self.view endEditing:YES];
    self.otherChangeView.hidden = NO;
    self.otherChangeView.selectIndex = rechargeView.indexPayWay;
    self.otherChangeView.model = rechargeView.model;
    self.otherChangeView.otherPayArr = rechargeView.model.pay_list;
    [UIView animateWithDuration:0.5 animations:^{
        //self.otherChangeView.frame = CGRectMake(10, kScreenH-260-kNumberBoardHeight, kScreenW-20, 260);
        self.otherChangeView.transform = CGAffineTransformMakeTranslation(0, -300-kNumberBoardHeight);
    } completion:^(BOOL finished) {
        
    }];
}

//点击其它支付的确定按钮
- (void)clickOtherRechergeWithView:(OtherChangeView *)otherView
{
    PayMoneyModel *model = [[PayMoneyModel alloc] init];
    model.hasOtherPay = YES;
    self.rechargeView.money = otherView.textField.text;
    [self.rechargeView payRequestWithModel:model withPayWayIndex:otherView.selectIndex];
}

- (void)rechargeSuccessWithRechargeView:(RechargeView *)rechargeView
{
    FWWeakify(self)
    [[IMAPlatform sharedInstance].host getMyInfo:^(AppBlockModel *blockModel) {
        
        FWStrongify(self)
        
        long currentDiamonds = [[IMAPlatform sharedInstance].host getDiamonds];
        [(GiftView*)self.mGiftView setDiamondsLabelTxt:[NSString stringWithFormat:@"%ld",currentDiamonds]];
        
        if (self.otherChangeView.hidden == NO)
        {
            [self.otherChangeView disChangeText];
        }
        
    }];
}

- (void)clickExchangeWithView:(OtherChangeView *)otherView
{
    [self choseRecharge:NO orExchange:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
