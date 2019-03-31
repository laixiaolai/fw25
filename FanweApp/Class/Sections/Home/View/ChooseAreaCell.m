//
//  ChooseAreaCell.m
//  FanweApp
//
//  Created by 丁凯 on 2017/6/2.
//  Copyright © 2017年 xfg. All rights reserved.

#import "ChooseAreaCell.h"

@implementation ChooseAreaCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.titlelabel.textColor = kAppGrayColor3;
    self.areaLabel.textColor = kAppGrayColor1;
    self.areaLabel.font = [UIFont boldSystemFontOfSize:15];
}

@end
