//
//  TimeTableViewCell.m
//  FanweApp
//
//  Created by GuoMs on 16/8/5.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "TimeTableViewCell.h"

@implementation TimeTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.textField.borderStyle = UITextBorderStyleNone;
    self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.textField.clearsOnBeginEditing = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
