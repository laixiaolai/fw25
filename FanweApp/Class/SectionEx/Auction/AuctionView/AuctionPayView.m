//
//  AuctionPayView.m
//  FanweApp
//
//  Created by 王珂 on 16/10/26.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "AuctionPayView.h"

@interface  AuctionPayView()

@property (nonatomic, strong) UIImageView * auctionGoodsView; //商品图片
@property (nonatomic, strong) UILabel * titleLabel; //商品介绍
@property (nonatomic, strong) UIImageView * diamondView; //钻石图片
@property (nonatomic, strong) UILabel * priceLabel; //商品价格
@property (nonatomic, strong) UIView * rechargeContainerView;
@property (nonatomic, strong) UILabel * txtLabel; //充值
@property (nonatomic, strong) UILabel *diamondsLabel; //账户剩余钻石
@property (nonatomic, strong) UIImageView *diamondsImgView; //钻石图标
@property (nonatomic, strong) UIImageView *diamondsArrowImgView; //右箭头
@property (nonatomic, strong) UIButton *  cancelBtn;
@property (nonatomic, strong) UIButton *  payBtn;
@property (nonatomic, strong) UIButton *  chargeBtn;

@end

@implementation AuctionPayView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _auctionGoodsView =[[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 90, 70)];
        [self addSubview:_auctionGoodsView];
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_auctionGoodsView.frame)+5, 5, kScreenW-CGRectGetMaxX(_auctionGoodsView.frame)-10, 40)];
        //titleLabel.text = @"商品介绍";
        _titleLabel.numberOfLines = 0;
        _titleLabel.font = kAppMiddleTextFont;
        _titleLabel.textColor = kAppGrayColor1;
        [self addSubview:_titleLabel];
        _diamondView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_auctionGoodsView.frame)+5, CGRectGetMaxY(_titleLabel.frame)+7, 20, 15)];
        _diamondView.image = [UIImage imageNamed:@"com_diamond_1"];
        [self addSubview:_diamondView];
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_diamondView.frame)+5, CGRectGetMaxY(_titleLabel.frame)+5, kScreenW-145-CGRectGetMaxX(_diamondView.frame), 20)];
        //priceLabel.text =@"付款价格";
        _priceLabel.textColor = kAppGrayColor1;
        _priceLabel.font = kAppSmallTextFont;
        [self addSubview:_priceLabel];
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenW-135, CGRectGetMaxY(_titleLabel.frame)+5,135 ,20)];
        // _timeLabel.text = [NSString stringWithFormat:@"剩%02d分%02d秒  自动关闭",_payMinute,_paySecond];
        _timeLabel.textColor = kAppGrayColor1;
        _timeLabel.font = kAppSmallTextFont;
        [self addSubview:_timeLabel];
        _rechargeContainerView = [[UIView alloc]initWithFrame:CGRectMake(0, 90, 170, 40)];
        [self addSubview:_rechargeContainerView];
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.backgroundColor = kAppMainColor;
        _cancelBtn.frame = CGRectMake(kScreenW-140, 95, 60, 30);
        _cancelBtn.titleLabel.font = kAppSmallTextFont;
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        _cancelBtn.layer.cornerRadius = 15;
        _cancelBtn.layer.masksToBounds = YES;
        [_cancelBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_cancelBtn];
        
        _payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _payBtn.backgroundColor = kAppMainColor;
        _payBtn.frame = CGRectMake(kScreenW-70, 95, 60, 30);
        _payBtn.titleLabel.font = kAppSmallTextFont;
        [_payBtn setTitle:@"付款" forState:UIControlStateNormal];
        _payBtn.layer.cornerRadius = 15;
        _payBtn.layer.masksToBounds = YES;
        [_payBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_payBtn];
    }
    return self;
}

- (void)creatWith:(UserModel *)model withCurrentDiamonds:(NSInteger )currentDiamonds withPrice:(NSString *)priceStr
{
    _titleLabel.text = model.goods_name;
    _priceLabel.text = priceStr;
    [_auctionGoodsView sd_setImageWithURL:[NSURL URLWithString:model.goods_icon]];
    UILabel *txtLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, CGRectGetHeight(_rechargeContainerView.frame))];
    txtLabel.font = kAppSmallTextFont;
    txtLabel.textAlignment = NSTextAlignmentCenter;
    txtLabel.text = @"充值";
    [_rechargeContainerView addSubview:txtLabel];
    NSString * str = [NSString stringWithFormat:@"%ld",(long)currentDiamonds];
    CGSize titleSize = [str boundingRectWithSize:CGSizeMake(100, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kAppSmallTextFont} context:nil].size;
    _diamondsLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(txtLabel.frame), 0, titleSize.width, CGRectGetHeight(_rechargeContainerView.frame))];
    _diamondsLabel.font = kAppSmallTextFont;
    _diamondsLabel.text = str;
    [_rechargeContainerView addSubview:_diamondsLabel];
    _diamondsImgView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_diamondsLabel.frame)+3,(CGRectGetHeight(_rechargeContainerView.frame)-15)/2, 20, 15)];
    _diamondsImgView.contentMode = UIViewContentModeScaleAspectFit;
    [_diamondsImgView setImage:[UIImage imageNamed:@"com_diamond_1"]];
    [_rechargeContainerView addSubview:_diamondsImgView];
    _diamondsArrowImgView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_diamondsImgView.frame)+3,(CGRectGetHeight(_rechargeContainerView.frame)-12)/2, 6, 12)];
    _diamondsArrowImgView.contentMode = UIViewContentModeScaleAspectFit;
    [_diamondsArrowImgView setImage:[UIImage imageNamed:@"com_arrow_right_1"]];
    [_rechargeContainerView addSubview:_diamondsArrowImgView];
    _chargeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 150, 40)];
    _chargeBtn.width = CGRectGetMaxX(_diamondsArrowImgView.frame);
    [_rechargeContainerView addSubview:_chargeBtn];
    [_chargeBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setDiamondsText:(NSString *)txt
{
    _diamondsLabel.text = txt;
    CGSize titleSize = [txt boundingRectWithSize:CGSizeMake(100, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kAppSmallTextFont} context:nil].size;
    _diamondsLabel.frame = CGRectMake(_diamondsLabel.frame.origin.x, _diamondsLabel.frame.origin.y, titleSize.width, _diamondsLabel.frame.size.height);
    _diamondsImgView.frame = CGRectMake(CGRectGetMaxX(_diamondsLabel.frame)+3,_diamondsImgView.frame.origin.y, _diamondsImgView.frame.size.width, _diamondsImgView.frame.size.height);
    _diamondsArrowImgView.frame = CGRectMake(CGRectGetMaxX(_diamondsImgView.frame)+3,_diamondsArrowImgView.frame.origin.y, _diamondsArrowImgView.frame.size.width, _diamondsArrowImgView.frame.size.height);
    _chargeBtn.width = CGRectGetMaxX(_diamondsArrowImgView.frame);
}

- (void)clickBtn:(UIButton *)button
{
    if (button==_cancelBtn)
    {
        if (_delegate && [_delegate respondsToSelector:@selector(cancelPay)])
        {
            [_delegate cancelPay];
        }
    }
    else if (button==_payBtn)
    {
        if (_delegate && [_delegate respondsToSelector:@selector(clickToPay)])
        {
            [_delegate clickToPay];
        }
    }
    else if (button==_chargeBtn)
    {
        if (_delegate && [_delegate respondsToSelector:@selector(clickRechargeAction)])
        {
            [_delegate clickRechargeAction];
        }
    }
}

@end
