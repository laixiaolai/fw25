//
//  SRedBagViewCell.m
//  FanweApp
//
//  Created by 丁凯 on 2017/7/15.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "SRedBagViewCell.h"

@implementation SRedBagViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.headView.layer.cornerRadius = 18;
    self.headView.layer.masksToBounds = YES;
    self.nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.lineView.backgroundColor = kAppSpaceColor4;
}


- (void)creatCellWithModel:(CustomMessageModel *)model andRow:(int)row
{
    NSString *string1 = model.nick_name;
    if (string1.length > 0)
    {
        NSMutableAttributedString *attr1 = [[NSMutableAttributedString alloc] initWithString:string1];
        [attr1 setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.0]} range:NSMakeRange(0, string1.length)];
        
        CGFloat width =[string1 sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}].width;
        if (width+120+32 > self.width)
        {
            width = self.width-120-32;
        }
        CGRect rect = self.nameLabel.frame;
        rect.size.width = width;
        self.nameLabel.frame = rect;
        self.nameLabel.attributedText = attr1;
    }
    self.moneyLabel.text = [NSString stringWithFormat:@"%d",(int)model.diamonds];
    if (row == 0)
    {
        self.goldView.hidden = NO;
        self.moneyLabelTopHeight.constant = 6;
        self.goldViewTopHeight.constant = 7;
    }else
    {
        self.goldView.hidden = YES;
        self.moneyLabelTopHeight.constant = 18;
        self.goldViewTopHeight.constant = 19;
    }
    if ([model.sex isEqualToString:@"1"])
    {
        self.sexView.image = [UIImage imageNamed:@"com_male_selected"];
    }else
    {
        self.sexView.image = [UIImage imageNamed:@"com_female_selected"];
    }
    [self.headView sd_setImageWithURL:[NSURL URLWithString:model.head_image] placeholderImage:kDefaultPreloadHeadImg];
}

@end
