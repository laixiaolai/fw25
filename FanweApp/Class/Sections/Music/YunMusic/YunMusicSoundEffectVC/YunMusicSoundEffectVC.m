//
//  YunMusicSoundEffectVC.m
//  FanweApp
//
//  Created by 岳克奎 on 16/11/14.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "YunMusicSoundEffectVC.h"

@interface YunMusicSoundEffectVC ()<UIGestureRecognizerDelegate>

@end

@implementation YunMusicSoundEffectVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self loadTapGes];
    
    //旋转 90
    self.bgm_Slider.transform = CGAffineTransformMakeRotation(-M_PI/2);
     self.mic_Slider.transform = CGAffineTransformMakeRotation(-M_PI/2);
    
    [self setMicSlider];
    [self setBgmSlider];
    [self addEffectOfFrostedGlassOnView:_soundEffect_BG_View
                             effectType:0];
}
#pragma mark - 设置 bgm Slider
- (void)setBgmSlider{
    _bgm_Slider.minimumValue = 0.0;////设置最小数
    _bgm_Slider.maximumValue = 2.0;///腾讯默认人声为1  0-2
     _bgm_Slider.value = _bgmNowValue_CGFloat;//设置起始位置
    _bgm_Slider.backgroundColor = [UIColor clearColor];//设置背景颜色
    [_bgm_Slider addTarget:self
                    action:@selector(updateBGMValue)
          forControlEvents:UIControlEventValueChanged];
    
}
- (void)updateBGMValue{
    self.bgmNowValue_CGFloat = self.bgm_Slider.value;
    //调代理
    if([_delegate respondsToSelector:@selector(setBGMValue:)]){
        [_delegate setBGMValue:_bgmNowValue_CGFloat];
    }
}

#pragma mark - 设置 Mic Slider
- (void)setMicSlider{
    _mic_Slider.minimumValue = 0.0;////设置最小数
    _mic_Slider.maximumValue = 2.0;///腾讯默认人声为1  0-2
    _mic_Slider.value = _micNowValue_CGFloat;//设置起始位置
    _mic_Slider.backgroundColor = [UIColor clearColor];//设置背景颜色
    [_mic_Slider addTarget:self action:@selector(updateMicValue) forControlEvents:UIControlEventValueChanged];
    
}
- (void)updateMicValue{
    self.micNowValue_CGFloat = self.mic_Slider.value;
    //调代理
    if([_delegate respondsToSelector:@selector(setMicValue:)]){
        [_delegate setMicValue:_micNowValue_CGFloat];
    }
}


#pragma mark - 创建 直播上音效界面
+(YunMusicSoundEffectVC *)showYunMusicSoundEffectVCInVC:(UIViewController *)vc inView:(UIView *)view showFrame:(CGRect)showFrame oldBGMValue:(CGFloat)oldBGMValue oldMicValue:(CGFloat)oldMicValue {
    YunMusicSoundEffectVC *soundEffect_VC = [[YunMusicSoundEffectVC alloc]initWithNibName:@"YunMusicSoundEffectVC"
                                                                                   bundle:nil];
//    [vc addChild:soundEffect_VC container:soundEffect_VC.view inRect:showFrame animation:^{
//        [UIView animateWithDuration:1
//                         animations:^{
//                             soundEffect_VC.view.transform = CGAffineTransformMakeTranslation(0, -soundEffect_VC.view.size.height);
//                                   }
//         
//                         completion:^(BOOL finished) {
//            
//                         }];
//    }];
   // TCShowReLiveViewController *reLive_VC =(TCShowReLiveViewController*) vc;

    [vc addChild:soundEffect_VC];
    [vc.view addSubview:soundEffect_VC.view];
    soundEffect_VC.view.frame =showFrame;
    soundEffect_VC.recoedLiveController = (FWTLiveController *)vc;
    //动画
//    [UIView animateWithDuration:1
//                     animations:^{
//         soundEffect_VC.view.transform = CGAffineTransformMakeTranslation(0, -soundEffect_VC.view.size.height);
//                                  }
//                     completion:^(BOOL finished) {
//        
//    }];
//    [UIView animateWithDuration:1 animations:^{
//         soundEffect_VC.view.transform = CGAffineTransformMakeTranslation(0, -soundEffect_VC.view.size.height);
//    }];
    soundEffect_VC.bgmNowValue_CGFloat = oldBGMValue;
    soundEffect_VC.micNowValue_CGFloat = oldMicValue;
    
    soundEffect_VC.bgm_Slider.value = oldBGMValue;
    soundEffect_VC.mic_Slider.value = oldMicValue;
    return soundEffect_VC;

}

#pragma mark - 点击X 关闭
- (IBAction)removeFromReliveVC:(UIButton *)sender {
//    if([_delegate respondsToSelector:@selector(removeYunMusicSoundEffectVC)]){
//        [_delegate removeYunMusicSoundEffectVC];
//    }
    [self  removeYunMusicSoundEffectViewController];
}
#pragma mark - 还原slider value
- (IBAction)recoverDefaultSliderValue:(UIButton *)sender {
    _bgm_Slider.value = 1.0;
    _mic_Slider.value = 1.0;
    [self updateBGMValue];
    [self updateMicValue];
}


#pragma nark -高斯处理 (笔记已经扩展3种)
- (void)addEffectOfFrostedGlassOnView:(UIView *)bgView
                          effectType:(NSInteger)type{
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:type];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame =CGRectMake(0, 0,bgView.bounds.size.width,bgView.bounds.size.height);
    //bgView.alpha = 0.5;
    [bgView addSubview:effectView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - gets
- (void)loadTapGes{
        _tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                         action:@selector(removeYunMusicSoundEffectViewController)];
        _tapGes.delegate =self;
        [self.bgView addGestureRecognizer:_tapGes];

}
- (void)removeYunMusicSoundEffectViewController{
    if (self&&self.recoedLiveController) {
        [self.recoedLiveController removeChild:self];
        [self.view removeFromSuperview];
    }
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
       shouldReceiveTouch:(UITouch *)touch{
    if (![touch.view isDescendantOfView:self.bgView]) {
        return NO;
    }
    return YES;
}

@end
