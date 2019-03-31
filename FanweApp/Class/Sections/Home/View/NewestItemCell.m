//
//  NewestItemCell.m
//  FanweApp
//
//  Created by 丁凯 on 2017/8/8.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "NewestItemCell.h"
#import "LivingModel.h"

@implementation NewestItemCell

- (void)setCellContent:(LivingModel *)LModel
{
    self.backgroundColor = kBackGroundColor;
    
    self.placeLabel.textColor = kAppGrayColor1;
    self.personLabel.layer.cornerRadius  = 15/2.0f;
    self.personLabel.layer.masksToBounds = YES;
    self.personLabel.layer.borderWidth = 1;
    self.personLabel.layer.borderColor = kWhiteColor.CGColor;
    self.personLabel.backgroundColor     = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    
    self.paidLabel.layer.cornerRadius    = 15/2.0f;
    self.paidLabel.layer.masksToBounds   = YES;
    self.paidLabel.layer.borderWidth = 1;
    self.paidLabel.layer.borderColor = kWhiteColor.CGColor;
    self.paidLabel.backgroundColor       = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:LModel.live_image] placeholderImage:kDefaultPreloadHeadImg];
    self.rankImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"rank_%@",LModel.user_level]];
    if (LModel.distance/1000 > 100)
    {
        if (LModel.city.length > 0)
        {
            self.placeLabel.text = [NSString stringWithFormat:@"  %@",LModel.city];
        }else
        {
            self.placeLabel.text = @" 火星";
        }
    }else if (LModel.distance/1000 > 1 && LModel.distance/1000 < 100)
    {
        self.placeLabel.text = [NSString stringWithFormat:@"  %.1fkm",LModel.distance/1000.0];
    }else if (LModel.distance < 1000 && LModel.distance > 100)
    {
        self.placeLabel.text = [NSString stringWithFormat:@"  %.0fm",LModel.distance];
    }
    else
    {
        self.placeLabel.text = @" 100m";
    }
    [self setupPersonAndPaid:LModel personLabel:self.personLabel paidLabel:self.paidLabel];

}

//设置“新人”和“付费”
- (void)setupPersonAndPaid:(LivingModel *)model personLabel:(UILabel *)personLabel paidLabel:(UILabel *)paidLabel
{
    if ([model.today_create isEqualToString:@"1"] && [model.is_live_pay isEqualToString:@"1"])
    {
        personLabel.hidden = NO;
        paidLabel.hidden = NO;
        personLabel.text = @"新人";
        paidLabel.text = @"付费";
        self.paidLabelSpaceTopH.constant = 25;
    }
    else if ([model.today_create isEqualToString:@"1"] && [model.is_live_pay isEqualToString:@"0"])
    {
        personLabel.hidden = NO;
        paidLabel.hidden = YES;
        personLabel.text = @"新人";
    }
    else if ([model.today_create isEqualToString:@"0"] && [model.is_live_pay isEqualToString:@"1"])
    {
        personLabel.hidden = NO;
        paidLabel.hidden = YES;
        personLabel.text = @"付费";
        self.paidLabelSpaceTopH.constant = 5;
    }
    else
    {
        personLabel.hidden = YES;
        paidLabel.hidden = YES;
    }
    
}

@end
