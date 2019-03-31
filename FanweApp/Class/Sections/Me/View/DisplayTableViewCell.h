//
//  DisplayTableViewCell.h
//  FanweApp
//
//  Created by yy on 16/7/20.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DisplayTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
@property (weak, nonatomic) IBOutlet UIImageView *diamondImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *diamondImgHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *diamondImgWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *diamondImgRight;

@end
