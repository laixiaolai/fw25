//
//  CdescriptTableViewCell.m
//  FanweApp
//
//  Created by GuoMs on 16/8/8.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "CdescriptTableViewCell.h"

@implementation CdescriptTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.desTextView.backgroundColor = kAppSpaceColor3;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
