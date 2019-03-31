//
//  AddressTableViewCell.m
//  FanweApp
//
//  Created by fanwe2014 on 16/8/10.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "AddressTableViewCell.h"

@implementation AddressTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.addressLabel.textColor = self.namePhoneLabel.textColor = kAppGrayColor1;
    
}

@end
