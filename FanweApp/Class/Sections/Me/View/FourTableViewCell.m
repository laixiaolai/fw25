//
//  FourTableViewCell.m
//  FanweApp
//
//  Created by fanwe2014 on 16/7/22.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "FourTableViewCell.h"


@implementation FourTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    
    self.nameLabel.textColor = self.nameLabel2.textColor = self.nameLabel3.textColor = kAppGrayColor2;
    
    self.headImgView1.userInteractionEnabled =self.headImgView2.userInteractionEnabled = self.headImgView3.userInteractionEnabled = YES;
    
    self.headImgView1.contentMode = self.headImgView2.contentMode = self.headImgView3.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.headImgView1 addGestureRecognizer:tap1];
    [self.headImgView2 addGestureRecognizer:tap2];
    [self.headImgView3 addGestureRecognizer:tap3];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    
}

- (void)creatCellWithAuthentication:(int)authentication andHeadImgStr1:(NSString *)string1 andHeadImgStr2:(NSString *)string2 andHeadImgStr3:(NSString *)string3 andUrlStr:(NSString *)urlStr
{
    if (authentication == 1 || authentication == 2 || authentication == 3)
    {
        [self.headImgView1 sd_setImageWithURL:[NSURL URLWithString:string1] placeholderImage:[UIImage imageNamed:@"me_addPhoto"]];
        [self.headImgView2 sd_setImageWithURL:[NSURL URLWithString:string2] placeholderImage:[UIImage imageNamed:@"me_addPhoto"]];
         [self.headImgView3 sd_setImageWithURL:[NSURL URLWithString:string3] placeholderImage:[UIImage imageNamed:@"me_addPhoto"]];
        if (authentication == 3)
        {
            self.headImgView1.userInteractionEnabled = YES;
            self.headImgView2.userInteractionEnabled = YES;
            self.headImgView3.userInteractionEnabled = YES;
        }else
        {
            self.headImgView1.userInteractionEnabled = NO;
            self.headImgView2.userInteractionEnabled = NO;
            self.headImgView3.userInteractionEnabled = NO;
        }
   
    }else
    {
        self.headImgView1.userInteractionEnabled = YES;
        self.headImgView2.userInteractionEnabled = YES;
        self.headImgView3.userInteractionEnabled = YES;
    }
    
    if (urlStr.length)
    {
        [self.imgView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:kDefaultPreloadHeadImg];
    }else
    {
        self.imgView.hidden = NO;
    }
}

- (void)tap:(UITapGestureRecognizer *)tap
{
    if (self.delegate)
    {
        if ([self.delegate respondsToSelector:@selector(getImgWithtag:andCell:)])
        {
            [self.delegate getImgWithtag:(int)tap.view.tag andCell:self];
        }
    }
}

@end
