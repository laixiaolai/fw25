//
//  SetTableViewself.m
//  FanweApp
//
//  Created by GuoMs on 16/7/18.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "SetTableViewCell.h"

@implementation SetTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.setText.textColor = self.loginBack.textColor = kAppGrayColor1;
    self.memoryText.textColor = kAppGrayColor3;
    
}

- (void)configurationCellWithSection:(NSInteger)section row:(NSInteger)row distribution_module:(NSString *)distribution_module
{
    if (section == 3)
    {
        self.setText.hidden = YES;
        self.memoryText.hidden = YES;
        self.comeBackIMG.hidden = YES;
        self.loginBack.textColor = kAppGrayColor1;
        
    }
    else
    {
        self.loginBack.hidden = YES;
    }
    
    if (section == 0)
    {
        self.setText.text = @"帐号与安全";
    }
    else if (section == 1)
    {
        if ([distribution_module integerValue] == 1)
        {
            NSArray *text = @[@"黑名单",@"推送管理",@"推荐人ID"];
            self.setText.text = text[row];
        }
        else
        {
            NSArray *text = @[@"黑名单",@"推送管理"];
            self.setText.text = text[row];
        }
        
    }
    else if (section == 2)
    {
        if (row == 1)
        {
            self.memoryText.hidden = NO;
        }
        NSArray *text;
        if (kIsEqualCheckingVersion)
        {
            text = @[@"帮助与反馈",@"关于我们"];
            self.setText.text = text[row];
        }
        else
        {
            text = @[@"帮助与反馈",@"检查更新",@"关于我们"];
            self.setText.text = text[row];
            self.memoryText.text = VersionNum;
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
