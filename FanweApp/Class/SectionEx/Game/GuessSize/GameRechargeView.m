//
//  GameRechargeView.m
//  FanweApp
//
//  Created by 方维 on 2017/5/27.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "GameRechargeView.h"

@implementation GameRechargeView
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backGroundView.backgroundColor = kGrayTransparentColor4_1;
    self.backGroundView.layer.cornerRadius = 13;
    self.backGroundView.layer.masksToBounds = YES;
    if ([GlobalVariables sharedInstance].appModel.open_diamond_game_module == 1)
    {
        self.diamondsImageView.image = [UIImage imageNamed:@"com_diamond_1"];
    }
    else
    {
        self.diamondsImageView.image = [UIImage imageNamed:@"gm_coin"];
    }
}

@end
