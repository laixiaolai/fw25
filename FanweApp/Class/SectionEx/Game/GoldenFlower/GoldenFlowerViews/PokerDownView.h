//
//  PokerDownView.h
//  GoldenFlowerDemo
//
//  Created by GuoMs on 16/11/17.
//  Copyright © 2016年 zcd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THLabel.h"
@interface PokerDownView : UIView
@property (strong, nonatomic) IBOutlet UILabel *betMultiple;//押注倍数
@property (strong, nonatomic) IBOutlet UIImageView *plantIMG;//星球的图片分为左右中
//@property (strong, nonatomic) IBOutlet UILabel *amountBetLable;//直播间押注数额
//@property (strong, nonatomic) IBOutlet UILabel *amountBetLable;//直播间押注数额
@property (strong, nonatomic) IBOutlet UILabel *betPersonLable;//个人押注数额
@property (strong, nonatomic) IBOutlet UIImageView *lotPokerIMG;//存放游戏即将开始一摞牌图片
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *plantImgWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *plantImgHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *betPersonLableHeight;
@property (weak, nonatomic) IBOutlet THLabel *amountBetLable;



@end
