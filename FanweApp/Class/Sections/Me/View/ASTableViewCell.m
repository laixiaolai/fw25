//
//  ASTableViewCell.m
//  FanweApp
//
//  Created by GuoMs on 16/7/18.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "ASTableViewCell.h"

@implementation ASTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.leftNameLabel.textColor = kAppGrayColor1;
    self.phoneNumber.textColor   = kAppGrayColor3;
    
    
    
}


@end
