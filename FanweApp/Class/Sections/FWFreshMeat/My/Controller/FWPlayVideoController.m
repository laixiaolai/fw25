//
//  FWPlayVideoController.m
//  FanweApp
//
//  Created by fanwe2014 on 2017/4/10.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "FWPlayVideoController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

@interface FWPlayVideoController ()
{
    AVPlayer                    *_player;                //视频播放器
    AVPlayerViewController      *_playerController;
    AVAudioSession              *_session;
}
@property (nonatomic,strong)MPMoviePlayerController *mp;
@end

@implementation FWPlayVideoController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self creatMainView];
}



- (void)creatMainView
{
    self.view.backgroundColor = [UIColor blackColor];
    
    _session = [AVAudioSession sharedInstance];
    [_session setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    _player = [AVPlayer playerWithURL:[NSURL URLWithString:self.playUrl]];
    _playerController = [[AVPlayerViewController alloc] init];
    _playerController.player = _player;
    _playerController.videoGravity = AVLayerVideoGravityResizeAspect;
    _playerController.allowsPictureInPicturePlayback = true;    //画中画，iPad可用
    _playerController.showsPlaybackControls = true;
    
    [self addChildViewController:_playerController];
    _playerController.view.translatesAutoresizingMaskIntoConstraints = true;    //AVPlayerViewController 内部可能是用约束写的，这句可以禁用自动约束，消除报错
    _playerController.view.frame = CGRectMake(0, 0, kScreenW, kScreenH);
    [self.view addSubview:_playerController.view];
    [_playerController.player play];    //自动播放
    
    UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
    if ([UIDevice currentDevice].systemVersion.doubleValue > 11.0)
    {
      btn.frame=CGRectMake(10, kStatusBarHeight, 50, 50);
    }else
    {
      btn.frame=CGRectMake(10, 70, 50, 50);
    }
    
    btn.layer.cornerRadius = 25;
    btn.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    [btn setImage:[UIImage imageNamed:@"fw_me_comeBack"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(goBakc) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}


//返回按钮
- (void)goBakc
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [[UIApplication sharedApplication]setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    
}
//恢复系统导航栏的默认样式
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [[UIApplication sharedApplication]setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    _session = nil;
    _playerController = nil;
    _player = nil;
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[UIApplication sharedApplication]setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    _session = nil;
    _playerController = nil;
    _player = nil;
}




@end
