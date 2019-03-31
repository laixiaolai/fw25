//
//  ChargerTableViewCell.m
//  FanweApp
//
//  Created by fanwe2014 on 2016/11/24.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "ChargerTableViewCell.h"
#import "LiveDataModel.h"

@implementation ChargerTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.fanweApp =[GlobalVariables sharedInstance];
    self.headImgView.layer.cornerRadius = 25;
    self.headImgView.layer.masksToBounds = YES;
    
    self.lineView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.headImgView.frame)+10, self.frame.size.height-1, kScreenW-CGRectGetMaxX(self.headImgView.frame)-10, 1)];
    self.lineView.backgroundColor = kAppSpaceColor4;
    [self addSubview:self.lineView];
    
    self.timeLabel.textColor  = kAppGrayColor2;
    self.moneyLabel.textColor = kAppGrayColor2;
    self.lookLabel.textColor  = kAppGrayColor2;
    self.nameLabel.textColor  = kAppGrayColor1;
    
}

- (void)setCellWithDict:(LiveDataModel *)model andType:(int)type andLive_pay_type:(int)live_pay_type
{
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:model.head_image]];
    NSString *nameString;
    if (model.nick_name.length < 1)
    {
        nameString = @"暂时还未命名";
    }else
    {
        nameString = model.nick_name;
    }
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:nameString];
    [attr setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15.0]} range:NSMakeRange(0, nameString.length)];
    CGFloat width =[nameString sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}].width;
    if (width+5 > kScreenW-130)//名字控件需要控制长度
    {
        width = kScreenW - 135;
        self.nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    self.nameLabel.frame = CGRectMake(70, 11, width, 21);
    self.sexImgView.frame = CGRectMake(width+75, 14, 14, 14);
    self.rankImgView.frame = CGRectMake(width+94, 13, 28, 16);
    self.nameLabel.attributedText = attr;
    if ([model.sex isEqualToString:@"1"])
    {
        self.sexImgView.image = [UIImage imageNamed:@"com_male_selected"];
    }else if([model.sex isEqualToString:@"2"])
    {
        self.sexImgView.image = [UIImage imageNamed:@"com_female_selected"];
    }
    self.rankImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"rank_%@",model.user_level]];
    if (type == 0)
    {
        self.moneyLabel.text = [NSString stringWithFormat:@"消费%@:%@",self.fanweApp.appModel.diamond_name,model.total_diamonds];
    }else
    {
        self.moneyLabel.text = [NSString stringWithFormat:@"贡献%@:%@",self.fanweApp.appModel.diamond_name,model.total_diamonds];
    }
    
    self.lookLabel.text = [NSString stringWithFormat:@"开始观看时间:%@",model.start_time];
    
    if (live_pay_type == 1)
    {
        self.timeLabel.hidden = YES;
    }else
    {
        self.timeLabel.hidden = NO;
        self.timeLabel.text = [NSString stringWithFormat:@"观看时长:%@",model.total_time_format];
    }
    
}


@end
