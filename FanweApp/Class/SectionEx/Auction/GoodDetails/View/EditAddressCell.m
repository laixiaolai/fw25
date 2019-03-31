//
//  EditAddressCell.m
//  FanweApp
//
//  Created by fanwe2014 on 16/10/19.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "EditAddressCell.h"

@implementation EditAddressCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.lineView1.backgroundColor = self.lineView4.backgroundColor = self.lineView2.backgroundColor = self.lineView3.backgroundColor = self.lineView5.backgroundColor =kAppSpaceColor;
    
    self.personLabel.textColor =self.personFiled.textColor =  self.phoneLabel.textColor = self.phoneFiled.textColor =self.cityLabel.textColor =self.cityFiled.textColor = self.smallAddressLabel.textColor = self.smallAddressFiled.textColor =self.defaultLabel.textColor =self.defaultFiled.textColor = self.locationLabel.textColor =kAppGrayColor1;
    
    self.myWitch.on = NO;
    self.myWitch.userInteractionEnabled = NO;
}

- (IBAction)AddressButtonClick:(UIButton *)sender
{
    if (self.delegate)
    {
        if ([self.delegate respondsToSelector:@selector(pushToMapController)])
        {
            [self.delegate pushToMapController];
        }
    }
}



@end
