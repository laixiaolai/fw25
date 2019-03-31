//
//  TitleViewCell.h
//  FanweApp
//
//  Created by fanwe2014 on 16/11/7.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TitleViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

- (CGFloat)setCellWithString:(NSString *)string;

@end
