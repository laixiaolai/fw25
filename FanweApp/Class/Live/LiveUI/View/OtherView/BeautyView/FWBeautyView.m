//
//  FWBeautyView.m
//  FanweApp
//
//  Created by xfg on 2017/2/17.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "FWBeautyView.h"

@interface FWBeautyView()<UIPickerViewDataSource,UIPickerViewDelegate,UIGestureRecognizerDelegate>
{
    NSInteger   _curIdx;
    NSArray * _effectNames;
    NSInteger _curEffectIdx;
}

@end

@implementation FWBeautyView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _beautyBgView = [[UIView alloc]init];
        _beautyBgView.backgroundColor = kWhiteColor;
        [self addSubview:_beautyBgView];
        
        _filterGroupType = [self addSegCtrlWithItems:
                            @[ @"关",
                               @"简单美颜",
                               @"美颜pro",
                               @"红润美颜",
                               @"美颜特效",
                               ]];
        _filterGroupType.selectedSegmentIndex = 1;
        [_filterGroupType setBackgroundColor:kWhiteColor];
        _filterGroupType.tintColor = kAppGrayColor1;
        
        _effectNames = [NSArray arrayWithObjects: @"1 小清新",  @"2 靓丽",
                        @"3 甜美可人",  @"4 怀旧",  @"5 蓝调",  @"6 老照片" , nil];
        _curEffectIdx = 1;
        // 修改美颜参数
        _filterParam1 = [self addSliderName:@"参数" From:0 To:100 Init:50];
        _filterParam2 = [self addSliderName:@"美白" From:0 To:100 Init:50];
        _filterParam3 = [self addSliderName:@"红润" From:0 To:100 Init:50];
        _filterParam1.hidden = YES;
        _filterParam2.hidden = YES;
        
        _effectPicker = [[UIPickerView alloc] init];
        [_beautyBgView addSubview:_effectPicker];
        _effectPicker.hidden     = YES;
        _effectPicker.delegate   = self;
        _effectPicker.dataSource = self;
        _effectPicker.showsSelectionIndicator= YES;
        
        [self selectFilter:1];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)layoutUI
{
    _beautyBgView.frame = CGRectMake(0, self.frame.size.height-300, self.frame.size.width, 300);
    
    [self layoutMyCommponent];
}

- (void)layoutMyCommponent
{
    CGRect comFrame = _beautyBgView.frame;
    _filterGroupType.frame = CGRectMake(kDefaultMargin, comFrame.size.height-40, comFrame.size.width-kDefaultMargin*2, 29);
    
    _filterParam3.frame = CGRectMake(kDefaultMargin, CGRectGetMinY(_filterGroupType.frame)-40, comFrame.size.width-kDefaultMargin*2, 35);
    
    _filterParam2.frame = CGRectMake(kDefaultMargin, CGRectGetMinY(_filterParam3.frame)-40, comFrame.size.width-kDefaultMargin*2, 35);
    
    _filterParam1.frame = CGRectMake(kDefaultMargin, CGRectGetMinY(_filterParam2.frame)-40, comFrame.size.width-kDefaultMargin*2, 35);
    
    _effectPicker.frame = CGRectMake(kDefaultMargin, CGRectGetMinY(_filterParam1.frame)-170, comFrame.size.width-kDefaultMargin*2, 160);
}

- (void)onSegCtrl:(id)sender
{
    if (_filterGroupType == sender)
    {
        [self selectFilter:_filterGroupType.selectedSegmentIndex];
    }
}

- (void)selectFilter:(NSInteger)idx
{
    if (idx == _curIdx)
    {
        return;
    }
    _curIdx = idx;
    _filterParam1.hidden = YES;
    _filterParam2.hidden = YES;
    _filterParam3.hidden = YES;
    _effectPicker.hidden = YES;
    // 标识当前被选择的滤镜
    if (idx == 0)
    {
        _curFilter  = nil;
        
        _beautyBgView.frame = CGRectMake(0, self.frame.size.height-51, self.frame.size.width, 51);
        [self layoutMyCommponent];
    }
    else if (idx == 1)
    {
        _filterParam3.nameL.text = @"参数";
        _filterParam3.hidden = NO;
        _curFilter = [[KSYGPUBeautifyExtFilter alloc] init];
        
        _beautyBgView.frame = CGRectMake(0, self.frame.size.height-91, self.frame.size.width, 91);
        [self layoutMyCommponent];
    }
    else if (idx == 2)
    { // 美颜pro
        KSYBeautifyProFilter * f = [[KSYBeautifyProFilter alloc] init];
        _filterParam1.hidden = NO;
        _filterParam2.hidden = NO;
        _filterParam3.hidden = NO;
        _filterParam1.nameL.text = @"磨皮";
        f.grindRatio  = _filterParam1.normalValue;
        f.whitenRatio = _filterParam2.normalValue;
        f.ruddyRatio  = _filterParam3.normalValue;
        _curFilter    = f;
        
        _beautyBgView.frame = CGRectMake(0, self.frame.size.height-160, self.frame.size.width, 160);
        [self layoutMyCommponent];
    }
    else if (idx == 3)
    { // 红润 + 美颜
        _filterParam1.nameL.text = @"磨皮";
        _filterParam3.nameL.text = @"红润";
        _filterParam1.hidden = NO;
        _filterParam2.hidden = NO;
        _filterParam3.hidden = NO;
        UIImage * rubbyMat = [[self class] KSYGPUImageNamed:@"3_tianmeikeren.png"];
        KSYBeautifyFaceFilter * bf = [[KSYBeautifyFaceFilter alloc] initWithRubbyMaterial:rubbyMat];
        bf.grindRatio  = _filterParam1.normalValue;
        bf.whitenRatio = _filterParam2.normalValue;
        bf.ruddyRatio  = _filterParam3.normalValue;
        _curFilter = bf;
        
        _beautyBgView.frame = CGRectMake(0, self.frame.size.height-160, self.frame.size.width, 160);
        [self layoutMyCommponent];
    }
    else if (idx == 4)
    { // 美颜 + 特效 滤镜组合
        _filterParam1.nameL.text = @"磨皮";
        _filterParam3.nameL.text = @"特效";
        _filterParam1.hidden = NO;
        _filterParam2.hidden = NO;
        _filterParam3.hidden = NO;
        _effectPicker.hidden = NO;
        // 构造美颜滤镜 和  特效滤镜
        KSYBeautifyFaceFilter    * bf = [[KSYBeautifyFaceFilter alloc] init];
        KSYBuildInSpecialEffects * sf = [[KSYBuildInSpecialEffects alloc] initWithIdx:_curEffectIdx];
        bf.grindRatio  = _filterParam1.normalValue;
        bf.whitenRatio = _filterParam2.normalValue;
        sf.intensity   = _filterParam3.normalValue;
        [bf addTarget:sf];
        
        // 用滤镜组 将 滤镜 串联成整体
        GPUImageFilterGroup * fg = [[GPUImageFilterGroup alloc] init];
        [fg addFilter:bf];
        [fg addFilter:sf];
        
        [fg setInitialFilters:[NSArray arrayWithObject:bf]];
        [fg setTerminalFilter:sf];
        _curFilter = fg;
        
        _beautyBgView.frame = CGRectMake(0, self.frame.size.height-330, self.frame.size.width, 330);
        [self layoutMyCommponent];
    }
    else
    {
        _curFilter = nil;
    }
}

- (void)onSlider:(id)sender
{
    if (sender != _filterParam1 &&
        sender != _filterParam2 &&
        sender != _filterParam3 ) {
        return;
    }
    float nalVal = _filterParam1.normalValue;
    if (_curIdx == 1)
    {
        int val = (nalVal*5) + 1; // level 1~5
        [(KSYGPUBeautifyExtFilter *)_curFilter setBeautylevel: val];
    }
    else if (_curIdx == 2 )
    {
        KSYBeautifyProFilter * f =(KSYBeautifyProFilter*)_curFilter;
        if (sender == _filterParam1 )
        {
            f.grindRatio = _filterParam1.normalValue;
        }
        if (sender == _filterParam2 )
        {
            f.whitenRatio = _filterParam2.normalValue;
        }
        if (sender == _filterParam3 )
        {  // 红润参数
            f.ruddyRatio = _filterParam3.normalValue;
        }
    }
    else if (_curIdx == 3 )
    { // 美颜
        KSYBeautifyFaceFilter * f =(KSYBeautifyFaceFilter*)_curFilter;
        if (sender == _filterParam1 )
        {
            f.grindRatio = _filterParam1.normalValue;
        }
        if (sender == _filterParam2 )
        {
            f.whitenRatio = _filterParam2.normalValue;
        }
        if (sender == _filterParam3 )
        {  // 红润参数
            f.ruddyRatio = _filterParam3.normalValue;
        }
    }
    else if ( _curIdx == 4 )
    {
        GPUImageFilterGroup *fg = (GPUImageFilterGroup *)_curFilter;
        KSYBeautifyFaceFilter    * bf = (KSYBeautifyFaceFilter *)[fg filterAtIndex:0];
        KSYBuildInSpecialEffects * sf = (KSYBuildInSpecialEffects *)[fg filterAtIndex:1];
        if (sender == _filterParam1 )
        {
            bf.grindRatio = _filterParam1.normalValue;
        }
        if (sender == _filterParam2 )
        {
            bf.whitenRatio = _filterParam2.normalValue;
        }
        if (sender == _filterParam3 )
        {  // 特效参数
            [sf setIntensity:_filterParam3.normalValue];
        }
    }
}


#pragma mark  - ----------------------- effect picker -----------------------
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return 1; // 单列
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _effectNames.count;//
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [_effectNames objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _curEffectIdx = row+1;
    if ( [_curFilter isMemberOfClass:[GPUImageFilterGroup class]])
    {
        GPUImageFilterGroup * fg = (GPUImageFilterGroup *)_curFilter;
        KSYBuildInSpecialEffects * sf = (KSYBuildInSpecialEffects *)[fg filterAtIndex:1];
        [sf setSpecialEffectsIdx: _curEffectIdx];
    }
}

#pragma mark  - ----------------------- 单击 -----------------------
- (void)tapClick:(UITapGestureRecognizer *)tap
{
    self.hidden = YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isDescendantOfView:_beautyBgView])
    {
        return NO;
    }
    return YES;
}

#pragma mark  - ----------------------- UI -----------------------
- (UISegmentedControl *)addSegCtrlWithItems:(NSArray *)items
{
    UISegmentedControl *segC = [[UISegmentedControl alloc] initWithItems:items];
    segC.selectedSegmentIndex = 0;
    segC.layer.cornerRadius = 5;
    segC.backgroundColor = [UIColor lightGrayColor];
    [segC addTarget:self action:@selector(onSegCtrl:) forControlEvents:UIControlEventValueChanged];
    [_beautyBgView addSubview:segC];
    return segC;
}

- (FWNameSlider *)addSliderName: (NSString*) name
                            From: (float) minV
                              To: (float) maxV
                            Init: (float) iniV {
    FWNameSlider *sl = [[FWNameSlider alloc] init];
    [_beautyBgView addSubview:sl];
    sl.slider.minimumValue = minV;
    sl.slider.maximumValue = maxV;
    sl.slider.value = iniV;
    sl.nameL.text = name;
    sl.normalValue = (iniV -minV)/maxV;
    sl.valueL.text = [NSString stringWithFormat:@"%d", (int)iniV];
    if (iniV <2){
        sl.precision = 2;
    }
    [sl.slider addTarget:self action:@selector(onSlider:) forControlEvents:UIControlEventValueChanged ];
    __weak typeof(self) ws = self;
    sl.onSliderBlock = ^(id sender){
        [ws onSlider:sender];
    };
    return sl;
}

- (UILabel *)addLable:(NSString*)title
{
    UILabel *  lbl = [[UILabel alloc] init];
    lbl.text = title;
    [_beautyBgView addSubview:lbl];
    lbl.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.3];
    return lbl;
}

#pragma mark - load resource from resource bundle
+ (NSBundle*)KSYGPUResourceBundle
{
    static dispatch_once_t onceToken;
    static NSBundle *resBundle = nil;
    dispatch_once(&onceToken, ^{
        resBundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"KSYGPUResource" withExtension:@"bundle"]];
    });
    return resBundle;
}

+ (UIImage*)KSYGPUImageNamed:(NSString*)name
{
    UIImage *imageFromMainBundle = [UIImage imageNamed:name];
    if (imageFromMainBundle)
    {
        return imageFromMainBundle;
    }
    UIImage *imageFromKSYBundle = [UIImage imageWithContentsOfFile:[[[FWBeautyView KSYGPUResourceBundle] resourcePath] stringByAppendingPathComponent:name]];
    return imageFromKSYBundle;
}

@end
