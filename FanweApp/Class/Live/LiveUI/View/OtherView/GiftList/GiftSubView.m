//
//  GiftSubView.m
//  FanweApp
//
//  Created by xfg on 16/5/20.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "GiftSubView.h"

#define kLabelHeight        15
#define kImgViewY           kHomeCateViewHeight-kLabelHeight-kImgViewWidth

@implementation GiftSubView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = [kWhiteColor colorWithAlphaComponent:0.1].CGColor;
        
        CGFloat subViewW = frame.size.width;
        CGFloat subViewH = frame.size.height;
        
        _diamondsImgView = [[UIImageView alloc]initWithFrame:CGRectMake(subViewW*0.4, subViewH-kDefaultMargin-10, 11, 11)];
        _diamondsImgView.contentMode = UIViewContentModeScaleAspectFit;
        [_diamondsImgView setImage:[UIImage imageNamed:@"com_diamond_1"]];
        [self addSubview:_diamondsImgView];
        
        _diamondsLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_diamondsImgView.frame)+3, CGRectGetMinY(_diamondsImgView.frame)-3, subViewW*0.5-6, kLabelHeight)];
        _diamondsLabel.font = [UIFont systemFontOfSize:11.0];
        _diamondsLabel.textColor = kWhiteColor;
        [self addSubview:_diamondsLabel];
        
        _txtLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetMinY(_diamondsImgView.frame)-kLabelHeight-kDefaultMargin, subViewW-10, kLabelHeight)];
        _txtLabel.font = [UIFont systemFontOfSize:10.0];
        _txtLabel.textAlignment = NSTextAlignmentCenter;
        _txtLabel.textColor = kWhiteColor;
        [self addSubview:_txtLabel];
        
        CGFloat min = MIN(subViewW, subViewH-kLabelHeight*2)*0.7;
        CGFloat imgViewWAndH = min;
        
        _imgView = [[FLAnimatedImageView alloc]initWithFrame:CGRectMake((subViewW-imgViewWAndH)/2, (subViewH-imgViewWAndH-kLabelHeight*2)/2, imgViewWAndH, imgViewWAndH)];
        _imgView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_imgView];
        
        //连
        _continueImgView = [[UIImageView alloc]initWithFrame:CGRectMake(subViewW-20, 5, 15, 15)];
        _continueImgView.contentMode = UIViewContentModeScaleAspectFit;
        [_continueImgView setImage:[UIImage imageNamed:@"lr_gift_list_continue"]];
        [self addSubview:_continueImgView];
        
        //用来被点击的按钮
        _bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _bottomBtn.frame = CGRectMake(1, 1, subViewW-2, subViewH-2);
        _bottomBtn.backgroundColor = [UIColor clearColor];
        [_bottomBtn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
        _bottomBtn.layer.borderWidth = 1;
        _bottomBtn.layer.borderColor = kClearColor.CGColor;
        [self addSubview:_bottomBtn];
        
    }
    return self;
}

- (void)btnAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(cateBtn:)])
    {
        [_delegate cateBtn:(int)self.tag];
    }
}

- (void)resetDiamondsFrame
{
    if (![FWUtils isBlankString:_diamondsLabel.text])
    {
        CGSize titleSize = [_diamondsLabel.text boundingRectWithSize:CGSizeMake(100, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
        CGFloat tmpX = (self.frame.size.width-3-CGRectGetWidth(_diamondsImgView.frame)-titleSize.width)/2;
        _diamondsImgView.frame = CGRectMake(tmpX, CGRectGetMinY(_diamondsImgView.frame), CGRectGetWidth(_diamondsImgView.frame), CGRectGetHeight(_diamondsImgView.frame));
        _diamondsLabel.frame = CGRectMake(CGRectGetMaxX(_diamondsImgView.frame)+3, CGRectGetMinY(_diamondsLabel.frame), CGRectGetWidth(_diamondsLabel.frame), CGRectGetHeight(_diamondsLabel.frame));
        
    }
}

@end
