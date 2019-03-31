//
//  STSeachView.m
//  FanweApp
//
//  Created by 岳克奎 on 17/4/27.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "STSeachView.h"

@implementation STSeachView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
    }
    return self;
}
-(void)awakeFromNib{
    [super awakeFromNib];
}
-(void)setDelegate:(id<STSeachViewDelegate>)delegate{
    _delegate = delegate;
}
@end
