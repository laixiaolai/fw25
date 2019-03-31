//
//  FWLivePayManager.m
//  FanweApp
//
//  Created by 丁凯 on 2017/8/16.
//  Copyright © 2017年 xfg. All rights reserved.

/*
 付费直播流程
 1主播:主播通过心跳接口判断是否加价或者提档-->进行加价或者提档-->加价或者提档成功IM发送消息给观众-->IM消息接收之后规定时间进行付费(付费成功继续观看，否则无法观看直播页面以及关闭直播声音)
 2观众:进入直播通过get_video判断直播间是否进行收费-->收费直播就进行收费操作，且无法观看直播页面以及关闭直播声音(不需要就继续观看)
 */
#import "FWLivePayManager.h"
#import "LivePayLeftPromptV.h"

@implementation FWLivePayManager

#pragma mark =============================主播================================
- (id)initWithLiveView:(TCShowLiveView *)liveView andRoomId:(int)roomId andhostDict:(NSDictionary *)hostDict andpayType:(NSInteger)payType
{
    if (self = [super init])
    {
        self.roomId = roomId;
        self.httpsManager = [NetHttpsManager manager];
        self.fanweApp = [GlobalVariables sharedInstance];
        self.buttomFunctionType = payType;
        self.is_agree = NO;
        self.subLiving = liveView;
        self.hostDict = hostDict;
        self.hostLeftPView = [[LivePayLeftPromptV alloc]init];
        self.hostLeftPView.frame = CGRectMake(kDefaultMargin,CGRectGetMaxY(self.subLiving.topView.otherContainerView.frame)+kStatusBarHeight, 0, kTicketContrainerViewHeight);
        [self.subLiving addSubview:self.hostLeftPView];
        [self creatViewWithDict:self.hostDict];
    }
    return self;
}

#pragma mark 心跳接口判断是否付费或者提档 主播和观众同时在直播间里面开始收费的流程
- (void)creatViewWithDict:(NSDictionary *)dict
{
    if ([[dict objectForKey:@"live"] toInt:@"allow_mention"] == 1)
    {
        self.is_mentionType = 1;
        SUS_WINDOW.isShowMention = YES;
        [self.subLiving.bottomView addLiveFunc:self.buttomFunctionType];
    }
    else
    {
        if (self.liveType != 40)//为了防止按场付费开启后没有分享等功能(和开启按时付费开启后多一个切换付费的功能)
        {
            if ([dict toInt:@"live_pay_type"] == 0 && self.subLiving.isHost)
            {
                SUS_WINDOW.isShowLivePay = YES;
                [self.subLiving.bottomView addLiveFunc:self.buttomFunctionType];
            }
        }
    }
}

#pragma mark 切换付费或者提档后的代理
- (void)creatPriceViewWithCount:(int)count
{
    if (count == 1)//按时付费@"1<=价格<=100"
    {
        [FanweMessage alertInput:@"按时付费定价" message:[NSString stringWithFormat:@"请输入价格(%@/分钟)",self.fanweApp.appModel.diamond_name] placeholder:[NSString stringWithFormat:@"%ld<=价格<=%ld",(long)self.fanweApp.appModel.live_pay_min,(long)self.fanweApp.appModel.live_pay_max] keyboardType:UIKeyboardTypeNumberPad destructiveTitle:nil destructiveAction:^(NSString *text)
         {
            if ([text longLongValue] > (long)self.fanweApp.appModel.live_pay_max || [text longLongValue] < (long)self.fanweApp.appModel.live_pay_min)
            {
                [FanweMessage alertTWMessage:@"请输入正确的价格"];
                return ;
            }
            [self hostComfirmChargerWithStr:text];
        } cancelTitle:nil cancelAction:^{
            
        }];
    }else if (count == 2)//提档
    {
        [FanweMessage alert:@"按时付费提档" message:@"确定要提档?" destructiveAction:^{
            [self hostComfirmChargerWithStr:nil];
        } cancelAction:^{
            
        }];
    }else if (count == 3)//按场次
    {
        [FanweMessage alertInput:@"按场付费定价" message:[NSString stringWithFormat:@"请输入该场价格(%@/场)",self.fanweApp.appModel.diamond_name] placeholder:[NSString stringWithFormat:@"%ld<=价格<=%ld",(long)self.fanweApp.appModel.live_pay_scene_min,(long)self.fanweApp.appModel.live_pay_scene_max] keyboardType:UIKeyboardTypeNumberPad destructiveTitle:nil destructiveAction:^(NSString *text)
         {
             if ([text longLongValue] > (long)self.fanweApp.appModel.live_pay_scene_max || [text longLongValue] < (long)self.fanweApp.appModel.live_pay_scene_min)
             {
                 [FanweMessage alertTWMessage:@"请输入正确的价格"];
                 return ;
             }
             [self hostComfirmChargerWithStr:text];
         } cancelTitle:nil cancelAction:^{
             
         }];
    }
}

#pragma mark 主播提档或者切换付费之后确定的接口
- (void)hostComfirmChargerWithStr:(NSString *)textStr
{
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    [mDict setObject:@"live" forKey:@"ctl"];
    [mDict setObject:@"live_pay" forKey:@"act"];
    if (self.liveType == 40)
    {
        [mDict setObject:@"1" forKey:@"live_pay_type"];
    }else
    {
        [mDict setObject:@"0" forKey:@"live_pay_type"];
    }
    [mDict setObject:[NSString stringWithFormat:@"%d",(int)self.roomId] forKey:@"room_id"];
    if (self.is_mentionType == 1)
    {
        [mDict setObject:@"1" forKey:@"is_mention"];
    }else
    {
        [mDict setObject:@"0" forKey:@"is_mention"];
        if (textStr)
        {
           [mDict setObject:textStr forKey:@"live_fee"];
        }
    }
    [self.httpsManager POSTWithParameters:mDict SuccessBlock:^(NSDictionary *responseJson)
     {
         if ([responseJson toInt:@"status"] == 1)
         {
             SUS_WINDOW.isShowLivePay = NO;
             SUS_WINDOW.isShowMention = NO;
             [self.subLiving.bottomView addLiveFunc:self.buttomFunctionType];
             if (self.liveType == 40)
             {
                 [self.hostLeftPView addFirstLabWithStr:[NSString stringWithFormat:@"该直播%d%@/场",[responseJson toInt:@"live_fee"],self.fanweApp.appModel.diamond_name]];
                 [self.hostLeftPView addSecondLabWithStr:[NSString stringWithFormat:@"直播间付费人数:%d",[responseJson toInt:@"live_viewer"]]];
                 
             }else
             {
                 self.hostTimeCount = [[responseJson toString:@"count_down"] intValue];
                 if (self.hostTimeCount > 0)
                 {
                     self.hostTimeCount = [[responseJson toString:@"count_down"] intValue];
                     [self.hostLeftPView addFirstLabWithStr:[NSString stringWithFormat:@"%d秒后付费开始",(int)self.hostTimeCount]];
                     if (!self.hostPayLiveTime)
                     {
                         self.hostPayLiveTime = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(HostTimeGo) userInfo:nil repeats:YES];
                         [[NSRunLoop currentRunLoop] addTimer:self.hostPayLiveTime forMode:NSDefaultRunLoopMode];
                     }
                     [self.hostLeftPView addSecondLabWithStr:[NSString stringWithFormat:@"%d%@/分钟",[responseJson toInt:@"live_fee"],self.fanweApp.appModel.diamond_name]];
                     [self.hostLeftPView addThreeLabWithStr:[NSString stringWithFormat:@"直播间付费人数:%d",[responseJson toInt:@"live_viewer"]]];
                 }else
                 {
                     [self.hostLeftPView addSecondLabWithStr:[NSString stringWithFormat:@"%d%@/分钟",[responseJson toInt:@"live_fee"],self.fanweApp.appModel.diamond_name]];
                     [self.hostLeftPView addThreeLabWithStr:[NSString stringWithFormat:@"直播间付费人数:%d",[responseJson toInt:@"live_viewer"]]];
                 }
             }
         }
     } FailureBlock:^(NSError *error)
     {
         NSLog(@"error===%@",error);
     }];
}

#pragma mark 主播付费页面显示倒计时
- (void)HostTimeGo
{
    self.hostTimeCount --;
    if (self.hostTimeCount == 0)
    {
        [self.hostPayLiveTime invalidate];
        self.hostPayLiveTime = nil;
        [self.hostLeftPView removeFirstLabel];
        return;
    }
    [self.hostLeftPView addFirstLabWithStr:[NSString stringWithFormat:@"%d秒后付费开始",(int)self.hostTimeCount]];
}

#pragma mark 主播异常后再次可以进入原来自己的付费直播
- (void)hostEnterLiveAgainWithMDict:(NSDictionary *)responseJson
{
   if ([responseJson toInt:@"live_pay_type"] == 1)//按场收费
   {
       self.liveType = 40;
       [self.hostLeftPView addFirstLabWithStr:[NSString stringWithFormat:@"该直播%d%@/场",[responseJson toInt:@"live_fee"],self.fanweApp.appModel.diamond_name]];
       [self.hostLeftPView addSecondLabWithStr:[NSString stringWithFormat:@"直播间付费人数:%d",[responseJson toInt:@"live_viewer"]]];
   }else //按时付费
   {
       self.hostTimeCount = [[responseJson toString:@"count_down"] intValue];
       if (self.hostTimeCount > 0)
       {
           self.hostTimeCount = [[responseJson toString:@"count_down"] intValue];
           [self.hostLeftPView addFirstLabWithStr:[NSString stringWithFormat:@"%d秒后付费开始",(int)self.hostTimeCount]];
           if (!self.hostPayLiveTime)
           {
               self.hostPayLiveTime = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(HostTimeGo) userInfo:nil repeats:YES];
               [[NSRunLoop currentRunLoop] addTimer:self.hostPayLiveTime forMode:NSDefaultRunLoopMode];
           }
           [self.hostLeftPView addSecondLabWithStr:[NSString stringWithFormat:@"%d%@/分钟",[responseJson toInt:@"live_fee"],self.fanweApp.appModel.diamond_name]];
           [self.hostLeftPView addThreeLabWithStr:[NSString stringWithFormat:@"直播间付费人数:%d",[responseJson toInt:@"live_viewer"]]];
       }else
       {
           [self.hostLeftPView addSecondLabWithStr:[NSString stringWithFormat:@"%d%@/分钟",[responseJson toInt:@"live_fee"],self.fanweApp.appModel.diamond_name]];
           [self.hostLeftPView addThreeLabWithStr:[NSString stringWithFormat:@"直播间付费人数:%d",[responseJson toInt:@"live_viewer"]]];
       }
   }
}

#pragma mark ==================================观众========================================
- (id)initWithController:(UIViewController *)controller andLiveView:(TCShowLiveView *)liveView andRoomId:(int)roomId andAudienceDict:(NSDictionary *)audienceDict andButton:(UIButton *)closeBtn
{
    if (self = [super init])
    {
        self.roomId = roomId;
        self.httpsManager = [NetHttpsManager manager];
        self.fanweApp = [GlobalVariables sharedInstance];
        self.closeButton = closeBtn;
        self.is_agree = NO;
        self.subLiving = liveView;
        self.livController = controller;
        self.audienceDict = audienceDict;
        self.audienceLeftPView = [[LivePayLeftPromptV alloc]init];
        self.audienceLeftPView.frame = CGRectMake(kDefaultMargin,CGRectGetMaxY(self.subLiving.topView.otherContainerView.frame)+kStatusBarHeight, 0, kTicketContrainerViewHeight);
        [self.subLiving addSubview:self.audienceLeftPView];
    }
    return self;
}

#pragma mark 观众进入直播间后是否需要付费 观众1
- (void)creatAudienceWithDict:(NSDictionary *)dict
{
    if (!self.payLiveTime)
    {
        self.payLiveTime = [NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(ChargeTimeGo) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.payLiveTime forMode:NSDefaultRunLoopMode];
        [self enterMoneyMode];//请求接口
    }
}

#pragma mark 按场付费直播观众在主播开启付费之后进入直播间变灰
- (void)AudienceBecomeshadowView
{
    self.liveType = 40;
    [self creatTwoPromptView];//切换付费
}

#pragma mark 观众在收费直播间IM收到收费的通知 typeTag = 40 为按场次付费
- (void)AudienceGetVedioViewWithType:(int)typeTag
{
    [self creatShadowView];
    self.liveType = typeTag;
    if (typeTag == 40)  //按场次付费
    {
        self.shadowView.hidden = NO;
        [self enterMoneyMode];
        [self sentNotice:0];
    }else               //按时间付费
    {
        [self goToCountDownTime];
        [self enterMoneyMode];
        if (!self.payLiveTime)
        {
            self.payLiveTime = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(ChargeTimeGo) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:self.payLiveTime forMode:NSDefaultRunLoopMode];
        }
    }
}

#pragma mark 观众倒计时方法的调用
- (void)goToCountDownTime
{
    self.downTimeType = 1;
    if (!self.countDownTime)
    {
        self.countDownTime = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(moneyCountDownTimeGo) userInfo:nil repeats:YES];
        self.timeCount = self.fanweApp.appModel.live_pay_count_down;
        [[NSRunLoop currentRunLoop] addTimer:self.countDownTime forMode:NSDefaultRunLoopMode];
    }
}
#pragma mark 观众倒计时
- (void)moneyCountDownTimeGo
{
    self.timeCount --;
    if (self.downTimeType == 1)
    {
        if (self.timeCount == 0)
        {
            [self.countDownTime invalidate];
            self.countDownTime = nil;
            [self.audienceLeftPView.threeLabel removeFromSuperview];
            if (self.is_agree)
            {
                [self enterMoneyMode];
            }else
            {
                [self closeYY];
                self.shadowView.hidden = NO;
                [self sentNotice:0];
            }
            return;
        }
    }else
    {
        if (self.timeCount == 0)
        {
            [self.countDownTime invalidate];
            self.countDownTime = nil;
            
            [self.audienceLeftPView.threeLabel removeFromSuperview];
            if (self.is_agree)
            {
                [self enterMoneyMode];
            }else
            {
                [self closeYY];
                self.shadowView.hidden = NO;
                [self sentNotice:0];
            }
            return;
        }
    }
    [self.audienceLeftPView addThreeLabWithStr:[NSString stringWithFormat:@"%d秒后付费开始",(int)self.timeCount]];
}

#pragma mark 阴影部分的创建
- (void)creatShadowView
{
    if (!self.shadowView)//覆盖直播间的view
    {
        self.shadowView = [[UIView alloc]initWithFrame:CGRectMake(-3*kScreenW, 0, 5*kScreenW, kScreenH)];
        self.shadowView.backgroundColor = kLightGrayColor;
        self.shadowView.hidden = YES;
        [self.livController.view addSubview:self.shadowView];
        [self.livController.view bringSubviewToFront:self.closeButton];
    }
}

#pragma mark 30秒循环定时器
- (void)ChargeTimeGo
{
    [self enterMoneyMode];
}

#pragma mark 观众点击确定进入收费模式
- (void)enterMoneyMode
{
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    [mDict setObject:@"live" forKey:@"ctl"];
    [mDict setObject:@"live_pay_deduct" forKey:@"act"];
    [mDict setObject:[NSString stringWithFormat:@"%d",self.is_agree] forKey:@"is_agree"];
    [mDict setObject:[NSString stringWithFormat:@"%d",(int)self.roomId] forKey:@"room_id"];
    FWWeakify(self)
    [self.httpsManager POSTWithParameters:mDict SuccessBlock:^(NSDictionary *responseJson)
     {
         FWStrongify(self)
         if ([responseJson toInt:@"status"] == 1)
         {
             self.isEnterPayLive = 1;
             [[IMAPlatform sharedInstance].host setDiamonds:[NSString stringWithFormat:@"%ld",(long)[responseJson toInt:@"diamonds"]]];
             [self.subLiving.giftView setDiamondsLabelTxt:[NSString stringWithFormat:@"%ld",(long)[responseJson toInt:@"diamonds"]]];
             self.audienceDict = responseJson;
             
             if (self.fanweApp.appModel.open_diamond_game_module == 1)
             {
                 //更新游戏的余额
                 [[NSNotificationCenter defaultCenter]postNotificationName:@"updateCoin" object:nil];
             }
             
             if ([responseJson toInt:@"is_live_pay"]== 1)//是否收费，1是 0 否
             {
                 self.subLiving.topView.ticketNumLabel.text =[NSString stringWithFormat:@"%d",[responseJson toInt:@"ticket"]];
                 [self.subLiving.topView relayoutOtherContainerViewFrame];
                 
                 if (self.liveType == 40)
                 {
                     [self.audienceLeftPView addFirstLabWithStr:[NSString stringWithFormat:@"该直播%d%@/场",[responseJson toInt:@"live_fee"],self.fanweApp.appModel.diamond_name]];
                     if (self.is_agree == 0)
                     {
                         [self creatTwoPromptView];
                     }else
                     {
                         [self getAudienceStateWithDict:self.audienceDict];
                     }
                 }else
                 {
                      [self creatAudienceWithDict:self.audienceDict];
                     [self.audienceLeftPView addFirstLabWithStr:[NSString stringWithFormat:@"%d%@/分钟",[responseJson toInt:@"live_fee"],self.fanweApp.appModel.diamond_name]];
                     [self.audienceLeftPView addSecondLabWithStr:[NSString stringWithFormat:@"已观看:%d分钟",[responseJson toInt:@"total_time"]/60]];
                     if ([responseJson toInt:@"count_down"])
                     {
                         self.timeCount = [responseJson toInt:@"count_down"];
                         [self.audienceLeftPView addThreeLabWithStr:[NSString stringWithFormat:@"%d秒后付费开始",[responseJson toInt:@"count_down"]]];
                         if (!self.countDownTime)
                         {
                             self.countDownTime = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(moneyCountDownTimeGo) userInfo:nil repeats:YES];
                             [[NSRunLoop currentRunLoop] addTimer:self.countDownTime forMode:NSDefaultRunLoopMode];
                         }
                     }
                     if (self.is_agree == 1)//是否同意，1同意 0不同意
                     {
                         [self getAudienceStateWithDict:self.audienceDict];
                     }else
                     {
                         if ([responseJson toInt:@"on_live_pay"] == 1)//是否收费中 1是 0否
                         {
                             self.shadowView.hidden = NO;
//                             [self sentNotice:0];
                         }
                             [self creatTwoPromptView];
                     }
                 }
             }else
             {
                 NSLog(@"not need to do");
             }
         }
     } FailureBlock:^(NSError *error)
     {
         NSLog(@"error===%@",error);
     }];
}

#pragma mark 判断观众现在的状态,钱为0,钱不够5分钟，钱足够  观众3
- (void)getAudienceStateWithDict:(NSDictionary *)dict
{
    if ([dict toInt:@"is_diamonds_low"] == 1 && [dict toInt:@"is_recharge"] == 0)//余额很少
    {
        [FWUtils closeKeyboard]; // 关闭键盘
        if (self.payDelegate)//加载直播间视频的代理
        {
            if ([self.payDelegate respondsToSelector:@selector(livePayLoadVedioIsComfirm:)])
            {
                [self.payDelegate livePayLoadVedioIsComfirm:YES];
            }
        }
        FWWeakify(self)
        if (!self.myAlertView2)
        {
            self.myAlertView2 = [FanweMessage alert:@"温馨提示" message:[NSString stringWithFormat:@"账户余额:%d%@",[dict toInt:@"diamonds"],self.fanweApp.appModel.diamond_name] destructiveAction:^{
                FWStrongify(self)
                self.block(@"1");
                [self.myAlertView2 removeFromSuperview];
                self.myAlertView2 = nil;
            } cancelAction:^{
                [self.myAlertView2 removeFromSuperview];
                self.myAlertView2 = nil;
            }];
        }
        
        if (self.shadowView)
        {
            [self.shadowView removeFromSuperview];
            self.shadowView = nil;
        }
        [self sentNotice:1];
    }else if ([dict toInt:@"is_diamonds_low"] == 1 && [dict toInt:@"is_recharge"] == 1)//余额为不足
    {
        // 关闭键盘
        [FWUtils closeKeyboard];
        
        [self creatShadowView];//没钱就要加上阴影
        if (self.timeCount < 1)
        {
            [self closeYY];
            self.shadowView.hidden = NO;
        }
        
        FWWeakify(self)
        if (!self.myAlertView3)
        {
          self.myAlertView3 = [FanweMessage alert:@"温馨提示" message:[NSString stringWithFormat:@"账户余额:%d%@",[dict toInt:@"diamonds"],self.fanweApp.appModel.diamond_name] destructiveAction:^{
                FWStrongify(self)
                self.block(@"1");
              [self.myAlertView3 removeFromSuperview];
              self.myAlertView3 = nil;
            } cancelAction:^{
                FWStrongify(self)
                if (self.payDelegate)//加载或者不加载直播间视频的代理
                {
                    if ([self.payDelegate respondsToSelector:@selector(livePayLoadVedioIsComfirm:)])
                    {
                        [self.payDelegate livePayLoadVedioIsComfirm:NO];
                    }
                }
                [self.myAlertView3 removeFromSuperview];
                self.myAlertView3 = nil;
            }];
        }
        [self sentNotice:0];
        
    }else
    {
        if (self.payDelegate)//加载直播间视频的代理
        {
            if ([self.payDelegate respondsToSelector:@selector(livePayLoadVedioIsComfirm:)])
            {
                [self.payDelegate livePayLoadVedioIsComfirm:YES];
            }
        }
        if (self.shadowView)
        {
            [self.shadowView removeFromSuperview];
            self.shadowView = nil;
        }
        [self sentNotice:1];
    }
}

#pragma mark 创建TwoPromptView
- (void)creatTwoPromptView
{
    if (!self.myAlertView1)
    {
        NSString *promptStr;
        if (self.liveType == 40)
        {
            promptStr = [NSString stringWithFormat:@"主播开启了付费直播，%d%@/场，是否进入?",[self.audienceDict toInt:@"live_fee"],self.fanweApp.appModel.diamond_name];
        }else
        {
            promptStr = [NSString stringWithFormat:@"主播开启了付费直播，%d%@/分钟，是否进入?",[self.audienceDict toInt:@"live_fee"],self.fanweApp.appModel.diamond_name];
        }
       self.myAlertView1 = [FanweMessage alert:@"付费直播" message:promptStr destructiveAction:^{
            self.is_agree = YES;
            [self enterMoneyMode];
           [self.myAlertView1 removeFromSuperview];
           self.myAlertView1 = nil;
        } cancelAction:^{
            [self.myAlertView1 removeFromSuperview];
            self.myAlertView1 = nil;
            if (self.payDelegate)//加载或者不加载直播间视频的代理
            {
                if ([self.payDelegate respondsToSelector:@selector(livePayLoadVedioIsComfirm:)])
                {
                    [self.payDelegate livePayLoadVedioIsComfirm:NO];
                }
            }
        }];
    }
}

#pragma mark 发送通知来关闭云直播间的声音
- (void)sentNotice:(int)type
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:[NSString stringWithFormat:@"%d",type] forKey:@"type"];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"closeAndOpenVoice" object:dict];
}
#pragma mark 观众直播间有连麦，付费直播后不能看直播就关闭连麦
- (void)closeYY
{
    NSString *controlRole;
    if (![FWUtils isBlankString:_fanweApp.appModel.spear_normal])
    {
        controlRole = self.fanweApp.appModel.spear_normal;
    }
    else
    {
        controlRole = @"NormalGuest";
    }
}

#pragma mark ===========共用==================
- (void)changeLeftViewFrameWithIsHost:(BOOL)isHost andAuctionView:(UIView *)auctionView andBankerView:(UIView *)bankerView
{
    if (isHost == YES)//是主播
    {
        if (bankerView.hidden)
        {
            if (auctionView.hidden)
            {
                CGRect rect = self.hostLeftPView.frame;
                rect.origin.y = CGRectGetMaxY(self.subLiving.topView.otherContainerView.frame)+kStatusBarHeight;
                self.hostLeftPView.frame = rect;
            }
            else
            {
                CGRect rect = self.hostLeftPView.frame;
                rect.origin.y = CGRectGetMaxY(self.subLiving.topView.otherContainerView.frame)+auctionView.height+8+kStatusBarHeight;
                self.hostLeftPView.frame = rect;
            }
        }
        else
        {
            if (auctionView.hidden)
            {
                CGRect rect = self.hostLeftPView.frame;
                rect.origin.y = CGRectGetMaxY(self.subLiving.topView.otherContainerView.frame)+bankerView.height+8+kStatusBarHeight;
                self.hostLeftPView.frame = rect;
            }
            else
            {
                CGRect rect = self.hostLeftPView.frame;
                rect.origin.y = CGRectGetMaxY(self.subLiving.topView.otherContainerView.frame)+bankerView.height+auctionView.height+8+8+kStatusBarHeight;
                self.hostLeftPView.frame = rect;
            }
        }
    }else//是观众
    {
        if (bankerView.hidden)
        {
            if (auctionView.hidden)
            {
                CGRect rect = self.audienceLeftPView.frame;
                rect.origin.y = CGRectGetMaxY(self.subLiving.topView.otherContainerView.frame)+kStatusBarHeight;
                self.audienceLeftPView.frame = rect;
            }
            else
            {
                CGRect rect = self.audienceLeftPView.frame;
                rect.origin.y = CGRectGetMaxY(self.subLiving.topView.otherContainerView.frame)+auctionView.height+8+kStatusBarHeight;
                self.audienceLeftPView.frame = rect;
            }
        }
        else
        {
            if (auctionView.hidden)
            {
                CGRect rect = self.audienceLeftPView.frame;
                rect.origin.y = CGRectGetMaxY(self.subLiving.topView.otherContainerView.frame)+bankerView.height+8+kStatusBarHeight;
                self.audienceLeftPView.frame = rect;
            }
            else
            {
                CGRect rect = self.audienceLeftPView.frame;
                rect.origin.y = CGRectGetMaxY(self.subLiving.topView.otherContainerView.frame)+bankerView.height+auctionView.height+8+8+kStatusBarHeight;
                self.audienceLeftPView.frame = rect;
            }
        }
    }
}

@end
