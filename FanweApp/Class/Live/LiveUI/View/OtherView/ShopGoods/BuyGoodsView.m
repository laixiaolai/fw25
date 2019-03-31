//
//  BuyGoodsView.m
//  FanweApp
//
//  Created by 王珂 on 16/10/28.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "BuyGoodsView.h"

@interface BuyGoodsView()//购买商品成功后的推送视图

@property (nonatomic, strong) UIImageView * goodsView;//商品图片
@property (nonatomic, strong) UIView * bigView;//背景
@property (nonatomic, strong) UIView * smallView;//
@property (nonatomic, strong) UIImageView * headImage; //用户头像
@property (nonatomic, strong) UILabel * numberLabel;//商品数量
@property (nonatomic, strong) UILabel * goodsDesLabel;//商品描述
@property (nonatomic, strong) UILabel * nameLabel; //购买人姓名
@property (nonatomic, strong) UILabel * desLabel; //商品详情
@property (nonatomic, assign) CGFloat desWith;//购买详情的长度

@end

@implementation BuyGoodsView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _giveLabel = [[UILabel alloc] init];
        _giveLabel.font = [UIFont systemFontOfSize:45];
        _giveLabel.textColor = [UIColor greenColor];
        _giveLabel.backgroundColor = [UIColor whiteColor];
        _giveLabel.textAlignment = NSTextAlignmentCenter;
        _giveLabel.hidden = YES;
        [self addSubview:_giveLabel];
        _bigView = [[UIView alloc] init];
        _bigView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_bigView];
        _goodsView = [[UIImageView alloc] init];
        [_bigView addSubview:_goodsView];
        _goodsDesLabel = [[UILabel alloc] init];
        _goodsDesLabel.font = [UIFont systemFontOfSize:13];
        _goodsDesLabel.textAlignment = NSTextAlignmentCenter;
        [_bigView addSubview:_goodsDesLabel];
        _numberLabel = [[UILabel alloc] init];
        _numberLabel.textColor = [UIColor blueColor];
        _numberLabel.font = [UIFont systemFontOfSize:30];
        _numberLabel.textAlignment = NSTextAlignmentCenter;
        [_bigView addSubview:_numberLabel];
        _addExpLabel = [[UILabel alloc] init];
        _addExpLabel.textColor = [UIColor redColor];
        _addExpLabel.font = [UIFont systemFontOfSize:30];
        _addExpLabel.textAlignment = NSTextAlignmentCenter;
        _addExpLabel.hidden = YES;
        [_bigView addSubview:_addExpLabel];
        _smallView = [[UIView alloc] init];
        //        _smallView.backgroundColor = kAppGrayColor2;
        //        _smallView.alpha = 0.8;
        _smallView.backgroundColor = kGrayTransparentColor4;
        [self addSubview:_smallView];
        _headImage = [[UIImageView alloc] init];
        [_smallView addSubview:_headImage];
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.font = [UIFont systemFontOfSize:15];
        [_smallView addSubview:_nameLabel];
        _desLabel = [[UILabel alloc] init];
        _desLabel.textColor = kAppGrayColor1;
        _desLabel.font = [UIFont systemFontOfSize:15];
        [_smallView addSubview:_desLabel];
    }
    return self;
}

- (void)addDataWithDesMoel:(CustomMessageModel *)model andIsHost:(BOOL )isHost
{
    self.giveLabel.text = @"送主播";
    NSString * str;
    if ([model.is_self isEqualToString:@"1"]) {
        str = [NSString stringWithFormat:@"购买了%@商品",model.goods.goods_name];
    }
    else if ([model.is_self isEqualToString:@"0"])
    {
        str = [NSString stringWithFormat:@"购买了%@商品送主播",model.goods.goods_name];
    }
    //    CGSize titleSize = [str boundingRectWithSize:CGSizeMake(110, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
    //    _desWith = titleSize.width>110?110:titleSize.width;
    //如果是送给主播 高230，宽170；
    if ([model.is_self isEqualToString:@"0"])
    {
        _giveLabel.hidden=NO;
        _giveLabel.frame = CGRectMake(0, 0, 170, 60);
        _giveLabel.layer.cornerRadius = 5;
        _giveLabel.layer.masksToBounds = YES;
        _bigView.frame = CGRectMake(0,60 , 170, 170);
        _bigView.layer.cornerRadius = 5;
        _bigView.layer.masksToBounds = YES;
        _goodsView.frame = CGRectMake(0, 55, 170, 80);
        _goodsDesLabel.frame = CGRectMake(0, CGRectGetMaxY(_goodsView.frame)+5, 170, 25);
        //        _smallView.frame = CGRectMake(0, 60, _desWith+60, 50);
        _smallView.frame = CGRectMake(0, 60, 170, 50);
        _smallView.layer.cornerRadius = 5;
        _smallView.layer.masksToBounds = YES;
        _headImage.frame = CGRectMake(0, 0, 50, 50);
        _headImage.layer.cornerRadius = 25;
        _headImage.layer.masksToBounds = YES;
        _nameLabel.frame = CGRectMake(CGRectGetMaxX(_headImage.frame), 3, 100, 20);
        //        _desLabel.frame = CGRectMake(CGRectGetMaxX(_headImage.frame)+5, CGRectGetMaxY(_nameLabel.frame)+3, _desWith, 20);
        _desLabel.frame = CGRectMake(CGRectGetMaxX(_headImage.frame)+5, CGRectGetMaxY(_nameLabel.frame)+3, 110, 20);
        //        if (isHost) {
        //            _numberLabel.frame = CGRectMake(0, 60, 170, 30);
        //            _addExpLabel.hidden = NO;
        //            _addExpLabel.frame = CGRectMake(0, CGRectGetMaxY(_numberLabel.frame)+10, 170, 30);
        //        }
        //        else
        //        {
        //            _addExpLabel.hidden = YES;
        //            _numberLabel.frame = CGRectMake(0, 70, 170, 30);
        //        }
        _numberLabel.frame = CGRectMake(0, 60, 170, 30);
        _addExpLabel.hidden = NO;
        _addExpLabel.frame = CGRectMake(0, CGRectGetMaxY(_numberLabel.frame)+10, 170, 30);
    }
    else if ([model.is_self isEqualToString:@"1"])
    {
        _giveLabel.hidden = YES;
        _bigView.frame = CGRectMake(0, 0, 170, 170);
        _bigView.layer.cornerRadius = 5;
        _bigView.layer.masksToBounds = YES;
        _goodsView.frame = CGRectMake(0, 55, 170, 80);
        _goodsDesLabel.frame = CGRectMake(0, CGRectGetMaxY(_goodsView.frame)+5, 170, 25);
        _numberLabel.frame = CGRectMake(0, 70, 170, 30);
        _smallView.frame = CGRectMake(0, 0, 170, 50);
        //        _smallView.frame = CGRectMake(0, 0, _desWith+60, 50);
        _smallView.layer.cornerRadius = 5;
        _smallView.layer.masksToBounds = YES;
        _headImage.frame = CGRectMake(0, 0, 50, 50);
        _headImage.layer.cornerRadius = 25;
        _headImage.layer.masksToBounds = YES;
        _nameLabel.frame = CGRectMake(CGRectGetMaxX(_headImage.frame), 3, 100, 20);
        _desLabel.frame = CGRectMake(CGRectGetMaxX(_headImage.frame)+5, CGRectGetMaxY(_nameLabel.frame)+3, 110, 20);
        //        _desLabel.frame = CGRectMake(CGRectGetMaxX(_headImage.frame)+5, CGRectGetMaxY(_nameLabel.frame)+3, _desWith, 20);
        //        if (isHost) {
        //            _numberLabel.frame = CGRectMake(0, 60, 170, 30);
        //            _addExpLabel.hidden = NO;
        //            _addExpLabel.frame = CGRectMake(0, CGRectGetMaxY(_numberLabel.frame)+10, 170, 30);
        //        }
        //        else
        //        {
        //            _addExpLabel.hidden = YES;
        //            _numberLabel.frame = CGRectMake(0, 70, 170, 30);
        //        }
        _numberLabel.frame = CGRectMake(0, 60, 170, 30);
        _addExpLabel.hidden = NO;
        _addExpLabel.frame = CGRectMake(0, CGRectGetMaxY(_numberLabel.frame)+10, 170, 30);
    }
    [_headImage sd_setImageWithURL:[NSURL URLWithString:model.user.head_image] placeholderImage:kDefaultPreloadHeadImg];
    _nameLabel.text = model.user.nick_name;
    _desLabel.text = str;
    [_goodsView sd_setImageWithURL:[NSURL URLWithString:model.goods.goods_logo] placeholderImage:kDefaultPreloadHeadImg];
    _numberLabel.text = [NSString stringWithFormat:@"X %@",model.goods.quantity];
    _addExpLabel.text = [NSString stringWithFormat:@"+ %@",model.score];
    _goodsDesLabel.text = model.goods.goods_name;
}

@end
