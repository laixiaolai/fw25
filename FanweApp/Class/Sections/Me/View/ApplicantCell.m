//
//  ApplicantCell.m
//  FanweApp
//
//  Created by 杨仁伟 on 2017/8/8.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "ApplicantCell.h"

@implementation ApplicantCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.applicantHeadImg.layer.cornerRadius = 20;
    self.applicantHeadImg.clipsToBounds = YES;
    self.applicantLivingBtn.layer.cornerRadius = 10;
    self.applicantLivingBtn.clipsToBounds = YES;
    self.applicantRefuseBtn.layer.cornerRadius = 10;
    self.applicantRefuseBtn.clipsToBounds = YES;
    self.applicantAgreeBtn.layer.cornerRadius = 10;
    self.applicantAgreeBtn.clipsToBounds = YES;
    self.applicantAgreeBtn.backgroundColor = kAppMainColor;
    self.applicantNickNameLbl.textColor = kAppGrayColor1;
}

- (void)configCellMsg:(SociatyDetailModel *)model
{
    self.applicantLivingBtn.hidden = model.live_in.intValue == 1 ? NO : YES;
    self.applicantLivingLbl.hidden = model.live_in.intValue == 1 ? NO : YES;
    [self.applicantHeadImg sd_setImageWithURL:[NSURL URLWithString:model.user_image] placeholderImage:kDefaultPreloadHeadImg];
    self.applicantGradeImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"rank_%@",model.user_lv]];
    self.applicantNickNameLbl.text = model.user_name;
    self.applicantSexImg.image = [model.user_sex intValue] == 1 ? [UIImage imageNamed:@"com_male_selected"] : [UIImage imageNamed:@"com_female_selected"];
}

- (IBAction)agreeClick:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(agreeOfSociety:)]) {
        [self.delegate agreeOfSociety:self];
    }
}

- (IBAction)refuseClick:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(refuseOfSociety:)]) {
        [self.delegate refuseOfSociety:self];
    }
}

- (IBAction)viewLiving:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(viewLiving:)]) {
        [self.delegate viewLiving:self];
    }
}

@end
