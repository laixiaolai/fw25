//
//  YunMusicSoundEffectVC.h
//  FanweApp
//
//  Created by 岳克奎 on 16/11/14.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YunMusicPlayVC;
@class FWTLiveController;

@protocol YunMusicSoundEffectVCDelegate <NSObject>

@optional
- (void)setBGMValue:(CGFloat )bgmValue;
- (void)setMicValue:(CGFloat )micValue;
////移除 音效VC
//- (void)removeYunMusicSoundEffectVC;
@end
@interface YunMusicSoundEffectVC :   UIViewController
@property (nonatomic ,weak) id <YunMusicSoundEffectVCDelegate>delegate;
@property (weak, nonatomic)   IBOutlet UIButton  *changeBtn;
@property (weak, nonatomic)   IBOutlet UIButton  *back_Btn;           //返回
@property (weak, nonatomic)   IBOutlet UISlider  *bgm_Slider;         //伴奏
@property (weak, nonatomic)   IBOutlet UISlider  *mic_Slider;         //人生
@property (weak, nonatomic)   IBOutlet UIView    *soundEffect_BG_View; //高斯 处理
@property (assign, nonatomic) CGFloat            bgmNowValue_CGFloat;//滑动伴奏 记录slider 数值
@property (assign, nonatomic) CGFloat            micNowValue_CGFloat;//滑动人声 记录slider 数值
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (strong, nonatomic)UITapGestureRecognizer *tapGes;
@property (weak, nonatomic) IBOutlet UIView *effectTopView;
@property (weak, nonatomic) IBOutlet UIView *effectControlView;
@property (strong, nonatomic) FWTLiveController *recoedLiveController;
#pragma mark - 创建 直播上音效界面
+(YunMusicSoundEffectVC *)showYunMusicSoundEffectVCInVC:(FWTLiveController *)vc inView:(UIView *)view showFrame:(CGRect)showFrame oldBGMValue:(CGFloat)oldBGMValue oldMicValue:(CGFloat)oldMicValue;
#pragma mark - 移除 音效界面
/**
 *   移除 音效调节界面
 */
//+ (void)removeYunMusicSoundEffectVC;
@end
