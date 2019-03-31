//
//  GameHistoryTableViewCell.m
//  FanweApp
//
//  Created by yy on 16/12/5.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "GameHistoryTableViewCell.h"

@implementation GameHistoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _imageViewArr = @[_leftImg,_midImg,_rightImg];
}

- (void)createCellWithArray:(NSNumber *)winNum withRow:(NSInteger)row
{
    if (row == 0) {
        _historyNewImg.hidden = NO;
    }
    else
    {
        _historyNewImg.hidden = YES;
    }
    if ([winNum integerValue] > 0) {
        for (UIImageView * imageView in _imageViewArr) {
            if ([imageView isEqual:_imageViewArr[[winNum integerValue]-1]]) {
                imageView.image = _gameID == 4 ? [UIImage imageNamed:@"com_radio_selected_2"] : [UIImage imageNamed:@"gm_history_s"];
            }
            else
            {
                imageView.image = _gameID == 4 ? [UIImage imageNamed:@"com_radio_normal_2"] : [UIImage imageNamed:@"gm_history_fu"];
            }
        }
    }
    
}

@end
