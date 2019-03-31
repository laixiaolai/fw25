//
//  ShakeLabel2.h
//  FanweApp
//
//  Created by xfg on 16/5/23.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShakeLabelDelegate2 <NSObject>
@required

- (void)shakeLabelAnimateFinished2;

@end

@interface ShakeLabel2 : UILabel

@property (nonatomic, weak) id<ShakeLabelDelegate2>delegate;

// 动画时间
@property (nonatomic, assign) NSTimeInterval duration;
// 描边颜色
@property (nonatomic, strong) UIColor *borderColor;

- (void)startAnimWithDuration:(NSTimeInterval)duration;

@end
