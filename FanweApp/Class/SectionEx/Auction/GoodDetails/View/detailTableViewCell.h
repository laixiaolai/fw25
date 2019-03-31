//
//  detailTableViewCell.h
//  FanweApp
//
//  Created by lxt2016 on 16/11/29.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface detailTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UIView *lineView;

- (CGFloat)setCellWithString:(NSString *)string;

@end
