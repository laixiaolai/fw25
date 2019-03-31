//
//  HMHotTableViewCell.m
//  FanweApp
//
//  Created by xfg on 2017/7/5.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "HMHotTableViewCell.h"

@implementation HMHotTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.fanweApp = [GlobalVariables sharedInstance];
    self.headImgBtn.layer.borderWidth = 1;
    self.headImgBtn.layer.borderColor = [kAppGrayColor4 CGColor];
    self.headImgBtn.layer.cornerRadius = CGRectGetWidth(self.headImgBtn.frame) / 2;
    self.headImgBtn.clipsToBounds = YES;
    
    self.userNameLabel.textColor = kAppGrayColor1;
    
    self.areaLabel.backgroundColor = kAppMainColor;
    self.areaLabel.layer.masksToBounds = YES;
    self.areaLabel.edgeInsets = UIEdgeInsetsMake(0 , 8, 0, 8);    // 设置内边距
    self.areaLabel.layer.cornerRadius = 8;
    
    self.watchNumLabel.textColor = kAppGrayColor3;
    
    self.liveStateLabel.layer.borderWidth = 1;
    self.liveStateLabel.clipsToBounds = YES;
    self.liveStateLabel.layer.cornerRadius = 10;
    self.liveStateLabel.layer.borderColor = kWhiteColor.CGColor;
    self.liveStateLabel.textColor = [UIColor whiteColor];
    self.liveStateLabel.backgroundColor = kGrayTransparentColor2_1;
    self.liveStateLabel.edgeInsets = UIEdgeInsetsMake(0 , 15, 0, 15);   // 设置内边距
    [self.liveStateLabel sizeToFit];                                    // 重新计算尺寸
    
    self.livePriceLabel.layer.borderWidth = 1;
    self.livePriceLabel.clipsToBounds = YES;
    self.livePriceLabel.layer.cornerRadius = 10;
    self.livePriceLabel.layer.borderColor = kWhiteColor.CGColor;
    self.livePriceLabel.textColor = [UIColor whiteColor];
    self.liveStateLabel.backgroundColor = kGrayTransparentColor2_1;
    self.liveStateLabel.edgeInsets = UIEdgeInsetsMake(0 , 15, 0, 15);   // 设置内边距
    [self.livePriceLabel sizeToFit];                                    // 重新计算尺寸
    
    self.gameStateLabel.layer.borderWidth = 1;
    self.gameStateLabel.clipsToBounds = YES;
    self.gameStateLabel.layer.cornerRadius = 10;
    self.gameStateLabel.layer.borderColor = kWhiteColor.CGColor;
    self.gameStateLabel.textColor = [UIColor whiteColor];
    self.gameStateLabel.backgroundColor = kGrayTransparentColor2_1;
    self.gameStateLabel.edgeInsets = UIEdgeInsetsMake(0 , 15, 0, 15);   // 设置内边距
    [self.gameStateLabel sizeToFit];                                    // 重新计算尺寸
    
    self.lineLabel.backgroundColor = kBackGroundColor;
    
    self.liveDecLabel.textColor = RGB(167, 167, 167);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)initWidthModel:(HMHotItemModel *)hotItemModel rowIndex:(NSInteger)rowIndex
{
    _rowIndex = rowIndex;
    
    [self.headImgBtn sd_setImageWithURL:[NSURL URLWithString:hotItemModel.head_image] forState:UIControlStateNormal placeholderImage:kDefaultPreloadHeadImg];
    
    FWWeakify(self)
    [self.headImgBtn setClickAction:^(id<MenuAbleItem> menu) {
        
        FWStrongify(self)
        if ([self.delegate respondsToSelector:@selector(clickUserIcon:)])
        {
            [self.delegate clickUserIcon:_rowIndex];
        }
        
    }];
    
    [self.autImgView sd_setImageWithURL:[NSURL URLWithString:hotItemModel.v_icon] placeholderImage:nil];
    self.userNameLabel.attributedText = [[NSMutableAttributedString alloc] initWithString:hotItemModel.nick_name];
    self.areaLabel.text = hotItemModel.city;
    self.watchNumLabel.text = [NSString stringWithFormat:@"%@ 在看",hotItemModel.watch_number];
    [self.liveImgView sd_setImageWithURL:[NSURL URLWithString:hotItemModel.live_image] placeholderImage:nil];
    if (![FWUtils isBlankString:hotItemModel.title])
    {
        self.liveDecLabel.attributedText = [[NSMutableAttributedString alloc] initWithString:hotItemModel.title];
    }
    
    if (hotItemModel.is_live_pay)
    {
        if (hotItemModel.live_in == FW_LIVE_STATE_ING && [hotItemModel.is_live_pay isEqualToString:@"0"])
        {
            self.livePriceLabel.hidden = YES;
            self.gameStateSpaceTopLayout.constant = 26;
        }
        else if (hotItemModel.live_in == FW_LIVE_STATE_RELIVE && [hotItemModel.is_live_pay isEqualToString:@"0"])
        {
            self.livePriceLabel.hidden = YES;
            self.gameStateSpaceTopLayout.constant = 26;
        }
        else if (hotItemModel.live_in == FW_LIVE_STATE_ING && [hotItemModel.is_live_pay isEqualToString:@"1"])
        {
            self.livePriceLabel.hidden = NO;
            self.gameStateSpaceTopLayout.constant = 52;
            if ([hotItemModel.live_pay_type isEqualToString:@"1"])
            {
                self.livePriceLabel.text = [NSString stringWithFormat:@"%@%@/场",hotItemModel.live_fee,self.fanweApp.appModel.diamond_name];
            }
            else
            {
                self.livePriceLabel.text = [NSString stringWithFormat:@"%@%@/分钟",hotItemModel.live_fee,self.fanweApp.appModel.diamond_name];
            }
        }
        else if (hotItemModel.live_in == FW_LIVE_STATE_RELIVE && [hotItemModel.is_live_pay isEqualToString:@"1"])
        {
            self.livePriceLabel.hidden = NO;
            self.gameStateSpaceTopLayout.constant = 52;
            if ([hotItemModel.live_pay_type isEqualToString:@"1"])
            {
                self.livePriceLabel.text = [NSString stringWithFormat:@"%@%@/场",hotItemModel.live_fee,self.fanweApp.appModel.diamond_name];
            }
            else
            {
                self.livePriceLabel.text = [NSString stringWithFormat:@"%@%@/分钟",hotItemModel.live_fee,self.fanweApp.appModel.diamond_name];
            }
        }
    }
    else
    {
        self.livePriceLabel.hidden = YES;
        self.gameStateSpaceTopLayout.constant = 26;
    }
    
    if (![FWUtils isBlankString:hotItemModel.live_state])
    {
        self.liveStateLabelHeight.constant = 20;
        self.liveStateLabelSpaceTop.constant = 13;
        self.liveStateLabel.hidden = NO;
        self.liveStateLabel.text = hotItemModel.live_state;
    }else
    {
        self.liveStateLabelHeight.constant = 0;
        self.liveStateLabelSpaceTop.constant = 0;
        self.liveStateLabel.hidden = YES;
    }
    
    if ([hotItemModel.title isEqualToString:@""])
    {
        self.liveDecLabel.hidden = YES;
        self.noDecLayout.constant = 0;
    }
    else
    {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleToTopicVC:)];
        [self.liveDecLabel addGestureRecognizer:tap];
        
        self.liveDecLabel.hidden = NO;
        self.noDecLayout.constant = 42;
    }
    
    if ([hotItemModel.is_gaming isEqualToString:@"1"])
    {
        self.gameStateLabel.hidden = NO;
        if (![FWUtils isBlankString:hotItemModel.game_name])
        {
            self.gameStateLabel.text = hotItemModel.game_name;
        }
    }
    else
    {
        self.gameStateLabel.hidden = YES;
    }
    
    [self layoutIfNeeded];
}

#pragma mark -- 点击话题题目的点击事件
- (void)handleToTopicVC:(UITapGestureRecognizer *)tap
{
    if ([self.delegate respondsToSelector:@selector(pushToTopic:)])
    {
        [self.delegate pushToTopic:_rowIndex];
    }
}

@end
