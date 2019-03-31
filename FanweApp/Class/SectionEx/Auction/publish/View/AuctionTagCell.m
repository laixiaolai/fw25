//
//  AuctionTagCell.m
//  FanweApp
//
//  Created by 方维 on 2017/9/26.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "AuctionTagCell.h"
#import "TagsModel.h"
@implementation AuctionTagCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.layer.borderWidth = 0.5;
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.cornerRadius = 5.0;
    self.contentView.layer.borderColor = [kAppGrayColor4 CGColor];
    self.titleLabel.textColor = kAppGrayColor3;
}

- (void)setModel:(TagsModel *)model
{
    _model = model;
    if (model.isSelected)
    {
        self.contentView.backgroundColor = kAppMainColor;
        self.contentView.layer.borderColor = kAppMainColor.CGColor;
        self.titleLabel.textColor = kWhiteColor;
    }
    else
    {
        self.contentView.backgroundColor = kWhiteColor;
        self.contentView.layer.borderColor = [kAppGrayColor4 CGColor];
        self.titleLabel.textColor = kAppGrayColor3;
    }
    self.titleLabel.text = model.name;
}

@end
