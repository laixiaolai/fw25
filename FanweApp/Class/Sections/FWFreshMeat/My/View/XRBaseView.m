
//
//  XRBaseView.m
//  FanweApp
//
//  Created by 丁凯 on 2017/6/24.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "XRBaseView.h"

@implementation XRBaseView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [kBlackColor colorWithAlphaComponent:0.5];
        
        self.bottomView = [[UIView alloc]initWithFrame:CGRectMake(kScreenW/2 -149, kScreenH/2 - 88, 296, 176)];
        self.bottomView.backgroundColor = kWhiteColor;
        self.bottomView.layer.cornerRadius = 3;
        self.bottomView.layer.masksToBounds = YES;
        [self addSubview:self.bottomView];
    }
    return self;
}

@end
