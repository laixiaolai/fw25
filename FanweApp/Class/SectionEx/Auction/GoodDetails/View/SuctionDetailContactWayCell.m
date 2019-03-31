//
//  SuctionDetailContactWayCell.m
//  FanweApp
//
//  Created by fanwe2014 on 16/8/10.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "SuctionDetailContactWayCell.h"

@implementation SuctionDetailContactWayCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.personTextFiled.textColor = self.phoneTextFiled.textColor =  self.nameLabel.textColor = self.contactPhoneLabel.textColor = self.contactPersonLabel.textColor = kAppGrayColor1;
    
    self.lineView1.backgroundColor =  self.lineView2.backgroundColor = self.lineView3.backgroundColor = kAppSpaceColor4;
}


@end
