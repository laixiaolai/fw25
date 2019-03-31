//
//  VideoCollectionViewCell.m
//  FanweApp
//
//  Created by 王珂 on 17/5/2.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "VideoCollectionViewCell.h"

@implementation VideoCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backView.backgroundColor = kGrayTransparentColor2;
    //self.backView.backgroundColor = [UIColor clearColor];
    self.placeLabel.textColor = [UIColor whiteColor];
    self.videoImageView.contentMode =  UIViewContentModeScaleAspectFill;
    self.videoImageView.clipsToBounds = YES;
}

-(void)setModel:(HMHotItemModel *)model
{
    _model = model;
    [self.videoImageView sd_setImageWithURL:[NSURL URLWithString:model.live_image] placeholderImage:[UIImage imageNamed:@"DefaultImg"]];
    self.placeLabel.text = model.city;
}
@end
