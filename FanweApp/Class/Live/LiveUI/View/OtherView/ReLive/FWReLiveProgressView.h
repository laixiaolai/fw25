//
//  FWReLiveProgressView.h
//  FanweApp
//
//  Created by xfg on 2017/2/10.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^DragingSliderCallback)(float progress);

@interface FWReLiveProgressView : UIView

@property (nonatomic, strong) UISlider *            slider;
@property (nonatomic, strong) UIProgressView *      progressView;
@property (nonatomic, strong) UILabel *             playedTimeLabel;
@property (nonatomic, strong) UILabel *             unplayedTimeLabel;
@property (nonatomic, strong) UIButton *            playBtn;

@property (nonatomic, assign) float                 totalTimeInSeconds;
@property (nonatomic, assign) float                 cacheProgress;
@property (nonatomic, assign) float                 playProgress;
@property (nonatomic, assign) BOOL                  isStartSeekPro;              // 是否开始拖动进度条
@property (nonatomic, copy) DragingSliderCallback   dragingSliderCallback;
@property (nonatomic, copy) FWVoidBlock             playBtnCallback;

@end
