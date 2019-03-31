//
//  AuctionResultView.m
//  FanweApp
//
//  Created by 王珂 on 16/10/26.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "AuctionResultView.h"

@interface  AuctionResultView()

@property (nonatomic, strong) UIView * backView;//用来装竞拍图片下方的显示内容
@property (nonatomic, strong) UIImageView * resultImage;//竞拍结果图片，显示为竞拍成功，竞拍失败，付款成功
@property (nonatomic, strong) UIImageView * diamondView;//钻石图片
@property (nonatomic, strong) UILabel * nameLabel; //竞拍成功人的名字
@property (nonatomic, strong) UILabel * lastLabel; //最终价
@property (nonatomic, strong) UILabel * priceLabel; //最终价格Label
@property (nonatomic, strong) UIView * titleView; //如果竞拍成功且付款人在付款中
@property (nonatomic, strong) UIButton * payButton; //立即付款按钮

@end

@implementation AuctionResultView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _resultImage = [[UIImageView alloc] init];
        [self addSubview:_resultImage];
        _backView = [[UIView alloc] init];
        [self addSubview:_backView];
        _titleView = [[UIView alloc] init];
        [_backView addSubview:_titleView];
        _nameLabel = [[UILabel alloc] init];
        [_backView addSubview:_nameLabel];
        _lastLabel = [[UILabel alloc] init];
        [_titleView addSubview:_lastLabel];
        _diamondView = [[UIImageView alloc] init];
        [_titleView addSubview:_diamondView];
        _priceLabel = [[UILabel alloc] init];
        [_titleView addSubview:_priceLabel];
        _payButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backView addSubview:_payButton];
    }
    return self;
}

- (void)createWithType:(NSInteger )type andResult:(NSString *)result andName:(NSString *) name andPrice:(NSString *)price
{
    CGFloat scaleW = [[UIScreen mainScreen] bounds].size.width/375.0;
    //如果是竞拍成功状态
    if ([result isEqualToString:@"ac_auction_success"])
    {
        _resultImage.frame = CGRectMake(0, 0, 250*scaleW, 170*scaleW);
        _resultImage.image = [UIImage imageNamed:result];
        _backView.frame = CGRectMake(0, 170*scaleW, 250*scaleW, 70*scaleW);
        if (type==0)
        {
            _backView.backgroundColor = kGrayTransparentColor2;
            _nameLabel.frame= CGRectMake(0, 5*scaleW, 250*scaleW, 30*scaleW);
            _nameLabel.text = name;
            _nameLabel.textColor = [UIColor whiteColor];
            _nameLabel.font = [UIFont systemFontOfSize:18.0];
            _nameLabel.textAlignment = NSTextAlignmentCenter;
            NSString * priceStr = [NSString stringWithFormat:@"%@",price];
            CGSize priceSize = [priceStr boundingRectWithSize:CGSizeMake(MAXFLOAT, 25*scaleW) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}  context:nil].size;
            CGFloat length = priceSize.width+60*scaleW+33*scaleW;
            _titleView.frame = CGRectMake((250*scaleW-length)/2, 40*scaleW, length, 25*scaleW);
            _lastLabel.frame = CGRectMake(0, 0, 60*scaleW, 25*scaleW);
            _lastLabel.text = @"最终价";
            _lastLabel.textColor = [UIColor whiteColor];
            _lastLabel.font = [UIFont systemFontOfSize:15.0];
            _diamondView.image = [UIImage imageNamed:@"com_diamond_1"];
            _diamondView.frame = CGRectMake(CGRectGetMaxX(_lastLabel.frame),0, 33*scaleW, 25*scaleW);
            _priceLabel.frame = CGRectMake(CGRectGetMaxX(_diamondView.frame), 0, priceSize.width, 25*scaleW);
            _priceLabel.text =priceStr;
            _priceLabel.textColor = [UIColor whiteColor];
            _priceLabel.font = [UIFont systemFontOfSize:15.0];
        }
        else if (type==1)
        {
            _payButton.frame = CGRectMake(75*scaleW, 5*scaleW, 100*scaleW, 30*scaleW);
            _payButton.backgroundColor = kAuctionBtnColor;
            _payButton.layer.cornerRadius = 12;
            [_payButton setTitle:@"立即付款" forState:UIControlStateNormal];
            [_payButton addTarget:self action:@selector(clickBtnToPay) forControlEvents:UIControlEventTouchUpInside];
        }
    }
   else if ([result isEqualToString:@"ac_pay_success"])
   {
       _resultImage.frame = CGRectMake(0, 0, 250*scaleW, 170*scaleW);
       _resultImage.image = [UIImage imageNamed:result];
       _backView.frame = CGRectMake(0, 170*scaleW, 250*scaleW, 70*scaleW);
       if (type==0)
       {
           _backView.backgroundColor = kGrayTransparentColor2;
           _nameLabel.frame = CGRectMake(0, 5*scaleW, 250*scaleW, 30*scaleW);
           _nameLabel.text = [NSString stringWithFormat:@"%@付款成功",name];
           _nameLabel.textColor = [UIColor whiteColor];
           _nameLabel.font = [UIFont systemFontOfSize:18.0];
           _nameLabel.textAlignment = NSTextAlignmentCenter;
           NSString * priceStr = [NSString stringWithFormat:@"%@",price];
           CGSize priceSize = [priceStr boundingRectWithSize:CGSizeMake(MAXFLOAT, 25*scaleW) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}  context:nil].size;
           CGFloat length = priceSize.width+60*scaleW+33*scaleW;
           _titleView.frame = CGRectMake((250*scaleW-length)/2, 40*scaleW, length, 25*scaleW);
           _lastLabel.frame= CGRectMake(0, 0, 60*scaleW, 25*scaleW);
           _lastLabel.text = @"最终价";
           _lastLabel.textColor = [UIColor whiteColor];
           _lastLabel.font = [UIFont systemFontOfSize:15.0];
           _diamondView.image =[UIImage imageNamed:@"com_diamond_1"];
           _diamondView.frame = CGRectMake(CGRectGetMaxX(_lastLabel.frame),0, 33*scaleW, 25*scaleW);
           _priceLabel.frame = CGRectMake(CGRectGetMaxX(_diamondView.frame), 0, priceSize.width, 25*scaleW);
           _priceLabel.text =priceStr;
           _priceLabel.textColor = [UIColor whiteColor];
           _priceLabel.font = [UIFont systemFontOfSize:15.0];
       }
       else if (type==1)
       {
           _lastLabel.frame = CGRectMake(0, 5*scaleW, 250*scaleW, 30*scaleW);
           _lastLabel.text = @"恭喜你付款成功";
           _lastLabel.backgroundColor = kGrayTransparentColor2;
           _lastLabel.textColor = [UIColor whiteColor];
           _lastLabel.font = [UIFont systemFontOfSize:18.0];
           _lastLabel.textAlignment = NSTextAlignmentCenter;
       }
   }
    else if ([result isEqualToString:@"ac_auction_fail"])
    {
        _resultImage.frame = CGRectMake(0, 0, 250*scaleW, 165*scaleW);
        _resultImage.image = [UIImage imageNamed:result];
        _backView.frame = CGRectMake(0, 165*scaleW, 250*scaleW, 40*scaleW);
        _backView.backgroundColor = kGrayTransparentColor2;
        _lastLabel.frame= CGRectMake(0, 5*scaleW, 250*scaleW, 30*scaleW);
        if (type==0) {
            _lastLabel.text = @"无人参拍";
        }
        else if (type==1)
        {
            _lastLabel.text = @"中拍者超时未付款";
        }
        else if (type==2)
        {
            _lastLabel.text = @"您参与的竞拍超时未付款";
        }
        _lastLabel.textColor = [UIColor whiteColor];
        _lastLabel.font = [UIFont systemFontOfSize:18.0];
        _lastLabel.textAlignment = NSTextAlignmentCenter;
    }
}

//点击付款按钮
- (void)clickBtnToPay
{
    if (_delegate && [_delegate respondsToSelector:@selector(toPay)])
    {
        [_delegate toPay];
    }
}

@end
