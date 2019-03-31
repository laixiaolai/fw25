//
//  FWKSYPlayerController.m
//  FanweApp
//
//  Created by xfg on 2017/2/10.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "FWKSYPlayerController.h"

@interface FWKSYPlayerController ()
{
    double             _lastSize;             //上一秒读取的数据量
    NSTimeInterval     _lastCheckTime;        //上一秒的时间点
    BOOL               _reloading;
    NSTimer            *_proTimer;
}

@end

@implementation FWKSYPlayerController

- (void)dealloc
{
    [self releaseAll];
}

- (void)releaseAll
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [_moviePlayer removeObserver:self forKeyPath:@"currentPlaybackTime" context:nil];
    [_moviePlayer removeObserver:self forKeyPath:@"clientIP" context:nil];
    [_moviePlayer removeObserver:self forKeyPath:@"localDNSIP" context:nil];
    
    if ([self observationInfo])
    {
        
    }
    
    @try {
        [self removeObserver:self forKeyPath:@"moviePlayer"];
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    
    [_moviePlayer.view removeFromSuperview];
    self.moviePlayer = nil;
    
    if (_proTimer)
    {
        [_proTimer invalidate];
        _proTimer = nil;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 添加视频容器视图
    _videoContrainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    _videoContrainerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_videoContrainerView];
    
    [self addObserver:self forKeyPath:@"moviePlayer" options:NSKeyValueObservingOptionNew context:nil];
}

#pragma mark 初始化视频播放类
- (void)initPlayerWithUrl:(NSURL *)playUrl createType:(NSInteger)createType
{
    if (!playUrl)
    {
        return;
    }
    
    if (_moviePlayer)
    {
        [self reloadPlay];
        return;
    }
    
    _playUrl = playUrl;
    _lastSize = 0.0;
    self.moviePlayer = [[KSYMoviePlayerController alloc] initWithContentURL:playUrl];
    
    [self setupObservers];
    
    _moviePlayer.logBlock = ^(NSString *logJson){
        //        NSLog(@"logJson is %@",logJson);
    };
    
    _moviePlayer.controlStyle = MPMovieControlStyleNone;
    [_moviePlayer.view setFrame:_videoContrainerView.frame];  // player's frame must match parent's
    [_videoContrainerView addSubview:_moviePlayer.view];
    _videoContrainerView.autoresizesSubviews = TRUE;
    _moviePlayer.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    // 播放视频时是否需要自动播放，默认值为YES。
    _moviePlayer.shouldAutoplay = TRUE;
    // 是否开启视频后处理
    _moviePlayer.shouldEnableVideoPostProcessing = TRUE;
    // 当前缩放显示模式
    if (createType == 1)
    {
        _moviePlayer.scalingMode = MPMovieScalingModeAspectFit;
    }
    else
    {
        _moviePlayer.scalingMode = MPMovieScalingModeFill;
    }
    
    // 是否开启硬件解码
    _moviePlayer.videoDecoderMode = MPMovieVideoDecoderMode_AUTO;
    // 是否静音
    _moviePlayer.shouldMute = NO;
    // 收集日志的状态，默认开启
    _moviePlayer.shouldEnableKSYStatModule = NO;
    // 是否循环播放
    _moviePlayer.shouldLoop = NO;
    // 是否进行视频反交错处理
    _moviePlayer.deinterlaceMode = MPMovieVideoDeinterlaceMode_Auto;
    // 指定拉流超时时间,单位是秒
    [_moviePlayer setTimeout:10 readTimeout:60];
    
    NSKeyValueObservingOptions opts = NSKeyValueObservingOptionNew;
    [_moviePlayer addObserver:self forKeyPath:@"currentPlaybackTime" options:opts context:nil];
    [_moviePlayer addObserver:self forKeyPath:@"clientIP" options:opts context:nil];
    [_moviePlayer addObserver:self forKeyPath:@"localDNSIP" options:opts context:nil];
    
    NSLog(@"sdk version:%@", [_moviePlayer getVersion]);
    [_moviePlayer prepareToPlay];
    [self isCurPlaying:YES];
}

#pragma mark - ----------------------- 播放事件 -----------------------
- (void)isCurPlaying:(BOOL)isPlaying
{
    if (isPlaying)
    {
        [_reLiveProgressView.playBtn setImage:[UIImage imageNamed:@"fw_relive_suspend"] forState:UIControlStateNormal];
    }
    else
    {
        [_reLiveProgressView.playBtn setImage:[UIImage imageNamed:@"fw_relive_start"] forState:UIControlStateNormal];
    }
}
#pragma mark 暂停播放
- (void)pausePlay
{
    [self isCurPlaying:NO];
    if (_moviePlayer)
    {
        [_moviePlayer pause];
    }
}

#pragma mark 继续播放
- (void)resumePlay
{
    [self isCurPlaying:YES];
    if (_moviePlayer)
    {
        [_moviePlayer play];
    }
}

#pragma mark 重新播放
- (void)reloadPlay
{
    [self isCurPlaying:YES];
    if (_moviePlayer && _playUrl)
    {
        [_moviePlayer reload:_playUrl flush:NO mode:MPMovieReloadMode_Accurate];
    }
}

#pragma mark 结束播放
- (void)stopPlay
{
    [self isCurPlaying:NO];
    if (_moviePlayer)
    {
        [_moviePlayer stop];
    }
    
    [self releaseAll];
}


#pragma mark - ----------------------- 时间监听 -----------------------
- (void)setupObservers
{
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handlePlayerNotify:)
                                                name:(MPMediaPlaybackIsPreparedToPlayDidChangeNotification)
                                              object:_moviePlayer];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handlePlayerNotify:)
                                                name:(MPMoviePlayerPlaybackStateDidChangeNotification)
                                              object:_moviePlayer];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handlePlayerNotify:)
                                                name:(MPMoviePlayerPlaybackDidFinishNotification)
                                              object:_moviePlayer];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handlePlayerNotify:)
                                                name:(MPMoviePlayerLoadStateDidChangeNotification)
                                              object:_moviePlayer];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handlePlayerNotify:)
                                                name:(MPMovieNaturalSizeAvailableNotification)
                                              object:_moviePlayer];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handlePlayerNotify:)
                                                name:(MPMoviePlayerFirstVideoFrameRenderedNotification)
                                              object:_moviePlayer];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handlePlayerNotify:)
                                                name:(MPMoviePlayerFirstAudioFrameRenderedNotification)
                                              object:_moviePlayer];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handlePlayerNotify:)
                                                name:(MPMoviePlayerSuggestReloadNotification)
                                              object:_moviePlayer];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handlePlayerNotify:)
                                                name:(MPMoviePlayerPlaybackStatusNotification)
                                              object:_moviePlayer];
}

- (void)handlePlayerNotify:(NSNotification*)notify
{
    if (!_moviePlayer)
    {
        return;
    }
    if (MPMediaPlaybackIsPreparedToPlayDidChangeNotification ==  notify.name)
    {
        NSLog(@"========接收监听：KSYPlayerVC: %@ -- ip:%@", [[_moviePlayer contentURL] absoluteString], [_moviePlayer serverAddress]);
        [self startProTimer];
    }
    if (MPMoviePlayerPlaybackStateDidChangeNotification ==  notify.name)
    {
        NSLog(@"========接收监听：player playback state: %ld", (long)_moviePlayer.playbackState);
    }
    if (MPMoviePlayerLoadStateDidChangeNotification ==  notify.name)
    {
        NSLog(@"========接收监听：player load state: %ld", (long)_moviePlayer.loadState);
        if (MPMovieLoadStateStalled & _moviePlayer.loadState)
        {
            NSLog(@"player start caching");
        }
        
        if (_moviePlayer.bufferEmptyCount && (MPMovieLoadStatePlayable & _moviePlayer.loadState || MPMovieLoadStatePlaythroughOK & _moviePlayer.loadState))
        {
            NSLog(@"player finish caching");
            NSString *message = [[NSString alloc]initWithFormat:@"loading occurs, %d - %0.3fs",
                                 (int)_moviePlayer.bufferEmptyCount,
                                 _moviePlayer.bufferEmptyDuration];
            NSLog(@"=======:%@",message);
        }
    }
    if (MPMoviePlayerPlaybackDidFinishNotification ==  notify.name)
    {
        NSLog(@"========接收监听：player finish state: %ld", (long)_moviePlayer.playbackState);
        NSLog(@"player download flow size: %f MB", _moviePlayer.readSize);
        NSLog(@"buffer monitor  result: \n   empty count: %d, lasting: %f seconds",
              (int)_moviePlayer.bufferEmptyCount,
              _moviePlayer.bufferEmptyDuration);
        int reason = [[[notify userInfo] valueForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
        if (reason ==  MPMovieFinishReasonPlaybackEnded)
        {
            NSString *tipStr = [NSString stringWithFormat:@"player finish"];
            NSLog(@"%@",tipStr);
        }
        else if (reason == MPMovieFinishReasonPlaybackError)
        {
            NSString *tipStr = [NSString stringWithFormat:@"player Error : %@", [[notify userInfo] valueForKey:@"error"]];
            NSLog(@"%@",tipStr);
        }
        else if (reason == MPMovieFinishReasonUserExited)
        {
            NSString *tipStr = [NSString stringWithFormat:@"player userExited"];
            NSLog(@"%@",tipStr);
        }
        [_reLiveProgressView.playBtn setImage:[UIImage imageNamed:@"fw_relive_start"] forState:UIControlStateNormal];
    }
    
    if (MPMovieNaturalSizeAvailableNotification ==  notify.name)
    {
        NSLog(@"========接收监听：video size %.0f-%.0f", _moviePlayer.naturalSize.width, _moviePlayer.naturalSize.height);
    }
    if (MPMoviePlayerFirstVideoFrameRenderedNotification == notify.name)
    {
        _reloading = NO;
        if (_delegate && [_delegate respondsToSelector:@selector(firstFrame:)])
        {
            [_delegate firstFrame:self];
        }
    }
    
    if (MPMoviePlayerFirstAudioFrameRenderedNotification == notify.name)
    {
        NSLog(@"========接收监听：first audio frame render");
    }
    
    if (MPMoviePlayerSuggestReloadNotification == notify.name)
    {
        NSLog(@"========接收监听：suggest using reload function!\n");
        if(!_reloading)
        {
            _reloading = YES;
            
            __weak typeof(self) ws = self;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(){
                [ws reloadPlay];
            });
        }
    }
    
    if(MPMoviePlayerPlaybackStatusNotification == notify.name)
    {
        int status = [[[notify userInfo] valueForKey:MPMoviePlayerPlaybackStatusUserInfoKey] intValue];
        if(MPMovieStatusVideoDecodeWrong == status)
        {
            NSLog(@"========接收监听：Video Decode Wrong!\n");
        }
        else if(MPMovieStatusAudioDecodeWrong == status)
        {
            NSLog(@"========接收监听：Audio Decode Wrong!\n");
        }
        else if (MPMovieStatusHWCodecUsed == status )
        {
            NSLog(@"========接收监听：Hardware Codec used\n");
        }
        else if (MPMovieStatusSWCodecUsed == status )
        {
            NSLog(@"========接收监听：Software Codec used\n");
        }
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if([keyPath isEqual:@"currentPlaybackTime"])
    {
        if (_moviePlayer && _reLiveProgressView)
        {
            _reLiveProgressView.playProgress = _moviePlayer.currentPlaybackTime / _moviePlayer.duration;
        }
    }
    else if([keyPath isEqual:@"clientIP"])
    {
        NSLog(@"client IP is %@\n", [change objectForKey:NSKeyValueChangeNewKey]);
    }
    else if([keyPath isEqual:@"localDNSIP"])
    {
        NSLog(@"local DNS IP is %@\n", [change objectForKey:NSKeyValueChangeNewKey]);
    }
    else if ([keyPath isEqualToString:@"moviePlayer"])
    {
        if (_reLiveProgressView)
        {
            if (_moviePlayer)
            {
                _reLiveProgressView.hidden = NO;
                __weak KSYMoviePlayerController * weakPlayer = _moviePlayer;
                _reLiveProgressView.dragingSliderCallback = ^(float progress){
                    typeof(weakPlayer) strongPlayer = weakPlayer;
                    double seekPos = progress * strongPlayer.duration;
                    //strongPlayer.currentPlaybackTime = progress * strongPlayer.duration;
                    //使用currentPlaybackTime设置为依靠关键帧定位
                    //使用seekTo:accurate并且将accurate设置为YES时为精确定位
                    [strongPlayer seekTo:seekPos accurate:YES];
                };
            }
            else
            {
                _reLiveProgressView.hidden = YES;
            }
        }
    }
}

#pragma mark - ----------------------- 点播模块独有的 -----------------------
- (void)startProTimer
{
    if (_reLiveProgressView)
    {
        _reLiveProgressView.totalTimeInSeconds = _moviePlayer.duration;
    }
    if(_proTimer != nil)
    {
        return;
    }
    _proTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateStat:) userInfo:nil repeats:YES];
}

- (void)updateStat:(NSTimer *)timer
{
    double flowSize = [_moviePlayer readSize];
    _speedK = 8*1024.0*(flowSize - _lastSize)/([self getCurrentTime] - _lastCheckTime);
    
    _lastCheckTime = [self getCurrentTime];
    _lastSize = flowSize;
    
    if (_reLiveProgressView)
    {
        CGFloat duration = _moviePlayer.duration;
        CGFloat playableDuration = _moviePlayer.playableDuration;
        if(duration > 0)
        {
            _reLiveProgressView.cacheProgress = playableDuration / duration;
        }
        else
        {
            _reLiveProgressView.cacheProgress = 0.0;
        }
    }
}

- (NSTimeInterval) getCurrentTime
{
    return [[NSDate date] timeIntervalSince1970];
}


@end
