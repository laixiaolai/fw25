//
//  CustomButton.m
//  自定义Button
//
//  Created by sunbk on 16/7/6.
//  Copyright © 2016年 xingyuan. All rights reserved.

#import "CustomButton.h"

@implementation CustomButton

- (instancetype)initWithFrame:(CGRect)frame  bothLabelHeight:(CGFloat)height imgName:(NSString *)imgName
{
    if (self = [super initWithFrame:frame])
    {
        self.customImgView  = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imgName]];
        self.customImgView.center = CGPointMake(frame.size.width/2.0, (frame.size.height - height)/2.0);
        self.leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenW *0.0312, frame.size.height-height-kScreenH *0.0176, frame.size.width*0.6, height)];
        self.leftLabel.textAlignment = NSTextAlignmentLeft;
        self.rightButton = [[UIButton alloc]initWithFrame:CGRectMake(frame.size.width*0.25+kScreenW *0.0312, frame.size.height-height-kScreenH *0.0176,frame.size.width-frame.size.width*0.25-kScreenW *0.0312, height)];
        self.rightButton.titleLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.customImgView];
        [self addSubview:self.leftLabel];
        [self addSubview:self.rightButton];
    }
    return self;
}

@end
