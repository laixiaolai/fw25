//
//  FiveSectionTableViewCell.m
//  FanweApp
//
//  Created by fanwe2014 on 16/8/5.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "FiveSectionTableViewCell.h"

@implementation FiveSectionTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.depositButton.backgroundColor = kAppMainColor;
    [self.depositButton setTitleColor:[UIColor whiteColor] forState:0];
    self.depositButton.layer.cornerRadius = 15;
    
    self.continueButton.backgroundColor = kAppMainColor;
    [self.continueButton setTitleColor:[UIColor whiteColor] forState:0];
    self.continueButton.layer.cornerRadius = 35/2;
    
    self.auctionLabel.textColor = kAppGrayColor1;
    self.auctionMoneyLabel.textColor = kAppGrayColor1;
    
}
- (IBAction)buttonClick:(UIButton *)sender
{
    if (self.delegate)
    {
        if ([self.delegate respondsToSelector:@selector(buttonClickWithTag:)])
        {
            [self.delegate buttonClickWithTag:(int)sender.tag];
        }
    }
}


@end
