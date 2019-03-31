//
//  FWNameSlider.m
//  FanweApp
//
//  Created by xfg on 2017/2/17.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "FWNameSlider.h"

@implementation FWNameSlider

- (id)init
{
    self = [super init];
    if (self)
    {
        self.nameL  = [[UILabel alloc] init];
        self.nameL.textColor = kAppGrayColor1;
        self.nameL.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_nameL];
        
        self.valueL = [[UILabel alloc] init];
        self.valueL.textColor = kAppGrayColor1;
        self.valueL.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_valueL];
        
        self.slider = [[UISlider alloc] init];
        self.slider.minimumValue = 0;
        self.slider.maximumValue = 100;
        [self.slider setThumbImage:[UIImage imageNamed:@"fw_relive_slider_thumb"] forState:UIControlStateNormal];
        self.slider.minimumTrackTintColor = kAppMainColor;
        [self addSubview:_slider];
        [_slider addTarget:self action:@selector(onSlider:) forControlEvents:UIControlEventValueChanged];

        self.onSliderBlock = nil;
        _normalValue = (_slider.value - _slider.minimumValue) / _slider.maximumValue;
        _precision = 0;
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self layoutSlider];
}

- (void)layoutSlider
{
    CGFloat wdt = self.frame.size.width;
    CGFloat hgt = self.frame.size.height;
    [_nameL sizeToFit];
    [_valueL sizeToFit];
    
    CGFloat wdtN = _nameL.frame.size.width + 10;
    CGFloat wdtV = _valueL.frame.size.width + 10;
    CGFloat wdtS = wdt - wdtN - wdtV;
    _nameL.frame  = CGRectMake(0, 0, wdtN, hgt);
    _slider.frame = CGRectMake(wdtN, 0, wdtS, hgt);
    _valueL.frame = CGRectMake(wdtN+wdtS, 0,wdtV, hgt);
}

- (void)updateValue
{
    float val = _slider.value;
    if (_precision == 0){
        _valueL.text = [NSString stringWithFormat:@"%d", (int)val];
    }
    else {
        NSString *fmt =[NSString stringWithFormat:@"%%0.%df", _precision];
        _valueL.text = [NSString stringWithFormat:fmt, val];
    }
    [self layoutSlider];
    _normalValue = (_slider.value - _slider.minimumValue) / _slider.maximumValue;
}

//UIControlEventValueChanged
- (void)onSlider:(id)sender
{
    [self updateValue];
    if (_onSliderBlock)
    {
        _onSliderBlock(self);
    }
}

@synthesize normalValue = _normalValue;

- (float)normalValue
{
    return _normalValue;
}

- (void)setNormalValue:(float )val
{
    _slider.value = val * _slider.maximumValue + _slider.minimumValue;
    [self updateValue];
}

@end
