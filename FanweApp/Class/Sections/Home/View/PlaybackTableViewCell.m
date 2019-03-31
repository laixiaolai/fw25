//
//  PlaybackTableViewCell.m
//  FanweApp
//
//  Created by GuoMs on 16/7/4.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "PlaybackTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "HMHotItemModel.h"

@implementation PlaybackTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.userIMg.clipsToBounds = YES;
    self.userIMg.layer.borderWidth = 1;
    self.userIMg.layer.borderColor =  kAppBorderColor;
    self.userIMg.userInteractionEnabled = YES;
    
    self.backPlay.backgroundColor = RGB(255, 117, 81);
    self.levelImg.layer.masksToBounds = YES;
    self.levelImg.layer.cornerRadius = 15 / 2;
    UITapGestureRecognizer *tapPhoto = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleToMian:)];
    [self.userIMg addGestureRecognizer:tapPhoto];
    
    self.lineView.backgroundColor = kAppSpaceColor;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.userIMg.layer.cornerRadius = CGRectGetHeight(self.userIMg.frame)/2;
}

#pragma mark 点击头像到主页
- (void)handleToMian:(UITapGestureRecognizer *)tap
{
    if ([self.delegate respondsToSelector:@selector(handleWithPlayBackMainPage:index:)])
    {
        NSInteger tag = tap.view.tag;
        [self.delegate handleWithPlayBackMainPage:tap index:tag];
    }
}

- (void)setValueForCell:(HMHotItemModel *)model index:(NSInteger)tag
{
    self.userIMg.tag = tag;
    [self.userIMg sd_setImageWithURL:[NSURL URLWithString:model.head_image] placeholderImage:nil];
    
    self.userName.attributedText = [[NSMutableAttributedString alloc] initWithString:model.nick_name];
    
    self.SayLable.attributedText = [[NSMutableAttributedString alloc] initWithString:model.title];
    
    self.timeLable.text = model.begin_time_format;
    self.watchNamber.text = model.watch_number_format;
    [self.levelImg sd_setImageWithURL:[NSURL URLWithString:model.v_icon] placeholderImage:nil];
}

@end
