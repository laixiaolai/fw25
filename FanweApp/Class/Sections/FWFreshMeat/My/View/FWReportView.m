//
//  FWReportView.m
//  FanweApp
//
//  Created by fanwe2014 on 2017/3/20.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "FWReportView.h"

@implementation FWReportView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
//    self.backgroundColor = kBlackColor;
//    self.alpha = 0.5;
//    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
//    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
//    effectView.alpha = 0.25;
//    effectView.frame = CGRectMake(0, 0, kScreenW, kScreenH);
//    [self addSubview:effectView];
//    [self sendSubviewToBack:effectView];
    self.backgroundColor = [kBlackColor colorWithAlphaComponent:0.5];
    
    self.backImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    self.backImgView.image = [UIImage imageNamed:@"fw_report_effect"];
    [self addSubview:self.backImgView];
    [self sendSubviewToBack:self.backImgView];
    
    self.backView.backgroundColor = kWhiteColor;
    self.backView.layer.cornerRadius = 3;
    self.lineView.backgroundColor = kAppSpaceColor2;
    self.titleLabel.textColor = kAppGrayColor1;
    self.commentLabel.textColor = kAppGrayColor1;
    [self.comfirmBtn setTitleColor:kAppGrayColor1 forState:UIControlStateNormal];
    
}

- (IBAction)btnClick:(UIButton *)sender
{
    if (_RDeleGate && [_RDeleGate respondsToSelector:@selector(reportComeBack)])
    {
        [_RDeleGate reportComeBack];
    }
}

@end
