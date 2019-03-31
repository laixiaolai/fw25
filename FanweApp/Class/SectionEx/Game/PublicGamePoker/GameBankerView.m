//
//  GameBankerView.m
//  FanweApp
//
//  Created by 王珂 on 17/2/23.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "GameBankerView.h"

@implementation GameBankerView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.bankerImageView.layer.cornerRadius = 20;
    self.bankerImageView.layer.masksToBounds = YES;
    self.backgroundColor = kGrayTransparentColor3;
    self.layer.cornerRadius = 25;
    self.layer.masksToBounds = YES;
}

@end
