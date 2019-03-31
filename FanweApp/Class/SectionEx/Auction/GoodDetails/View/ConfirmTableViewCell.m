//
//  ConfirmTableViewCell.m
//  FanweApp
//
//  Created by fanwe2014 on 16/8/12.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "ConfirmTableViewCell.h"

@implementation ConfirmTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.protocolLabel.textColor          = kAppGrayColor1;
    [self.protocolButton setTitleColor:kAppGrayColor3 forState:0];
    self.comfirmButton.layer.cornerRadius = self.comfirmButton.frame.size.height/2;
    self.comfirmButton.backgroundColor    = kAppMainColor;
    [self.comfirmButton setTitleColor:kWhiteColor forState:0];
    self.lineView.backgroundColor         = kAppSpaceColor4;
}



@end
