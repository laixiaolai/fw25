//
//  DailyQuestCell.m
//  PopupViewWindow
//
//  Created by 杨仁伟 on 2017/5/22.
//  Copyright © 2017年 yrw. All rights reserved.
//

#import "DailyQuestCell.h"
#import "BMListModel.h"

@implementation DailyQuestCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.distanceTopConstant.constant    = self.distanceTopConstant.constant * kAppRowHScale;
    self.imgDistanceTopConstant.constant = self.imgDistanceTopConstant.constant * kAppRowHScale;
    self.receiveBtnWConstant.constant    = self.receiveBtnWConstant.constant * kScaleWidth;
    self.receiveBtnHconstant.constant    = self.receiveBtnHconstant.constant * kAppRowHScale;
    self.receiveBtn.layer.cornerRadius   = 3;
    self.viewVideoLbl.font               = [UIFont systemFontOfSize:15];
    self.viewVideoLbl.textColor          = kAppGrayColor1;
    self.rewardLbl.textColor             = RGB(255, 95, 95);
    self.rewardLbl.font                  = [UIFont systemFontOfSize:13];
}

- (void)configDailyQuestWithImgArray:(NSMutableArray *)imgArray taskArray:(NSMutableArray *)taskArray currentIndexPath:(NSInteger)currentIndexPath
{
    self.img.image = [UIImage imageNamed:imgArray[currentIndexPath]];
    self.viewVideoLbl.text = taskArray[currentIndexPath];
}

- (void)creatCellWithModel:(BMListModel *)listModel andRow:(int)row
{
    [self.img sd_setImageWithURL:[NSURL URLWithString:listModel.image] placeholderImage:kDefaultPreloadHeadImg];
    self.viewVideoLbl.text = listModel.title;
    self.rewardLbl.text = listModel.desc;
    self.receiveBtn.tag = row;
    
    if ([listModel.left_times intValue] == 0)
    {
        self.receiveBtn.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        self.receiveBtn.layer.cornerRadius = 3;
        self.receiveBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
        self.receiveBtn.userInteractionEnabled = NO;
        [self.receiveBtn setTitle:@"已领" forState:UIControlStateNormal];
        [self.receiveBtn setTitleColor:RGB(102, 102, 102) forState:UIControlStateNormal];
    }else
    {
        if ([listModel.progress intValue] == 100)
        {
            self.receiveBtn.layer.cornerRadius = 3;
            self.receiveBtn.userInteractionEnabled = YES;
            self.receiveBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
            self.receiveBtn.backgroundColor = kAppMainColor;
            [self.receiveBtn setTitle:@"领取" forState:UIControlStateNormal];
            [self.receiveBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        }else
        {
            self.receiveBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            [self.receiveBtn setTitleColor:kAppGrayColor1 forState:UIControlStateNormal];
            self.receiveBtn.backgroundColor = kClearColor;
            [self.receiveBtn setTitle:[NSString stringWithFormat:@"%@/%@",listModel.current,listModel.target] forState:UIControlStateNormal];
            self.receiveBtn.userInteractionEnabled = NO;
        }
    }
}
- (IBAction)receiveBtn:(UIButton *)sender
{
    if (self.taskBlock)
    {
        self.taskBlock((int)sender.tag);
    }
}


@end
