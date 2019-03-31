//
//  LivePayLeftPromptV.h
//  FanweApp
//
//  Created by 丁凯 on 2017/8/16.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LivePayLeftPromptV : UIView

@property ( nonatomic,strong) UILabel  *firstLabel;         //第1个label
@property ( nonatomic,strong) UILabel  *secondLabel;        //第2个label
@property ( nonatomic,strong) UILabel  *threeLabel;         //第3个label

@property ( nonatomic,assign) float    myHeight;            //高度
@property ( nonatomic,assign) float    myWidth;             //宽度


//以下方法增删label,同时也根据label适应自身的宽高
- (void)addFirstLabWithStr:(NSString *)labeStr;             //add第1个label
- (void)addSecondLabWithStr:(NSString *)labeStr;            //add第2个label
- (void)addThreeLabWithStr:(NSString *)labeStr;             //add第3个label

- (void)removeFirstLabel;                                   //remove第1个label
- (void)removeSecondLabel;                                  //remove第2个label
- (void)removeThreeLabel;                                   //remove第3个label

//通过该方法向上或下移动30间距，适应竞拍ui的显示  myHeight高度
- (void)updateMyFrameIsToUp:(BOOL)isUp andMyHeight:(CGFloat)myHeight;                     //isUp yes向上移动30间距 no向下移动30间距  myHeight移动的距离


@end
