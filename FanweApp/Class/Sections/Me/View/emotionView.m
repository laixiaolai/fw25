//
//  emotionView.m
//  FanweApp
//
//  Created by fanwe2014 on 16/7/19.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "emotionView.h"

@implementation emotionView

- (instancetype)initWithFrame:(CGRect)frame withName:(NSString *)name
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.arrayCount = 0;
        @autoreleasepool
        {
            self = [super initWithFrame:frame];
            self.titleArray = @[@"保密",@"单身",@"恋爱中",@"已婚",@"同性"];
            for (int j= 0 ; j < self.titleArray.count; j ++)
            {
                if ([self.titleArray[j] isEqualToString:name])
                {
                    self.arrayCount = j;
                }
            }
            if (self)
            {
                self.backgroundColor = [UIColor whiteColor];
                for (int i = 0; i < 5; i ++)
                {
                    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                    button.frame = CGRectMake(kScreenW*0.05 +kScreenW*0.233*(i%4) , 30 +60*(i/4), kScreenW*0.2, 40);
                    button.titleLabel.font = [UIFont systemFontOfSize:16];
                    button.tag = 100+i;
                    button.layer.cornerRadius = 5;
                    if (self.arrayCount == i)
                    {
                        button.backgroundColor = kAppSecondaryColor;
                        [button setTitleColor:kWhiteColor forState:0];
                    }else
                    {
                        button.backgroundColor = kGrayTransparentColor1;
                        [button setTitleColor:kAppGrayColor1 forState:0];
                    }
                    [button setTitle:self.titleArray[i] forState:0];
                    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
                    [self addSubview:button];
                    
                }
            }
        }
    }
    return self;
}

- (void)buttonClick:(UIButton *)button
{
    for ( UIButton *btn in self.subviews)
    {
        //因为label和button都是继承制UIView,所以可以这样枚举
        //如果是label则删除
        if ([button isKindOfClass:[UIButton class]])
        {
            if (button.tag == btn.tag)
            {
                [btn setTitleColor:kWhiteColor forState:0];
                btn.backgroundColor = kAppSecondaryColor;
            }
            else
            {
                [btn setTitleColor:kAppGrayColor1 forState:0];
                btn.backgroundColor = kGrayTransparentColor1;
            }
        }
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.delegate)
        {
            if ([self.delegate respondsToSelector:@selector(changeEmotionStatuWithString:)])
            {
                [self.delegate changeEmotionStatuWithString:self.titleArray[button.tag-100]];
            }
        }

    });
    
}

@end
