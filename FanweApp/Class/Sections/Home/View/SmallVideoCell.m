//
//  SmallVideoCell.m
//  FanweApp
//
//  Created by 丁凯 on 2017/8/17.
//  Copyright © 2017年 xfg. All rights reserved.

#import "SmallVideoCell.h"
#import "SmallVideoListModel.h"

@implementation SmallVideoCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.smallImgView.layer.cornerRadius  = 25*kScaleWidth/2;
    self.bottomView.layer.cornerRadius    = self.bottomView.height/2;
    self.smallImgView.layer.masksToBounds = YES;
    self.bottomView.layer.masksToBounds   = YES;
    self.bottomView.backgroundColor       = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    self.bigImgView.contentMode           = UIViewContentModeScaleAspectFit;
    self.smallImgView.contentMode         = UIViewContentModeScaleAspectFit;
    
}

- (void)creatCellWithModel:(SmallVideoListModel *)model andRow:(int)row
{
    [self.bigImgView sd_setImageWithURL:[NSURL URLWithString:model.photo_image] placeholderImage:kDefaultPreloadImgSquare];
    [self.smallImgView sd_setImageWithURL:[NSURL URLWithString:model.head_image] placeholderImage:kDefaultPreloadHeadImg];
    self.nameLabel.text = model.nick_name;
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:model.video_count];
    [attr setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:11.0]} range:NSMakeRange(0, model.video_count.length)];
    CGFloat width =[model.video_count sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]}].width;
    self.bottomViewConstraintW.constant = width+38;
    self.numLbale.attributedText = attr;
}

@end
