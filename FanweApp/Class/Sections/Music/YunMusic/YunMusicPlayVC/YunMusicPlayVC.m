//
//  YunMusicPlayVC.m
//  FanweApp
//
//  Created by 岳克奎 on 16/11/14.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "YunMusicPlayVC.h"

@interface YunMusicPlayVC ()<YunMusicSoundEffectVCDelegate>

@end

@implementation YunMusicPlayVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _musicPlayVC_Pan_Ges = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGesClick:)];
    [self.view addGestureRecognizer:_musicPlayVC_Pan_Ges];
}

- (void)panGesClick:(UIPanGestureRecognizer *)pan
{
    if (_yunMusicPlayVCPanGesBlock)
    {
        _yunMusicPlayVCPanGesBlock(self,_musicPlayVC_Pan_Ges);
    }
}

#pragma mark 音效页面
- (IBAction)soundefectSet:(UIButton *)sender
{
    YunMusicSoundEffectVC *soundsEffect_VC = [YunMusicSoundEffectVC showYunMusicSoundEffectVCInVC:_fwTLiveController inView:_fwTLiveController.liveServiceController.liveUIViewController.liveView showFrame:CGRectMake(0,0,kScreenW, kScreenH) oldBGMValue:_recordBgmValue oldMicValue:_recordMicValue];
    soundsEffect_VC.delegate = self;
}

#pragma mark- 关闭music
- (IBAction)soundEndBtnClick:(UIButton *)sender
{
    // 结束因为播放
    [self.fwTLiveController.publishController.txLivePublisher stopBGM];
    // 移除用代理 因为音效VC如果存在也要退出
    // 移除本页面
    [self removeMusicPlayVC];
    
    self.musicPlaySuperVC = nil;
}

#pragma mark- 暂停和播放  切换
/**
 暂停和播放 切换

 @param sender fw_relive_start：未播放    fw_relive_suspend：正在播放
 */
- (IBAction)pauseMusic:(UIButton *)sender
{
    _yunMusicPlaying = !_yunMusicPlaying;
    if (_yunMusicPlaying)
    {
        // 暂停状态 转为播放
        [self.fwTLiveController.publishController.txLivePublisher pauseBGM];
        [_pauseMusic_Btn setImage:[UIImage imageNamed:@"fw_relive_suspend"] forState:UIControlStateNormal];
        [self.fwTLiveController.publishController.txLivePublisher resumeBGM];
        if (self.recordMusicCurrentTime+200>= self.recordMusicTotalTime && self.recordMusicModel &&_yunMusicPlaying&&self.recordMusicTotalTime/1000>10)
        {
            // 需要重新播放
            __weak YunMusicPlayVC *weak_Self= self;
            [[MusicCenterManager shareManager] showMusicLRCofLRCDataStr:weak_Self.recordMusicModel.mLrc_content musicNameStr:weak_Self.recordMusicModel.mAudio_name musicSingerStr:weak_Self.recordMusicModel.mArtist_name complete:^(BOOL finished, NSMutableArray *lrcModelMArray, NSMutableArray *lrcPointTimeStrArray)
             {
                 // 歌词处理完毕 得到数据  将处理好的数据 传给lrcView，等待歌词开启的时候使用
                 weak_Self.lrcView.lrcUpLab.text = @" ";
                 weak_Self.lrcView.lrcDowmLab.text = @" ";
                 weak_Self.lrcView.lrcModelMArray = lrcModelMArray;
                 
                 weak_Self.lrcView.lrcTimePointMArray = lrcPointTimeStrArray;
                 
                 // 开始播放
                 weak_Self.yunMusicPlaying =  [weak_Self.fwTLiveController.publishController.txLivePublisher playBGM:[weak_Self getFullFilePath:weak_Self.recordMusicModel.mFilePath] withBeginNotify:^(NSInteger errCode) {
                     
                 } withProgressNotify:^(NSInteger progressMS, NSInteger durationMS) {
                     
                     // 再检修播放
                     weak_Self.recordMusicTotalTime = durationMS;
                     weak_Self.recordMusicCurrentTime = progressMS;
                     if (progressMS+200>=durationMS)
                     {
                         weak_Self.yunMusicPlaying  = NO;
                         [weak_Self.pauseMusic_Btn setImage:[UIImage imageNamed:@"fw_relive_start"] forState:UIControlStateNormal];
                     }
                     
                     [ weak_Self.lrcView setCurrentTime:progressMS*0.001 musicTotalTime:durationMS*0.001 present:durationMS ==0 ?0:(CGFloat)progressMS/durationMS];
                     
                 }andCompleteNotify:^(NSInteger errCode) {
                     
                 }];
             }];
        }
    }
    else
    {
        [self.fwTLiveController.publishController.txLivePublisher pauseBGM];
        [_pauseMusic_Btn setImage:[UIImage imageNamed:@"fw_relive_start"] forState:UIControlStateNormal];
    }
}

- (void)showYunMusicPlayInVC:(UIViewController*)vc inview:(UIView*)inview showframe:(CGRect)showframe myPlayType:(NSInteger)playType
{
    // 1 选择music vc
    choseMuiscVC* chosevc = [[choseMuiscVC alloc]initWithNibName:@"choseMuiscVC" bundle:nil];
    // 2 nav
    UIViewController* nullvc = UIViewController.new;
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:nullvc];
    nav.navigationBarHidden = YES;
    nav.view.backgroundColor = [UIColor clearColor];
    nav.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    
    self.musicPlaySuperVC = vc;
    // 3
    __block UIViewController *tmpVC = self.musicPlaySuperVC;
    chosevc.mitblock = ^(musiceModel* chosemusic)
    {
        [nav dismissViewControllerAnimated:YES completion:^{
            
            if(chosemusic)
            {
                // 选择了就开始放歌了
                [YunMusicPlayVC showYunMusicPlayInVC:tmpVC inview:inview musicFrame:showframe musicmodel:chosemusic PlayType:playType];
                tmpVC = nil;
            }
            
        }];
        
    };
    // 跳转到choseMusicVC
    [vc presentViewController:nav animated:NO completion:^{
        [nav pushViewController:chosevc animated:YES];
    }];
}

#pragma mark -public  methods ------------------------------------------ 公有方法区域  -----------------------------------------
- (NSInteger)fileSizeAtPath:(NSString*) filePath
{
    NSFileManager* manager = [NSFileManager defaultManager];
    
    if ([manager fileExistsAtPath:filePath])
    {
        return (NSInteger)[[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

#pragma mark 加载到 直播VC上
+ (YunMusicPlayVC *)showYunMusicPlayInVC:(UIViewController*)vc inview:(UIView*)inview musicFrame:(CGRect)musicFrame musicmodel:(musiceModel*)musicmodel PlayType:(NSInteger)playType
{
    FWTLiveController *live_VC = (FWTLiveController *)vc;
    for (UIView *one_View in live_VC.liveServiceController.liveUIViewController.liveView.subviews)
    {
        if ([one_View.nextResponder isKindOfClass:[YunMusicPlayVC class]])
        {
            [live_VC removeChild:(YunMusicPlayVC *)one_View.nextResponder];
            [one_View removeFromSuperview];
        }
    }
    
    YunMusicPlayVC *music_VC = [[YunMusicPlayVC alloc]initWithNibName:@"YunMusicPlayVC" bundle:nil];
    music_VC.recordBgmValue = 1.0;
    music_VC.recordMicValue = 1.0;
    
    MUSIC_CENTER_MANAGER.dataDelegate =  music_VC;
    [vc addChild:music_VC];
    [inview addSubview:music_VC.view];
    music_VC.view.frame = musicFrame;
    music_VC.fwTLiveController =(FWTLiveController *)vc;
    if (music_VC.fwTLiveController.publishController.txLivePublisher)
    {
        
    }
    // 歌词处理
    __weak YunMusicPlayVC *weak_playVC = music_VC;
    music_VC.recordMusicModel = musicmodel;
    [[MusicCenterManager shareManager] showMusicLRCofLRCDataStr:musicmodel.mLrc_content musicNameStr:musicmodel.mAudio_name musicSingerStr:musicmodel.mArtist_name complete:^(BOOL finished, NSMutableArray *lrcModelMArray, NSMutableArray *lrcPointTimeStrArray)
     {
         // 歌词处理完毕 得到数据  将处理好的数据 传给lrcView，等待歌词开启的时候使用
         weak_playVC.lrcView.lrcUpLab.text = @" ";
         weak_playVC.lrcView.lrcDowmLab.text = @" ";
         weak_playVC.lrcView.lrcModelMArray = lrcModelMArray;
         
         weak_playVC.lrcView.lrcTimePointMArray = lrcPointTimeStrArray;
         
         NSLog(@"==========filePath:%@",[music_VC getFullFilePath:musicmodel.mFilePath]);
         NSLog(@"eqqew ========== %ld",(long)[music_VC fileSizeAtPath:[music_VC getFullFilePath:musicmodel.mFilePath]]);
         // 开始播放,先结束之前播放的BGM
         [music_VC.fwTLiveController.publishController.txLivePublisher stopBGM];
         weak_playVC.yunMusicPlaying =  [music_VC.fwTLiveController.publishController.txLivePublisher playBGM:[music_VC getFullFilePath:musicmodel.mFilePath] withBeginNotify:^(NSInteger errCode) {
             
         } withProgressNotify:^(NSInteger progressMS, NSInteger durationMS) {
             
             // 再检修播放
             weak_playVC.recordMusicTotalTime = durationMS;
             weak_playVC.recordMusicCurrentTime = progressMS;
             if (progressMS+200>=durationMS)
             {
                 weak_playVC.yunMusicPlaying  = NO;
                 [weak_playVC.pauseMusic_Btn setImage:[UIImage imageNamed:@"fw_relive_start"] forState:UIControlStateNormal];
             }
             [weak_playVC.lrcView setCurrentTime:progressMS*0.001 musicTotalTime:durationMS*0.001 present:durationMS ==0 ?0:(CGFloat)progressMS/durationMS];
             
         }andCompleteNotify:^(NSInteger errCode) {
             
         }];
     }];
    
    music_VC.musicName_Lab.text = [NSString stringWithFormat:@"%@(%@)",musicmodel.mAudio_name,musicmodel.mArtist_name];
    music_VC.yunMusicPlayVCPanGesBlock =^(YunMusicPlayVC* yunMusicPlayVC,UIPanGestureRecognizer *pan)
    {
        CGPoint panPoint = [pan locationInView:yunMusicPlayVC.fwTLiveController.liveServiceController.liveUIViewController.liveView];
        CGPoint panPoint_moveValue = [pan translationInView:yunMusicPlayVC.fwTLiveController.liveServiceController.liveUIViewController.liveView];
        [yunMusicPlayVC  setPanGesForYunMusicVC:panPoint withModeValue:panPoint_moveValue showInVC:yunMusicPlayVC];
        
    };
    
    return music_VC;
}

#pragma mark 完整的音乐文件地址
- (NSString*)getFullFilePath:(NSString *)filePathStr
{
    NSString *str = [NSString stringWithFormat:@"/Documents/%@/%@",@"music",filePathStr];
    if (str && ![str isEqualToString:@""])
    {
        return [NSHomeDirectory() stringByAppendingString:str];
    }
    return NSHomeDirectory();
}

#pragma -custom delegate ---------------------------------------------------自定义代理
- (void)changeMusicBtnOfPlayStatewWithMusicPlayState:(BOOL)musicPlaySate
{
    _yunMusicPlaying = !musicPlaySate;
    [self pauseMusic:nil];
}

#pragma mark - 音频效果的代理/调节伴奏 bgm
- (void)setBGMValue:(CGFloat )bgmValue
{
    _recordBgmValue = bgmValue;
    [self.fwTLiveController.publishController.txLivePublisher setBGMVolume:bgmValue];
    NSLog(@" current  bgmValue =  %f",bgmValue);
}

#pragma mark -调节人声 mic
- (void)setMicValue:(CGFloat )micValue
{
    _recordMicValue = micValue;
    [self.fwTLiveController.publishController.txLivePublisher setMicVolume:micValue];
    NSLog(@" current  micValue =  %f",micValue);
}

#pragma mark - 移除 VC
- (void)removeMusicPlayVC
{
    for (UIViewController *vc in self.fwTLiveController.childViewControllers)
    {
        if ([vc isKindOfClass:[self class]])
        {
            [self.fwTLiveController removeChild:vc];
            [vc.view removeFromSuperview];
        }
    }
}

#pragma mark ------------处理pan移动问题
/**
 移动到边界处理，当移动屏幕超出 默认window（界面）时，结束手势状态下，动画设置回弹效果 确保在屏幕内部

 @param panPoint 点击的点
 @param moveVlue 实时移动的店
 @param yunMusicPlayVC YunMusicPlayVC
 */
- (void)setPanGesForYunMusicVC:(CGPoint)panPoint withModeValue:(CGPoint)moveVlue showInVC:(YunMusicPlayVC *)yunMusicPlayVC
{
    yunMusicPlayVC.view.transform = CGAffineTransformTranslate( yunMusicPlayVC.view.transform, moveVlue.x, moveVlue.y);
    [yunMusicPlayVC.musicPlayVC_Pan_Ges setTranslation:CGPointZero inView:yunMusicPlayVC.view];
    
    if (yunMusicPlayVC.musicPlayVC_Pan_Ges.state == UIGestureRecognizerStateBegan)
    {
    }
    
    if (yunMusicPlayVC.musicPlayVC_Pan_Ges.state == UIGestureRecognizerStateChanged)
    {
    }
    
    if (yunMusicPlayVC.musicPlayVC_Pan_Ges.state == UIGestureRecognizerStateEnded)
    {
        if(yunMusicPlayVC.view.x<0)
        {
            [UIView animateWithDuration:0.2 animations:^{
                yunMusicPlayVC.view.x = 0;
            }completion:^(BOOL finished) {
                
            }];
        }
        
        if (yunMusicPlayVC.view.frame.origin.y<50)
        {
            [UIView animateWithDuration:0.2 animations:^{
                yunMusicPlayVC.view.y = 50;
            }completion:^(BOOL finished) {
                
            }];
        }
        
        if (yunMusicPlayVC.view.frame.origin.y> kScreenH - 300)
        {
            [UIView animateWithDuration:0.2 animations:^{
                yunMusicPlayVC.view.y = kScreenH-300;
            } completion:^(BOOL finished) {
                
            }];
            
        }
        
        if (yunMusicPlayVC.view.x>kScreenW-0.4*kScreenW)
        {
            [UIView animateWithDuration:0.2 animations:^{
                yunMusicPlayVC.view.x = kScreenW-0.4*kScreenW;
            } completion:^(BOOL finished) {
                
            }];
        }
    }
}

- (void)setRecordMusicModel:(musiceModel *)recordMusicModel
{
    _recordMusicModel = recordMusicModel;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
