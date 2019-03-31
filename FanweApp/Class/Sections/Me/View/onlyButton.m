//
//  onlyButton.m
//  FanweApp
//
//  Created by yy on 16/7/14.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "onlyButton.h"

@implementation onlyButton

- (instancetype)initWithFrame:(CGRect)frame  bothLabelHeight:(CGFloat)height imgName:(NSString *)imgName
{
    
    if (self = [super initWithFrame:frame]) {
        self.customImgView  = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imgName]];
        
        self.customImgView.center = CGPointMake(frame.size.width/2.0, (frame.size.height - height)/2.0);
        
        self.leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenW *0.0312, frame.size.height-height-kScreenH *0.0176, frame.size.width*0.25, height)];
        self.leftLabel.textAlignment = NSTextAlignmentLeft;
        
        self.imageLabel =[[UILabel alloc]initWithFrame:CGRectMake(frame.size.width*0.25+kScreenW *0.0312, frame.size.height-height-kScreenH *0.0176, frame.size.width-frame.size.width*0.25-kScreenW *0.0312-kScreenW *0.078, height)];
        
        self.rightButton = [[UIButton alloc]initWithFrame:CGRectMake(frame.size.width-kScreenW *0.078, frame.size.height-height-kScreenH *0.015,kScreenW *0.078, height)];
        
        self.imageLabel.textAlignment = NSTextAlignmentRight;
        
        [self addSubview:self.imageLabel];
        [self addSubview:self.customImgView];
        [self addSubview:self.leftLabel];
        [self addSubview:self.rightButton];
    }
    return self;
    
}


@end
