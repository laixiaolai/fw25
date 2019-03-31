//
//  RechargeWayCell.m
//  FanweApp
//
//  Created by 王珂 on 17/5/10.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "RechargeWayCell.h"

@implementation RechargeWayCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.payWayLabel.edgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
//    self.payWayLabel.textColor = kAppGrayColor1;
//    self.payWayLabel.layer.cornerRadius = 5;
//    self.payWayLabel.layer.masksToBounds = YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCell)];
    [self addGestureRecognizer:tap];
}

- (void)setModel:(PayTypeModel *)model
{
    self.payWayLabel.backgroundColor = model.isSelect == YES ? kAppGrayColor1 : kWhiteColor;
    self.payWayLabel.textColor = model.isSelect == YES ? kWhiteColor :kAppGrayColor1;
    self.payWayLabel.text = model.name;
}

- (void)clickCell
{
    if (_delegate && [_delegate respondsToSelector:@selector(clickWithRechargeWayCell:)]) {
        [_delegate clickWithRechargeWayCell:self];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.payWayLabel.layer.cornerRadius = CGRectGetHeight(self.payWayLabel.frame)/2;
    self.payWayLabel.layer.masksToBounds = YES;
    self.payWayLabel.layer.borderWidth = 1;
    self.payWayLabel.layer.borderColor = kAppGrayColor1.CGColor;
}

@end
