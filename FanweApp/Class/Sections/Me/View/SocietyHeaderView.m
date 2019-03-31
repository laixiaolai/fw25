//
//  TianTuanHeaderView.m
//  FanweApp
//
//  Created by 杨仁伟 on 2017/8/8.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "SocietyHeaderView.h"

@implementation SocietyHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.societyBgBtn.layer.cornerRadius = 35;
    self.societyBgBtn.clipsToBounds = YES;
    if (isIPhoneX())
    {
        self.headTopH.constant = 45;
        self.headBottomH.constant = 17;
    }
    else
    {
        self.headTopH.constant = 36;
        self.headBottomH.constant = 26;
    }
}

- (IBAction)goBackClick:(id)sender
{
    [[FWBaseAppDelegate sharedAppDelegate] popViewController];
}

@end
