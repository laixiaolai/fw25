//
//  ChargerTableViewCell.h
//  FanweApp
//
//  Created by fanwe2014 on 2016/11/24.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LiveDataModel;

@interface ChargerTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel      *moneyLabel;       //消费金额
@property (weak, nonatomic) IBOutlet UILabel      *timeLabel;        //时间
@property (weak, nonatomic) IBOutlet UIImageView  *headImgView;      //消费头像
@property (weak, nonatomic) IBOutlet UILabel      *nameLabel;        //名字
@property (weak, nonatomic) IBOutlet UIImageView  *sexImgView;       //性别
@property (weak, nonatomic) IBOutlet UIImageView  *rankImgView;      //等级
@property (weak, nonatomic) IBOutlet UILabel      *lookLabel;
@property (strong, nonatomic) GlobalVariables     *fanweApp;

@property (nonatomic, strong) UIView              *lineView;         //分割线

/*
 type 判断是付费记录还是收费记录0付费 1收费
 */
- (void)setCellWithDict:(LiveDataModel *)model andType:(int)type andLive_pay_type:(int)live_pay_type;

@end
