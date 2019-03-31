//
//  PokerDownView.m
//  GoldenFlowerDemo
//
//  Created by GuoMs on 16/11/17.
//  Copyright © 2016年 zcd. All rights reserved.
//

#import "PokerDownView.h"

#define kStrokeSize			(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 2.0 : 1.0)

@implementation PokerDownView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    CGFloat smallheight = kPokerH+7;
    self.plantImgHeight.constant = smallheight*103.0/143.0;
    self.plantImgWidth.constant = smallheight*103.0/143.0*152.0/129.0;
    self.betPersonLableHeight.constant = smallheight*40.0/143.0;
    self.lotPokerIMG.hidden = YES;
    self.betPersonLable.backgroundColor = [kBlackColor colorWithAlphaComponent:0.5];
    self.backgroundColor = [kBlackColor colorWithAlphaComponent:0.3];
    //self.betMultiple.textColor =[kBlackColor colorWithAlphaComponent:0.5];
    self.betMultiple.textColor = kWhiteColor;
    //    self.layer.cornerRadius = 6.0;
    //    self.layer.masksToBounds = YES;
    self.amountBetLable.strokeColor = [UIColor blackColor];
    self.amountBetLable.strokeSize = kStrokeSize;
}

#pragma  mark -- 文字设置描边
- (void)setText:(UILabel *)lable
{
    NSMutableParagraphStyle *paragaph = [[NSMutableParagraphStyle alloc]init];
    paragaph.alignment = NSTextAlignmentCenter;
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:24],NSParagraphStyleAttributeName:paragaph,NSForegroundColorAttributeName:[UIColor whiteColor],NSStrokeWidthAttributeName:@-3,NSStrokeColorAttributeName:[UIColor blackColor]};
    [lable.text drawInRect:lable.bounds withAttributes:dict];
}

@end
