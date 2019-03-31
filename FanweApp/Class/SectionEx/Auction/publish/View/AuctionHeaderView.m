//
//  AuctionHeaderView.m
//  FanweApp
//
//  Created by 王珂 on 16/10/13.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "AuctionHeaderView.h"
#import "AuctionGoodsModel.h"

@interface  AuctionHeaderView()

@property (nonatomic, strong) UIImageView   *goodsImage;//实物竞拍图片
@property (nonatomic, strong) UILabel       *nameLabel;//竞拍商品名称
@property (nonatomic, strong) UIImageView   *diamondsImgView;//竞拍商品钻石
@property (nonatomic, strong) UILabel       *priceLabel;

@end

@implementation AuctionHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _goodsImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 100, 100)];
        [self addSubview:_goodsImage];
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_goodsImage.frame)+5, 10, kScreenW-CGRectGetMaxX(_goodsImage.frame)-15, 70)];
        _nameLabel.numberOfLines=0;
        _nameLabel.textColor = kAppGrayColor1;
        _nameLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:_nameLabel];
        _diamondsImgView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_goodsImage.frame)+5,80, 20, 20)];
        _diamondsImgView.contentMode = UIViewContentModeScaleAspectFit;
        [_diamondsImgView setImage:[UIImage imageNamed:@"com_diamond_1"]];
        [self addSubview:_diamondsImgView];
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_diamondsImgView.frame)+5, 80, kScreenW-CGRectGetMaxX(_diamondsImgView.frame)-15, 20)];
        _priceLabel.textColor = kAppGrayColor1;
        _priceLabel.font= [UIFont systemFontOfSize:18];
        [self addSubview:_priceLabel];
    }
    return self;
}

- (void)setModel:(AuctionGoodsModel  *)model
{
    _model=model;
    [_goodsImage sd_setImageWithURL:[NSURL URLWithString:model.imgs[0]]];
    _nameLabel.text = model.name;
    _priceLabel.text = model.qp_diamonds;
}

@end
