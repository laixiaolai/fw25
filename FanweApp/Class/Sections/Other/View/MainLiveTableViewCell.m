//
//  MainLiveTableViewCell.m
//  FanweApp
//
//  Created by fanwe2014 on 16/6/15.
//  Copyright © 2016年 xfg. All rights reserved.

#import "MainLiveTableViewCell.h"
#import "SenderModel.h"

@implementation MainLiveTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = kWhiteColor;
    self.titleLabel.textColor =  self.watchLabel.textColor =kAppGrayColor1;
    self.timelabel.textColor  = kAppGrayColor3;
    self.lineView.backgroundColor = kAppSpaceColor4;
}

- (void)creatCellWithModel:(SenderModel *)model
{
    self.titleLabel.text = model.title;
    self.timelabel.text = model.begin_time_format;
    NSString *numString;
    if (model.watch_number_format.length < 1)
    {
        numString = @"0";
    }else
    {
        numString = model.watch_number_format;
    }
    self.watchLabel.text = numString;
}

@end
