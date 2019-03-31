//
//  FWTLiveBeautyView.m
//  FanweApp
//
//  Created by xfg on 2017/2/17.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "FWTLiveBeautyView.h"

#define kBeautyBtnLineNum       3   // 一排n个
#define kBeautyBtnSpace_X       20  // 横向间隔
#define kBeautyBtnSpace_Y       8   // 纵向间隔
#define kBeautyBtnHeight        30  // 按钮高度

@interface FWTLiveBeautyView()<UIPickerViewDataSource,UIPickerViewDelegate,UIGestureRecognizerDelegate>
{
    NSInteger   _curEffectIdx;
    NSMutableArray     *_beautyBtnArray;
    NSArray     *_beautyBtnNameArray;
    float       _beautyBtnWidth;
    float       _beautyBtnContrianerViewHeight;
    NSString    *_currentBeautyBtnNameStr;
}

@end

@implementation FWTLiveBeautyView

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
                               @"普通美颜",
                               @"浪漫",
                               @"清新",
                               @"唯美",
                               @"粉嫩",
                               @"怀旧",
                               @"蓝调",
                               @"清凉",
                               @"日系",
                               nil];
        _beautyBtnContrianerViewHeight = [self createBtn:_beautyBtnNameArray];
        
        _currentBeautyBtnNameStr = [_beautyBtnNameArray firstObject];
        
        _curEffectIdx = 1;
        // 修改美颜参数
        _filterParam1 = [self addSliderName:@"美颜" From:0 To:100 Init:50];
        _filterParam2 = [self addSliderName:@"美白" From:0 To:100 Init:50];
        _filterParam1.hidden = YES;
        _filterParam2.hidden = YES;
        
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
    
    _filterParam2.frame = CGRectMake(kDefaultMargin, CGRectGetMinY(_beautyBtnContrianerView.frame)-40, comFrame.size.width-kDefaultMargin*2, 35);
    
    _filterParam1.frame = CGRectMake(kDefaultMargin, CGRectGetMinY(_filterParam2.frame)-40, comFrame.size.width-kDefaultMargin*2, 35);
}


#pragma mark  - ----------------------- 切换美颜 -----------------------
- (void)onBtnClick:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    _currentBeautyBtnNameStr = _beautyBtnNameArray[btn.tag];
    
    [self setCurrentBeautyBtnColor:btn.tag];
    
    _filterParam1.hidden = NO;
    _filterParam2.hidden = NO;
    
    NSString* lookupFileName = @"";
    
    if ([_currentBeautyBtnNameStr isEqualToString:@"关闭美颜"])
    {
        [self layoutUI];
    }
    else
    {
        _beautyBgView.frame = CGRectMake(0, self.frame.size.height-(_beautyBtnContrianerViewHeight+80), self.frame.size.width, _beautyBtnContrianerViewHeight+80);
        [self layoutMyCommponent];
    }
    
    if ([_currentBeautyBtnNameStr isEqualToString:@"关闭美颜"])
    {
        _filterParam1.hidden = YES;
        _filterParam2.hidden = YES;
    }
    else if ([_currentBeautyBtnNameStr isEqualToString:@"普通美颜"])
    {
        lookupFileName = @"普通美颜";
    }
    else if ([_currentBeautyBtnNameStr isEqualToString:@"浪漫"])
    {
        lookupFileName = @"langman.png";
    }
    else if ([_currentBeautyBtnNameStr isEqualToString:@"清新"])
    {
        lookupFileName = @"qingxin.png";
    }
    else if ([_currentBeautyBtnNameStr isEqualToString:@"唯美"])
    {
        lookupFileName = @"weimei.png";
    }
    else if ([_currentBeautyBtnNameStr isEqualToString:@"粉嫩"])
    {
        lookupFileName = @"fennen.png";
    }
    else if ([_currentBeautyBtnNameStr isEqualToString:@"怀旧"])
    {
        lookupFileName = @"huaijiu.png";
    }
    else if ([_currentBeautyBtnNameStr isEqualToString:@"蓝调"])
    {
        lookupFileName = @"landiao.png";
    }
    else if ([_currentBeautyBtnNameStr isEqualToString:@"清凉"])
    {
        lookupFileName = @"qingliang.png";
    }
    else if ([_currentBeautyBtnNameStr isEqualToString:@"日系"])
    {
        lookupFileName = @"rixi.png";
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(setBeauty:withBeautyName:)])
    {
        [_delegate setBeauty:self withBeautyName:lookupFileName];
    }
}

- (void)onSlider:(id)sender
{
    if (sender != _filterParam1 &&
        sender != _filterParam2 )
    {
        return;
    }
    
    if ([_currentBeautyBtnNameStr isEqualToString:@"关闭美颜"])
    {
        _filterParam1.slider.value = 0;
        _filterParam2.slider.value = 0;
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(setBeautyValue:)])
    {
        [_delegate setBeautyValue:self];
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
    UIImage *imageFromKSYBundle = [UIImage imageWithContentsOfFile:[[[FWTLiveBeautyView KSYGPUResourceBundle] resourcePath] stringByAppendingPathComponent:name]];
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
