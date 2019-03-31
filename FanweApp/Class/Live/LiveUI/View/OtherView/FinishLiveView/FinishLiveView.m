//
//  FinishLiveView.m
//  FanweApp
//
//  Created by xfg on 2017/8/28.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "FinishLiveView.h"

@implementation FinishLiveView

- (id)init
{
    self  = [[[NSBundle mainBundle] loadNibNamed:@"FinishLiveView" owner:self options:nil] lastObject];
    if(self)
    {
        self.frame = CGRectMake(0, 0, kScreenW, kScreenH);
        
        self.backgroundColor = kClearColor;
        self.bgView.backgroundColor = kGrayTransparentColor1;
                // 毛玻璃效果
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        effectView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [self.bgView addSubview:effectView];
        
        self.userHeadImgView.layer.borderWidth = 1;
        self.userHeadImgView.layer.borderColor = kWhiteColor.CGColor;
        self.userHeadImgView.layer.cornerRadius = CGRectGetHeight(self.userHeadImgView.frame)/2;
        self.userHeadImgView.clipsToBounds = YES;
        
        self.shareFollowBtn.layer.borderWidth = 1;
        self.shareFollowBtn.layer.borderColor = kWhiteColor.CGColor;
        self.shareFollowBtn.layer.cornerRadius = CGRectGetHeight(self.shareFollowBtn.frame)/2;
        
        self.backHomeBtn.layer.borderWidth = 1;
        self.backHomeBtn.layer.borderColor = kWhiteColor.CGColor;
        self.backHomeBtn.layer.cornerRadius = CGRectGetHeight(self.backHomeBtn.frame)/2;
        self.ticketNameLabel.text = [NSString stringWithFormat:@"获得%@",self.fanweApp.appModel.ticket_name];
        [self.delLiveBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        self.delLiveBtn.hidden = YES;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.userHeadImgView.layer.cornerRadius = CGRectGetWidth(self.userHeadImgView.frame)/2;
    
}

- (IBAction)shareFollowAction:(id)sender
{
    if (_shareFollowBlock)
    {
        _shareFollowBlock();
    }
}

- (IBAction)backHomeAction:(id)sender
{
    if (_backHomeBlock)
    {
        _backHomeBlock();
    }
}

- (IBAction)delLiveAction:(id)sender
{
    if (_delLiveBlock)
    {
        _delLiveBlock();
    }
}

@end
