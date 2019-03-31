//
//  TianTuanCell.m
//  FanweApp
//
//  Created by 杨仁伟 on 2017/8/7.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "SociatyHomePageCell.h"

@implementation SociatyHomePageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.tianTuanImgH.constant = (kScreenW - betButtonInterval) / 2.0;
    self.underView.alpha = 0.2;
}

@end
