//
//  PublishLiveTopView.m
//  FanweApp
//
//  Created by xgh on 2017/8/24.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "PublishLiveTopView.h"
@implementation PublishLiveTopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self= [super initWithFrame:frame];
    if (self) {
        [self locationCityJudge];
        self.locationBtn =  [self setButtomNormalImage:@"pl_publishlive_nolocation" selectedImage:@"pl_publishlive_location" text:@"开定位" normalcolor:kAppGrayColor4 selectedColor:kWhiteColor  frame:CGRectMake(10, 36, 65, 15) sel:@selector(locationBtnAction:)];
        self.locationBtn.selected = YES;
        self.isCanLocation = YES;
        [self.locationBtn setTitle:[NSString stringWithFormat:@"%@", _locationCityString] forState:UIControlStateSelected];
        self.pravicyBtn = [self setButtomNormalImage:@"pl_publishlive_pravicyoff" selectedImage:@"pl_publishlive_pravicyon" text:@"私密" normalcolor:kAppGrayColor4 selectedColor:kWhiteColor frame:CGRectMake(80, 36, 60, 15) sel:@selector(pravicyBtnAction:)];
        self.classifyBtn = [self setButtomNormalImage:@"pl_publishlive_classify" selectedImage:@"pl_publishlive_classify" text:@"选择分类" normalcolor:kWhiteColor selectedColor:kWhiteColor frame:CGRectMake(150, 36, 80, 15) sel:@selector(classifyBtnAction:)];
        self.closeBtn = [self setButtomNormalImage:@"pl_publishlive_close" selectedImage:@"pl_publishlive_close" text:@"" normalcolor:kWhiteColor selectedColor:kWhiteColor frame:CGRectMake(self.width - 25, 36, 15, 15) sel:@selector(closeBtnAction:)];
    }
    return self;
}

- (void)locationBtnAction:(ImageTitleButton *)sender
{
    sender.selected = !sender.selected;
    self.isCanLocation = sender.selected;
}

- (void)pravicyBtnAction:(ImageTitleButton *)sender
{
    sender.selected = !sender.selected;
    self.pravicy = sender.selected;
    if (self.delegate && [self.delegate respondsToSelector:@selector(ispracychangeActionDelegate:)]) {
        [self.delegate ispracychangeActionDelegate:self.pravicy];
    }
}

- (void)classifyBtnAction:(ImageTitleButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(classifyButtonActionDelegate)]) {
        [self.delegate classifyButtonActionDelegate];
    }
  
}

- (void)closeBtnAction:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(closeThePublishLive:)]) {
        [self.delegate closeThePublishLive:self];
    }
}
#pragma mark 获取到地理位置
- (void)locationCityJudge
{
    if ( self.fanweApp.province != nil && self.fanweApp.locationCity!=nil)
    {
        _locationCityString = self.fanweApp.locationCity;
        _provinceSrting = self.fanweApp.province;
    }
    else
    {
        _locationCityString =[self.fanweApp.appModel.ip_info objectForKey:@"city"];
        _provinceSrting =[self.fanweApp.appModel.ip_info objectForKey:@"province"];
    }
}
- (UIButton *)setButtomNormalImage:(NSString *)image selectedImage:(NSString *)selectedImage text:(NSString *)text normalcolor:(UIColor *)color selectedColor:(UIColor *)selecedColor frame:(CGRect)frame sel:(SEL)sel
{
    UIButton *button = [[ImageTitleButton alloc]initWithStyle: EImageLeftTitleRight];
    if (sel == @selector(closeBtnAction:)) {
        button = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    button.frame  = frame;
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:selectedImage] forState:UIControlStateSelected];
    [button setTitle:text forState:UIControlStateNormal];
    [button addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:color forState:UIControlStateNormal];
    [button setTitleColor:selecedColor forState:UIControlStateSelected];
    [button.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [self addSubview:button];
    return button;
}

@end
