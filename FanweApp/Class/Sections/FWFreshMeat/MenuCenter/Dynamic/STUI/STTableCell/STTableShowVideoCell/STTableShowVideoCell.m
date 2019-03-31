//
//  STTableShowVideoCell.m
//  FanweApp
//
//  Created by 岳克奎 on 17/4/19.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "STTableShowVideoCell.h"

@implementation STTableShowVideoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)changeVideoClick:(UIButton *)sender {
    if (_delegate &&[_delegate respondsToSelector:@selector(showSystemIPC:andMaxSelectNum:)]) {
        [_delegate showSystemIPC:YES andMaxSelectNum:1];
    }
}

- (IBAction)changeVideoCoverClick:(UIButton *)sender {
    if(_delegate &&[_delegate respondsToSelector:@selector(showSTTableShowVideoCell:andChangeVideoCoverClick:)]){
        [_delegate showSTTableShowVideoCell:self
                   andChangeVideoCoverClick:sender];
    }
}

-(void)setDelegate:(id<STTableShowVideoCellDelegate>)delegate{
    _delegate = delegate;
}
@end
