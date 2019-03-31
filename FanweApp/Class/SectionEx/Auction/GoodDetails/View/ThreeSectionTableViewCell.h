//
//  ThreeSectionTableViewCell.h
//  FanweApp
//
//  Created by fanwe2014 on 16/8/5.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThreeSectionTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (nonatomic, strong) UIView *lineView;

- (void)creatCellWithNum:(int)count;

@end
