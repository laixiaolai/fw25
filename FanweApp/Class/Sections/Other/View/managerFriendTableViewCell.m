//
//  managerFriendTableViewCell.m
//  FanweApp
//
//  Created by fanwe2014 on 16/6/30.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "managerFriendTableViewCell.h"
#import "SenderModel.h"

@implementation managerFriendTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];

    self.headImgView.layer.cornerRadius = 25*kAppRowHScale;
    self.headImgView.layer.masksToBounds = YES;
    
    self.rightImgView.layer.cornerRadius = 15*kAppRowHScale;
    self.rightImgView.layer.masksToBounds = YES;
    self.nameLabel.textColor    =    kAppGrayColor1;
    self.commentLabel.textColor = kAppGrayColor3;
    self.lineView.backgroundColor = kAppSpaceColor4;
    
}

- (void)creatCellWithModel:(SenderModel *)model 
{
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:model.head_image] placeholderImage:kDefaultPreloadHeadImg];
    if (model.nick_name.length < 1)
    {
        model.nick_name = @"暂时还未命名";
    }
    self.nameLabel.textColor = kAppGrayColor1;
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:model.nick_name];
    self.nameLabel.attributedText = attr;
    
    if ([model.sex isEqualToString:@"1"])
    {
        self.sexImgView.image = [UIImage imageNamed:@"com_male_selected"];
    }else
    {
        self.sexImgView.image = [UIImage imageNamed:@"com_female_selected"];
    }
    self.rankImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"rank_%d",(int)model.user_level]];
    
    self.commentLabel.textColor = [UIColor blackColor];
    if (model.signature.length < 1)
    {
        self.commentLabel.text = @"";
    }else
    {
        NSMutableAttributedString *attr1 = [[NSMutableAttributedString alloc] initWithString:model.signature];
        self.commentLabel.attributedText = attr1;
    }
    
}


@end
