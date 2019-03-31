//
//  STSuspensionWindow.h
//  FanweApp
//
//  Created by 岳克奎 on 17/1/18.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "STBaseSuspensionWindow.h"
#import "STBaseSuspensionWindow.h"

typedef NS_ENUM(NSUInteger,STSusWindowShowState)
{
    stSusWindowShowYES = 0, //显示
    stSusWindowShowNO = 1,  //隐藏
} ;

@protocol STSuspensionWindowDelegate <NSObject>

@optional

- (void)showAnimationComplete:(void(^)(BOOL finished))block;
//动画处理成满屏完毕
- (void)showFullScreenFinished:(void(^)(BOOL finished))block;

@end


@interface STSuspensionWindow : STBaseSuspensionWindow
//delegate
@property (nonatomic, weak) id<STSuspensionWindowDelegate>delegate;
//悬浮 小 大
@property (nonatomic, assign) BOOL isSmallSize;
//控制显示
@property (nonatomic, assign) STSusWindowShowState stSusWindowShowState;
//new STBaseSuspensionWindow
+(STSuspensionWindow *)showWindowTypeOfSTBaseSuspensionWindowOfFrameRect:(CGRect)frameRect
                                      ofSTBaseSuspensionWindowLevelValue:(CGFloat)stSuspensionWindowLevelValue
                                                                complete:(void(^)(BOOL finished,
                                                                                  STSuspensionWindow *stSuspensionWindow))block;

@end
