//
//  GameGiftCell.m
//  FanweApp
//
//  Created by 王珂 on 17/4/28.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "GameGiftCell.h"

@implementation GameGiftCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectedImageView.hidden = YES;
    self.diamondLabel.textColor = kAppGrayColor1;
    self.layer.cornerRadius = 3;
    self.layer.masksToBounds = YES;
//    self.giftImageView.contentMode = UIViewContentModeScaleAspectFill;
//    self.giftImageView.clipsToBounds = YES;
}

-(void)setModel:(GiftModel *)model
{
    _model = model;
    self.layer.borderWidth = 1.0;
    if (!model.isSelected) {
        self.layer.borderColor = kAppSpaceColor.CGColor;
    }
    else
    {
         self.layer.borderColor = kAppGrayColor1.CGColor;
    }
    self.selectedImageView.hidden = !model.isSelected;
    [self.giftImageView sd_setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:kDefaultPreloadImgSquare];
    self.diamondLabel.text = [NSString stringWithFormat:@"%ld",(long)model.diamonds];
}

@end
