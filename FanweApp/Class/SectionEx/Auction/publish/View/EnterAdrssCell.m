//
//  EnterAdrssCell.m
//  O2O
//
//  Created by fanwe2014 on 15/7/28.
//  Copyright (c) 2015年 fanwe. All rights reserved.
//

#import "EnterAdrssCell.h"

@implementation EnterAdrssCell

- (void)awakeFromNib
{
    // Initialization code
    [super awakeFromNib];
    self.adressName.textColor=kAppGrayColor2;
    self.descriptionText.textColor=kAppGrayColor1;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"EnterAdrssCell";
    EnterAdrssCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setCellContent:(NSString *)adressName description:(NSString *)description{
    self.adressName.text = adressName;
    self.descriptionText.text = description;
}


@end
