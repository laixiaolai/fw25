//
//  FourSectionTableViewCell.m
//  FanweApp
//
//  Created by fanwe2014 on 16/8/5.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "FourSectionTableViewCell.h"
#import "AcutionHistoryModel.h"

@implementation FourSectionTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    //
    //    self.lineView = [[UIView alloc]initWithFrame:CGRectMake(10, self.frame.size.height-1, kScreenW-10, 1)];
    //    self.lineView.backgroundColor = kGrayTransparentColor1;
    //    [self addSubview:self.lineView];
    
    self.headImgView.layer.cornerRadius = 12;
    self.headImgView.layer.masksToBounds = YES;
    
    self.stateLabel.frame = CGRectMake(0, 0, 37, 21);
    self.timeLabel.frame = CGRectMake(self.stateLabel.frame.size.width+3, 0, 97, 21);
    self.buttomLabel.frame = CGRectMake(kScreenW/2-137/2, 10,self.stateLabel.frame.size.width+self.stateLabel.frame.origin.x, 21);
    
    self.nameLabel.textColor = kAppGrayColor1;
    self.stateLabel.textColor = kAppGrayColor1;
    self.timeLabel.textColor = kAppGrayColor1;
    self.moneyLabel.textColor = kAppGrayColor1;
    self.lineView.backgroundColor = kAppSpaceColor4;
}

- (void)creatCellWithModel:(AcutionHistoryModel *)model withRow:(int)row
{
    if (model.user_name.length < 1)
    {
        model.user_name = @"aa88";
    }
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:model.head_image]];
    NSMutableString *strMobile = [NSMutableString stringWithString:model.user_name];
    [strMobile replaceCharactersInRange:NSMakeRange(1, model.user_name.length-2) withString:@"**"];
    self.nameLabel.text = strMobile;
    NSString *moneyStr = model.pai_diamonds;
    if ([moneyStr integerValue] > 10000)
    {
        moneyStr = [NSString stringWithFormat:@"%.3f万",[moneyStr floatValue]/10000];
    }else
    {
        if (!moneyStr.length)
        {
            moneyStr = @"";
        }
    }
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:moneyStr];
    [attr setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12.0]} range:NSMakeRange(0, moneyStr.length)];
    CGFloat width =[moneyStr sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}].width;
    self.rightViewConstraintW.constant = width+16;
    self.moneyLabel.attributedText = attr;
    self.timeLabel.text = model.pai_time_ymd;
    if (row == 0)
    {
        self.nameLabel.textColor = kAppGrayColor1;
        self.stateLabel.backgroundColor = kAppMainColor;
        self.stateLabel.text = @"领先";
        self.stateLabel.textColor = kWhiteColor;
        self.timeLabel.textColor = kAppGrayColor1;
        self.moneyLabel.textColor = kAppGrayColor1;
    }else
    {
        self.stateLabel.layer.borderWidth = 1;
        self.stateLabel.text = @"出局";
        self.stateLabel.layer.borderColor = kAppGrayColor1.CGColor;
    }
    
    if (row == 2)
    {
        self.lineView.hidden = YES;
    }
}

@end
