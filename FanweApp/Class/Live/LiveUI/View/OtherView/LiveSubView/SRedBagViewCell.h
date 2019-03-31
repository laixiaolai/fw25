//
//  SRedBagViewCell.h
//  FanweApp
//
//  Created by 丁凯 on 2017/7/15.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SRedBagViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headView;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *goldView;
@property (weak, nonatomic) IBOutlet UIImageView *sexView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *goldViewTopHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moneyLabelTopHeight;
@property (weak, nonatomic) IBOutlet UIView *lineView;

//@property(strong,nonatomic)UIView *lineView;

- (void)creatCellWithModel:(CustomMessageModel *)model andRow:(int)row;


@end
