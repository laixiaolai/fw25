//
//  TexasPokerLeftAndRight.h
//  FanweApp
//
//  Created by GuoMs on 16/12/12.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayingCardView.h"
@interface TexasPokerLeftAndRight : UIView
@property (strong, nonatomic) IBOutlet UIImageView *texasLeftAndRightOne;//第一张牌
@property (strong, nonatomic) IBOutlet UIImageView *texasLeftAndRightTwo;//第二张牌
@property (strong, nonatomic) IBOutlet UIImageView *pokerResultView;//显示本副牌的结果
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pokerTwoLeftLeading;
@property (nonatomic, assign) CGFloat  height;//视图的高度
@property (nonatomic, assign) CGFloat  pokWidth;//扑克牌的宽度
@property (nonatomic, assign) CGFloat  pokHeight;//扑克牌的高度
@property (nonatomic, strong) PlayingCardView *playingCardView;//单张扑克牌视图

- (void)hidenTexasPoker:(BOOL)hiden;///隐藏两张扑克牌
@end
