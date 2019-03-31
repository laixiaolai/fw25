//
//  DisplayTableViewCell.m
//  FanweApp
//
//  Created by yy on 16/7/20.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "DisplayTableViewCell.h"

@implementation DisplayTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.lineView.backgroundColor = kBackGroundColor;
    self.topLabel.textColor = kAppGrayColor1;
    self.bottomLabel.textColor = kAppGrayColor3;
    self.rightLabel.textColor = kAppMainColor;
    self.rightLabel.layer.cornerRadius = 15;
    self.rightLabel.layer.borderColor = [kAppMainColor CGColor];
    self.rightLabel.layer.masksToBounds = YES;
    self.rightLabel.layer.borderWidth = 1;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
