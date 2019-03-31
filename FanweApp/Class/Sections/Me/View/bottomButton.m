//
//  bottomButton.m
//  FanweApp
//
//  Created by yy on 16/7/6.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "bottomButton.h"

@implementation bottomButton

- (instancetype)initWithFrame:(CGRect)frame  bothLabelHeight:(CGFloat)height imgName:(NSString *)imgName
{
    
    if (self = [super initWithFrame:frame]) {
        self.leftLabel  = [[UILabel alloc]initWithFrame:CGRectMake(kScreenW *0.0312, (frame.size.height-height)/2, frame.size.width/3, height)];
        
        self.rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(frame.size.width/2, (frame.size.height-height)/2, frame.size.width/2-kScreenW *0.0625, height)];
        
        self.leftLabel.textAlignment = NSTextAlignmentLeft;
        
        self.rightLabel.textAlignment =NSTextAlignmentRight;
        
        self.rightImage = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width-kScreenW *0.0468, (frame.size.height-kScreenH *0.0088)/2-kScreenH *0.003, kScreenW *0.0218, kScreenH *0.0176)];
        
        self.rightImage.image =[UIImage imageNamed:imgName];
        [self addSubview:self.leftLabel];
        [self addSubview:self.rightLabel];
        [self addSubview:self.rightImage];
    }
    return self;
    
}


@end
