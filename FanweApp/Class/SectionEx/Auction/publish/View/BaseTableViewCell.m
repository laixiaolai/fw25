//
//  BaseTableViewCell.m
//  FanweApp
//
//  Created by GuoMs on 16/8/6.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "BaseTableViewCell.h"

@implementation BaseTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.text_field.borderStyle = UITextBorderStyleNone;
    self.nameL.textColor = kAppGrayColor1;
    self.text_field.textColor = kAppGrayColor2;
}


@end
