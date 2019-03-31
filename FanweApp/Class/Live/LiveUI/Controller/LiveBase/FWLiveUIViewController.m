//
//  FWLiveUIViewController.m
//  FanweLive
//
//  Created by xfg on 16/11/23.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "FWLiveUIViewController.h"
#import "FWConversationListController.h"

#define BEGIN_SLIDE_RATE 0.15 // 当从左往右滑动时，滑动超过了屏幕宽度的BEGIN_SLIDE_RATE时候就向左滑动
#define BEGIN_SLIDE_RATE2 0.3 // 当从上往下滑动时，滑动超过了屏幕高度的BEGIN_SLIDE_RATE时候就切换直播频道
#define DURING_TIME 10

@interface FWLiveUIViewController ()

@end

@implementation FWLiveUIViewController

#pragma mark - ----------------------- 直播生命周期 -----------------------
- (void)releaseAll
{
    [self removePanGestureRec];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [_imChatVCBgView removeFromSuperview];
    
    _liveController = nil;
    
    _liveItem = nil;
    
    if (self.livePayTimer)
    {
        [self.livePayTimer invalidate];
        self.livePayTimer = nil;
    }
    if (self.livePayLeftTimer)
    {
        [self.livePayLeftTimer invalidate];
        self.livePayLeftTimer = nil;
    }
    
    // 关闭付费的定时器
    if (self.livePay.payLiveTime)
    {
        [self.livePay.payLiveTime invalidate];
        self.livePay.payLiveTime = nil;
    }
    if (self.livePay.payLiveTime)
    {
        [self.livePay.hostPayLiveTime invalidate];
        self.livePay.hostPayLiveTime = nil;
    }
    if (self.livePay.countDownTime)
    {
        [self.livePay.countDownTime invalidate];
        self.livePay.countDownTime = nil;
    }
    
    self.livePay.livController = nil;
}

- (void)dealloc
{
    [self releaseAll];
}

#pragma mark 开始直播
- (void)startLive
{
    [self.liveView startLive];
}

#pragma mark 暂停直播
- (void)pauseLive
{
    [self.liveView pauseLive];
}

#pragma mark 重新开始直播
- (void)resumeLive
{
    [self.liveView resumeLive];
}

#pragma mark 结束直播
- (void)endLive
{
    [self releaseAll];
    
    [self.liveView endLive];
    for (UIView *tmpView in self.liveView.subviews)
    {
        [tmpView removeFromSuperview];
    }
    [self.liveView removeFromSuperview];
}

#pragma mark 初始化房间信息等
- (instancetype)initWith:(id<FWShowLiveRoomAble>)liveItem liveController:(id<FWLiveControllerAble>)liveController
{
    if (self = [super init])
    {
        _liveItem = liveItem;
        _isHost = [liveItem isHost];
        _liveController = liveController;
        self.liveView = [[TCShowLiveView alloc] initWith:liveItem liveController:liveController];
        self.liveView.uiDelegate = self;
        [self.liveView setFrameAndLayout:self.view.bounds];
        [self.view addSubview:self.liveView];
    }
    return self;
}

#pragma mark 请求完接口后，刷新直播间相关信息
- (void)refreshLiveItem:(id<FWShowLiveRoomAble>)liveItem liveInfo:(CurrentLiveInfo *)liveInfo
{
    _liveItem = liveItem;
    [self.liveView refreshLiveItem:liveItem liveInfo:liveInfo];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self registerKeyBoardNotification];
    
    _panGestureRec = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveViewWithGesture:)];
    _panGestureRec.delegate = self;
    [self.view addGestureRecognizer:_panGestureRec];
}


#pragma mark - ----------------------- 付费相关UI -----------------------
#pragma mark 付费直播
- (void)beginEnterPayLive:(NSDictionary *)responseJson closeBtn:(UIButton *)closeBtn
{
    if (!_isHost && ![[[IMAPlatform sharedInstance].host imUserId] isEqualToString:[[_liveItem liveHost] imUserId]])
    {
        if (!self.livePay)
        {
            self.livePay = [[FWLivePayManager alloc]initWithController:self andLiveView:self.liveView andRoomId:[_liveItem liveAVRoomId] andAudienceDict:responseJson andButton:closeBtn];
            if ([responseJson toInt:@"is_live_pay"] == 1)
            {
                if ([_liveItem liveType] == FW_LIVE_TYPE_RELIVE || [_liveItem liveType] == FW_LIVE_TYPE_AUDIENCE)//回播或者云直播的观众
                {
                    if ([responseJson toString:@"preview_play_url"] && ![[responseJson toString:@"preview_play_url"] isEqualToString:@""])
                    {
                        [_liveController startLiveRtmp:[responseJson toString:@"preview_play_url"]];
                        self.livePay.shadowView.backgroundColor = kClearColor;
                        [_liveController setSDKMute:NO];
                        if ([responseJson toInt:@"is_only_play_voice"] == 1)//只有声音没有视频画面
                        {
                            [self.livePayTimer invalidate];
                            self.livePayTimer = nil;
                            [self.livePayLabel removeFromSuperview];
                            self.livePayLabel = nil;
                            [self.livePay creatShadowView];
                            self.livePay.shadowView.hidden = NO;
                            [self.view bringSubviewToFront:self.livePay.shadowView];
                            
                        }
                    }
                    else
                    {
                        self.livePay.shadowView.backgroundColor = kLightGrayColor;
                        self.livePay.shadowView.hidden = NO;
                    }
                    self.livePayCount = [responseJson toInt:@"countdown"];
                    if (self.livePayCount)
                    {
                        self.livePayTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(livePayTimeGo) userInfo:nil repeats:YES];
                        [[NSRunLoop currentRunLoop] addTimer:self.livePayTimer forMode:NSRunLoopCommonModes];
                    }
                    if ([responseJson toInt:@"is_pay_over"] == 0)//开启付费且
                    {
                        self.livePayLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 80, kScreenW-20, 90)];
                        self.livePayLabel.textAlignment = NSTextAlignmentCenter;
                        self.livePayLabel.font = [UIFont systemFontOfSize:16];
                        self.livePayLabel.textColor = kWhiteColor;
                        self.livePayLabel.numberOfLines = 0;
                        self.livePayLabel.backgroundColor = kClearColor;
                        if ([responseJson toInt:@"live_pay_type"] == 1)//按场收费
                        {
                            self.payLiveType = 1;
                            self.livePayLabel.text =[NSString stringWithFormat:@"该直播按场收费,您还能预览倒计时%d秒",self.livePayCount];
                        }
                        else
                        {
                            self.payLiveType = 0;
                            self.livePayLabel.text =[NSString stringWithFormat:@"1分钟内重复进入,不重复扣费,请能正常预览视频后,点击进入,以免扣费后不能正常进入,您还能预览倒计时%d秒",self.livePayCount];
                        }
                        [self.view addSubview:self.livePayLabel];
                    }
                    [self.view bringSubviewToFront:closeBtn];
                }
                if ([responseJson toInt:@"live_pay_type"] == 1)//按场收费
                {
                    self.livePay.liveType = 40;
                }
                if ([responseJson toInt:@"is_pay_over"] == 0)//该参数是否付费过 1付费过 0未付费
                {
                    self.livePay.audienceLeftPView.hidden = YES;//为了预览倒计时和观众左边重叠
                    self.livePay.is_agree = NO;
                }
                else
                {
                    self.livePay.is_agree = YES;
                }
                [self.livePay enterMoneyMode];
                [self changePayView:self.liveView];
            }
            
            FWWeakify(self)
            [self.livePay setBlock:^(NSString *string){
                FWStrongify(self)
                if ([string isEqualToString:@"1"])
                {
                    [self chargerMoney];
                }
                else if ([string isEqualToString:@"2"])
                {
                    [self closeLiveController];
                }
            }];
        }
        [self changePayViewFrame:self.liveView];
    }else
    {
        if ([responseJson toInt:@"is_live_pay"] == 1 && [_liveItem liveType] != FW_LIVE_TYPE_RELIVE)
        {
            if (!self.livePay)
            {
                self.livePay = [[FWLivePayManager alloc]initWithLiveView:self.liveView andRoomId:[_liveItem liveAVRoomId] andhostDict:responseJson andpayType:[_liveItem liveType]];
            }
            
            [self.livePay hostEnterLiveAgainWithMDict:responseJson];
        }
    }
}

#pragma mark 心跳唤起付费界面
- (void)createPayLiveView:(NSDictionary *)responseJson
{
    self.currentMonitorDict = responseJson;
    [self.livePay creatViewWithDict:responseJson];
}

#pragma mark IM消息的通知
- (void)getVedioViewWithType:(int)type closeBtn:(UIButton *)closeBtn
{
    if (!self.livePay)
    {
        self.livePay = [[FWLivePayManager alloc]initWithController:self andLiveView:self.liveView andRoomId:[_liveItem liveAVRoomId] andAudienceDict:self.currentMonitorDict andButton:closeBtn];
        
        FWWeakify(self)
        [self.livePay setBlock:^(NSString *string)
         {
             FWStrongify(self)
             if ([string isEqualToString:@"1"])
             {
                 [self chargerMoney];
             }
             else if ([string isEqualToString:@"2"])
             {
                 [self closeLiveController];
             }
         }];
    }
    [self.livePay AudienceGetVedioViewWithType:type];
    [self changePayViewFrame:self.liveView];
}

#pragma mark 插件中心点击付费
- (void)clickPluginPayItem:(GameModel *)model closeBtn:(UIButton *)closeBtn
{
    if ([model.class_name isEqualToString:@"live_pay"]) // 按时付费
    {
        if ([model.is_active isEqualToString:@"0"])
        {
            SUS_WINDOW.isShowLivePay = YES;
            if (!self.livePay)
            {
                self.livePay = [[FWLivePayManager alloc]initWithLiveView:self.liveView andRoomId:[_liveItem liveAVRoomId] andhostDict:self.currentMonitorDict andpayType:[_liveItem liveType]];
                if ([[self.currentMonitorDict objectForKey:@"live"] toInt:@"allow_live_pay"] != 1)
                {
                    [FanweMessage alertTWMessage:@"直播间人数未达到收费人数"];
                }
                else
                {
                    self.livePay.buttomFunctionType = self.livePay.liveType = [_liveItem liveType];//通过这个判断来显示付费页面左边的提示
                    [self.livePay creatPriceViewWithCount:1];
                }
            }
            else
            {
                self.livePay.buttomFunctionType = self.livePay.liveType = [_liveItem liveType];
                [self.livePay creatViewWithDict:self.currentMonitorDict];
                if ([[self.currentMonitorDict objectForKey:@"live"] toInt:@"allow_live_pay"] != 1)
                {
                    [FanweMessage alertTWMessage:@"直播间人数未达到收费人数"];
                }
                else
                {
                    [self.livePay creatPriceViewWithCount:1];
                }
            }
        }
        else
        {
            [FanweMessage alertTWMessage:@"直播间已处于收费模式中"];
        }
        [self changePayView:self.liveView];
        [self changePayViewFrame:self.liveView];
    }
    else if ([model.class_name isEqualToString:@"live_pay_scene"]) // 按场付费
    {
        if ([model.is_active isEqualToString:@"0"])
        {
            if (!self.livePay)
            {
                self.livePay = [[FWLivePayManager alloc]initWithLiveView:self.liveView andRoomId:[_liveItem liveAVRoomId] andhostDict:self.currentMonitorDict andpayType:[_liveItem liveType]];
                self.livePay.liveType = 40;
                [self.livePay creatPriceViewWithCount:3];
            }
            else
            {
                self.livePay.liveType = 40;
                [self.livePay creatPriceViewWithCount:3];
            }
        }
        else
        {
            [FanweMessage alertTWMessage:@"直播间已处于收费模式中"];
        }
        [self changePayViewFrame:self.liveView];
    }
}

#pragma mark 付费列表倒计时
- (void)livePayTimeGo
{
    self.livePayCount --;
    if (self.livePayCount == 0)
    {
        [self.livePayLabel removeFromSuperview];
        self.livePayLabel = nil;
        [self.livePayTimer invalidate];
        self.livePayTimer = nil;
        [_liveController stopLiveRtmp];
        [_liveController setSDKMute:YES];
    }
    
    if (self.payLiveType == FW_LIVE_TYPE_RELIVE)
    {
        self.livePayLabel.text =[NSString stringWithFormat:@"该直播按场收费,您还能预览倒计时%d秒",self.livePayCount];
    }
    else
    {
        self.livePayLabel.text =[NSString stringWithFormat:@"1分钟内重复进入,不重复扣费,请能正常预览视频后,点击进入,以免扣费后不能正常进入,您还能预览倒计时%d秒",self.livePayCount];
    }
}

#pragma mark 付费直播充钱的操作
- (void)chargerMoney
{
    if (_serviceDelegate && [_serviceDelegate respondsToSelector:@selector(showRechargeView:)])
    {
        [_serviceDelegate showRechargeView:self];
    }
}

#pragma mark 付费直播关闭直播间的操作
- (void)closeLiveController
{
    BOOL isDirectCloseLive;
    if (_isHost)
    {
        isDirectCloseLive = NO;
    }
    else
    {
        isDirectCloseLive = YES;
    }
    DebugLog(@"=================：付费直播关闭直播间的操作");
    if (_serviceDelegate && [_serviceDelegate respondsToSelector:@selector(closeCurrentLive:isHostShowAlert:)])
    {
        [_serviceDelegate closeCurrentLive:isDirectCloseLive isHostShowAlert:NO];
    }
}

#pragma mark 切换付费
- (void)clickChangePay:(TCShowLiveView *)showLiveView
{
    if ([[self.currentMonitorDict objectForKey:@"live"] toInt:@"allow_live_pay"] == 1)
    {
        [self.livePay creatPriceViewWithCount:1];
    }
    else
    {
        [FanweMessage alertTWMessage:@"直播间人数未达到收费人数"];
    }
}

#pragma mark 提档
- (void)clickMention:(TCShowLiveView *)showLiveView
{
    if ([[self.currentMonitorDict objectForKey:@"live"] toInt:@"allow_mention"] == 1)
    {
        [self.livePay creatPriceViewWithCount:2];
    }
}

- (void)changePayView:(TCShowLiveView *)showLiveView
{
    [self.livePay changeLeftViewFrameWithIsHost:_isHost andAuctionView:showLiveView.topView.priceView andBankerView:showLiveView.gameBankerView];
}

- (void)changePayViewFrame:(TCShowLiveView *)showLiveView
{
    [self.livePay changeLeftViewFrameWithIsHost:_isHost andAuctionView:showLiveView.topView.priceView andBankerView:showLiveView.gameBankerView];
}

- (void)dealLivepayTComfirm
{
    self.livePay.audienceLeftPView.hidden = NO;//观众进入直播间要把左边的付费信息显示出来（一开始为了避免预览倒计时和左边重叠就将其隐藏）
    [self.livePayTimer invalidate];
    self.livePayTimer = nil;
    [self.livePayLabel removeFromSuperview];
    self.livePayLabel = nil;
}


#pragma mark - ----------------------- 键盘事件 -----------------------
#pragma mark 键盘监听
- (void)registerKeyBoardNotification
{
    //添加键盘监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    FWWeakify(self)
    // 1.监听键盘 地球 切换
    [Noti_Default addObserverForName:UIKeyboardDidChangeFrameNotification
                              object:nil
                               queue:[NSOperationQueue mainQueue]
                          usingBlock:^(NSNotification *_Nonnull note) {
                              
                              FWStrongify(self)
                              // 取出键盘高度
                              CGRect keyboardF = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
                              CGFloat keyboardH = keyboardF.size.height;
                              if (self.isKeyboardTypeNum == 1 && self.isHaveHalfIMMsgVC)
                              {
                                  for (UIViewController *one_VC in self.childViewControllers)
                                  {
                                      if ([one_VC isKindOfClass:[FWConversationServiceController class]])
                                      {
                                          FWConversationServiceController *im_Msg_VC = (FWConversationServiceController *) one_VC;
                                          
                                          [UIView animateWithDuration:0.25
                                                           animations:^{
                                                               
                                                               im_Msg_VC.view.y = kScreenH / 2 - keyboardH;
                                                               
                                                           }
                                                           completion:^(BOOL finished){
                                                               
                                                           }];
                                      }
                                  }
                              }
                          }];
    
}

- (void)onKeyboardWillShow:(NSNotification *)notification
{
    // 1.键盘弹出需要的时间
    CGFloat animationDuration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 取出键盘高度
    CGRect keyboardF = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardH = keyboardF.size.height;
    FWWeakify(self)
    [UIView animateWithDuration:animationDuration animations:^{
        
        FWStrongify(self)
        if (_isHaveHalfIMMsgVC == YES && _isKeyboardTypeNum != 1)
        {
            //  弹出 文本 键盘
            //[self textKeyboardUp:keyboardH];
        }
        if (self.isHaveHalfIMChatVC == NO )
        {
            if (self.liveView.goldFlowerView && self.liveView.goldViewCanNotSee == NO && self.liveView.bankerViewCanSee == NO)
            {
                self.liveView.liveInputView.transform = CGAffineTransformMakeTranslation(0, -keyboardH+self.liveView.goldFlowerViewHeiht);
                self.liveView.msgView.transform = CGAffineTransformMakeTranslation(0, -keyboardH+self.liveView.goldFlowerViewHeiht);
                // [self textKeyboardUp:keyboardH];
            }
            else if (self.liveView.guessSizeView && self.liveView.guessSizeViewCanNotSee == NO && self.liveView.bankerViewCanSee == NO)
            {
                self.liveView.liveInputView.transform = CGAffineTransformMakeTranslation(0, -keyboardH+kGuessSizeViewHeight);
                self.liveView.msgView.transform = CGAffineTransformMakeTranslation(0, -keyboardH+kGuessSizeViewHeight);
                //[self textKeyboardUp:keyboardH];
            }
            else if ((self.liveView.goldFlowerView || self.liveView.guessSizeView) && self.liveView.bankerViewCanSee == YES)
            {
                //                _liveView.bankerView.y = _liveView.height - keyboardF.size.height - _liveView.bankerView.height - 50;
            }
            else
            {
                self.liveView.transform = CGAffineTransformMakeTranslation(0, - keyboardH);
            }
        }
    }];
    
}

#pragma mark 弹起文本键盘
- (void)textKeyboardUp:(CGFloat)move_high
{
    for (UIViewController *vc in self.childViewControllers)
    {
        if ([vc isKindOfClass:[FWConversationServiceController class]])
        {
            FWConversationServiceController *im_Msg_VC = (FWConversationServiceController *) vc;
            
            FWWeakify(self)
            __weak FWConversationServiceController *imMsgVC = im_Msg_VC;
            
            _isKeyboardTypeNum = 1;
            //关闭
            CGFloat time = 0.0;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                // 保证表情
                
                if(move_high <100)
                {
                    return ;
                }
                [UIView animateWithDuration:0.4 animations:^{
                    
                    //im_Msg_VC.view.height = kScreenH/2;
                    imMsgVC.view.y = kScreenH/2-move_high;
                    
                } completion:^(BOOL finished) {
                    
                    FWStrongify(self)
                    //必须写在这里
                    if (finished)
                    {
                        imMsgVC.view.height = kScreenH/2;
                        imMsgVC.view.y = kScreenH/2-move_high;
                        imMsgVC.inputView.hidden = YES;
                        self.isKeyboardTypeNum = 1;//是否加载半屏幕 VC 键盘类型 1文本  2表情  3更多
                    }
                    
                }];
            });
        }
    }
}

- (void)onKeyboardDidShow:(NSNotification *)notification
{
}

- (void)onKeyboardWillHide:(NSNotification *)notification
{
    self.liveView.bottomView.hidden = NO;
    [self.liveView hideInputView];
    // 1.键盘弹出需要的时间
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 取出键盘高度
    CGRect keyboardF = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardH = keyboardF.size.height;
    
    FWWeakify(self)
    // 2.动画
    [UIView animateWithDuration:duration animations:^{
        
        FWStrongify(self)
        if (_isHaveHalfIMMsgVC == YES)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"HalfIMMsgChaVC" object:nil userInfo:@{@"keyboardH":[NSString stringWithFormat:@"%f",keyboardH]}];
            return ;
        }
        if (self.isHaveHalfIMChatVC == NO)
        {
            if (self.liveView.goldFlowerView && self.liveView.goldViewCanNotSee == NO && self.liveView.bankerViewCanSee == NO)
            {
                self.liveView.liveInputView.transform = CGAffineTransformIdentity;//恢复之前的位置
                self.liveView.msgView.transform = CGAffineTransformIdentity;//恢复之前的位置
                self.liveView.transform = CGAffineTransformIdentity;//恢复之前的位置
            }
            else if (self.liveView.guessSizeView && self.liveView.guessSizeViewCanNotSee == NO && self.liveView.bankerViewCanSee == NO)
            {
                self.liveView.liveInputView.transform = CGAffineTransformIdentity;//恢复之前的位置
                self.liveView.msgView.transform = CGAffineTransformIdentity;//恢复之前的位置
                self.liveView.transform = CGAffineTransformIdentity;//恢复之前的位置
            }
            else if ((self.liveView.goldFlowerView || self.liveView.guessSizeView) && self.liveView.bankerViewCanSee == YES)
            {
                //                 self.liveView.bankerView.frame = CGRectMake((kScreenW - 255)/2, (kScreenH - 195)/2, 255, 195);
            }
            else
            {
                self.liveView.transform = CGAffineTransformIdentity;//恢复之前的位置
            }
            [self.liveView relayoutFrameOfSubViews];
        }
    }];
    
}

#pragma mark -表情／更多 键盘弹起

/*!
 *    @author Yue
 *
 *    @brief ykk825   代理实现 表情／更多按钮控制 键盘弹起
 *
 *    @param isFace   表情
 *    @param isHave   键盘是否已经存在
 *
 *     @step 1:       表情键盘
 *
 *
 */
- (void)faceAndMoreKeyboardBtnClickWith:(BOOL)isFace isNotHaveBothKeyboard:(BOOL)isHave keyBoardHeight:(CGFloat)height
{
    for (UIViewController *vc in self.childViewControllers)
    {
        if ([vc isKindOfClass:[FWConversationServiceController class]])
        {
            FWConversationServiceController *imMsg_VC = (FWConversationServiceController *) vc;
            [UIView animateWithDuration:0.2 animations:^{
                
                if(isHave == YES)
                {
                    imMsg_VC.view.y = kScreenH/2-300;
                    imMsg_VC.view.height = kScreenH-(kScreenH*0.5-300)-height;
                }
                else if (isFace == YES)
                {
                    imMsg_VC.view.y = kScreenH/2-300;
                    imMsg_VC.view.height =  kScreenH-(kScreenH*0.5-300);
                }
                else if (isHave == NO && isFace == NO)
                {
                    imMsg_VC.view.y = kScreenH/2;
                    imMsg_VC.view.height =kScreenH/2;
                }
                else
                {
                    imMsg_VC.view.y = kScreenH/2;
                    
                }
                
            } completion:^(BOOL finished) {
                
            }];
            
        }
    }
}

#pragma mark - ----------------------- 弹出 半屏幕VC 部分 -----------------------
/**
 直播VC 加2个子 半屏幕的子VC
 不能直接的push／模态。。弹出半VC，直播VC 还要能点击－－加载／退出分2部分： 导航上按钮控制 & 其他控件控制
 
 1: 添加chatVC        列表Vc
 2: chatVC           返回键
 3: chatVC           点击cell 加载 到 IMMsgVC
 4: IMMsgVC          返回按键  返回到 chatVC
 5: homePageVC       IMMsgVC push  homePageVC
 6: clickBlank       实现代理方法，是TCShowLieView 的方法（手势里
 7: returnChatVC     找到子VC－chatVC
 8: returnIMMsgVC    找到子VC －IMMsgVC
 */
- (void)addTwoSubVC
{
    if (!_imChatVCBgView)
    {
        _imChatVCBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
        _imChatVCBgView.backgroundColor = [UIColor clearColor];
        [self.liveView addSubview:_imChatVCBgView];
        UITapGestureRecognizer *IMChatVCTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ChatVCBgViewTap)];
        [_imChatVCBgView addGestureRecognizer:IMChatVCTap];
    }
    else
    {
        _imChatVCBgView.hidden = NO;
    }
    
    //1.
    if (self.isHaveHalfIMChatVC == YES)
    {
        return;
    }
    //2.
    //ConversationListController *imChat_VC = [ConversationListController createIMChatVCWithHalf:self isRelive:NO];
    FWConversationSegmentController *imChat_VC = [FWConversationSegmentController createIMChatVCWithHalf:self isRelive:NO];
    //3.
    _isKeyboardTypeNum = 0;
    self.isHaveHalfIMChatVC = YES;
    //4.
    __weak __typeof(self) weak_Self = self;
    __weak FWConversationSegmentController *weak_chat_VC = imChat_VC;
    
    //5.
    weak_chat_VC.goNextVCBlock = ^(int tag, SFriendObj *friend_Obj) {
        //6.
        if (tag == 1)
        {
            [weak_Self chatVCBackToLiveVC:weak_chat_VC];
        }
        else
        {
            //7.去聊天界面
            if (weak_Self.isHaveHalfIMMsgVC == YES)
            {
                return;
            }
            //8.Go
            [weak_Self chatVCGoIMMsgVC:weak_chat_VC withFrinend:friend_Obj];
            
        }
    };
    
}

#pragma mark -chatVC -返回
//@step 2:
- (void)chatVCBackToLiveVC:(FWConversationSegmentController *)chat_VC
{
    // A --返回  chatVC －－ 直接移到下面 并删除
    
    [UIView animateWithDuration:kHalfVCViewanimation animations:^{
        //当前chatVc  半VC  显示，要下去
        chat_VC.view.y = kScreenH;
    } completion:^(BOOL finished) {
        //移除 chatVc
        [chat_VC.view removeFromSuperview];
        [self removeChild:chat_VC];
        self.isHaveHalfIMChatVC = NO;
        self.isHaveHalfIMMsgVC = NO;
    }];
}

#pragma mark - Goto 聊天 half VC
//@step 3：
- (void)chatVCGoIMMsgVC:(FWConversationSegmentController *)chat_VC withFrinend:(SFriendObj *)friend_Obj
{
    FWConversationServiceController *imMsgChat_VC = [FWConversationServiceController createIMMsgVCWithHalfWith:friend_Obj form:self isRelive:NO];
    imMsgChat_VC.delegate = self;
    self.isHaveHalfIMMsgVC = YES;
    // 传一个参数
    __weak FWConversationServiceController *weak_iMsg_VC = imMsgChat_VC;
    weak_iMsg_VC.backOrGoNextVCBlock = ^(int tag) {
        // 返回到chatVC
        if (tag == 1)
        {
            [self imMsgVcGoBackToChatVC:weak_iMsg_VC];
        }
        else
        {
            //去  push
            [self imMsgVCPushHomePageVC:weak_iMsg_VC];
        }
    };
}

#pragma - imMsgVC - 聊天返回列表ChatVC
//@step 4：
- (void)imMsgVcGoBackToChatVC:(FWConversationServiceController *)weak_iMsg_VC
{
    //先下来  表情／更多
    CGFloat time;
    
    CGFloat height = weak_iMsg_VC.view.frame.size.height;
    
    if (height > kScreenH/2)
    {
        time = 0.2;
        weak_iMsg_VC.inputView.hidden = YES;
        [UIView animateWithDuration:time animations:^{
            weak_iMsg_VC.view.y =kScreenH/2;
        } completion:^(BOOL finished) {
            weak_iMsg_VC.view.height = kScreenH/2;
            
            weak_iMsg_VC.inputView.hidden = NO;
            self.isKeyboardTypeNum = 0;
        }];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [UIView animateWithDuration:kHalfVCViewanimation animations:^{
            
            weak_iMsg_VC.view.x = kScreenW;
            
        } completion:^(BOOL finished) {
            
            weak_iMsg_VC.view.height = kScreenH/2;
            [weak_iMsg_VC.view removeFromSuperview];
            [self removeChild:weak_iMsg_VC
                    animation:nil];
            self.isHaveHalfIMMsgVC = NO;
            
        }];
        
        
    });
}

#pragma - imMsgVC - push 到个人中心
// @step 5:
- (void)imMsgVCPushHomePageVC:(FWConversationServiceController *)imMsgChatVC
{
    SHomePageVC *tmpController = [[SHomePageVC alloc] init];
    tmpController.user_id = [NSString stringWithFormat:@"%d", imMsgChatVC.mChatFriend.mUser_id];
    tmpController.type = 0;
    [imMsgChatVC.navigationController pushViewController:tmpController animated:YES];
}

#pragma mark 点击空白部分(半VC出现时)
- (void)ChatVCBgViewTap
{
    //后期 通知要废掉
    [[NSNotificationCenter defaultCenter] postNotificationName:@"imRemoveNeedUpdate" object:nil];
    _imChatVCBgView.hidden = YES;
    self.panGestureRec.enabled = YES;
    for (UIViewController *one_VC in self.childViewControllers)
    {
        //chatVC  存在
        if ([one_VC isKindOfClass:[FWConversationSegmentController class]])
        {
            
            FWConversationSegmentController *imChat_VC = (FWConversationSegmentController *) one_VC;
            [UIView animateWithDuration:kHalfVCViewanimation
                             animations:^{
                                 imChat_VC.view.y = kScreenH;
                                 
                             }
                             completion:^(BOOL finished) {
                                 if (finished)
                                 {
                                     [imChat_VC.view removeFromSuperview];
                                     [self removeChild:imChat_VC];
                                     
                                     self.isHaveHalfIMChatVC = NO;
                                     _isKeyboardTypeNum = 0;
                                 }
                             }];
        }
        //聊天 退出
        if ([one_VC isKindOfClass:[FWConversationServiceController class]])
        {
            
            FWConversationSegmentController *imMsgChat_VC = (FWConversationSegmentController *) one_VC;
            [UIView animateWithDuration:kHalfVCViewanimation
                             animations:^{
                                 imMsgChat_VC.view.y = kScreenH;
                             }
                             completion:^(BOOL finished) {
                                 [imMsgChat_VC.view removeFromSuperview];
                                 [self removeChild:imMsgChat_VC];
                                 self.isHaveHalfIMMsgVC = NO;
                                 _isKeyboardTypeNum = 0;
                             }];
            
        }
    }
}

#pragma mark - ----------------------- 滑动手势 -----------------------

#pragma mark - pan手势冲突
#pragma mark移除滑动手势 ? ? ?

#pragma mark pan手势冲突

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (SUS_WINDOW.isSmallSusWindow)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

#pragma mark移除滑动手势
- (void)removePanGestureRec
{
    if (_panGestureRec)
    {
        [_panGestureRec removeTarget:self action:@selector(moveViewWithGesture:)];
    }
}

#pragma mark 设置当前是否能够使用滑动手势
- (void)setPanGesture:(BOOL)isEnabled
{
    _panGestureRec.enabled = isEnabled;
}

#pragma mark 滑动手势
- (void)moveViewWithGesture:(UIPanGestureRecognizer *)panGes
{
    // 关闭键盘
    [FWUtils closeKeyboard];
    //ykk 半VC 出现 禁止滑动live—View
    if (self.isHaveHalfIMChatVC == YES || self.isHaveHalfIMMsgVC == YES)
        
    {
        panGes.enabled = NO;
        return;
    }
    else
    {
        panGes.enabled = YES;
    }
    
    if (!_isHost)
    {
        static CGFloat startX;
        static CGFloat lastX;
        static CGFloat startY;
        static CGFloat lastY;
        static CGFloat durationX;
        static CGFloat durationY;
        CGPoint touchPoint = [panGes locationInView:[[UIApplication sharedApplication] keyWindow]];
        
        if (panGes.state == UIGestureRecognizerStateBegan)
        {
            startX = touchPoint.x;
            lastX = touchPoint.x;
            startY = touchPoint.y;
            lastY = touchPoint.y;
        }
        if (panGes.state == UIGestureRecognizerStateChanged)
        {
            CGFloat currentX = touchPoint.x;
            durationX = currentX - lastX;
            lastX = currentX;
            
            CGFloat currentY = touchPoint.y;
            durationY = currentY - lastY;
            lastY = currentY;
            
            //验证滑动手势朝左右方向大还是朝上下方向大
            //朝左右方向滑动
            if (fabs(durationX) > fabs(durationY))
            {
                //如果正在上下滑动就不能左右滑动
                if (self.view.frame.origin.y > 0 || CGRectGetMaxY(self.view.frame) < self.view.frame.size.height)
                {
                    return;
                }
                
                _isLeftOrRightPan = YES;
                if (durationX > 0)
                {
                    _isFromeLeft = YES;
                }
                else if (durationX < 0)
                {
                    _isFromeLeft = NO;
                }
                
                if (self.liveView.frame.origin.x <= 0 && !_isFromeLeft)
                {
                    return;
                }
                
                if (!_showingRight)
                {
                    _showingRight = YES;
                }
                
                float x = durationX + self.liveView.frame.origin.x;
                [self.liveView setFrame:CGRectMake(x, self.liveView.frame.origin.y, self.liveView.frame.size.width, self.liveView.frame.size.height)];
            }
            //            else    //朝上下方向滑动
            //            {
            //                //如果正在左右滑动就不能上下滑动
            //                if (self.view.frame.origin.x == 0 || self.view.frame.origin.x == self.view.frame.size.width)
            //                {
            //                    _isLeftOrRightPan = NO;
            //
            //                    if (durationY>0)
            //                    {
            //                        _isFromeTop = YES;
            //                    }
            //                    else if(durationY<0)
            //                    {
            //                        _isFromeTop = NO;
            //                    }
            //
            //                    float y = durationY + self.view.frame.origin.y;
            //                    [self.view setFrame:CGRectMake(self.view.frame.origin.x, y, self.view.frame.size.width, self.view.frame.size.height)];
            //                }
            //            }
        }
        else if (panGes.state == UIGestureRecognizerStateEnded)
        {
            if (_isLeftOrRightPan)
            { //朝左右方向滑动
                if (_showingRight)
                {
                    if (_isFromeLeft)
                    {
                        if (self.liveView.frame.origin.x < self.view.frame.size.width * BEGIN_SLIDE_RATE)
                        {
                            float durationTime = (self.liveView.frame.origin.x) / (self.view.frame.size.width) / DURING_TIME;
                            [UIView animateWithDuration:durationTime
                                             animations:^{
                                                 [self.liveView setFrame:CGRectMake(0, self.liveView.frame.origin.y, self.liveView.frame.size.width, self.liveView.frame.size.height)];
                                             }
                                             completion:^(BOOL finished) {
                                                 self.liveView.userInteractionEnabled = YES;
                                             }];
                        }
                        else
                        {
                            float durationTime = (1 - (self.liveView.frame.origin.x) / (self.view.frame.size.width)) / DURING_TIME;
                            [UIView animateWithDuration:durationTime
                                             animations:^{
                                                 [self.liveView setFrame:CGRectMake(self.view.frame.size.width, self.liveView.frame.origin.y, self.liveView.frame.size.width, self.liveView.frame.size.height)];
                                             }
                                             completion:^(BOOL finished) {
                                                 [self.view sendSubviewToBack:self.liveView];
                                                 _showingRight = NO;
                                             }];
                            
                        }
                    }
                    else
                    {
                        if (self.liveView.frame.origin.x < self.view.frame.size.width * (1 - BEGIN_SLIDE_RATE))
                        {
                            float durationTime = (self.liveView.frame.origin.x) / (self.view.frame.size.width) / DURING_TIME;
                            [UIView animateWithDuration:durationTime
                                             animations:^{
                                                 [self.liveView setFrame:CGRectMake(0, self.liveView.frame.origin.y, self.liveView.frame.size.width, self.liveView.frame.size.height)];
                                             }
                                             completion:^(BOOL finished) {
                                                 self.liveView.userInteractionEnabled = YES;
                                             }];
                        }
                        else
                        {
                            float durationTime = (1 - (self.liveView.frame.origin.x) / (self.view.frame.size.width)) / DURING_TIME;
                            [UIView animateWithDuration:durationTime
                                             animations:^{
                                                 [self.liveView setFrame:CGRectMake(self.view.frame.size.width, self.liveView.frame.origin.y, self.liveView.frame.size.width, self.liveView.frame.size.height)];
                                             }
                                             completion:^(BOOL finished) {
                                                 [self.view sendSubviewToBack:self.liveView];
                                                 _showingRight = NO;
                                             }];
                        }
                    }
                }
            }
            else //朝上下方向滑动
            {
                //                if (_isFromeTop)
                //                {
                //                    if (self.view.frame.origin.y < self.view.frame.size.height*BEGIN_SLIDE_RATE2)
                //                    {
                //                        float durationTime = (self.view.frame.origin.y)/(self.view.frame.size.height)/DURING_TIME;
                //                        [UIView animateWithDuration:durationTime animations:^{
                //                            [self.view setFrame:CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height)];
                //                        } completion:^(BOOL finished) {
                //                            self.view.userInteractionEnabled = YES;
                //                        }];
                //                    }
                //                    else
                //                    {
                //                        float durationTime = (1 - (_livingView.frame.origin.x)/(self.view.frame.size.width))/DURING_TIME;
                //                        [UIView animateWithDuration:durationTime animations:^ {
                //                            [_livingView setFrame:CGRectMake(self.view.frame.size.width, _livingView.frame.origin.y, _livingView.frame.size.width, _livingView.frame.size.height)];
                //                        } completion:^(BOOL finished) {
                //                            [self.view sendSubviewToBack:_livingView];
                //                            showingRight = NO;
                //
                //                        }];
                //                    }
                //                }
                //                else
                //                {
                //                    if (CGRectGetMaxY(self.view.frame) < self.view.frame.size.height*(1-BEGIN_SLIDE_RATE2))
                //                    {
                //                        float durationTime = (_livingView.frame.origin.x)/(self.view.frame.size.width)/DURING_TIME;
                //                        [UIView animateWithDuration:durationTime animations:^{
                //                            [_livingView setFrame:CGRectMake(0, _livingView.frame.origin.y, _livingView.frame.size.width, _livingView.frame.size.height)];
                //                        } completion:^(BOOL finished) {
                //                            _livingView.userInteractionEnabled = YES;
                //                        }];
                //                    }
                //                    else
                //                    {
                //                        float durationTime = (1 - CGRectGetMaxY(self.view.frame)/(self.view.frame.size.height))/DURING_TIME;
                //                        [UIView animateWithDuration:durationTime animations:^{
                //                            [self.view setFrame:CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height)];
                //                        } completion:^(BOOL finished) {
                //
                //                        }];
                //                    }
                //                }
            }
        }
    }
}

@end
