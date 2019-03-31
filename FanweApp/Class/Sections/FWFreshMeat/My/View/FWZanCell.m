//
//  FWZanCell.m
//  FanweApp
//
//  Created by fanwe2014 on 2017/3/23.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "FWZanCell.h"
#import "CommentModel.h"
@implementation FWZanCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.headImgView.layer.cornerRadius = 20;
    self.headImgView.layer.masksToBounds = YES;
    self.headImgView.userInteractionEnabled = YES;
    self.nameLabel.textColor = kAppGrayColor1;
    
    self.lineView = [[UIView alloc]initWithFrame:CGRectMake(60, 69,kScreenW-60,1)];
    self.lineView.backgroundColor = kAppSpaceColor2;
    [self addSubview:self.lineView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ImgViewTap:)];
    [self.headImgView addGestureRecognizer:tap];
}

- (void)creatCellWithModel:(CommentModel *)CModel andRow:(int)row
{
    self.headImgView.tag = row;
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:CModel.head_image] placeholderImage:kDefaultPreloadHeadImg];
    if ([CModel.is_authentication intValue] != 2)
    {
        self.iconImgView.hidden = YES;
    }
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:CModel.nick_name];
    self.nameLabel.attributedText = attr;
}

#pragma mark 点击头像
- (void)ImgViewTap:(UITapGestureRecognizer *)tap
{
    if (self.ZHIDeleGate && [self.ZHIDeleGate respondsToSelector:@selector(ClickZanHeadImgViewWithTag:)])
    {
        [self.ZHIDeleGate ClickZanHeadImgViewWithTag:(int)tap.view.tag];
    }
}


@end
