//
//  TexasPokerBetween.h
//  FanweApp
//
//  Created by 王珂 on 16/12/14.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TexasPokerBetween : UIView
@property (weak, nonatomic) IBOutlet UIImageView *texasPokerOne;//德州扑克公共牌的第一张牌
@property (weak, nonatomic) IBOutlet UIImageView *texasPokerTwo; //德州扑克公共牌的第二张牌
@property (weak, nonatomic) IBOutlet UIImageView *texasPokerThree; //德州扑克公共牌的第三张牌
@property (weak, nonatomic) IBOutlet UIImageView *texasPokerFour;  //德州扑克公共牌的第四张牌
@property (weak, nonatomic) IBOutlet UIImageView *texasPokerFive;  //德州扑克公共牌的第五张牌
@property (weak, nonatomic) IBOutlet UIImageView *pokerResultView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *texasPokerTwoLeftLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *texasPokerThreeLeftLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *texasPokerFourLeftLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *texasPokerFiveLeftLeading;
@property (nonatomic, strong) PlayingCardView *playingCardView;//单张扑克牌视图
@property (nonatomic, assign) CGFloat  height;//视图的高度
@property (nonatomic, assign) CGFloat  pokWidth;//扑克牌的宽度
@property (nonatomic, assign) CGFloat  pokHeight;//扑克牌的高度
//隐藏所有的牌
- (void)hidenTexasPoker:(BOOL)hiden ;
@end
