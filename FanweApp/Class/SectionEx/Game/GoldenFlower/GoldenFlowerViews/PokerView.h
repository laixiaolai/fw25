//
//  PokerView.h
//  GoldenFlowerDemo
//
//  Created by GuoMs on 16/11/17.
//  Copyright © 2016年 zcd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayingCardView.h"
@interface PokerView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *pokerOne;//存放第一张牌
@property (weak, nonatomic) IBOutlet UIImageView *pokerTwo;//存放第二张牌
@property (weak, nonatomic) IBOutlet UIImageView *pokerThree;//存放第三张牌
@property (weak, nonatomic) IBOutlet UIImageView *pokerResultView; //牌的结果判定
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondpokerLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thirdpokerLeading;
@property (nonatomic, assign) CGFloat  height;//视图的高度
@property (nonatomic, assign) CGFloat  pokWidth;//扑克牌的宽度
@property (nonatomic, assign) CGFloat  pokHeight;//扑克牌的高度
@property (nonatomic, strong) PlayingCardView *playingCardView;//单张扑克牌视图

- (void)hidenPoker:(BOOL)hiden ;//游戏准备
@end
