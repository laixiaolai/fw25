//
//  GameDistributionCell.m
//  FanweApp
//
//  Created by 王珂 on 17/4/5.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "GameDistributionCell.h"

@implementation GameDistributionCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.headImageView.layer.cornerRadius =20;
    self.headImageView.layer.masksToBounds = YES;
    self.nameLabel.textColor = kAppGrayColor1;
    self.incomeLabel.textColor = kAppGrayColor1;
    self.lineView.backgroundColor = kAppSpaceColor3;
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"gameDistrCell";
    GameDistributionCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setModel:(GameUserModel *)model
{
    _model = model;
    //如果是上级则隐藏其收益相关的信息
    //self.icomeStyleImg.hidden = model.isParent;
    self.icomeStyleImg.hidden = YES;
    self.incomeLabel.hidden = model.isParent;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.head_image] placeholderImage:kDefaultPreloadHeadImg];
    NSString *nameString;
    if (model.nick_name.length < 1)
    {
        nameString = @"暂时还未命名";
    }else
    {
        nameString = model.nick_name;
    }
    self.nameLabel.text = nameString;
    self.incomeLabel.text = model.sum;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
