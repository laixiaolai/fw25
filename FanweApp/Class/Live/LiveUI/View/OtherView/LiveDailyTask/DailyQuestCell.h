//
//  DailyQuestCell.h
//  PopupViewWindow
//
//  Created by 杨仁伟 on 2017/5/22.
//  Copyright © 2017年 yrw. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BMListModel;
@interface DailyQuestCell : UITableViewCell

//任务名称lbl距离顶部的约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *distanceTopConstant;
//图片距离顶部的约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgDistanceTopConstant;
//图片
@property (weak, nonatomic) IBOutlet UIImageView *img;
//任务
@property (weak, nonatomic) IBOutlet UILabel *viewVideoLbl;
//奖励
@property (weak, nonatomic) IBOutlet UILabel *rewardLbl;
//领取按钮
@property (weak, nonatomic) IBOutlet UIButton *receiveBtn;
//领取按钮宽的约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *receiveBtnWConstant;
//领取按钮高的约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *receiveBtnHconstant;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rewardConstraintWidth;
@property (nonatomic,copy)void (^ taskBlock)(int btnCount);

- (void)creatCellWithModel:(BMListModel *)listModel andRow:(int)row;

@end
