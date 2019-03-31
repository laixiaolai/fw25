//
//  UpgradeTipView.m
//  FanweApp
//
//  Created by xfg on 2017/7/15.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "UpgradeTipView.h"

@implementation UpgradeTipView

#pragma mark - ----------------------- 首次登陆奖励和升级提示消息 -----------------------
#pragma mark 每日首次登陆奖励和升级提示消息的初始化
- (void)initRewards
{
    //延迟三秒，以防跟广告图冲突
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber *haveLanch = [userDefaults objectForKey:@"haveLanch"];
    if ([haveLanch boolValue] == YES)
    {
        [self performSelector:@selector(loginRewards) withObject:nil afterDelay:3];
    }
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginRewards) name:@"rewardView" object:nil];
}

#pragma mark 每日首次登陆奖励和升级提示消息
- (void)loginRewards
{
    //灰色背景
    if (!_grayView)
    {
        _grayView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
        _grayView.backgroundColor = kGrayTransparentColor6;
        _grayView.hidden = YES;
        _grayView.alpha = 0.5;
        [kCurrentWindow addSubview:_grayView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
        [_grayView addGestureRecognizer:tap];
    }
    
    if (!_rewardView)
    {
        _rewardView = [LoginRewardView EditNibFromXib];
        _rewardView.hidden = YES;
        _rewardView.frame = CGRectMake((kScreenW-300)/2, kScreenH, 300, 302);
        _rewardView.backgroundColor = [UIColor clearColor];
        _rewardView.bgView.backgroundColor = [UIColor clearColor];
        _rewardView.displayView.layer.cornerRadius = 15;
        _rewardView.displayView.backgroundColor = kNavBarThemeColor;
        _rewardView.rewardLabel.textColor = kAppGrayColor1;
        _rewardView.exLabel.textColor = kAppGrayColor3;
        _rewardView.comfirmBtn.layer.cornerRadius = 5;
        [_rewardView.comfirmBtn setTitleColor:kNavBarThemeColor forState:UIControlStateNormal];
        _rewardView.comfirmBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        _rewardView.comfirmBtn.backgroundColor = kAppMainColor;
        [kCurrentWindow addSubview:_rewardView];
        
        FWWeakify(self)
        _rewardView.rewardBlock = ^(){
            
            if (fwwo)
            {
                [fwwo rewardAction];
            }
            else
            {
                [self rewardAction];
            }
            
        };
    }
    
    if (!_upgradeView)
    {
        _upgradeView = [UpgradeView EditNibFromXib];
        _upgradeView.hidden = YES;
        _upgradeView.frame = CGRectMake((kScreenW-300)/2, kScreenH, 300, 302);
        _upgradeView.backgroundColor = [UIColor clearColor];
        _upgradeView.bgView.backgroundColor = [UIColor clearColor];
        _upgradeView.displayView.layer.cornerRadius = 15;
        _upgradeView.displayView.backgroundColor = kNavBarThemeColor;
        _upgradeView.upgradeLabel.textColor = kAppGrayColor1;
        _upgradeView.exLabel.textColor = kAppGrayColor3;
        _upgradeView.comfirmBtn.layer.cornerRadius = 5;
        [_upgradeView.comfirmBtn setTitleColor:kNavBarThemeColor forState:UIControlStateNormal];
        _upgradeView.comfirmBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        _upgradeView.comfirmBtn.backgroundColor = kAppMainColor;
        [kCurrentWindow addSubview:_upgradeView];
        
        FWWeakify(self)
        _upgradeView.upgradeBlock = ^(){
            
            if (fwwo)
            {
                [fwwo upgradeAction];
            }
            else
            {
                [self upgradeAction];
            }
        };
    }
    
    _rewardView.exLabel.text = [NSString stringWithFormat:@"经验+%@",self.fanweApp.appModel.login_send_score];
    _upgradeView.upgradeLabel.text = [NSString stringWithFormat:@"恭喜您升到%ld级！",(long)self.fanweApp.appModel.new_level];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber *haveLanch = [userDefaults objectForKey:@"haveLanch"];
    if ([haveLanch boolValue] == YES )
    {
        [[NSUserDefaults standardUserDefaults]setObject:@(NO) forKey:@"haveLanch"];
        //既是每日首次登录，等级又提升了（先弹出登录提示再弹出升级提示）
        if ([self isRewardAndUpgrade])
        {
            [self promptRewardView];;
        }
        else
        {
            //是否有每日首次登入经验奖励
            if ([self.fanweApp.appModel.first_login isEqualToString:@"1"] )
            {
                [self promptRewardView];
            }
            //是否升级了
            if (self.fanweApp.appModel.new_level > 0 && self.fanweApp.appModel.open_upgrade_prompt == 1)
            {
                [self promptUpgradeView];
            }
        }
    }
}

- (void)rewardAction
{
    [UIView animateWithDuration:0.3 animations:^{
        self.rewardView.frame = CGRectMake((kScreenW-300)/2, kScreenH, 300, 302);
        self.grayView.hidden = YES;
    }completion:^(BOOL finished){
        self.rewardView.hidden = YES;
    }];
    
    if ([self isRewardAndUpgrade])
    {
        self.isAppear = !self.isAppear;
        [self promptUpgradeView];
    }
}

- (void)upgradeAction
{
    [UIView animateWithDuration:0.3 animations:^{
        self.upgradeView.frame = CGRectMake((kScreenW-300)/2, kScreenH, 300, 302);
        self.grayView.hidden = YES;
    }completion:^(BOOL finished) {
        self.upgradeView.hidden = YES;
    }];
    
    if ([self isRewardAndUpgrade])
    {
        self.isAppear = !self.isAppear;
    }
}

#pragma mark   是否有每日升级提示，又有等级提升
- (BOOL)isRewardAndUpgrade
{
    //既是每日首次登录，等级又提升了
    if ([self.fanweApp.appModel.first_login isEqualToString:@"1"] && self.fanweApp.appModel.new_level > 0 && self.fanweApp.appModel.open_upgrade_prompt == 1)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

#pragma mark    每日首次登录动画
- (void)promptRewardView
{
    //放在视图最前面
    [kCurrentWindow bringSubviewToFront:_grayView];
    [kCurrentWindow bringSubviewToFront:_rewardView];
    [UIView animateWithDuration:0.3 animations:^{
        _rewardView.frame = CGRectMake((kScreenW-300)/2, (kScreenH-302)/2-64, 300, 302);
        _grayView.hidden = NO;
        _rewardView.hidden = NO;
    }];
}

#pragma mark    等级升级提示
- (void)promptUpgradeView
{
    //放在视图最前面
    [kCurrentWindow bringSubviewToFront:_grayView];
    [kCurrentWindow bringSubviewToFront:_upgradeView];
    [UIView animateWithDuration:0.3 animations:^{
        _upgradeView.frame = CGRectMake((kScreenW-300)/2, (kScreenH-302)/2-64, 300, 302);
        _grayView.hidden = NO;
        _upgradeView.hidden = NO;
    }];
}

#pragma mark  _grayView的点击事件
- (void)tapClick
{
    if ([self isRewardAndUpgrade])
    {
        _isAppear = !_isAppear;
    }
    
    if (_rewardView.hidden == NO)
    {
        [UIView animateWithDuration:0.2 animations:^{
            _rewardView.frame = CGRectMake((kScreenW-300)/2, kScreenH, 300, 302);
            _grayView.hidden = YES;
        }completion:^(BOOL finished) {
            _rewardView.hidden = YES;
        }];
    }
    
    if (_upgradeView.hidden == NO)
    {
        [UIView animateWithDuration:0.2 animations:^{
            _upgradeView.frame = CGRectMake((kScreenW-300)/2, kScreenH, 300, 302);
            _grayView.hidden = YES;
        }completion:^(BOOL finished) {
            _upgradeView.hidden = YES;
        }];
    }
    
    if ([self isRewardAndUpgrade] && _isAppear == YES)
    {
        [self promptUpgradeView];
    }
}


@end
