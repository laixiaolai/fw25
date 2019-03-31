//
//  ULGView.m
//  FanweApp
//
//  Created by fanwe2014 on 2016/12/10.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "ULGView.h"

@implementation ULGView

- (id)initWithFrame:(CGRect)frame Array:(NSArray *)array
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self creatViewWithArray:array];
    }
    return self;
}

- (void)creatViewWithArray:(NSArray *)array
{
    CGFloat Width = (kScreenW - array.count*47)/(array.count+1);
    for (int i = 0; i < array.count; i ++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        //[button setImage:[UIImage imageNamed:array[i]] forState:UIControlStateNormal];
        [self creatButtonViewWithButton:button andCount:[array[i] intValue]];
        button.frame =CGRectMake((Width+47)*i+Width, 0, 47, 47);
        button.tag = 100+[array[i] intValue];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.layer.cornerRadius = button.frame.size.width/2;
        [self addSubview:button];
    }
    
}

- (void)creatButtonViewWithButton:(UIButton *)button andCount:(int)count
{
    switch (count)
    {
        case 1:
            [button setImage:[UIImage imageNamed:@"lg_qq"] forState:UIControlStateNormal];
            break;
        case 2:
            [button setImage:[UIImage imageNamed:@"lg_weixin"] forState:UIControlStateNormal];
            break;
        case 3:
            [button setImage:[UIImage imageNamed:@"lg_xinlangweibo"] forState:UIControlStateNormal];
            break;
        case 4:
            [button setImage:[UIImage imageNamed:@"lg_shouji"] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}

- (void)buttonClick:(UIButton *)button
{
    if (self.LDelegate)
    {
        if ([self.LDelegate respondsToSelector:@selector(enterLoginWithCount:)])
        {
            [self.LDelegate enterLoginWithCount:(int)(button.tag-100)];
        }
    }
}


@end
