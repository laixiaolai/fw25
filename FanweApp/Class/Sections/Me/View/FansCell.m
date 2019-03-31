//
//  FansCell.m
//  FanweApp
//
//  Created by 杨仁伟 on 2017/8/8.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "FansCell.h"

@implementation FansCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.fansHeadImg.layer.cornerRadius = 20;
    self.fansHeadImg.clipsToBounds = YES;
    self.fansGoOutBtn.layer.cornerRadius = 10;
    self.fansGoOutBtn.clipsToBounds = YES;
    self.fansPridisentLbl.layer.cornerRadius = 2;
    self.fansPridisentLbl.clipsToBounds = YES;
    self.fansNickNameLbl.textColor = kAppGrayColor1;
    [self.fansGoOutBtn setBackgroundColor:kAppMainColor];
    self.fansViewLiveBtn.layer.cornerRadius = 10;
    self.fansViewLiveBtn.clipsToBounds = YES;
}

- (void)configCellMsg:(SociatyDetailModel *)model memberType:(int)memberType
{
    [self.fansHeadImg sd_setImageWithURL:[NSURL URLWithString:model.user_image] placeholderImage:kDefaultPreloadHeadImg];
    self.fansGradeImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"rank_%@",model.user_lv]];
    self.fansNickNameLbl.text = model.user_name;
    self.fansSexImg.image = [model.user_sex intValue] == 1 ? [UIImage imageNamed:@"com_male_selected"] : [UIImage imageNamed:@"com_female_selected"];
    if (memberType == 1) {
        self.fansGoOutBtn.hidden = [model.user_position intValue] == 1 ? YES : NO;
    }
    else {
        self.fansGoOutBtn.hidden = YES;
    }
    if (model.user_position.intValue == 1)
    {
        self.goOutWidth.constant = 0;
        self.distanceWidth.constant = 0;
    }
    else
    {
        self.goOutWidth.constant = 55;
        self.distanceWidth.constant = 5;
    }
    self.fansPridisentLbl.hidden = model.user_position.intValue == 1 ? NO : YES;
    self.fansPridisentLblW.constant = model.user_position.intValue == 1 ? 30 : 0;
    self.fansDistanceW.constant = model.user_position.intValue == 1 ? 5 : 0;
    self.fansViewLiveBtn.hidden = model.live_in.intValue == 0 ? YES : NO;
}

- (IBAction)leavingSocietyClick:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(pleaseLeaveWithSocietyMember:)]) {
        [self.delegate pleaseLeaveWithSocietyMember:self];
    }
}
- (IBAction)viewLiveCLick:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(fansViewLiving:)]) {
        [self.delegate fansViewLiving:self];
    }
}

@end
