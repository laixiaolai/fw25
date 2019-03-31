//
//  STTableSaleBuyBtnCell.m
//  FanweApp
//
//  Created by 岳克奎 on 17/4/21.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "STTableSaleBuyBtnCell.h"

@implementation STTableSaleBuyBtnCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _leftBtn.layer.cornerRadius   = 3;
    _leftBtn.layer.masksToBounds  = YES;
    _rightBtn.layer.cornerRadius  = 3;
    _rightBtn.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}
- (IBAction)btnClick:(UIButton *)sender {
    if (_delegate &&[_delegate respondsToSelector:@selector(showSTTableSaleBuyBtnCell:andClickBtn:)]) {
        [_delegate showSTTableSaleBuyBtnCell:self andClickBtn:sender];
    }
}
-(void)setDelegate:(id<STTableSaleBuyBtnCellDelegate>)delegate{
    _delegate = delegate;
}
@end
