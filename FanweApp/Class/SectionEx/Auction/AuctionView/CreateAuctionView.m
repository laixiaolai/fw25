//
//  CreateAuctionView.m
//  FanweApp
//
//  Created by 王珂 on 16/10/14.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "CreateAuctionView.h"

@interface  CreateAuctionView()

@property (nonatomic, strong) UILabel * label1; //画线label
@property (nonatomic, strong) UILabel * label2; //画线label
@property (nonatomic, strong) UILabel * virtulLabel; //虚拟竞拍
@property (nonatomic, strong) UILabel * realLabel; //实物竞拍
@property (nonatomic, strong) UIButton * virtulButton; //虚拟竞拍按钮
@property (nonatomic, strong) UIButton * realButton; //实物竞拍按钮
@property (nonatomic, strong) UIButton * cancelButton; //取消按钮
@property (nonatomic, strong) UIImageView * virtulView; //虚拟竞拍图片
@property (nonatomic, strong) UIImageView * realView;  //实物竞拍图片

@end

@implementation CreateAuctionView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame])
    {
        _label1=[[UILabel alloc] init];
        [self addSubview:_label1];
        _label2=[[UILabel alloc] init];
        [self addSubview:_label2];
        _virtulLabel=[[UILabel alloc] init];
        [self addSubview:_virtulLabel];
        _realLabel=[[UILabel alloc] init];
        [self addSubview:_realLabel];
        _virtulButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_virtulButton];
        _realButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_realButton];
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_cancelButton];
        _virtulView = [[UIImageView alloc] init];
        [self addSubview:_virtulView];
        _realView =[[UIImageView alloc] init];
        [self addSubview:_realView];
        
        [_virtulView setImage:[UIImage imageNamed:@"ac_virtual_goods"]];
        _virtulLabel.textColor = kAppGrayColor1;
        _virtulLabel.text = @"虚拟竞拍";
        _virtulLabel.font = kAppMiddleTextFont;
        _label1.alpha = 0.5;
        _label1.backgroundColor = kAppGrayColor4;
        
        [_realView setImage:[UIImage imageNamed:@"ac_real_goods"]];
        _realLabel.text = @"实物竞拍";
        _realLabel.textColor = kAppGrayColor1;
        _realLabel.font = kAppMiddleTextFont;
        _label2.alpha = 0.5;
        _label2.backgroundColor = kAppGrayColor4;
        
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = kAppMiddleTextFont;
        _cancelButton.tag = 303;
        _cancelButton.backgroundColor = kAppMainColor;
        _cancelButton.layer.cornerRadius = 18;
        _cancelButton.layer.masksToBounds= YES;
        [_cancelButton addTarget:self action:@selector(chooseButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)createVieWith:(NSInteger)i andNumber:(NSInteger)j
{
    //i为虚拟，j为实物
    if (i==1 && j==1)
    {
        [self creatVirtulView];
        _realView.frame = CGRectMake((kScreenW-108)/2, 94, 34, 38);
        _realLabel.frame = CGRectMake(CGRectGetMaxX(_realView.frame)+9, 98, 65, 30);
        _realButton.frame = CGRectMake(0, 76, kScreenW, 75);
        _realButton.tag = 302;
        [_realButton addTarget:self action:@selector(chooseButton:) forControlEvents:UIControlEventTouchUpInside];
        _label2.frame = CGRectMake(0, 151, kScreenW, 0.5);
        _cancelButton.frame = CGRectMake(5, 159, kScreenW-10, 36);
    }
    else if (j==0 && i==1) //只支持虚拟竞拍
    {
        [self creatVirtulView];
        _cancelButton.frame = CGRectMake(5, 83, kScreenW-10, 36);
    }
    else if (i==0 && j==1) //只支持实物竞拍
    {
        _realView.frame = CGRectMake((kScreenW-108)/2, 18, 34, 38);
        _realLabel.frame = CGRectMake(CGRectGetMaxX(_realView.frame)+9, 22, 65, 30);
        _realButton.frame = CGRectMake(0, 0, kScreenW, 75);
        _realButton.tag = 302;
        [_realButton addTarget:self action:@selector(chooseButton:) forControlEvents:UIControlEventTouchUpInside];
        _label1.frame = CGRectMake(0, 75, kScreenW, 0.5);
    }
}

- (void)chooseButton:(UIButton *)button
{
    if (_delegate&&[_delegate respondsToSelector:@selector(chooseButton:)])
    {
        [_delegate chooseButton:button];
    }
}

- (void)creatVirtulView
{
    _virtulView.frame = CGRectMake((kScreenW-108)/2, 25, 34, 25);
    _virtulLabel.frame = CGRectMake(CGRectGetMaxX(_virtulView.frame)+9, 22, 65, 30);
    _virtulButton.frame = CGRectMake(0, 0, kScreenW, 75);
    _virtulButton.tag = 301;
    [_virtulButton addTarget:self action:@selector(chooseButton:) forControlEvents:UIControlEventTouchUpInside];
    _label1.frame = CGRectMake(0, 75, kScreenW, 0.5);
}

@end
