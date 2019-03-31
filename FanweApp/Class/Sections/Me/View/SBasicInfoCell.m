//
//  SBasicInfoCell.m
//  FanweApp
//
//  Created by 丁凯 on 2017/8/7.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "SBasicInfoCell.h"

@implementation SBasicInfoCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.myNameLabel.textColor = self.mySexLabel.textColor = kAppGrayColor2;
}



@end
