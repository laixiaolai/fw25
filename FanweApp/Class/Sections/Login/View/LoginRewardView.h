//
//  LoginRewardView.h
//  FanweApp
//
//  Created by yy on 16/10/9.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^RewardBlock)();

@interface LoginRewardView : UIView

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *displayView;
@property (weak, nonatomic) IBOutlet UILabel *rewardLabel;
@property (weak, nonatomic) IBOutlet UILabel *exLabel;
@property (weak, nonatomic) IBOutlet UIButton *comfirmBtn;

@property (nonatomic, copy) RewardBlock rewardBlock;

+ (instancetype)EditNibFromXib;

@end
