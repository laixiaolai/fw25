//
//  LivePayLeftPromptV.m
//  FanweApp
//
//  Created by 丁凯 on 2017/8/16.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "LivePayLeftPromptV.h"

@implementation LivePayLeftPromptV


- (void)addFirstLabWithStr:(NSString *)labeStr
{
    if (!self.firstLabel)
    {
        self.firstLabel                           = [[UILabel alloc]init];
        self.firstLabel.font                      = [UIFont systemFontOfSize:15];
        self.firstLabel.textColor                 = kWhiteColor;
        self.firstLabel.textAlignment             = NSTextAlignmentCenter;
        self.firstLabel.backgroundColor           = kGrayTransparentColor2;
        self.firstLabel.layer.cornerRadius        = 11;
        self.firstLabel.layer.masksToBounds       = YES;
        CGFloat labelW                                = [labeStr boundingRectWithSize:CGSizeMake(MAXFLOAT, kTicketContrainerViewHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}  context:nil].size.width;
        self.firstLabel.frame                         = CGRectMake(0,kDefaultMargin, labelW+kTicketContrainerViewHeight, kTicketContrainerViewHeight);
    }
    else
    {
        CGFloat labelW                                = [labeStr boundingRectWithSize:CGSizeMake(MAXFLOAT, kTicketContrainerViewHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}  context:nil].size.width;
        CGRect rect           = self.firstLabel.frame;
        rect.size.width      = labelW + kTicketContrainerViewHeight;
        self.firstLabel.frame = rect;
    }
    self.firstLabel.text                          = labeStr;
    [self addSubview:self.firstLabel];
    [self relayoutMyselfViewFrame];
    
}

- (void)addSecondLabWithStr:(NSString *)labeStr
{
    if (!self.secondLabel)
    {
        self.secondLabel                           = [[UILabel alloc]init];
        self.secondLabel.font                      = [UIFont systemFontOfSize:15];
        self.secondLabel.textColor                 = kWhiteColor;
        self.secondLabel.textAlignment             = NSTextAlignmentCenter;
        self.secondLabel.backgroundColor           = kGrayTransparentColor2;
        self.secondLabel.layer.cornerRadius        = 11;
        self.secondLabel.layer.masksToBounds       = YES;
        CGFloat labelW                                 = [labeStr boundingRectWithSize:CGSizeMake(MAXFLOAT, kTicketContrainerViewHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}  context:nil].size.width;
        self.secondLabel.frame                         = CGRectMake(0, CGRectGetMaxY(self.firstLabel.frame)+8, labelW+kTicketContrainerViewHeight, kTicketContrainerViewHeight);
    }
//    else
//    {
//        CGFloat labelW                                = [labeStr boundingRectWithSize:CGSizeMake(MAXFLOAT, kTicketContrainerViewHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}  context:nil].size.width;
//        CGRect rect           = self.secondLabel.frame;
//        rect.size.height      = labelW + kTicketContrainerViewHeight;
//        self.secondLabel.frame = rect;
//    }
    self.secondLabel.text                          = labeStr;
    [self addSubview:self.secondLabel];
    [self relayoutMyselfViewFrame];
}

- (void)addThreeLabWithStr:(NSString *)labeStr
{
    if (!self.threeLabel)
    {
        self.threeLabel                           = [[UILabel alloc]init];
        self.threeLabel.font                      = [UIFont systemFontOfSize:15];
        self.threeLabel.textColor                 = kWhiteColor;
        self.threeLabel.textAlignment             = NSTextAlignmentCenter;
        self.threeLabel.backgroundColor           = kGrayTransparentColor2;
        self.threeLabel.layer.cornerRadius        = 11;
        self.threeLabel.layer.masksToBounds       = YES;
        CGFloat labelW                            = [labeStr boundingRectWithSize:CGSizeMake(MAXFLOAT, kTicketContrainerViewHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}  context:nil].size.width;
        self.threeLabel.frame                     = CGRectMake(0,CGRectGetMaxY(self.secondLabel.frame)+8, labelW+kTicketContrainerViewHeight, kTicketContrainerViewHeight);
    }
//    else
//    {
//        CGFloat labelW                            = [labeStr boundingRectWithSize:CGSizeMake(MAXFLOAT, kTicketContrainerViewHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}  context:nil].size.width;
//        CGRect rect           = self.threeLabel.frame;
//        rect.size.height      = labelW + kTicketContrainerViewHeight;
//        self.threeLabel.frame = rect;
//    }
    self.threeLabel.text                          = labeStr;
    [self addSubview:self.threeLabel];
    [self relayoutMyselfViewFrame];
}

- (void)removeFirstLabel
{
    if (self.firstLabel)
    {
        [self.firstLabel removeFromSuperview];
        self.firstLabel = nil;
    }
    [self relayoutMyselfViewFrame];
}

- (void)removeSecondLabel
{
    if (self.secondLabel)
    {
        [self.secondLabel removeFromSuperview];
        self.secondLabel = nil;
    }
    [self relayoutMyselfViewFrame];
}

- (void)removeThreeLabel
{
    if (self.threeLabel)
    {
        [self.threeLabel removeFromSuperview];
        self.threeLabel = nil;
    }
    [self relayoutMyselfViewFrame];
}

- (void)relayoutMyselfViewFrame
{
    self.myWidth     = 0.0;
    CGFloat labelW1  = 0.0;
    CGFloat labelW2  = 0.0;
    CGFloat labelW3  = 0.0;
    
    if (self.firstLabel)
    {
        labelW1= [self.firstLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, kTicketContrainerViewHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.width + kTicketContrainerViewHeight;
        self.myHeight = 30;
    }
    
    if (self.secondLabel)
    {
        labelW2= [self.secondLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, kTicketContrainerViewHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.width + kTicketContrainerViewHeight;
        if (self.firstLabel)
        {
            CGRect rect = self.secondLabel.frame;
            rect.origin.x = 0;
            rect.origin.y = CGRectGetMaxY(self.firstLabel.frame)+8;
            rect.size.width = labelW2;
            rect.size.height = kTicketContrainerViewHeight;
            self.secondLabel.frame = rect;
            self.myHeight = 60;
            
        }else
        {
            CGRect rect = self.secondLabel.frame;
            rect.origin.x = 0;
            rect.origin.y = kDefaultMargin;
            rect.size.width = labelW2;
            rect.size.height = kTicketContrainerViewHeight;
            self.secondLabel.frame = rect;
            self.myHeight = 30;
        }
    }
    
    if (self.threeLabel)
    {
        labelW3= [self.threeLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, kTicketContrainerViewHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.width + kTicketContrainerViewHeight;
        if (self.firstLabel && self.secondLabel)
        {
            CGRect rect      = self.threeLabel.frame;
            rect.origin.x    = 0;
            rect.origin.y    = CGRectGetMaxY(self.secondLabel.frame)+8;
            rect.size.width  = labelW3;
            rect.size.height = kTicketContrainerViewHeight;
            self.threeLabel.frame = rect;
            self.myHeight = 90;
        }else if (self.firstLabel && !self.secondLabel)
        {
            CGRect rect = self.threeLabel.frame;
            rect.origin.x = 0;
            rect.origin.y = CGRectGetMaxY(self.firstLabel.frame)+8;
            rect.size.width = labelW3;
            rect.size.height = kTicketContrainerViewHeight;
            self.threeLabel.frame = rect;
            self.myHeight = 60;
        }else if (!self.firstLabel && self.secondLabel)
        {
            CGRect rect = self.threeLabel.frame;
            rect.origin.x = 0;
            rect.origin.y = CGRectGetMaxY(self.secondLabel.frame)+8;
            rect.size.width = labelW3;
            rect.size.height = kTicketContrainerViewHeight;
            self.threeLabel.frame = rect;
            self.myHeight = 60;
        }
        else
        {
            CGRect rect = self.threeLabel.frame;
            rect.origin.x = 0;
            rect.origin.y = kDefaultMargin;
            rect.size.width = labelW3;
            rect.size.height = kTicketContrainerViewHeight;
            self.threeLabel.frame = rect;
            self.myHeight = 30;
        }
    }
    
    if (self.myWidth < labelW1)
    {
        self.myWidth = labelW1;
    }
    if (self.myWidth < labelW2)
    {
        self.myWidth = labelW2;
    }
    if (self.myWidth < labelW3)
    {
        self.myWidth = labelW3;
    }
    
    CGRect rect              = self.frame;
    rect.origin.x            = kDefaultMargin;
    rect.origin.y            = self.origin.y;
    rect.size.height         = self.myHeight;
    rect.size.width          = self.myWidth;
    self.frame               = rect;
    self.backgroundColor     = kClearColor;
}

- (void)updateMyFrameIsToUp:(BOOL)isUp andMyHeight:(CGFloat)myHeight
{
    [UIView animateWithDuration:0.6 animations:^{
        if (isUp == YES)
        {
            CGRect rect      =  self.frame;
            rect.origin.y    = rect.origin.y-myHeight;
            self.frame       = rect;
        }else
        {
            CGRect rect      =  self.frame;
            rect.origin.y    = rect.origin.y+myHeight;
            self.frame       = rect;
        }
    }];
}


@end
