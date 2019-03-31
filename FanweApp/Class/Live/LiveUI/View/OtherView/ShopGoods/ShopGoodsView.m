//
//  ShopGoodsView.m
//  FanweApp
//
//  Created by 王珂 on 16/10/31.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "ShopGoodsView.h"

@interface ShopGoodsView()

@property (nonatomic, strong) UIImageView   * goodsImage;//商品图片
@property (nonatomic, strong) UIImageView   * arrowImage;//箭头
@property (nonatomic, strong) UIImageView   * diamondsView; //钻石图片
@property (nonatomic, strong) UILabel       * titleLabel; //商品名称
@property (nonatomic, strong) UILabel       * priceLabel; //价格
@property (nonatomic, strong) UIButton      * goodsBtn;//按钮
@property (nonatomic, strong) UIButton      * sendAnchorBtn;//送给主播
@property (nonatomic, strong) UIButton      * giveSelfBtn;//买给自己

@end


@implementation ShopGoodsView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _goodsImage = [[UIImageView alloc] init];
        _goodsImage.contentMode = UIViewContentModeScaleAspectFill;
        _goodsImage.clipsToBounds = YES;
        [self addSubview:_goodsImage];
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = kAppMiddleTextFont;
        _titleLabel.textColor = kAppGrayColor1;
        _titleLabel.numberOfLines = 0;
        [self addSubview:_titleLabel];
        _diamondsView = [[UIImageView alloc] init];
        _diamondsView.image = [UIImage imageNamed:@"com_diamond_1"];
        [self addSubview:_diamondsView];
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.font = kAppSmallTextFont;
        _priceLabel.textColor = kAppGrayColor1;
        [self addSubview:_priceLabel];
        _sendAnchorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendAnchorBtn.backgroundColor = [UIColor flatYellowColor];
        _sendAnchorBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:_sendAnchorBtn];
        _giveSelfBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _giveSelfBtn.backgroundColor = kAppMainColor;
        _giveSelfBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:_giveSelfBtn];
        _goodsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_goodsBtn addTarget:self action:@selector(clickGoodsBtn) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_goodsBtn];
    }
    return self;
}

- (void)setModel:(GoodsModel *)model
{
    _model = model;
    _goodsImage.frame = CGRectMake(5, 5, 90, 90);
    _goodsBtn.frame = CGRectMake(0, 0, 300, 100);
    if (model.url.length>0 && model.type == 1)
    {
        _titleLabel.frame = CGRectMake(CGRectGetMaxX(_goodsImage.frame)+3, 10, 195, 55);
        _priceLabel.frame = CGRectMake(CGRectGetMaxX(_goodsImage.frame)+3, CGRectGetMaxY(_titleLabel.frame)+10, 180, 15);
    }
    else
    {
        if (_type==0)
        {
            _sendAnchorBtn.hidden = YES;
            _giveSelfBtn.hidden = YES;
            _sendAnchorBtn.enabled = NO;
            _giveSelfBtn.enabled = NO;
            _titleLabel.frame = CGRectMake(CGRectGetMaxX(_goodsImage.frame)+3, 15, 195, 40);
            _priceLabel.frame = CGRectMake(CGRectGetMaxX(_goodsImage.frame)+3, CGRectGetMaxY(_titleLabel.frame)+15, 180, 15);
        }
        else if (_type==1)
        {
            _sendAnchorBtn.hidden = kSupportH5Shopping ? YES : NO;
            _giveSelfBtn.hidden = kSupportH5Shopping ? YES : NO;
            _sendAnchorBtn.enabled = kSupportH5Shopping ? NO : YES;
            _giveSelfBtn.enabled = kSupportH5Shopping ? NO : YES;
            _titleLabel.frame = CGRectMake(CGRectGetMaxX(_goodsImage.frame)+3, 5, 195, 40);
            _priceLabel.frame = CGRectMake(CGRectGetMaxX(_goodsImage.frame)+3, CGRectGetMaxY(_titleLabel.frame)+5, 180, 15);
            _sendAnchorBtn.frame = CGRectMake(155, CGRectGetMaxY(_priceLabel.frame)+5, 55, 25);
            _giveSelfBtn.frame = CGRectMake(CGRectGetMaxX(_sendAnchorBtn.frame)+20, CGRectGetMaxY(_priceLabel.frame)+5, 55, 25);
            _sendAnchorBtn.layer.cornerRadius = 5;
            _sendAnchorBtn.layer.masksToBounds = YES;
            _giveSelfBtn.layer.cornerRadius = 5;
            _giveSelfBtn.layer.masksToBounds = YES;
            [_sendAnchorBtn setTitle:@"送给主播" forState:UIControlStateNormal];
            [_giveSelfBtn setTitle:@"买给自己" forState:UIControlStateNormal];
            [_sendAnchorBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
            [_giveSelfBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    [_goodsImage sd_setImageWithURL:[NSURL URLWithString:model.imgs] placeholderImage:[UIImage imageNamed:@"DefaultImg"]];
    _titleLabel.text = model.name;
    _priceLabel.text = [NSString stringWithFormat:@"¥ %@",model.price];
}

- (void)clickGoodsBtn
{
    if (_delegate && [_delegate respondsToSelector:@selector(toGoods)])
    {
        [_delegate toGoods];
    }
}

- (void)clickBtn:(UIButton *) button
{
    
    if (button==_sendAnchorBtn)
    {
        if (_delegate && [_delegate respondsToSelector:@selector(toGoods)])
        {
            [_delegate toGoods];
        }
    }
    else if (button==_giveSelfBtn)
    {
        if (_delegate && [_delegate respondsToSelector:@selector(toGoods)]) {
            [_delegate toGoods];
        }
    }
}

@end
