//
//  DistributionCell.m
//  FanweApp
//
//  Created by fanwe2014 on 2016/12/27.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "DistributionCell.h"
#import "LiveDataModel.h"

@implementation DistributionCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    _fanweApp = [GlobalVariables sharedInstance];
    self.headImgView.layer.cornerRadius = 20;
    self.headImgView.layer.masksToBounds = YES;
    
    self.nameLabel.textColor = kAppGrayColor1;
    self.ticketLabel.textColor = kAppGrayColor1;
    
    self.lineView.backgroundColor = kAppSpaceColor4;
  
    
}

- (void)setCellWithModel:(LiveDataModel *)model
{
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:model.head_image]];
    NSString *nameString;
    if (model.user_name.length < 1)
    {
        nameString = @"暂时还未命名";
    }else
    {
       nameString = model.user_name;
    }
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:nameString];
    self.nameLabel.attributedText = attr;
    
    if (model.diamonds > 10000)
    {
        self.ticketLabel.text = [NSString stringWithFormat:@"%.2f万%@",model.diamonds,_fanweApp.appModel.diamond_name];
    }else
    {
        self.ticketLabel.text = [NSString stringWithFormat:@"%.2f%@",model.diamonds ,_fanweApp.appModel.diamond_name];
    }
    
}



@end
