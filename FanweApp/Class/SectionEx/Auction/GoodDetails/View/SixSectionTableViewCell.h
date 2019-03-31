//
//  SixSectionTableViewCell.h
//  FanweApp
//
//  Created by fanwe2014 on 16/8/5.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SixSectionTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *pointTimeLabel;
@property (nonatomic, strong) UILabel *pointPlaceLabel;

- (CGFloat)setCellWithPlace:(NSString *)palceString andPlace:(NSString *)timeString;

@end
