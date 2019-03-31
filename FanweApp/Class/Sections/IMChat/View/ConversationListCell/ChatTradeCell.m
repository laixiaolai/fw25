//
//  ChatTradeCell.m
//  FanweApp
//
//  Created by 朱庆彬 on 2017/8/22.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "ChatTradeCell.h"

@implementation ChatTradeCell

{
    BOOL _select;
}
- (void)awakeFromNib
{
    [super awakeFromNib];

    self.mMsg_LabRight_Constraint.constant = 8;
    [self.mheadimg.layer setMasksToBounds:YES];
    [self.mheadimg.layer setCornerRadius:45 / 2];
    self.mheadimg.layer.borderWidth = 1;
    self.mheadimg.layer.borderColor = [UIColor whiteColor].CGColor;
    self.mmsg.font = kAppMiddleTextFont;
}

//判断信息的高度
- (CGFloat)judge:(NSString *)msg
{

    CGFloat msgHeight = [self boundingRectWithSize:msg withLabelWidth:kScreenW - 69];

    NSString *str1 = @"1";
    CGFloat height = [self boundingRectWithSize:str1 withLabelWidth:kScreenW - 69];

    if (msgHeight == height)
    {
        [self.mdownImg setHidden:YES]; //隐藏
    }
    else
    {
        [self.mdownImg setHidden:NO];
        self.mMsg_LabRight_Constraint.constant = 38;
    }

    return msgHeight;
}

//计算文本高度
- (CGFloat)boundingRectWithSize:(NSString *)str withLabelWidth:(CGFloat)width
{
    //69是约束的长度
    CGRect rect = [str boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName: kAppMiddleTextFont } context:nil];

    CGFloat height = rect.size.height;

    return height;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//cell是否展开 0未展开1展开
- (void)setContentFlag:(NSString *)contentFlag
{

    if ([contentFlag isEqualToString:@"0"])
    {
        _mmsg.numberOfLines = 1;
        CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI * 2);
        _mdownImg.transform = transform;
    }
    else
    {
        _mmsg.numberOfLines = 0;
        CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI);
        _mdownImg.transform = transform;
    }
}

@end
