//
//  RechargeDesCell.m
//  FanweApp
//
//  Created by 王珂 on 17/3/13.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "RechargeDesCell.h"
@interface RechargeDesCell()

@end
@implementation RechargeDesCell
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _rechargeView = [[UIView alloc] init];
        [self.contentView addSubview:_rechargeView];
        _numberLabel = [[UILabel alloc] init];
        _numberLabel.font = kAppMiddleTextFont;
        _numberLabel.textColor = kAppGrayColor1;
        [_rechargeView addSubview:_numberLabel];
        _diamondImageView = [[UIImageView alloc] init];
        _diamondImageView.image = [UIImage imageNamed:@"com_diamond_1"];
        _diamondImageView.contentMode = UIViewContentModeScaleAspectFit;
        [_rechargeView addSubview:_diamondImageView];
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, self.width, 15)];
        _priceLabel.font = kAppSmallTextFont;
        _priceLabel.textColor = kAppGrayColor3;
        _priceLabel.text = @"售价:0.01";
        _priceLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_priceLabel];
        _gameCoinLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 45,self.width , 15)];
        _gameCoinLabel.font = kAppSmallTextFont;
        _gameCoinLabel.textColor = kAppGrayColor3;
        _gameCoinLabel.textAlignment = NSTextAlignmentCenter;
        _gameCoinLabel.text = @"赠送10000游戏币";
        [self.contentView addSubview:_gameCoinLabel];
        _otherPayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (self.height-15)/2, self.width, 15)];
        _otherPayLabel.textAlignment = NSTextAlignmentCenter;
        _otherPayLabel.text = @"输入其它金额";
        _otherPayLabel.font = kAppMiddleTextFont;
        _otherPayLabel.textColor = kAppGrayColor3;
        _otherPayLabel.hidden = YES;
        [self.contentView addSubview:_otherPayLabel];
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.contentView.layer.cornerRadius = 5;
        self.contentView.layer.masksToBounds = YES;
        self.contentView.layer.borderColor = kAppGrayColor1.CGColor;
        self.contentView.layer.borderWidth = 1.0;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCell)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)setModel:(PayMoneyModel *)model
{
    _model = model;
    for (UIView *view in self.contentView.subviews) {
        view.hidden = YES;
    }
    if (model.hasOtherPay) {
        _otherPayLabel.hidden = NO;
    }
    else
    {
        NSString * str = [NSString stringWithFormat:@"%zd",self.model.diamonds];
        CGSize priceSize = [str boundingRectWithSize:CGSizeMake(MAXFLOAT, self.width) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kAppMiddleTextFont}  context:nil].size;
        CGFloat length = priceSize.width+17;
        _rechargeView.hidden = NO;
        _numberLabel.hidden = NO;
        _diamondImageView.hidden = NO;
        if (model.gift_coins_des.length>0) {
            _rechargeView.frame = CGRectMake((self.width-length)/2, 5, length, 15);
            _priceLabel.frame = CGRectMake(0, 25, self.width, 15);
            _gameCoinLabel.frame = CGRectMake(0, 45, self.width, 15);
            _priceLabel.hidden = NO;
            _gameCoinLabel.text = [NSString stringWithFormat:@"%@",model.gift_coins_des];
            _gameCoinLabel.hidden = NO;
        }
        else
        {
            _rechargeView.frame = CGRectMake((self.width-length)/2, 15, length, 15);
            _priceLabel.frame = CGRectMake(0, 35, self.width, 15);
            _priceLabel.hidden = NO;
        }
        _numberLabel.frame = CGRectMake(0, 0, priceSize.width, 15);
        _diamondImageView.frame = CGRectMake(CGRectGetMaxX(_numberLabel.frame)+2,0, 15, 15);
        _numberLabel.text = str;
        _priceLabel.text = [NSString stringWithFormat:@"售价:%@",model.money_name];
    }
}

- (void)clickCell
{
    if (_delegate && [_delegate respondsToSelector:@selector(clickWithRechargeDesCell:)])
    {
        [_delegate clickWithRechargeDesCell:self];
    }
}

@end
