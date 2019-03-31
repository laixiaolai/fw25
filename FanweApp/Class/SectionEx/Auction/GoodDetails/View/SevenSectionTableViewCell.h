//
//  SevenSectionTableViewCell.h
//  FanweApp
//
//  Created by fanwe2014 on 16/8/5.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SevenSectionTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;

- (CGFloat)setCellWithString:(NSString *)string;

@end
