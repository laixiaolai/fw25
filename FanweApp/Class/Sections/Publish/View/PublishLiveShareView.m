//
//  PublishLiveShareView.m
//  FanweApp
//
//  Created by xgh on 2017/8/28.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "PublishLiveShareView.h"

@implementation PublishLiveShareView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addShareImageView];
        [self addshareButtons];
        
    }
    return self;
}
- (void)addShareImageView
{
    _shareImgViewArray = [NSMutableArray array];
    if (self.fanweApp.appModel.qq_app_api == 1)
    {
        [_shareImgViewArray addObject:@[@"pl_publishlive_qq_off",@"pl_publishlive_qq_on"]];
        [_shareImgViewArray addObject:@[@"pl_publishlive_quene_off", @"pl_publishlive_quene_on"]];
    }
    if (self.fanweApp.appModel.wx_app_api == 1)
    {
        [_shareImgViewArray addObject:@[@"pl_publishlive_wechat_off", @"pl_publishlive_wechat_on"]];
        [_shareImgViewArray addObject:@[@"pl_publishlive_friendcyle_off", @"pl_publishlive_friendcyle_on"]];
    }
    if (self.fanweApp.appModel.sina_app_api == 1)
    {
        [_shareImgViewArray addObject:@[@"pl_publishlive_sina_off", @"pl_publishlive_sina_on"]];
    }
    
}

- (void)addshareButtons
{
    NSUInteger num = self.shareImgViewArray.count;
    CGFloat width = 52;
    CGFloat space = (self.width - (num * width))/(num + 1);
    start_x = space;
    
    if (self.fanweApp.appModel.qq_app_api == 1)
    {
        [self createTheButtonWithNormal:@"pl_publishlive_qq_off" selected:@"pl_publishlive_qq_on" sel:@selector(QQShareAction:)];
        [self createTheButtonWithNormal:@"pl_publishlive_quene_off" selected:@"pl_publishlive_quene_on" sel:@selector(qzoneShareAction:)];
  }
    if (self.fanweApp.appModel.wx_app_api == 1) {
        [self createTheButtonWithNormal:@"pl_publishlive_wechat_off" selected:@"pl_publishlive_wechat_on" sel:@selector(wechatShareAction:)];
        [self createTheButtonWithNormal:@"pl_publishlive_friendcyle_off" selected:@"pl_publishlive_friendcyle_on" sel:@selector(weixin_circleShareAction:)];
    }
    if (self.fanweApp.appModel.sina_app_api == 1) {
        [self createTheButtonWithNormal:@"pl_publishlive_sina_off" selected:@"pl_publishlive_sina_on" sel:@selector(sinaShareAction:)];
        }
    self.shareStr = @"";
    
    
}
- (UIButton *)createTheButtonWithNormal:(NSString *)normal selected:(NSString *)selected sel:(SEL)sel
{
    NSUInteger num = self.shareImgViewArray.count;
    CGFloat width = 52;
    CGFloat height = 50;
    CGFloat space = (self.width - (num * width))/(num + 1);
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:normal] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:selected] forState:UIControlStateSelected];
    button.frame = CGRectMake(start_x, 0, width, height);
    [button addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    start_x += width + space;
    [self addSubview:button];
    return button;
    
}

- (void)QQShareAction:(UIButton *)sender
{
    if (![sender isEqual:self.selectedBtn]) {
        self.selectedBtn.selected = NO;
        self.selectedBtn = sender;
    }
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        self.shareStr = @"qq";
    }else {
        self.shareStr = @"";
    }
}
- (void)qzoneShareAction:(UIButton *)sender
{
    if (![sender isEqual:self.selectedBtn]) {
        self.selectedBtn.selected = NO;
        self.selectedBtn = sender;
    }
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.shareStr = @"qzone";
    }else {
        self.shareStr = @"";
    }
}
- (void)wechatShareAction:(UIButton *)sender
{
    if (![sender isEqual:self.selectedBtn]) {
        self.selectedBtn.selected = NO;
        self.selectedBtn = sender;
    }
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.shareStr = @"weixin";
    }else {
        self.shareStr = @"";
    }
}
- (void)weixin_circleShareAction:(UIButton *)sender
{
    if (![sender isEqual:self.selectedBtn]) {
        self.selectedBtn.selected = NO;
        self.selectedBtn = sender;
    }
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.shareStr = @"weixin_circle";
    }else {
        self.shareStr = @"";
    }
}
- (void)sinaShareAction:(UIButton *)sender
{
    if (![sender isEqual:self.selectedBtn]) {
        self.selectedBtn.selected = NO;
        self.selectedBtn = sender;
    }
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.shareStr = @"sina";
    }else {
        self.shareStr = @"";
    }
}

- (GlobalVariables *)fanweApp
{
    if (!_fanweApp)
    {
        _fanweApp = [GlobalVariables sharedInstance];
    }
    return _fanweApp;
}
@end
