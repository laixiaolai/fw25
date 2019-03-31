//
//  DistributionCell.h
//  FanweApp
//
//  Created by fanwe2014 on 2016/12/27.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LiveDataModel;

@interface DistributionCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView     *headImgView;
@property (weak, nonatomic) IBOutlet UILabel         *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel         *ticketLabel;
@property (nonatomic, strong) GlobalVariables        *fanweApp;
//@property (nonatomic, strong) UIView                 *lineView;//下滑线
@property (weak, nonatomic) IBOutlet UIView          *lineView;

- (void)setCellWithModel:(LiveDataModel *)model;

@end
