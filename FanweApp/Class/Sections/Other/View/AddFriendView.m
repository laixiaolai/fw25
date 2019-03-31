//
//  AddFriendView.m
//  FanweApp
//
//  Created by fanwe2014 on 16/6/29.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "AddFriendView.h"

@interface AddFriendView()
{
    UITapGestureRecognizer *_tap1;
    UITapGestureRecognizer *_tap2;
    UITapGestureRecognizer *_tap3;
}
@end


@implementation AddFriendView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = kClearColor;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
    [self addGestureRecognizer:tap];
    
    self.wechatImgView.userInteractionEnabled = YES;
    self.qqImgView.userInteractionEnabled = YES;
    self.yinKeImgView.userInteractionEnabled = YES;
    
    _tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [self.wechatImgView addGestureRecognizer:_tap1];
    
    _tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [self.qqImgView addGestureRecognizer:_tap2];
    
    _tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [self.yinKeImgView addGestureRecognizer:_tap3];
}

- (void)tap
{
    if (self.delegate)
    {
        if ([self.delegate respondsToSelector:@selector(deleteFriendView)])
        {
            [self.delegate deleteFriendView];
        }
    }
}

- (void)tap:(UITapGestureRecognizer *)tap
{
    int index =(int)tap.view.tag;
    if (self.delegate)
    {
        if ([self.delegate respondsToSelector:@selector(addFriendWithIndex:)])
        {
            [self.delegate addFriendWithIndex:index];
        }
    }
}

@end
