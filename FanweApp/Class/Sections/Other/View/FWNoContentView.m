//
//  FWNoContentView.m
//  FanweApp
//
//  Created by xfg on 2017/8/29.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "FWNoContentView.h"

@implementation FWNoContentView

+ (instancetype)noContentWithFrame:(CGRect)frame
{
    FWNoContentView *tmpView = [[[NSBundle mainBundle] loadNibNamed:@"FWNoContentView" owner:self options:nil] lastObject];
    tmpView.userInteractionEnabled = NO;
    tmpView.frame = frame;
    return tmpView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self creatMyUI];
    }
    return self;
}

- (void)creatMyUI
{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 150, 150)];
    imageView.image = [UIImage imageNamed:@"com_no_content"];
    [self addSubview:imageView];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame), 150, 25)];
    label.text = @"亲~暂无任何内容";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = kLightGrayColor;
    [self addSubview:label];
    
}

@end
