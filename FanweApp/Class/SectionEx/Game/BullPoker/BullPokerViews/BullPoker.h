//
//  BullPoker.h
//  FanweApp
//
//  Created by 王珂 on 16/12/2.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayingCardView.h"

@interface BullPoker : UIView

@property (weak, nonatomic) IBOutlet UIImageView *BullPokerOne;//斗牛每一副牌的第一张牌
@property (weak, nonatomic) IBOutlet UIImageView *BullPokerTwo;//斗牛每一副牌的第二张牌
@property (weak, nonatomic) IBOutlet UIImageView *BullPokerThree;//斗牛每一副牌的第三张牌
@property (weak, nonatomic) IBOutlet UIImageView *BullPokerFour;//斗牛每一副牌的第四张牌
@property (weak, nonatomic) IBOutlet UIImageView *BullPokerFive;//斗牛每一副牌的第五张牌
@property (strong, nonatomic) IBOutlet UIImageView *pokerResultView;//每副牌的判定结果
@property (nonatomic, strong) PlayingCardView *playingCardView;//单张扑克牌视图
@property (nonatomic, assign) CGFloat  height;//视图的高度
@property (nonatomic, assign) CGFloat  pokWidth;//扑克牌的宽度
@property (nonatomic, assign) CGFloat  pokHeight;//扑克牌的高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *BullPokerTwoLeftLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *BullPokerThreeLeftLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *BullPokerFourLeftLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *BullPokerFiveLeftLeding;

//隐藏所有的牌
- (void)hidenBullPoker:(BOOL)hiden;

@end
