//
//  GameResultView.m
//  FanweApp
//
//  Created by 方维 on 2017/6/7.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "GameResultView.h"

@implementation GameResultView
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.resultNumberView.backgroundColor = kGrayTransparentColor2;
    self.resultNumberLabel.textColor = kColorWithStr(@"ffe179");
    self.winTitleLabel.textColor = kColorWithStr(@"8f5928");
    self.winNameLabel.textColor = kColorWithStr(@"8f5928");
    self.winNumberLabel.textColor = kColorWithStr(@"f5342e");
}


@end
