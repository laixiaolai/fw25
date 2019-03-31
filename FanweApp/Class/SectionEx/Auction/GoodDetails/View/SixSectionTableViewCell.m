//
//  SixSectionTableViewCell.m
//  FanweApp
//
//  Created by fanwe2014 on 16/8/5.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "SixSectionTableViewCell.h"

@implementation SixSectionTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.pointTimeLabel = [[UILabel alloc]init];
    self.pointTimeLabel.font = [UIFont systemFontOfSize:14];
    self.pointTimeLabel.numberOfLines = 0;
    self.pointTimeLabel.textColor = kAppGrayColor1;
    
    self.pointPlaceLabel = [[UILabel alloc]init];
    self.pointPlaceLabel.font = [UIFont systemFontOfSize:14];
    self.pointPlaceLabel.numberOfLines = 0;
    self.pointPlaceLabel.textColor = kAppGrayColor1;
    
    [self.pointTimeLabel sizeToFit];
    [self.pointPlaceLabel sizeToFit];
    
    [self addSubview:self.pointPlaceLabel];
    [self addSubview:self.pointTimeLabel];
}

- (CGFloat)setCellWithPlace:(NSString *)palceString andPlace:(NSString *)timeString
{
    if (palceString.length<1)
    {
        palceString = @"约会地点: 福建省 厦门市 万达广场";
    }else
    {
        palceString = [NSString stringWithFormat:@"约会地点: %@",palceString];
    }
    
    if (timeString.length<1)
    {
        timeString = @"约会时间: 2016年06月06日 18:00";
    }else
    {
        timeString = [NSString stringWithFormat:@"约会时间: %@",timeString];
    }
    
    //约会地点
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
    // 参数1代表文字自适应的范围，参数2代表文字自适应的方式（前三种），参数3代表文字在自适应过程中以多大的字体作为依据
    CGFloat height = [palceString boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 10, 10000000) options:NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size.height;
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:palceString];
    [attr setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.0]} range:NSMakeRange(0, palceString.length)];
    // CGFloat height =[palceString sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}].height;
    self.pointPlaceLabel.frame = CGRectMake(10, 10, kScreenW-10, height);
    self.pointPlaceLabel.attributedText = attr;
    
    
    //约会时间
    NSMutableAttributedString *attr1 = [[NSMutableAttributedString alloc] initWithString:timeString];
    [attr1 setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0]} range:NSMakeRange(0, timeString.length)];
    self.pointTimeLabel.frame = CGRectMake(10, 5+self.pointPlaceLabel.frame.size.height+self.pointPlaceLabel.frame.origin.y, kScreenW-10, 20);
    self.pointTimeLabel.attributedText = attr1;
    
    CGRect rect = self.frame;
    rect.size.height = self.pointTimeLabel.frame.size.height+self.pointTimeLabel.frame.origin.y+10;
    self.frame = rect;
    
    return self.frame.size.height;
    
}




@end
