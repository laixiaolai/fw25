//
//  STTableRewardCell.h
//  FanweApp
//
//  Created by 岳克奎 on 17/5/4.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STTableRewardCell : STTableBaseCell
@property (weak, nonatomic) IBOutlet UILabel            *topLab;
@property (weak, nonatomic) IBOutlet UILabel            *bottomLab;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgimgeViewRightLayoutConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *bgImgeView;

@end
