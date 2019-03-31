//
//  GameDistributionCell.h
//  FanweApp
//
//  Created by 王珂 on 17/4/5.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameDistributionModel.h"
@interface GameDistributionCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *icomeStyleImg;
@property (weak, nonatomic) IBOutlet UILabel *incomeLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (nonatomic, strong) GameUserModel * model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
