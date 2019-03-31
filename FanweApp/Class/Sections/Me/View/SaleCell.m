//
//  SaleCell.m
//  FanweApp
//
//  Created by 岳克奎 on 16/8/10.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "SaleCell.h"

@implementation SaleCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
}
- (void)rorateSign:(UIButton *)sender{
    NSLog(@"%s",__func__);
    if ([self.delegate respondsToSelector:@selector(rorateSign:)]) {
        [self.delegate rorateSign:sender];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
