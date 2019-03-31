//
//  UpgradeTipView.h
//  FanweApp
//
//  Created by xfg on 2017/7/15.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "FWBaseView.h"
#import "LoginRewardView.h"
#import "UpgradeView.h"

@interface UpgradeTipView : FWBaseView

@property (nonatomic, strong) LoginRewardView               *rewardView;        //首次登录view
@property (nonatomic, strong) UpgradeView                  *upgradeView;       //升到10级view
@property (nonatomic, strong) UIView                      *grayView;          //灰色背景
@property (nonatomic, assign) BOOL                        isAppear;           //每日登录提示是否出现

- (void)initRewards;

@end
