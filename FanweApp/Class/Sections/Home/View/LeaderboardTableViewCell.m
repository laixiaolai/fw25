//
//  LeaderboardTableViewCell.m
//  FanweApp
//
//  Created by yy on 16/10/11.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "LeaderboardTableViewCell.h"

@implementation LeaderboardTableViewCell
{
    GlobalVariables *_fanweApp;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    _fanweApp = [GlobalVariables sharedInstance];
    self.nameLabel.textColor = kAppGrayColor1;
    self.numLabel.layer.cornerRadius = 2;
    self.numLabel.clipsToBounds = YES;
    self.ticketLabel.textColor = kAppGrayColor3;
}

- (void)createCellWithModel:(UserModel *)model withRow:(int)row withType:(int)type
{
    self.headImgView.layer.cornerRadius = 20;
    self.headImgView.layer.masksToBounds = YES;
    
    //名次
    self.numLabel.text = [NSString stringWithFormat:@"%d",row+4];
    //昵称
    self.nameLabel.text = model.nick_name;
    //头像
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:model.head_image] placeholderImage:kDefaultPreloadHeadImg];
    //认证
    if ([model.is_authentication intValue] == 2)
    {
        self.vImgView.hidden = NO;
        [self.vImgView sd_setImageWithURL:[NSURL URLWithString:model.v_icon]];
    }
    else
    {
        self.vImgView.hidden = YES;
    }
    //性别
    if ([model.sex isEqualToString:@"1"])
    {
        self.sexImgView.image = [UIImage imageNamed:@"com_male_selected"];
    }
    else
    {
        self.sexImgView.image = [UIImage imageNamed:@"com_female_selected"];
    }
    //等级
    if ([model.user_level intValue] !=0)
    {
        self.rankImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"rank_%@",model.user_level]];
    }
    else
    {
        self.rankImgView.image = [UIImage imageNamed:@"rank_1"];
    }
    //善券
    NSString *string = type > 3 ? @"消费" : @"获得";
    NSString *ticketName = type > 3 ? _fanweApp.appModel.diamond_name : _fanweApp.appModel.ticket_name;
    self.ticketLabel.text = [NSString stringWithFormat:@"%@%@%@",string ,model.ticket,ticketName];
}

@end
