//
//  PlaceTableViewCell.m
//  FanweApp
//
//  Created by fanwe2014 on 16/10/19.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "PlaceTableViewCell.h"
#import "ListModel.h"

@implementation PlaceTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.addressButton.layer.borderWidth = 1;
    self.addressButton.layer.cornerRadius = 5;
    self.addressButton.layer.borderColor = kAppGrayColor3.CGColor;
    [self.addressButton setTitleColor:kAppGrayColor3 forState:UIControlStateNormal];
    self.nameLabel.textColor = kAppGrayColor1;
    self.placeLabel.textColor = kAppGrayColor1;
}

- (void)creatCellWithModel:(ListModel *)model andRow:(int)row
{
    self.addressButton.tag = row;
    self.nameLabel.text = [NSString stringWithFormat:@"%@ %@",model.consignee,model.consignee_mobile];
    self.placeLabel.text = [NSString stringWithFormat:@"%@%@%@%@",model.consignee_district.province,model.consignee_district.city,model.consignee_district.area,model.consignee_address];
}


@end
