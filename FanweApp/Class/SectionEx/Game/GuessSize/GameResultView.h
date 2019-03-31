//
//  GameResultView.h
//  FanweApp
//
//  Created by 方维 on 2017/6/7.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameResultView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *resultImageView;
@property (weak, nonatomic) IBOutlet UIView *resultNumberView;
@property (weak, nonatomic) IBOutlet UILabel *resultNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *winTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *winNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *winNumberLabel;

@end
