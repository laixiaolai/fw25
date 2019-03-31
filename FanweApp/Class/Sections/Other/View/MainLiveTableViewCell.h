//
//  MainLiveTableViewCell.h
//  FanweApp
//
//  Created by fanwe2014 on 16/6/15.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SenderModel;

@interface MainLiveTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timelabel;
@property (weak, nonatomic) IBOutlet UILabel *watchLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;

- (void)creatCellWithModel:(SenderModel *)model;

@end
