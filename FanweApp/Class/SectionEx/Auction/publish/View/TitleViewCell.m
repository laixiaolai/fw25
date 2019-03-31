//
//  TitleViewCell.m
//  FanweApp
//
//  Created by fanwe2014 on 16/11/7.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "TitleViewCell.h"

@implementation TitleViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.titleLabel.textColor = kAppGrayColor1;
    self.titleLabel.numberOfLines = 0;
    [self.titleLabel sizeToFit];
}

- (CGFloat)setCellWithString:(NSString *)string
{
    NSString *nameString = [NSString stringWithFormat:@"%@",string];;
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:nameString];
    [attr setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.0]} range:NSMakeRange(0,nameString.length)];
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
    
    CGFloat height = [nameString boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 10, 10000000) options:NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size.height;
    CGRect rect = self.titleLabel.frame;
    rect = CGRectMake(10, 5, kScreenW-10, height+10);
    self.titleLabel.frame = rect;
    self.titleLabel.attributedText = attr;
    return height+20;
}

@end
