//
//  InComeDataCell.m
//  FanweApp
//
//  Created by 岳克奎 on 16/8/11.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "InComeDataCell.h"

@implementation InComeDataCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.auctionManagement_Btn.layer.borderColor = kAppMainColor.CGColor;
    [self.auctionManagement_Btn setTitleColor:kAppMainColor
                                     forState:UIControlStateNormal];
    self.auctionManagement_Btn.layer.borderWidth = 1.0f;
    self.auctionManagement_Btn.layer.cornerRadius = self.auctionManagement_Btn.frame.size.height/2.0f;
    self.auctionManagement_Btn.layer.masksToBounds = YES;
    //
    self.contentView.backgroundColor = kBackGroundColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
