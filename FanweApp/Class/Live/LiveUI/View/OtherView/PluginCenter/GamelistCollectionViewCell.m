//
//  GamelistCollectionViewCell.m
//  FanweApp
//
//  Created by yy on 16/11/25.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "GamelistCollectionViewCell.h"

@implementation GamelistCollectionViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.gamePlaying_L.backgroundColor = [kAppGrayColor1 colorWithAlphaComponent:0.6];
    self.gameName.textColor = kWhiteColor;
}

- (void)creatCellWithModel:(GameModel *)model withRow:(int)row
{
    self.rowCount = row;
    //游戏封面
    if (model.image.length != 0)
    {
        [self.gameImg sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:kDefaultPreloadImgSquare];
    }
    
    self.gameName.text = model.name;
}

@end
