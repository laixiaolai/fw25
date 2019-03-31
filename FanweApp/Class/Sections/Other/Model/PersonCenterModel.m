//
//  PersonCenterModel.m
//  FanweApp
//
//  Created by 丁凯 on 2017/7/20.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "PersonCenterModel.h"
#import "userPageModel.h"
#import "AccountRechargeVC.h"
#import "IncomeViewController.h"
#import "ChargerViewController.h"
#import "DistributionController.h"
#import "IdentificationViewController.h"
#import "SetViewController.h"
#import "GameDistributionViewController.h"
#import "ShopListViewController.h"
#import "OnLiveViewController.h"
#import "FollowerViewController.h"
#import "EditFamilyViewController.h"
#import "FamilyDesViewController.h"
#import "FamilyListViewController.h"
#import "SocietyListViewController.h"
#import "EditSocietyViewController.h"
#import "SocietyDesViewController.h"
#import "HPheadView.h"
#import "SSearchVC.h"
#import "FWEditInfoController.h"
#import "GetHeadImgViewController.h"
#import "FWConversationSegmentController.h"

@implementation PersonCenterModel

- (void)creatUIWithModel:(userPageModel *)userModel andMArr:(NSMutableArray *)detailArray andMyView:(UIView *)myView
{
    for (UIButton *btn in myView.subviews)
    {
        if ([btn viewWithTag:1])
        {
            if ([userModel.video_count integerValue] >= 10000)
            {
                [btn setTitle:[NSString stringWithFormat:@"直播 %.1f万",[userModel.video_count floatValue]/10000] forState:UIControlStateNormal];
            }
            else
            {
                [btn setTitle:[NSString stringWithFormat:@"直播 %@",userModel.video_count] forState:UIControlStateNormal];
            }
        }
        if([btn viewWithTag:2])
        {
            if ([userModel.focus_count floatValue]>=10000)
            {
                [btn setTitle:[NSString stringWithFormat:@"关注 %.1f万",[userModel.focus_count floatValue]/10000] forState:UIControlStateNormal];
            }
            else
            {
                [btn setTitle:[NSString stringWithFormat:@"关注 %@",userModel.focus_count] forState:UIControlStateNormal];
            }
        }
        if([btn viewWithTag:3])
        {
            if ([userModel.fans_count integerValue]>=10000)
            {
                [btn setTitle:[NSString stringWithFormat:@"粉丝 %.1f万",[userModel.fans_count floatValue]/10000] forState:UIControlStateNormal];
            }
            else
            {
                [btn setTitle:[NSString stringWithFormat:@"粉丝 %@",userModel.fans_count] forState:UIControlStateNormal];
            }
        }
    }
    
    if (userModel.user_level.length)
    {
        [detailArray replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%@级",userModel.user_level]];
    }
    
    if ([userModel.diamonds floatValue] > 10000)
    {
        [detailArray replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"%.2f万钻石",[userModel.diamonds floatValue]/10000]];
    }else
    {
        [detailArray replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"%@钻石",userModel.diamonds]];
    }
    
    if ([self.fanweApp.appModel.open_vip isEqualToString:@"1"])
    {
        if ([userModel.is_vip isEqualToString:@"1"])
        {
            [detailArray replaceObjectAtIndex:2 withObject:@"已开通"];
        }
        else
        {
            [detailArray replaceObjectAtIndex:2 withObject:userModel.vip_expire_time];
        }
    }
    else
    {
        [detailArray replaceObjectAtIndex:2 withObject:@""];
    }
    
    if (userModel.coin.length)
    {
        [detailArray replaceObjectAtIndex:3 withObject:[NSString stringWithFormat:@"%@游戏币",userModel.coin]];
    }
    
    if ([userModel.useable_ticket integerValue]>=10000)
    {
        [detailArray replaceObjectAtIndex:4 withObject:[NSString stringWithFormat:@"%.3f万%@",[userModel.useable_ticket floatValue]/10000,self.fanweApp.appModel.ticket_name]];
    }
    else
    {
        [detailArray replaceObjectAtIndex:4 withObject:[NSString stringWithFormat:@"%@%@",userModel.useable_ticket,self.fanweApp.appModel.ticket_name]];
    }
    
    if (userModel.podcast_order.length)
    {
        [detailArray replaceObjectAtIndex:5 withObject:[NSString stringWithFormat:@"%@ 个订单",userModel.podcast_order]];
    }
    if (userModel.podcast_pai.length)
    {
        [detailArray replaceObjectAtIndex:6 withObject:[NSString stringWithFormat:@"%@ 个竞拍",userModel.podcast_pai]];
    }
    if (userModel.show_user_order.length)
    {
        [detailArray replaceObjectAtIndex:7 withObject:[NSString stringWithFormat:@"%@ 个订单",userModel.show_user_order]];
    }
    
    if (userModel.podcast_goods.length)
    {
        [detailArray replaceObjectAtIndex:8 withObject:[NSString stringWithFormat:@"%@ 个商品",userModel.podcast_goods]];
    }
    if (userModel.user_pai.length)
    {
        [detailArray replaceObjectAtIndex:9 withObject:[NSString stringWithFormat:@"%@ 个竞拍",userModel.user_pai]];
    }
    if (self.fanweApp.appModel.shop_shopping_cart.length)
    {
        [detailArray replaceObjectAtIndex:10 withObject:[NSString stringWithFormat:@"%@ 个商品",self.fanweApp.appModel.shop_shopping_cart]];
    }
    if (userModel.open_podcast_goods.length)
    {
        [detailArray replaceObjectAtIndex:11 withObject:[NSString stringWithFormat:@"%@ 个商品",userModel.open_podcast_goods]];
    }
    
    NSString *idStr;
    if ([userModel.is_authentication intValue] ==0)
    {
        idStr = @"未认证";
    }
    if ([userModel.is_authentication intValue] ==1)
    {
        idStr = @"等待审核";
    }
    if ([userModel.is_authentication intValue] ==2)
    {
        idStr = @"已认证";
    }
    if ([userModel.is_authentication intValue] ==3)
    {
        idStr = @"审核不通过";
    }
    [detailArray replaceObjectAtIndex:13 withObject:idStr];
}

-(void)didSelectWithModel:(userPageModel *)userModel andSection:(int)section
{
    self.fanweApp = [GlobalVariables sharedInstance];
    if (section == 0)
    {
        NSString *tmpUrlStr;
#if kSupportH5Shopping
        tmpUrlStr = [NSString stringWithFormat:@"%@&user_id=%@",_fanweApp.appModel.h5_url.url_my_grades,_userModel.user_id];
#else
        tmpUrlStr = _fanweApp.appModel.h5_url.url_my_grades;
#endif
        FWMainWebViewController *tmpController = [FWMainWebViewController webControlerWithUrlStr:tmpUrlStr isShowIndicator:YES isShowNavBar:YES isShowBackBtn:YES];
        tmpController.navTitleStr = @"我的等级";
        [[AppDelegate sharedAppDelegate] pushViewController:tmpController];
    }
    else if (section == 1)
    {
        AccountRechargeVC *acountVC = [[AccountRechargeVC alloc]init];
        [[AppDelegate sharedAppDelegate] pushViewController:acountVC];
        
    }
    else if(section == 2)
    {
        AccountRechargeVC *acountVC = [[AccountRechargeVC alloc]init];
        acountVC.is_vip = YES;
        [[AppDelegate sharedAppDelegate] pushViewController:acountVC];
    }
    else if(section == 4)
    {
        IncomeViewController *profitVC = [[IncomeViewController alloc]init];
        [[AppDelegate sharedAppDelegate] pushViewController:profitVC];
    }else if (section == 5)
    {
        FWMainWebViewController *tmpController = [FWMainWebViewController webControlerWithUrlStr:self.fanweApp.appModel.h5_url.url_podcast_order isShowIndicator:YES isShowNavBar:YES isShowBackBtn:YES isShowCloseBtn:YES];
        tmpController.navTitleStr = @"订单管理";
        [[AppDelegate sharedAppDelegate] pushViewController:tmpController];
    }
    else if(section == 6)
    {
        FWMainWebViewController *tmpController = [FWMainWebViewController webControlerWithUrlStr:self.fanweApp.appModel.h5_url.url_podcast_pai isShowIndicator:YES isShowNavBar:YES isShowBackBtn:YES isShowCloseBtn:YES];
        tmpController.navTitleStr = @"竞拍管理";
        tmpController.isFrontRefresh = YES;
        [[AppDelegate sharedAppDelegate] pushViewController:tmpController];
    }
    else if(section == 7)
    {
        FWMainWebViewController *tmpController = [FWMainWebViewController webControlerWithUrlStr:self.fanweApp.appModel.h5_url.url_user_order isShowIndicator:YES isShowNavBar:YES isShowBackBtn:YES isShowCloseBtn:YES];
        tmpController.navTitleStr = @"我的订单";
        [[AppDelegate sharedAppDelegate] pushViewController:tmpController];
    }
    else if(section == 8)
    {
        FWMainWebViewController *tmpController = [FWMainWebViewController webControlerWithUrlStr:self.fanweApp.appModel.h5_url.url_podcast_goods isShowIndicator:YES isShowNavBar:YES isShowBackBtn:YES isShowCloseBtn:YES];
        tmpController.navTitleStr = @"商品管理";
        [[AppDelegate sharedAppDelegate] pushViewController:tmpController];
    }else if(section == 9)
    {
        FWMainWebViewController *tmpController = [FWMainWebViewController webControlerWithUrlStr:self.fanweApp.appModel.h5_url.url_user_pai isShowIndicator:YES isShowNavBar:YES isShowBackBtn:YES isShowCloseBtn:YES];
        tmpController.navTitleStr = @"我的竞拍";
        tmpController.isFrontRefresh = YES;
        [[AppDelegate sharedAppDelegate] pushViewController:tmpController];
    }
    else if(section == 10)
    {
        FWMainWebViewController *tmpController = [FWMainWebViewController webControlerWithUrlStr:self.fanweApp.appModel.h5_url.url_shopping_cart isShowIndicator:YES isShowNavBar:YES isShowBackBtn:YES isShowCloseBtn:YES];
        tmpController.navTitleStr = @"我的购物车";
        [[AppDelegate sharedAppDelegate] pushViewController:tmpController];
    }
    else if(section == 11)
    {
        ShopListViewController *shopListVC = [[ShopListViewController alloc]init];
        shopListVC.user_id = userModel.user_id;
        shopListVC.isOTOShop = YES;
        shopListVC.hidesBottomBarWhenPushed = YES;
        [[AppDelegate sharedAppDelegate] pushViewController:shopListVC];
    }else if(section == 12)
    {
        ContributionListViewController *contributionVC =[[ContributionListViewController alloc]init];
        contributionVC.type = @"0";
        contributionVC.user_id = userModel.user_id;
        contributionVC.hidesBottomBarWhenPushed = YES;
        [[AppDelegate sharedAppDelegate] pushViewController:contributionVC];
    }else if(section == 13)
    {
        IdentificationViewController *identificationVC = [[IdentificationViewController alloc]init];
        identificationVC.user_id = userModel.user_id;
        identificationVC.sexString = userModel.sex;
        identificationVC.nameString = userModel.nick_name;
        [[AppDelegate sharedAppDelegate] pushViewController:identificationVC];
    }else if(section == 15)
    {
        ChargerViewController *chargerVC = [[ChargerViewController alloc]init];
        chargerVC.type = 0;
        chargerVC.live_pay_type = _fanweApp.appModel.live_pay_time ? 0:1;
        [[AppDelegate sharedAppDelegate] pushViewController:chargerVC];
    }else if(section == 17)
    {
        DistributionController *DistributionVC = [[DistributionController alloc]init];
        [[AppDelegate sharedAppDelegate] pushViewController:DistributionVC];
    }else if(section == 18)
    {
        GameDistributionViewController *gameDistributionVC = [[GameDistributionViewController alloc]init];
        [[AppDelegate sharedAppDelegate] pushViewController:gameDistributionVC];
    }else if(section == 19)
    {
        SetViewController *setViewController = [[SetViewController alloc]init];
        setViewController.userID = userModel.user_id;
        [[AppDelegate sharedAppDelegate] pushViewController:setViewController];
    }else if(section == 21)//回播
    {
        OnLiveViewController *onliveVC = [[OnLiveViewController alloc]init];
        onliveVC.user_id = userModel.user_id;
        [[AppDelegate sharedAppDelegate] pushViewController:onliveVC];
    }else if(section == 22 || section == 23)//关注22  粉丝23
    {
        FollowerViewController *FollowVC = [[FollowerViewController alloc]init];
        FollowVC.user_id = userModel.user_id;
        FollowVC.type = [NSString stringWithFormat:@"%d",section-21];
        [[AppDelegate sharedAppDelegate] pushViewController:FollowVC];
    }else if (section == 24)//24搜索
    {
        SSearchVC *searchVC = [[SSearchVC alloc]init];
        searchVC.searchType = @"0";
        [[AppDelegate sharedAppDelegate] pushViewController:searchVC];
    }else if (section == 25)//25IM消息
    {
//        ConversationListController* chatlist = [[ConversationListController alloc]initWithNibName:@"ConversationListController" bundle:nil];
//        chatlist.mbackbt.hidden = NO;
        FWConversationSegmentController *chatListVC = [[FWConversationSegmentController alloc]init];
        [[AppDelegate sharedAppDelegate] pushViewController:chatListVC];
    }else if (section == 26)//26更换头像
    {
        GetHeadImgViewController *headVC =[[GetHeadImgViewController alloc]init];
        headVC.headImgString =userModel.head_image;
        headVC.userId =userModel.user_id;
        [[AppDelegate sharedAppDelegate]pushViewController:headVC];
    }else if (section == 27)//27编辑
    {
        FWEditInfoController *editVC = [[FWEditInfoController alloc]init];
        [[AppDelegate sharedAppDelegate] pushViewController:editVC];
    }
}

#pragma mark ======================兑换游戏币======================
- (void)createExchangeCoinViewWithVC:(UIViewController *)myVC
{
    _bgWindow = [[UIApplication sharedApplication].delegate window];
    
    if (!_exchangeView)
    {
        _exchangeBgView                    = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
        _exchangeBgView.backgroundColor    = kGrayTransparentColor4;
        _exchangeBgView.hidden             = YES;
        [myVC.view addSubview:_exchangeBgView];
        
        UITapGestureRecognizer  *bgViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(exchangeBgViewTap)];
        [_exchangeBgView addGestureRecognizer:bgViewTap];
        
        _exchangeView                      = [ExchangeCoinView EditNibFromXib];
        _exchangeView.exchangeType         = 1;
        _exchangeView.delegate             = self;
        _exchangeView.frame                = CGRectMake((kScreenW - 300)/2, kScreenH, 300, 230);
        [_exchangeView createSomething];
        [_bgWindow addSubview:_exchangeView];
    }
}

- (void)exchangeViewDownWithExchangeCoinView:(ExchangeCoinView *)exchangeCoinView
{
    if (_exchangeView == exchangeCoinView)
    {
        [_exchangeView.diamondLeftTextfield resignFirstResponder];
        _exchangeView.diamondLeftTextfield.text = nil;
        _exchangeView.coinLabel.text = @"0游戏币";
        [UIView animateWithDuration:0.3 animations:^{
            _exchangeView.frame = CGRectMake((kScreenW - 300)/2, kScreenH, 300, 230);
        } completion:^(BOOL finished) {
            _exchangeBgView.hidden = YES;
        }];
    }
}

- (void)exchangeBgViewTap
{
    [self exchangeViewDownWithExchangeCoinView:_exchangeView];
}

- (void)exchangeGaomeCoinsWithModel:(userPageModel *)userModel
{
    [_bgWindow bringSubviewToFront:_exchangeBgView];
    [_bgWindow bringSubviewToFront:_exchangeView];
    [_exchangeView obtainCoinProportion];
    [UIView animateWithDuration:0.3 animations:^{
        _exchangeBgView.hidden = NO;
        [_exchangeView.diamondLeftTextfield becomeFirstResponder];
        _exchangeView.ticket = userModel.diamonds;
        _exchangeView.diamondLabel.text =[NSString stringWithFormat:@"钻石余额:%@",userModel.diamonds];
        _exchangeView.frame = CGRectMake((kScreenW - 300)/2, (kScreenH - 350)/2, 300, 230);
    }];
}

#pragma mark ======================我的家族======================
- (void)createFamilyViewWithVC:(UIViewController *)myVC andModel:(userPageModel *)userModel
{
    self.userModel = userModel;
    if (!self.backgroundView)
    {
        self.backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
        self.backgroundView.backgroundColor = kAppGrayColor6;
        self.backgroundView.alpha = 0.5;
        self.backgroundView.hidden = NO;
        [myVC.view addSubview:self.backgroundView];
        self.bigButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
        [self.bigButton addTarget:self action:@selector(closeFamilyView) forControlEvents:UIControlEventTouchUpInside];
        [self.backgroundView addSubview:_bigButton];
        self.backView = [[UIView alloc] initWithFrame:CGRectMake(10, (kScreenH-170)/2, kScreenW-20, 170)];
        self.backView.backgroundColor = [UIColor grayColor];
        self.backView.layer.cornerRadius = 5;
        self.backView.layer.masksToBounds = YES;
        [myVC.view addSubview:_backView];
        self.bigView = [[UIView alloc] initWithFrame:CGRectMake(5, 5, kScreenW-30, 160)];
        self.bigView.backgroundColor = [UIColor whiteColor];
        self.bigView.layer.cornerRadius = 5;
        self.bigView.layer.masksToBounds = YES;
        [self.backView addSubview:self.bigView];
        self.addFamilyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.addFamilyBtn.frame = CGRectMake(15, 20, kScreenW-60, 48);
        self.addFamilyBtn.backgroundColor = kAppMainColor;
        self.addFamilyBtn.layer.cornerRadius = 15;
        self.addFamilyBtn.layer.masksToBounds = YES;
        [self.addFamilyBtn addTarget:self action:@selector(clickAddBtn) forControlEvents:UIControlEventTouchUpInside];
        [self.addFamilyBtn setTitle:@"加入家族" forState:UIControlStateNormal];
        [self.bigView addSubview:self.addFamilyBtn];
        self.createBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.createBtn.backgroundColor = kAppFamilyBtnColor;
        self.createBtn.layer.cornerRadius = 15;
        self.createBtn.layer.masksToBounds = YES;
        [self.createBtn setTitle:@"创建家族" forState:UIControlStateNormal];
        [self.createBtn addTarget:self action:@selector(clickCreateBtn) forControlEvents:UIControlEventTouchUpInside];
        [self.bigView addSubview:self.createBtn];
        
        if ([self.fanweApp.appModel.family_join intValue] == 0)
        {
            self.backView.frame = CGRectMake(10, (kScreenH-85)/2, kScreenW-20, 85);
            self.bigView.frame = CGRectMake(5, 2.5, kScreenW-30, 80);
            self.addFamilyBtn.hidden = YES;
            self.createBtn.frame = CGRectMake(15, CGRectGetMidY(_bigView.frame)-25, kScreenW-60, 48);
        }
        else if ([self.fanweApp.appModel.family_join intValue] == 1)
        {
            self.backView.frame = CGRectMake(10, (kScreenH-170)/2, kScreenW-20, 170);
            self.bigView.frame = CGRectMake(5, 5, kScreenW-30, 160);
            self.addFamilyBtn.hidden = NO;
            self.createBtn.frame = CGRectMake(15, 92, kScreenW-60, 48);
        }
    }
    else
    {
        self.backgroundView.hidden = NO;
        self.backView.hidden = NO;
    }
}
//关闭家族页面
- (void)closeFamilyView
{
    self.backgroundView.hidden = YES;
    self.backView.hidden = YES;
}

//加入家族
- (void)clickAddBtn
{
    self.backgroundView.hidden = YES;
    self.backView.hidden = YES;
    FamilyListViewController *familyListVC = [[FamilyListViewController alloc] init];
    [[AppDelegate sharedAppDelegate] pushViewController:familyListVC];
}

//创建家族
- (void)clickCreateBtn
{
    self.backgroundView.hidden = YES;
    self.backView.hidden = YES;
    EditFamilyViewController * editFamilyVC = [[EditFamilyViewController alloc] init];
    editFamilyVC.hidesBottomBarWhenPushed = YES;
    //创建家族时type=0;
    editFamilyVC.type = 0;
    editFamilyVC.user_id = self.userModel.user_id;
    [[AppDelegate sharedAppDelegate] pushViewController:editFamilyVC];
}

//家族详情
- (void)goToFamilyDesVCWithModel:(userPageModel *)userModel
{
    FamilyDesViewController * familyDesVc = [[FamilyDesViewController alloc] init];
    //是否是族长
    familyDesVc.isFamilyHeder = [userModel.family_chieftain intValue];
    familyDesVc.jid =userModel.family_id;
    familyDesVc.user_id =userModel.user_id;
    [[AppDelegate sharedAppDelegate] pushViewController:familyDesVc];
}

#pragma mark ======================我的公会======================
- (void)createSocietyViewWithVC:(UIViewController *)myVC andModel:(userPageModel *)userModel
{
    if (!self.backgroundViewTwo)
    {
        self.backgroundViewTwo = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
        self.backgroundViewTwo.backgroundColor = kAppGrayColor6;
        self.backgroundViewTwo.alpha = 0.5;
        self.backgroundViewTwo.hidden = NO;
        [myVC.view addSubview:self.backgroundViewTwo];
        self.bigBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
        [self.bigBtn addTarget:self action:@selector(closeSocietyView) forControlEvents:UIControlEventTouchUpInside];
        [self.backgroundViewTwo addSubview:self.bigBtn];
        self.backViewTwo = [[UIView alloc] initWithFrame:CGRectMake(10, (kScreenH-170)/2, kScreenW-20, 170)];
        self.backViewTwo.backgroundColor = [UIColor grayColor];
        self.backViewTwo.layer.cornerRadius = 5;
        self.backViewTwo.layer.masksToBounds = YES;
        [myVC.view addSubview:self.backViewTwo];
        self.bigViewTwo = [[UIView alloc] initWithFrame:CGRectMake(5, 5, kScreenW-30, 160)];
        self.bigViewTwo.backgroundColor = [UIColor whiteColor];
        self.bigViewTwo.layer.cornerRadius = 5;
        self.bigViewTwo.layer.masksToBounds = YES;
        [self.backViewTwo addSubview:self.bigViewTwo];
        self.addSocietyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.addSocietyBtn.frame = CGRectMake(15, 20, kScreenW-60, 48);
        self.addSocietyBtn.backgroundColor = kAppMainColor;
        self.addSocietyBtn.layer.cornerRadius = 15;
        self.addSocietyBtn.layer.masksToBounds = YES;
        [self.addSocietyBtn addTarget:self action:@selector(clickAddSocietyBtn) forControlEvents:UIControlEventTouchUpInside];
        [self.addSocietyBtn setTitle:@"加入公会" forState:UIControlStateNormal];
        [self.bigViewTwo addSubview:_addSocietyBtn];
        self.createSocietyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.createSocietyBtn.frame = CGRectMake(15, 92, kScreenW-60, 48);
        self.createSocietyBtn.backgroundColor = kAppFamilyBtnColor;
        self.createSocietyBtn.layer.cornerRadius = 15;
        self.createSocietyBtn.layer.masksToBounds = YES;
        [self.createSocietyBtn setTitle:@"创建公会" forState:UIControlStateNormal];
        [self.createSocietyBtn addTarget:self action:@selector(clickCreateSocietyBtn) forControlEvents:UIControlEventTouchUpInside];
        [self.bigViewTwo addSubview:self.createSocietyBtn];
    }
    else
    {
        self.backgroundViewTwo.hidden = NO;
        self.backViewTwo.hidden = NO;
    }
}

//关闭公会页面
- (void)closeSocietyView
{
    self.backgroundViewTwo.hidden = YES;
    self.backViewTwo.hidden = YES;
}
//加入公会
- (void)clickAddSocietyBtn
{
    self.backgroundViewTwo.hidden = YES;
    self.backViewTwo.hidden = YES;
    SocietyListViewController * societyListVC = [[SocietyListViewController alloc] init];
    [[AppDelegate sharedAppDelegate] pushViewController:societyListVC];
}

//创建公会
- (void)clickCreateSocietyBtn
{
    self.backgroundViewTwo.hidden = YES;
    self.backViewTwo.hidden = YES;
    EditSocietyViewController * editSocietyVC = [[EditSocietyViewController alloc] init];
    //创建公会时type=0;
    editSocietyVC.type = 0;
    editSocietyVC.user_id = _userModel.user_id;
    [[AppDelegate sharedAppDelegate] pushViewController:editSocietyVC];
}

//公会详情
- (void)goToSocietyDesVCWithModel:(userPageModel *)userModel
{
    SocietyDesViewController * societyDesVc = [[SocietyDesViewController alloc] init];
    //是否是公会长
    societyDesVc.isSocietyHeder = [userModel.society_chieftain intValue];
    societyDesVc.society_id =userModel.society_id;
    societyDesVc.user_id =userModel.user_id;
    [[AppDelegate sharedAppDelegate] pushViewController:societyDesVc];
}

//消息的角标
- (void)loadBadageDataWithView:(HPheadView *)headV
{
    [SFriendObj getAllUnReadCountComplete:^(int num) {
        
        int scount = num;
        if( scount )
        {
            if(scount >98){
                headV.numLabel.text = @"99+";
            }else{
                headV.numLabel.text = [NSString stringWithFormat:@"%d",scount];
            }
        }
        else
        {
            headV.numLabel.text = @"";
        }
    }];
}

- (GlobalVariables *)fanweApp
{
    if (!_fanweApp)
    {
        _fanweApp = [GlobalVariables sharedInstance];
    }
    return _fanweApp;
}


@end
