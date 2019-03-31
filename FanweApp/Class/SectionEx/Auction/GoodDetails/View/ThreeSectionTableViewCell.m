//
//  ThreeSectionTableViewCell.m
//  FanweApp
//
//  Created by fanwe2014 on 16/8/5.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "ThreeSectionTableViewCell.h"

@implementation ThreeSectionTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.nameLabel.textColor = kAppGrayColor1;
    self.lineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-1, kScreenW, 1)];
    self.lineView.backgroundColor = kAppSpaceColor4;
    [self addSubview:self.lineView];
}

- (void)creatCellWithNum:(int)count
{
    self.nameLabel.text =[NSString stringWithFormat:@"竞拍记录 (%d)",count];
}

@end
