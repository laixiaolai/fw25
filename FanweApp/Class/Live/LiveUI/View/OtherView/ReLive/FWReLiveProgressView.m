//
//  FWReLiveProgressView.m
//  FanweApp
//
//  Created by xfg on 2017/2/10.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "FWReLiveProgressView.h"

#define kPlayContrainerHeight 30

static const CGFloat        kBoundsMargin = 2.f;
static const CGFloat        kTimeLabelWidth = 75.f;
static NSString *           kNullTimeLabelText = @"--:--/--:--";
static NSString *           kFontName = @"Helvetica";

@interface FWReLiveProgressView ()

@end

@implementation FWReLiveProgressView

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"cacheProgress"];
    [self removeObserver:self forKeyPath:@"playProgress"];
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _progressView = [[UIProgressView alloc] init];
        _progressView.trackTintColor = [UIColor lightGrayColor];
        _progressView.progressTintColor = [UIColor darkGrayColor];
        [self addSubview:_progressView];
        
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playBtn setImage:[UIImage imageNamed:@"fw_relive_start"] forState:UIControlStateNormal];
        [_playBtn addTarget:self action:@selector(onStartOrStopPlay) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_playBtn];
        
        _slider = [[UISlider alloc] init];
        _slider.maximumTrackTintColor = [UIColor clearColor];
        _slider.minimumValue = 0.f;
        _slider.maximumValue = 1.f;
        [_slider setThumbImage:[UIImage imageNamed:@"fw_relive_slider_thumb"] forState:UIControlStateNormal];
        _slider.minimumTrackTintColor = kWhiteColor;
        _slider.value = 0;
        _slider.continuous = NO;
        [_slider addTarget:self action:@selector(onSeekBegin) forControlEvents:(UIControlEventTouchDown)];
        [_slider addTarget:self action:@selector(dragSliderDidEnd) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_slider];
        
        _playedTimeLabel = [self addTimeLabel];
        
        [self addObserver:self forKeyPath:@"cacheProgress" options:NSKeyValueObservingOptionNew context:nil];
        [self addObserver:self forKeyPath:@"playProgress" options:NSKeyValueObservingOptionNew context:nil];
        
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"cacheProgress"])
    {
        [_progressView setProgress:self.cacheProgress animated:YES];
    }
    if ([keyPath isEqualToString:@"playProgress"])
    {
        [_slider setValue:self.playProgress animated:YES];
        
        _playedTimeLabel.text = [NSString stringWithFormat:@"%@/%@",[self convertToMinutes:_totalTimeInSeconds * _playProgress],[self convertToMinutes:_totalTimeInSeconds]];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.backgroundColor = kClearColor;
    
    _playBtn.frame = CGRectMake(kDefaultMargin, 0, kPlayContrainerHeight, kPlayContrainerHeight);
    
    _playedTimeLabel.frame = CGRectMake(self.bounds.size.width-75-kDefaultMargin, 0, kTimeLabelWidth, kPlayContrainerHeight);
    
    CGRect progressAreaFrame = CGRectMake(CGRectGetMaxX(_playBtn.frame)+kDefaultMargin, 0, self.bounds.size.width-CGRectGetWidth(_playBtn.frame)-CGRectGetWidth(_playedTimeLabel.frame)-kDefaultMargin*4, self.bounds.size.height);
    
    _progressView.frame = CGRectMake(progressAreaFrame.origin.x + kBoundsMargin,
                                     progressAreaFrame.size.height / 2 - kBoundsMargin / 2,
                                     progressAreaFrame.size.width - 2 * kBoundsMargin,
                                     progressAreaFrame.size.height);
    
    _slider.frame = progressAreaFrame;
}

- (NSString *)convertToMinutes:(float)seconds
{
    NSString *timeStr = [NSString stringWithFormat:@"%02d:%02d", (int)seconds / 60, (int)seconds % 60];
    return timeStr;
}

- (UILabel *)addTimeLabel
{
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.textColor = [UIColor whiteColor];
    timeLabel.font = [UIFont fontWithName:kFontName size:12];
    timeLabel.text = kNullTimeLabelText;
    timeLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:timeLabel];
    
    return timeLabel;
}

- (void)onStartOrStopPlay
{
    self.playBtnCallback();
}

#pragma mark 进度条事件
- (void)onSeekBegin
{
    NSLog(@"%f",_slider.value);
    _isStartSeekPro = YES;
}

- (void)dragSliderDidEnd
{
    _isStartSeekPro = NO;
    self.dragingSliderCallback(_slider.value);
}

@end
