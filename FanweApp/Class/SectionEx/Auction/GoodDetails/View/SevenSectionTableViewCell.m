//
//  SevenSectionTableViewCell.m
//  FanweApp
//
//  Created by fanwe2014 on 16/8/5.
//  Copyright © 2016年 xfg. All rights reserved.

#import "SevenSectionTableViewCell.h"

@implementation SevenSectionTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.titleLabel = [[UILabel alloc]init];
        self.titleLabel.textColor = kAppGrayColor5;
        self.titleLabel.numberOfLines = 0;
        [self.titleLabel sizeToFit];
        [self addSubview:self.titleLabel];
    }
    return self;
}

- (CGFloat)setCellWithString:(NSString *)string
{
    NSString *nameString = [NSString stringWithFormat:@"竞拍名称:%@",string];;
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:nameString];
    [attr setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17.0]} range:NSMakeRange(0,nameString.length)];
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:17]};
    
    CGFloat height = [nameString boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 10, 10000000) options:NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size.height;
    NSLog(@"height==%f",height);
    // CGFloat height =[nameString sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]}].height;
    self.titleLabel.frame = CGRectMake(10, 0, kScreenW-10, height+15);
    self.titleLabel.attributedText = attr;
    return height+15;
}

@end
