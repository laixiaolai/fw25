//
//  FWSettingBeautyView.m
//  FanweApp
//
//  Created by xfg on 2017/2/17.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "FWSettingBeautyView.h"

#define kBeautyBtnLineNum       3   // 一排n个
#define kBeautyBtnSpace_X       20  // 横向间隔
#define kBeautyBtnSpace_Y       8   // 纵向间隔
#define kBeautyBtnHeight        30  // 按钮高度

@interface FWSettingBeautyView()<UIPickerViewDataSource,UIPickerViewDelegate,UIGestureRecognizerDelegate>
{
    NSInteger   _curEffectIdx;
    NSArray     *_effectNames;
    NSMutableArray     *_beautyBtnArray;
    NSArray     *_beautyBtnNameArray;
    float       _beautyBtnWidth;
    float       _beautyBtnContrianerViewHeight;
    NSString    *_currentBeautyBtnNameStr;
}

@end

@implementation FWSettingBeautyView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _beautyBtnWidth = (frame.size.width - (kBeautyBtnLineNum+1)*kBeautyBtnSpace_X) / kBeautyBtnLineNum;
        
        _beautyBgView = [[UIView alloc]init];
        _beautyBgView.backgroundColor = kWhiteColor;
        [self addSubview:_beautyBgView];
        
        _beautyBtnContrianerView = [[UIView alloc]init];
        _beautyBtnContrianerView.backgroundColor = kWhiteColor;
        [_beautyBgView addSubview:_beautyBtnContrianerView];
        
        _beautyBtnArray = [NSMutableArray array];
        _beautyBtnNameArray = [NSArray arrayWithObjects:@"关闭美颜",
                               @"嫩肤",
                               @"白肤",
                               @"自然",
                               @"柔肤",
                               @"白皙",
                               @"粉嫩",
                               nil];
        _beautyBtnContrianerViewHeight = [self createBtn:_beautyBtnNameArray];
        
        _currentBeautyBtnNameStr = [_beautyBtnNameArray firstObject];
        
        _effectNames = [NSArray arrayWithObjects: @"1 小清新",
                        @"2 靓丽",
                        @"3 甜美可人",
                        @"4 怀旧",
                        @"5 蓝调",
                        @"6 老照片",
                        nil];
        _curEffectIdx = 1;
        // 修改美颜参数
        _filterParam1 = [self addSliderName:@"磨皮" From:0 To:100 Init:50];
        _filterParam2 = [self addSliderName:@"美白" From:0 To:100 Init:50];
        _filterParam3 = [self addSliderName:@"红润" From:0 To:100 Init:50];
        _filterParam4 = [self addSliderName:@"参数" From:0 To:100 Init:50];
        _filterParam1.hidden = YES;
        _filterParam2.hidden = YES;
        _filterParam3.hidden = YES;
        _filterParam4.hidden = YES;
        
        _effectPicker = [[UIPickerView alloc] init];
        [_beautyBgView addSubview:_effectPicker];
        _effectPicker.hidden     = YES;
        _effectPicker.delegate   = self;
        _effectPicker.dataSource = self;
        _effectPicker.showsSelectionIndicator= YES;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.tag = 1;
        [self onBtnClick:button];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)layoutUI
{
    _beautyBgView.frame = CGRectMake(0, self.frame.size.height-_beautyBtnContrianerViewHeight, self.frame.size.width, _beautyBtnContrianerViewHeight);
    [self layoutMyCommponent];
}

- (void)layoutMyCommponent
{
    _beautyBtnContrianerView.frame = CGRectMake(0, _beautyBgView.frame.size.height - _beautyBtnContrianerViewHeight, _beautyBgView.frame.size.width, _beautyBtnContrianerViewHeight);
    
    CGRect comFrame = _beautyBgView.frame;
    
    _filterParam4.frame = CGRectMake(kDefaultMargin, CGRectGetMinY(_beautyBtnContrianerView.frame)-40, comFrame.size.width-kDefaultMargin*2, 35);
    
    _filterParam3.frame = CGRectMake(kDefaultMargin, CGRectGetMinY(_beautyBtnContrianerView.frame)-40, comFrame.size.width-kDefaultMargin*2, 35);
    
    _filterParam2.frame = CGRectMake(kDefaultMargin, CGRectGetMinY(_filterParam3.frame)-40, comFrame.size.width-kDefaultMargin*2, 35);
    
    _filterParam1.frame = CGRectMake(kDefaultMargin, CGRectGetMinY(_filterParam2.frame)-40, comFrame.size.width-kDefaultMargin*2, 35);
    
    _effectPicker.frame = CGRectMake(kDefaultMargin, CGRectGetMinY(_filterParam1.frame)-170, comFrame.size.width-kDefaultMargin*2, 160);
}


#pragma mark  - ----------------------- 切换美颜 -----------------------
- (void)onBtnClick:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    _currentBeautyBtnNameStr = _beautyBtnNameArray[btn.tag];
    
    [self setCurrentBeautyBtnColor:btn.tag];
    
    _filterParam1.hidden = YES;
    _filterParam2.hidden = YES;
    _filterParam3.hidden = YES;
    _filterParam4.hidden = YES;
    _effectPicker.hidden = YES;
    
    if ([_currentBeautyBtnNameStr isEqualToString:@"关闭美颜"])
    {
        _curFilter = nil;
        [self layoutUI];
    }
    else if ([_currentBeautyBtnNameStr isEqualToString:@"嫩肤"])
    {
        _filterParam4.nameL.text = @"嫩肤";
        _filterParam4.hidden = NO;
        
        // 构造美颜滤镜
        KSYGPUBeautifyExtFilter *currentFilter = [[KSYGPUBeautifyExtFilter alloc] init];
        [currentFilter setBeautylevel:_filterParam4.normalValue * 5];
        _curFilter = currentFilter;
        
        _beautyBgView.frame = CGRectMake(0, self.frame.size.height-(_beautyBtnContrianerViewHeight+40), self.frame.size.width, _beautyBtnContrianerViewHeight+40);
        [self layoutMyCommponent];
    }
    else if ([_currentBeautyBtnNameStr isEqualToString:@"白肤"])
    {
        _filterParam4.nameL.text = @"白肤";
        _filterParam4.hidden = NO;
        
        // 构造美颜滤镜
        KSYGPUBeautifyFilter *currentFilter = [[KSYGPUBeautifyFilter alloc] init];
        [currentFilter setBeautylevel:_filterParam4.normalValue * 5];
        _curFilter = currentFilter;
        
        _beautyBgView.frame = CGRectMake(0, self.frame.size.height-(_beautyBtnContrianerViewHeight+40), self.frame.size.width, _beautyBtnContrianerViewHeight+40);
        [self layoutMyCommponent];
    }
    else if ([_currentBeautyBtnNameStr isEqualToString:@"自然"])
    {
        // 构造美颜滤镜
        KSYGPUDnoiseFilter *currentFilter = [[KSYGPUDnoiseFilter alloc] init];
        _curFilter = currentFilter;
        
        [self layoutUI];
    }
    else if ([_currentBeautyBtnNameStr isEqualToString:@"柔肤"])
    {
        _filterParam4.nameL.text = @"柔肤";
        _filterParam4.hidden = NO;
        
        // 构造美颜滤镜
        KSYGPUBeautifyPlusFilter *currentFilter = [[KSYGPUBeautifyPlusFilter alloc] init];
        [currentFilter setBeautylevel:_filterParam4.normalValue * 5];
        _curFilter = currentFilter;
        
        _beautyBgView.frame = CGRectMake(0, self.frame.size.height-(_beautyBtnContrianerViewHeight+40), self.frame.size.width, _beautyBtnContrianerViewHeight+40);
        [self layoutMyCommponent];
    }
    else if ([_currentBeautyBtnNameStr isEqualToString:@"白皙"])
    {
        _filterParam2.nameL.text = @"磨皮";
        _filterParam2.hidden = NO;
        
        _filterParam3.nameL.text = @"美白";
        _filterParam3.hidden = NO;
        
        // 构造美颜滤镜
        KSYBeautifyFaceFilter *currentFilter = [[KSYBeautifyFaceFilter alloc] init];
        currentFilter.grindRatio = _filterParam2.normalValue;
        currentFilter.whitenRatio = _filterParam3.normalValue;
        _curFilter = currentFilter;
        
        _beautyBgView.frame = CGRectMake(0, self.frame.size.height-(_beautyBtnContrianerViewHeight+80), self.frame.size.width, _beautyBtnContrianerViewHeight+80);
        [self layoutMyCommponent];
    }
    else if ([_currentBeautyBtnNameStr isEqualToString:@"粉嫩"])
    {
        _filterParam1.nameL.text = @"磨皮";
        _filterParam1.hidden = NO;
        
        _filterParam2.nameL.text = @"美白";
        _filterParam2.hidden = NO;
        
        _filterParam3.nameL.text = @"红润";
        _filterParam3.hidden = NO;
        
        // 构造美颜滤镜
        KSYBeautifyProFilter *currentFilter = [[KSYBeautifyProFilter alloc] init];
        currentFilter.grindRatio = _filterParam1.normalValue;
        currentFilter.whitenRatio = _filterParam2.normalValue;
        currentFilter.ruddyRatio = _filterParam3.normalValue;
        _curFilter = currentFilter;
        
        _beautyBgView.frame = CGRectMake(0, self.frame.size.height-(_beautyBtnContrianerViewHeight+120), self.frame.size.width, _beautyBtnContrianerViewHeight+120);
        [self layoutMyCommponent];
    }
    
    if (_onBtnBlock)
    {
        _onBtnBlock(sender);
    }
}

- (void)onSlider:(id)sender
{
    if (sender != _filterParam1 &&
        sender != _filterParam2 &&
        sender != _filterParam3 &&
        sender != _filterParam4 )
    {
        return;
    }
    
    float filterVal1 = _filterParam1.slider.value;
    float filterVal2 = _filterParam2.slider.value;
    float filterVal3 = _filterParam3.slider.value;
    float filterVal4 = _filterParam4.slider.value;
    
    if ([_currentBeautyBtnNameStr isEqualToString:@"关闭美颜"])
    {
        _filterParam1.slider.value = 0;
        _filterParam2.slider.value = 0;
        _filterParam3.slider.value = 0;
        _filterParam4.slider.value = 0;
    }
    else if ([_currentBeautyBtnNameStr isEqualToString:@"嫩肤"])
    {
        int val = filterVal4/20; // level 1~5
        [(KSYGPUBeautifyExtFilter *)_curFilter setBeautylevel:val];
    }
    else if ([_currentBeautyBtnNameStr isEqualToString:@"白肤"])
    {
        int val = filterVal4/20; // level 1~5
        [(KSYGPUBeautifyFilter *)_curFilter setBeautylevel:val];
    }
    else if ([_currentBeautyBtnNameStr isEqualToString:@"自然"])
    {
        
    }
    else if ([_currentBeautyBtnNameStr isEqualToString:@"柔肤"])
    {
        int val = filterVal4/20; // level 1~5
        [(KSYGPUBeautifyPlusFilter *)_curFilter setBeautylevel:val];
    }
    else if ([_currentBeautyBtnNameStr isEqualToString:@"白皙"])
    {
        // 对于美白滤镜可以调节磨皮、白皙的等级
        KSYBeautifyFaceFilter *filter = (KSYBeautifyFaceFilter *)_curFilter;
        if (sender == _filterParam2 )
        {
            filter.grindRatio = filterVal2/100; //0.0 ~ 0.8 0.7为默认等级
        }
        if (sender == _filterParam3 )
        {
            filter.whitenRatio = filterVal3/100;//0.0 ~ 1.0 0.5为默认等级
        }
    }
    else if ([_currentBeautyBtnNameStr isEqualToString:@"粉嫩"])
    {
        KSYBeautifyProFilter *filter = (KSYBeautifyProFilter *)_curFilter;
        if (sender == _filterParam1 )
        {
            filter.grindRatio = filterVal1/100; // grindRatio ranges from 0.0 to 1.0, with 0.5 as the normal level
        }
        if (sender == _filterParam2 )
        {
            filter.whitenRatio = filterVal2/100;    // whitenRatio ranges from 0.0 to 1.0, with 0.3 as the normal level
        }
        if (sender == _filterParam3 )
        {
            filter.ruddyRatio = filterVal3/100; // ruddyRatio ranges from -1.0 to 1.0, with -0.3 as the normal level
        }
    }
    
    if (_onBtnBlock)
    {
        _onBtnBlock(sender);
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

#pragma mark  - ----------------------- UI -----------------------
- (float)createBtn:(NSArray *)arrayList
{
    CGFloat btn_x = kBeautyBtnSpace_X;
    CGFloat btn_y = kBeautyBtnSpace_Y;
    
    for(int i=0; i < [arrayList count]; i ++)
    {
        UIButton *btn = [self addButton:arrayList[i]];
        btn.tag = i;
        btn.frame = CGRectMake(btn_x, btn_y, _beautyBtnWidth, kBeautyBtnHeight);
        
        //计算下一个按钮的位置
        if (i < [arrayList count]-1)
        { //判断是否有下一个按钮
            //列
            if (self.frame.size.width - (btn_x + _beautyBtnWidth) < _beautyBtnWidth)
            {
                //换行
                btn_x = kBeautyBtnSpace_X;
                btn_y = btn_y + kBeautyBtnHeight + kBeautyBtnSpace_Y;
            }
            else
            {
                btn_x = btn_x + _beautyBtnWidth + kBeautyBtnSpace_X;
            }
        }
        [_beautyBtnArray addObject:btn];
    }
    
    return btn_y + kBeautyBtnHeight + kBeautyBtnSpace_Y;
}

#pragma mark 设置选中btn的颜色
- (void)setCurrentBeautyBtnColor:(NSInteger)btnTag
{
    for (UIButton *tmpBtn in _beautyBtnArray)
    {
        if (tmpBtn.tag == btnTag)
        {
            [tmpBtn setTitleColor:kAppGrayColor1 forState:UIControlStateNormal];
            tmpBtn.layer.borderColor = [kAppGrayColor1 CGColor];
        }
        else
        {
            [tmpBtn setTitleColor:kAppGrayColor3 forState:UIControlStateNormal];
            tmpBtn.layer.borderColor = [kAppGrayColor3 CGColor];
        }
    }
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

- (UIButton *)newButton:(NSString*)title
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle: title forState: UIControlStateNormal];
    [button setTitleColor:kAppGrayColor2 forState:UIControlStateNormal];
    button.titleLabel.font = kAppMiddleTextFont;
    button.backgroundColor = kClearColor;
    button.layer.cornerRadius = 5;
    button.clipsToBounds = YES;
    button.layer.borderWidth = kBorderWidth;
    button.layer.borderColor = [kAppGrayColor2 CGColor];
    [_beautyBtnContrianerView addSubview:button];
    return button;
}

- (UIButton *)addButton:(NSString*)title
{
    UIButton * button = [self newButton: title];
    [button addTarget:self action:@selector(onBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    return button;
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
    UIImage *imageFromKSYBundle = [UIImage imageWithContentsOfFile:[[[FWSettingBeautyView KSYGPUResourceBundle] resourcePath] stringByAppendingPathComponent:name]];
    return imageFromKSYBundle;
}

#pragma mark  - ----------------------- 手势 -----------------------
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

@end
