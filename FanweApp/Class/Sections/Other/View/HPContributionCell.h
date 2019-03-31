//
//  HPContributionCell.h
//  FanweApp
//
//  Created by 丁凯 on 2017/7/5.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HPContributionCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *myNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgView1;
@property (weak, nonatomic) IBOutlet UIImageView *imgView2;
@property (weak, nonatomic) IBOutlet UIImageView *imgView3;

@property (nonatomic,strong) UIView  *lineView;

@property (nonatomic, strong) GlobalVariables *fanweApp;

- (void)setCellWithArray:(NSMutableArray *)imageArray;

@end
