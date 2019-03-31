//
//  OneSectionCell.m
//  FanweApp
//  Created by fanwe2014 on 16/7/4.
//  Copyright © 2016年 xfg. All rights reserved.

#import "OneSectionCell.h"

@implementation OneSectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
    }
    return self;
}

- (CGFloat)creatCellWithArray:(NSMutableArray *)array
{
    for (UIView *subView in self.contentView.subviews)
    {
        [subView removeFromSuperview];
    }
    @autoreleasepool
    {
        if (array.count%2 == 0)//当主题列表是偶数个数时
        {
            int section = (int)array.count/2;//有多少段
            for (int i = 0; i < section; i ++)
            {
                for (int j = 0; j < 2; j ++)
                {
                    cuserModel *model = array[j+2*i];
                    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                    button.frame = CGRectMake(kScreenW*j/2+0.5*j+10, 41*i,(kScreenW-40)/2-0.5, 40);
                    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                    [button setTitleColor:myTextColorLine6 forState:0];
                    button.tag = j+ 2*i;
                    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
                    if (i == section-1 && j == 1)
                    {
                        [button setTitle:[NSString stringWithFormat:@"%@",model.title] forState:0];
                    }else
                    {
                        [button setTitle:model.title forState:0];
                    }
                    button.titleLabel.font = [UIFont systemFontOfSize:15];
                    [self.contentView addSubview:button];
                    //横分割线
                    if (i < section + 1 && j == 1 && i > 0)
                    {
                        UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(10, 40*i+(i-1), kScreenW-20, 1)];
                        lineView2.backgroundColor = myTextColorLine3;
                        lineView2.alpha = 0.3;
                        [self.contentView addSubview:lineView2];
                    }
                }
            }
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(kScreenW/2-0.5, 10, 1, 40*section-20)];
            lineView.alpha = 0.3;
            lineView.backgroundColor = myTextColorLine3;
            [self.contentView addSubview:lineView];
            return 41*section;//返回的高度
            
        }else//当主题列表是奇数个数时
        {
            int section = (int)array.count/2+1;//有多少段
            for (int i = 0; i < section; i ++)
            {
                for (int j = 0; j < 2; j ++)
                {
                    if (i == section-1 && j == 1)
                    {
                        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                        button.frame = CGRectMake(kScreenW*j/2+0.5*j+10, 41*i,(kScreenW-40)/2-0.5, 40);
                        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                        [button setTitleColor:myTextColorLine6 forState:0];
                        [self.contentView addSubview:button];
                        
                    }else
                    {
                        cuserModel *model = array[j+2*i];
                        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                        button.frame = CGRectMake(kScreenW*j/2+0.5*j+10, 41*i,(kScreenW-40)/2-0.5, 40);
                        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                        [button setTitleColor:myTextColorLine6 forState:0];
                        button.tag = j+ 2*i;
                        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
                        if (i == section-1 && j == 0)
                        {
                            [button setTitle:[NSString stringWithFormat:@"%@",model.title] forState:0];
                            
                        }else
                        {
                            [button setTitle:model.title forState:0];
                        }
                        button.titleLabel.font = [UIFont systemFontOfSize:15];
                        [self.contentView addSubview:button];
                    }
                    //横分割线
                    if (i < section + 1 && j == 1 && i > 0)
                    {
                        UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(10, 40*i+(i-1), kScreenW-20, 1)];
                        lineView2.backgroundColor = myTextColorLine3;
                        lineView2.alpha = 0.3;
                        [self.contentView addSubview:lineView2];
                    }
                    //最后一个话题的箭头图标
                    if (i == section-1 && j == 0)
                    {
                        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenW-10, 10, 10, 20)];
                        imgView.image = [UIImage imageNamed:@""];
                        [self.contentView addSubview:imgView];
                    }
                }
            }
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(kScreenW/2-0.5, 10, 1, 40*section-20)];
            lineView.alpha = 0.3;
            lineView.backgroundColor = myTextColorLine3;
            [self.contentView addSubview:lineView];
            return 41*section;//返回的高度
        }
    }
}
//点击事件,block传值
- (void)buttonClick:(UIButton *)button
{
   int index = (int) button.tag;
    if (self.block)
    {
        self.block(index);
    }
}

@end
