//
//  PlaceTableViewCell.h
//  FanweApp
//
//  Created by fanwe2014 on 16/10/19.
//  Copyright © 2016年 xfg. All rights reserved.

#import <UIKit/UIKit.h>

@class ListModel;

@interface PlaceTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *rightImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;
@property (weak, nonatomic) IBOutlet UIButton *addressButton;

- (void)creatCellWithModel:(ListModel *)model andRow:(int)row;

@end
