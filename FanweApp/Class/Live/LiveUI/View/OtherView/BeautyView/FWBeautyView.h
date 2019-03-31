//
//  FWBeautyView.h
//  FanweApp
//
//  Created by xfg on 2017/2/17.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FWNameSlider.h"

@interface FWBeautyView : UIView

@property (nonatomic, strong) UIView                            *beautyBgView;      // 美颜背景视图
@property (nonatomic, readonly) GPUImageOutput<GPUImageInput>   *curFilter;         // 选择滤镜
@property (nonatomic, readonly) UISegmentedControl              *filterGroupType;   // 滤镜组合
@property (nonatomic, readonly) UIPickerView                    *effectPicker;      // 特效滤镜

// 参数调节
@property (nonatomic, readonly) FWNameSlider            *filterParam1;      // 参数1
@property (nonatomic, readonly) FWNameSlider            *filterParam2;      // 参数2
@property (nonatomic, readonly) FWNameSlider            *filterParam3;      // 参数3

@end
