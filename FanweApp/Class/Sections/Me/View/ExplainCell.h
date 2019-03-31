//
//  ExplainCell.h
//  FanweApp
//
//  Created by 王珂 on 17/4/27.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BingdingStateModel.h"
@interface ExplainCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *explainLabel;
@property (nonatomic, strong) BingdingStateModel * model;
@property (nonatomic, copy) NSMutableAttributedString * attrStr;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
