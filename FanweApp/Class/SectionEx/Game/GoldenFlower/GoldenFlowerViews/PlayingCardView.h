//
//  PlayingCardView.h
//  GoldenFlowerDemo
//
//  Created by GuoMs on 16/11/22.
//  Copyright © 2016年 zcd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayingCardView : UIView
//牌的点数
@property (weak, nonatomic) IBOutlet UIImageView *numberOfCard;
//牌的花色（大的）
@property (weak, nonatomic) IBOutlet UIImageView *bigSuit;
//牌的花色（小的）
@property (weak, nonatomic) IBOutlet UIImageView *smallSuit;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *numberOfCardWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *smallSuitWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bigSuitWidth;

@end
