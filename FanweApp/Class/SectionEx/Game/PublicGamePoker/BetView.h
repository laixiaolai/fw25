//
//  BetView.h
//  GoldenFlowerDemo
//
//  Created by yy on 16/11/24.
//  Copyright © 2016年 zcd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BetViewDelegate <NSObject>

- (void)selectAmount:(UIButton *)sender;

@end

@interface BetView : UIView

@property (weak, nonatomic) id<BetViewDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIImageView *breathImg;
@property (weak, nonatomic) IBOutlet UIButton *betBtn;

+ (instancetype)EditNibFromXib;

@end
