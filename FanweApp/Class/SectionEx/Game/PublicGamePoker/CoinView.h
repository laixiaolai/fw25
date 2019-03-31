//
//  CoinView.h
//  GoldenFlowerDemo
//
//  Created by yy on 16/11/21.
//  Copyright © 2016年 zcd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXNibBridge.h"
#import "GameRechargeView.h"
@protocol CoinViewDelegate <NSObject>

- (void)selectAmount:(UIButton *)sender;

@end

@interface CoinView : UIView<XXNibBridge>

@property (weak, nonatomic) id<CoinViewDelegate>delegate;
@property (weak, nonatomic) IBOutlet GameRechargeView *gameRechargeView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gameRechargeWidth;

+ (instancetype)EditNibFromXib;

@end
