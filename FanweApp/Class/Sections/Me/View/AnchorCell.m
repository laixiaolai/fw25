//
//  AnchorCell.m
//  FanweApp
//
//  Created by 杨仁伟 on 2017/8/7.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "AnchorCell.h"

@implementation AnchorCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.anchorNameLbl.textColor = kAppGrayColor1;
    self.livingLbl.layer.cornerRadius = 8.5;
    self.livingLbl.clipsToBounds = YES;
    self.livingLbl.layer.borderWidth = 1;
    self.livingLbl.backgroundColor = RGBA(141, 153, 166, 0.5);
    self.livingLbl.layer.borderColor = [kWhiteColor colorWithAlphaComponent:0.8].CGColor;
    self.livingLbl.textColor = [kWhiteColor colorWithAlphaComponent:0.85];
    self.anchorImgH.constant = (kScreenW - kAppMargin2 * 4) / 3.0;
    self.predisentLbl.layer.cornerRadius = 8.5;
    self.predisentLbl.clipsToBounds = YES;
    self.predisentLbl.layer.borderWidth = 1;
    self.predisentLbl.layer.borderColor = [kWhiteColor colorWithAlphaComponent:0.8].CGColor;
    self.predisentLbl.textColor = [kWhiteColor colorWithAlphaComponent:0.85];
    self.predisentLbl.backgroundColor = RGBA(141, 153, 166, 0.5);
}

- (void)configCellMsg:(SociatyDetailModel *)model {
    
    [self.anchorImg sd_setImageWithURL:[NSURL URLWithString:model.user_image] placeholderImage:kDefaultPreloadHeadImg];
    self.gradeImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"rank_%@",model.user_lv]];
    self.anchorNameLbl.text = model.user_name;
    
    if (model.user_position.intValue == 1)
    {
        self.livingLbl.text = @"会长";
        self.livingLbl.hidden = NO;
        self.predisentLbl.hidden = model.live_in.intValue == 0 ? YES : NO;
    }
    else
    {
        self.livingLbl.text = @"直播中";
        self.livingLbl.hidden = model.live_in.intValue == 0 ? YES : NO;
        self.predisentLbl.hidden = YES;
    }
    
    if ([model.user_sex intValue] == 1)
    {
        self.sexImg.image = [UIImage imageNamed:@"com_male_selected"];
    }
    else if ([model.user_sex intValue] == 2)
    {
        self.sexImg.image = [UIImage imageNamed:@"com_female_selected"];
    }
}

@end
