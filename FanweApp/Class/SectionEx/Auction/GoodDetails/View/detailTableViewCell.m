//
//  detailTableViewCell.m
//  FanweApp
//
//  Created by lxt2016 on 16/11/29.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "detailTableViewCell.h"

@implementation detailTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, kScreenW-10, 45)];
        self.detailLabel.numberOfLines = 0;
        self.detailLabel.textColor = kAppGrayColor1;
        self.detailLabel.font = [UIFont systemFontOfSize:14];
        self.detailLabel.text = @"拍品详情";
        [self addSubview:self.detailLabel];
        //        self.lineView = [[UIView alloc]init];
        //        self.lineView.backgroundColor = kAppSpaceColor4;
        //        [self addSubview:self.lineView];
    }
    return self ;
}

- (CGFloat)setCellWithString:(NSString *)string
{
    NSString *detailString = [NSString stringWithFormat:@"拍品详情:%@",string];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:detailString];
    [attr setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.0]} range:NSMakeRange(0, detailString.length)];
    
    //约会地点
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
    // 参数1代表文字自适应的范围，参数2代表文字自适应的方式（前三种），参数3代表文字在自适应过程中以多大的字体作为依据
    CGFloat height = [detailString boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 10, 10000000) options:NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size.height;
    //    self.detailLabel.frame = CGRectMake(10, 0, kScreenW-10, height+10);
    self.detailLabel.attributedText = attr;
    
    //    self.lineView.frame = CGRectMake(0, height+10, kScreenW, 1);
    //    [self addSubview:self.lineView];
    return height+10;
}

@end
