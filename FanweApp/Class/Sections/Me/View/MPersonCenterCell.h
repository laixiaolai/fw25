//
//  MPersonCenterCell.h
//  FanweApp
//
//  Created by 丁凯 on 2017/8/23.
//  Copyright © 2017年 xfg. All rights reserved.


#import <UIKit/UIKit.h>

@interface MPersonCenterCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView   *leftImgView;
@property (weak, nonatomic) IBOutlet UILabel       *lefLabel;
@property (weak, nonatomic) IBOutlet UILabel       *rightLabel;
@property (weak, nonatomic) IBOutlet UIImageView   *rightImgView;
@property ( nonatomic,strong) UIView               *lineView;

- (void)creatCellWithImgStr:(NSString *)imgStr andLeftStr:(NSString *)leftStr andRightStr:(NSString *)rightStr andSection:(int)section;


@end
