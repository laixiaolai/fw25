//
//  EmojiScrollView.m
//  FanweApp
//
//  Created by 朱庆彬 on 2017/8/15.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "EmojiScrollView.h"

@implementation EmojiScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.pagingEnabled = YES;
        self.showsHorizontalScrollIndicator = NO;
    }
    return self;
}

@end
