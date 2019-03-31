//
//  ToolsCollectionViewCell.m
//  FanweApp
//
//  Created by xfg on 2017/6/1.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "ToolsCollectionViewCell.h"

@implementation ToolsCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.toolImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, kDefaultMargin, CGRectGetWidth(self.frame)-kDefaultMargin*2, CGRectGetWidth(self.frame)-kDefaultMargin*2)];
        self.toolImgView.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:self.toolImgView];
        
        self.toolLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.toolImgView.frame)+kDefaultMargin, CGRectGetWidth(self.frame)-kDefaultMargin*2, 20)];
        self.toolLabel.textAlignment = NSTextAlignmentCenter;
        self.toolLabel.font = kAppSmallTextFont;
        self.toolLabel.textColor = kWhiteColor;
        [self addSubview:self.toolLabel];
    }
    return self;
}

@end
