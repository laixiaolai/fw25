//
//  STTableMsgCell.m
//  FanweApp
//
//  Created by 岳克奎 on 17/4/23.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "STTableMsgCell.h"

@implementation STTableMsgCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
          self.headerImgView.layer.cornerRadius =  self.headerImgView.frame.size.width/2.0f;
    self.headerImgView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
