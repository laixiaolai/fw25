//
//  FWTLinkMicPlayItem.m
//  FanweApp
//
//  Created by xfg on 2017/1/20.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "FWTLinkMicPlayItem.h"

@implementation FWTLinkMicPlayItem

- (void)initLoadingView:(UIView*)view
{
    CGRect rect = view.frame;
    
    if (_loadingBackground == nil)
    {
        _loadingBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(rect), CGRectGetHeight(rect))];
        _loadingBackground.hidden = YES;
        _loadingBackground.backgroundColor = [UIColor blackColor];
        _loadingBackground.alpha  = 0.5;
        [view addSubview:_loadingBackground];
        
        if (_loadingTextView == nil)
        {
            _loadingTextView = [[UITextView alloc]init];
            _loadingTextView.bounds = CGRectMake(0, 0, CGRectGetWidth(rect), 30);
            _loadingTextView.center = CGPointMake(CGRectGetWidth(rect) / 2, CGRectGetHeight(rect) / 2 - 30);
            _loadingTextView.textAlignment = NSTextAlignmentCenter;
            _loadingTextView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
            _loadingTextView.textColor = [UIColor blackColor];
            _loadingTextView.text = @"连麦中···";
            _loadingTextView.hidden = YES;
            [_loadingBackground addSubview:_loadingTextView];
        }
    }
    
    if (_loadingImageView == nil)
    {
        float width = 50;
        float height = 50;
        NSMutableArray *array = [[NSMutableArray alloc] initWithObjects:[UIImage imageNamed:@"loading_image0.png"],
                                 [UIImage imageNamed:@"loading_image1.png"],
                                 [UIImage imageNamed:@"loading_image2.png"],
                                 [UIImage imageNamed:@"loading_image3.png"],
                                 [UIImage imageNamed:@"loading_image4.png"],
                                 [UIImage imageNamed:@"loading_image5.png"],
                                 [UIImage imageNamed:@"loading_image6.png"],
                                 [UIImage imageNamed:@"loading_image7.png"],
                                 [UIImage imageNamed:@"loading_image8.png"],
                                 [UIImage imageNamed:@"loading_image9.png"],
                                 [UIImage imageNamed:@"loading_image10.png"],
                                 [UIImage imageNamed:@"loading_image11.png"],
                                 [UIImage imageNamed:@"loading_image12.png"],
                                 [UIImage imageNamed:@"loading_image13.png"],
                                 [UIImage imageNamed:@"loading_image14.png"],
                                 nil];
        _loadingImageView = [[UIImageView alloc] init];
        _loadingImageView.bounds = CGRectMake(0, 0, width, height);
        _loadingImageView.center = CGPointMake(CGRectGetWidth(rect) / 2, CGRectGetHeight(rect) / 2);;
        _loadingImageView.animationImages = array;
        _loadingImageView.animationDuration = 1;
        _loadingImageView.hidden = YES;
        [view addSubview:_loadingImageView];
    }
}

- (void)emptyPlayInfo
{
    _pending = NO;
    _isWorking = NO;
    _userID  = @"";
    _playUrl = @"";
    
    _loadingBackground = nil;
    _loadingImageView = nil;
    
    _reStartTimes = 0;
}

- (void)setLoadingText:(NSString*)text
{
    if (_loadingTextView)
    {
        _loadingTextView.text = text;
    }
}

- (void)startLoading
{
    if (_loadingBackground)
    {
        _loadingBackground.hidden = NO;
    }
    
    if (_loadingImageView)
    {
        _loadingImageView.hidden = NO;
        [_loadingImageView startAnimating];
    }
}

- (void)stopLoading
{
    if (_loadingBackground)
    {
        _loadingBackground.hidden = YES;
    }
    
    if (_loadingImageView)
    {
        _loadingImageView.hidden = YES;
        [_loadingImageView stopAnimating];
    }
}

- (void)startPlay:(NSString*)playUrl
{
    _livePlayListener.playUrl = playUrl;
    _playUrl = playUrl;
    
    [self reStartPlay];
}

- (void)reStartPlay
{
    if (_btnKickout)
    {
        _btnKickout.hidden = YES;
    }
    if(_livePlayer)
    {
        [_livePlayer removeVideoWidget];
        [_livePlayer stopPlay];
    }
    
    if(_livePlayer)
    {
        [_livePlayer setupVideoWidget:CGRectMake(0, 0, 0, 0) containView: _videoView insertIndex:0];
        [_livePlayer setRenderMode:RENDER_MODE_FILL_SCREEN];
        [_livePlayer startPlay:_playUrl type:PLAY_TYPE_LIVE_RTMP_ACC];
    }
}

- (void)stopPlay
{
    [self stopLoading];
    
    if (_btnKickout)
    {
        _btnKickout.hidden = YES;
    }
    if(_livePlayer)
    {
        [_livePlayer removeVideoWidget];
        [_livePlayer stopPlay];
    }
}

@end
