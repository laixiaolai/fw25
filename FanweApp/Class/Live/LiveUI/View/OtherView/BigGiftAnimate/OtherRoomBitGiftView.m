//
//  OtherRoomBitGiftView.m
//  FanweApp
//
//  Created by xfg on 2017/7/12.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "OtherRoomBitGiftView.h"

static float const kAnimateTimes = 12;   // 动画时间

@implementation OtherRoomBitGiftView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = kClearColor;
        
        self.largeGiftBtn = [[MenuButton alloc] initWithFrame:CGRectMake(frame.size.width, 0, 0, frame.size.height)];
        [self.largeGiftBtn.titleLabel setFont:kAppMiddleTextFont];
        self.largeGiftBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.largeGiftBtn.titleEdgeInsets = UIEdgeInsetsMake(10, 50, 0, 0);
        self.largeGiftBtn.userInteractionEnabled = NO;
        [self addSubview:self.largeGiftBtn];
    }
    return self;
}

- (void)judgeGiftViewWith:(NSString *)str finishBlock:(FWVoidBlock)finishBlock
{
    CGSize strSize = [str sizeWithAttributes:@{NSFontAttributeName : self.largeGiftBtn.titleLabel.font}];
    
    self.largeGiftBtn.frame = CGRectMake(CGRectGetMinX(self.largeGiftBtn.frame), CGRectGetMinY(self.largeGiftBtn.frame), strSize.width + 70, CGRectGetHeight(self.largeGiftBtn.frame));
    
    [self.largeGiftBtn setBackgroundImage:[FWUtils resizableImage:@"lr_bg_fly_gift"] forState:UIControlStateNormal];
    
    [self.largeGiftBtn setTitle:str forState:UIControlStateNormal];
    
    [UIView animateWithDuration:kAnimateTimes delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        self.largeGiftBtn.frame = CGRectMake(- CGRectGetWidth(self.largeGiftBtn.frame), CGRectGetMinY(self.largeGiftBtn.frame), CGRectGetWidth(self.largeGiftBtn.frame), CGRectGetHeight(self.largeGiftBtn.frame));
        
    } completion:^(BOOL finished) {
        
        self.hidden = YES;
        self.largeGiftBtn.frame = CGRectMake(self.frame.size.width, CGRectGetMinY(self.largeGiftBtn.frame), strSize.width + 52, CGRectGetHeight(self.largeGiftBtn.frame));
        
        if (finishBlock)
        {
            finishBlock();
        }
        
    }];
}

@end
