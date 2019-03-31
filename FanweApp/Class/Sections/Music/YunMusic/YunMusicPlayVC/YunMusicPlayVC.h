//
//  YunMusicPlayVC.h
//  FanweApp
//
//  Created by 岳克奎 on 16/11/14.
//  Copyright © 2016年 xfg. All rights reserved.
//

/****************************************** 使用云直播music说明 ***************************
 1.laod type  = 0    3为互动直播    在互动直播间（未涉及云），用在reLiveController ----> #pragma mark 主播音乐
 2.quit 直播间  ---->#pragma mark -移除 音效VC
 */

#import <UIKit/UIKit.h>
#import "choseMuiscVC.h"
#import "YunMusicSoundEffectVC.h"

@interface YunMusicPlayVC : UIViewController<MusicCenterManagerLrcDataDelegate>

@property (weak, nonatomic) IBOutlet UIButton               *soundEffect_Btn;       // 音效
@property (weak, nonatomic) IBOutlet UIButton               *misicEnd_Btn;          // 结束播放
@property (weak, nonatomic) IBOutlet UIButton               *pauseMusic_Btn;        // 暂停music
@property (weak, nonatomic) IBOutlet UILabel                *musicName_Lab;         // 音乐名
@property (assign, nonatomic) BOOL                          yunMusicPlaying;        // 正在播放
@property (strong, nonatomic) NSString                      *musicFilePath_Str;     // 记录播放的路径
@property (nonatomic, strong) FWTLiveController             *fwTLiveController;
@property (strong, nonatomic) UIPanGestureRecognizer        *musicPlayVC_Pan_Ges;
@property (weak, nonatomic) IBOutlet LrcShowView            *lrcView;               // LrcView承载两行歌词的View
@property (strong, nonatomic) musiceModel                   *recordMusicModel;
@property (assign, nonatomic) NSInteger                     recordMusicTotalTime;
@property (assign, nonatomic) NSInteger                     recordMusicCurrentTime;
@property (nonatomic, assign) NSInteger                     livePlayType;           // 0：推流, 1：点播(回播、回看), 2：直播, 3：互动直播

@property (nonatomic, assign) CGFloat                       recordBgmValue;
@property (nonatomic, assign) CGFloat                       recordMicValue;

@property (nonatomic, strong) UIViewController              *musicPlaySuperVC;      // 音乐播放父控制器

@property (nonatomic, copy) void(^yunMusicPlayVCPanGesBlock)(YunMusicPlayVC* yunMusicPlayVC,UIPanGestureRecognizer *pan);

#pragma mark - Method
- (IBAction)soundefectSet:(UIButton *)sender;
- (IBAction)soundEndBtnClick:(UIButton *)sender;
- (IBAction)pauseMusic:(UIButton *)sender;

#pragma mark - 显示选择音乐界面
/**
 *  直播间进入音乐选择界面-->选择music
 */
- (void)showYunMusicPlayInVC:(UIViewController*)vc inview:(UIView*)inview showframe:(CGRect)showframe myPlayType:(NSInteger)playType;

/**
 * 选择音乐后，回到直播间加载music
 */
+ (YunMusicPlayVC *)showYunMusicPlayInVC:(UIViewController*)vc inview:(UIView*)inview musicFrame:(CGRect)musicFrame  musicmodel:(musiceModel*)musicmodel  PlayType:(NSInteger)playType;

@end
