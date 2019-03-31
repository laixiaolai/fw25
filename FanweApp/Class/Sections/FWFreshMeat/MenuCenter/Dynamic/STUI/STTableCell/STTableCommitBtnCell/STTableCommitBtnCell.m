//
//  STTableCommitBtnCell.m
//  FanweApp
//
//  Created by 岳克奎 on 17/4/18.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "STTableCommitBtnCell.h"

@implementation STTableCommitBtnCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.commitBtn.userInteractionEnabled = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
