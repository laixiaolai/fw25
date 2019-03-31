//
//  FWTLiveBeautyView.h
//  FanweApp
//
//  Created by xfg on 2017/2/17.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FWNameSlider.h"

@class FWTLiveBeautyView;

@protocol FWTLiveBeautyViewDelegate <NSObject>
@required

// 设置美颜类型
- (void)setBeauty:(FWTLiveBeautyView *)beautyView withBeautyName:(NSString *)beautyName;

// 设置美颜的值
- (void)setBeautyValue:(FWTLiveBeautyView *)beautyView;

@end

@interface FWTLiveBeautyView : UIView

@property (nonatomic, weak) id<FWTLiveBeautyViewDelegate> delegate;

@property (nonatomic, strong) UIView                    *beautyBgView;              // 美颜背景视图
@property (nonatomic, strong) UIView                    *beautyBtnContrianerView;   // 美颜按钮背景视图

// 参数调节
@property (nonatomic, readonly) FWNameSlider            *filterParam1;              // 参数1
@property (nonatomic, readonly) FWNameSlider            *filterParam2;              // 参数2

@end
