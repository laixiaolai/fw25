//
//  ProtocolTableViewCell.m
//  FanweApp
//
//  Created by fanwe2014 on 16/8/10.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "ProtocolTableViewCell.h"

@implementation ProtocolTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.buttomView = [[UIView alloc]init];
        self.nameLabel = [[UILabel alloc]init];
        self.protocolButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:self.buttomView];
        [self.buttomView addSubview:self.nameLabel];
        [self.buttomView addSubview:self.protocolButton];
        
        NSString *string = @"竞拍需同意 XXX 竞拍协议";
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:string];
        [attr setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.0]} range:NSMakeRange(0, string.length)];
        CGFloat width =[string sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}].width;
        self.nameLabel.frame = CGRectMake(0,5,width, 30);
        self.nameLabel.attributedText = attr;
        self.protocolButton.frame = CGRectMake(width+5,0,60, 40);
        [self.protocolButton setTitle:@"查看协议" forState:0];
        [self.protocolButton setTitleColor:kBlueColor forState:0];
        self.protocolButton.titleLabel.font = [UIFont systemFontOfSize:14];
        self.buttomView.frame = CGRectMake(kScreenW/2-(width+65)/2, 0, width+65, 40);
        
        [self.protocolButton addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)buttonClick
{
    if (self.delegate)
    {
        if ([self.delegate respondsToSelector:@selector(goToProtocolController)])
        {
            [self.delegate goToProtocolController];
        }
    }
}


@end
