//
//  RecommendTableViewCell.m
//  FanweApp
//
//  Created by 王珂 on 17/3/30.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "RecommendTableViewCell.h"

@implementation RecommendTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    _recommendLabel.textColor     = kAppGrayColor1;
    _recommendTypeField.textColor = kAppGrayColor4;
    _recommendField.textColor     = kAppGrayColor4;
    self.clipsToBounds            = YES;
}


+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"recommendCell";
    RecommendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
    }
    return cell;
}

- (IBAction)choseType:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(choseRecommendTypeWithRecommendViewCell:)])
    {
        [_delegate choseRecommendTypeWithRecommendViewCell:self];
    }
}

@end
