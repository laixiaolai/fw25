//
//  GoodsDetailsCell.m
//  FanweApp
//
//  Created by fanwe2014 on 16/10/15.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "GoodsDetailsCell.h"

@implementation GoodsDetailsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.buttonCount = 0;
        // self.fanweApp = [GlobalVariables sharedInstance];
        self.detailLabel = [[UILabel alloc]init];
        self.detailLabel.frame = CGRectMake(10, 0, kScreenW-65, 50);
        self.detailLabel.numberOfLines = 1;
        self.detailLabel.text = @"拍品详情";
        self.detailLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        self.detailLabel.textColor = kAppGrayColor1;
        [self addSubview:self.detailLabel];
        
        //        self.lineView = [[UIView alloc]initWithFrame:CGRectMake(10, 48, kScreenW-10, 1)];
        //        self.lineView.backgroundColor = kGrayTransparentColor1;
        //        [self addSubview:self.lineView];
        
        self.downUpImgView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenW-27, 20, 17, 9)];
        self.downUpImgView.image = [UIImage imageNamed:@"com_arrow_down_2"];
        [self addSubview:self.downUpImgView];
        
        self.clickButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.clickButton.frame = CGRectMake(kScreenW-65,0,55,50);
        self.clickButton.backgroundColor = kClearColor;
        [self.clickButton addTarget:self action:@selector(changeHeight:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.clickButton];
        
    }
    return self;
}

- (void)setCellWitCount:(int)count
{
    self.buttonCount = count;
}

- (void)changeHeight:(UIButton *)button
{
    if (self.buttonCount == 0)
    {
        self.buttonCount = 1;
        self.downUpImgView.image = [UIImage imageNamed:@"com_arrow_up_1"];
        //[self.clickButton setTitle:@"[收起]" forState:UIControlStateNormal];
        
    }else
    {
        self.buttonCount = 0;
        self.downUpImgView.image = [UIImage imageNamed:@"com_arrow_down_2"];
        //[self.clickButton setTitle:@"[展开]" forState:UIControlStateNormal];
        
    }
    
    if (self.delegate)
    {
        if ([self.delegate respondsToSelector:@selector(getCellHeightWithCount:)])
        {
            [self.delegate getCellHeightWithCount:self.buttonCount];
        }
    }
}



@end
