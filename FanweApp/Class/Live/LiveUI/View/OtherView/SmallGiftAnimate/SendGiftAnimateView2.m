//
//  SendGiftAnimateView2.m
//  FanweApp
//
//  Created by xfg on 16/5/23.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "SendGiftAnimateView2.h"

#define kBackGroundHeightRate 0.8
#define kBackGroundWidthRate 0.8

@interface SendGiftAnimateView2()<ShakeLabelDelegate2>{
    
    UIView *_backGroundView;
    UIImageView *_imgView;
    NSTimer* _animateDelayTimer; //动画停滞阶段计时
    CGFloat _viewY; //视图的Y值
    
}

@end

@implementation SendGiftAnimateView2

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame :frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        _viewY = frame.origin.y;
        
        _backGroundView = [[UIView alloc]initWithFrame:CGRectMake(-kBackGroundWidthRate*frame.size.width, frame.size.height*(1-kBackGroundHeightRate), frame.size.width*kBackGroundWidthRate, frame.size.height*kBackGroundHeightRate)];
        _backGroundView.backgroundColor = [UIColor clearColor];
        [self addSubview:_backGroundView];
        
        UIImageView *backGroundImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_backGroundView.frame), CGRectGetHeight(_backGroundView.frame))];
        backGroundImgView.contentMode = UIViewContentModeScaleToFill;
        [backGroundImgView setImage:[UIImage imageNamed:@"lr_small_gift_bg"]];
        backGroundImgView.clipsToBounds = YES;
        [_backGroundView addSubview:backGroundImgView];
        
        _headImgView = [[MenuButton alloc]initWithFrame:CGRectMake(1, 1, _backGroundView.frame.size.height-2, _backGroundView.frame.size.height-2)];
        _headImgView.contentMode = UIViewContentModeScaleAspectFill;
        _headImgView.layer.cornerRadius = (_backGroundView.frame.size.height-2)/2;
        _headImgView.clipsToBounds = YES;
        [_backGroundView addSubview:_headImgView];
        
        _titleNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_headImgView.frame)+5, 0, frame.size.width*0.6, _backGroundView.frame.size.height/2)];
        _titleNameLabel.textColor = [UIColor whiteColor];
        _titleNameLabel.font = [UIFont systemFontOfSize:13.0];
        [_backGroundView addSubview:_titleNameLabel];
        
        _giftNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_titleNameLabel.frame), CGRectGetMaxY(_titleNameLabel.frame), CGRectGetWidth(_titleNameLabel.frame), _backGroundView.frame.size.height/2)];
        _giftNameLabel.textColor = [UIColor yellowColor];
        _giftNameLabel.font = [UIFont systemFontOfSize:13.0];
        [_backGroundView addSubview:_giftNameLabel];
        
        CGFloat giftImgViewWH = self.frame.size.height-5;
        _giftImgView = [[UIImageView alloc]initWithFrame:CGRectMake(-giftImgViewWH, 0, giftImgViewWH, giftImgViewWH)];
        _giftImgView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_giftImgView];
        
        _numLabel = [[ShakeLabel2 alloc]initWithFrame:CGRectMake(frame.size.width*kBackGroundWidthRate, 0, frame.size.width*(1-kBackGroundWidthRate), frame.size.height*kBackGroundHeightRate)];
        _numLabel.backgroundColor = [UIColor clearColor];
        _numLabel.textColor = [UIColor greenColor];
        _numLabel.borderColor = [UIColor yellowColor];
        _numLabel.font = [UIFont systemFontOfSize:17];
        _numLabel.textAlignment = NSTextAlignmentCenter;
        _numLabel.delegate = self;
        [self addSubview:_numLabel];
        
        self.hidden = YES;
        
    }
    return  self;
}

- (void)setContent:(CustomMessageModel *)customMessageModel
{
    self.customMessageModel = customMessageModel;
    
    if(customMessageModel.type == 1)
    {
        [_headImgView sd_setImageWithURL:[NSURL URLWithString:customMessageModel.sender.head_image] forState:UIControlStateNormal placeholderImage:kDefaultPreloadHeadImg];
        
        _titleNameLabel.text = customMessageModel.sender.nick_name;
        _giftNameLabel.text = customMessageModel.desc;
        [_giftImgView sd_setImageWithURL:[NSURL URLWithString:customMessageModel.icon] placeholderImage:kDefaultPreloadImgSquare];
        _numLabel.text = [NSString stringWithFormat:@"X %ld",(long)customMessageModel.showNum];
        _numLabel.textColor = RGB(255,193,10);
        _numLabel.borderColor = kWhiteColor;
    }
    else if (customMessageModel.type == 28)
    {
        [_headImgView sd_setImageWithURL:[NSURL URLWithString:customMessageModel.user.head_image] forState:UIControlStateNormal placeholderImage:kDefaultPreloadHeadImg];
        
        _titleNameLabel.text = customMessageModel.user.nick_name;
        _giftNameLabel.text = [NSString stringWithFormat:@"参与%@次出价",customMessageModel.pai_sort];
        [_giftImgView setImage:[UIImage imageNamed:@"ac_hammers"]];
        _numLabel.text = [NSString stringWithFormat:@"X %@",customMessageModel.pai_sort];
        _numLabel.textColor = [UIColor whiteColor];
        _numLabel.borderColor = kAppRedColor;
    }
}

#pragma mark 恢复播放动画前的frame
- (void)recoveryViewFrame
{
    _backGroundView.frame = CGRectMake(-kBackGroundWidthRate*self.frame.size.width, _backGroundView.frame.origin.y, _backGroundView.frame.size.width, _backGroundView.frame.size.height);
    _giftImgView.frame = CGRectMake(-self.frame.size.height*0.8, _giftImgView.frame.origin.y, _giftImgView.frame.size.width, _giftImgView.frame.size.height);
    self.frame = CGRectMake(self.frame.origin.x, _viewY, self.frame.size.width, self.frame.size.height);
    //    self.alpha = 1.0;
    
    if(_animateDelayTimer)
    {
        [_animateDelayTimer invalidate];
        _animateDelayTimer = nil;
    }
}

#pragma mark 开始动画
- (BOOL)showGiftAnimate
{
    if (!_isPlaying && !_isPlayingDeplay)
    {
        self.hidden = NO;
        
        [UIView animateWithDuration:0.2 animations:^{
            _isPlaying = YES;
            _isPlayingDeplay = NO;
            _numLabel.hidden = YES;
            _backGroundView.frame = CGRectMake(0, _backGroundView.frame.origin.y, _backGroundView.frame.size.width, _backGroundView.frame.size.height);
        }completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.1 animations:^{
                _giftImgView.frame = CGRectMake(CGRectGetWidth(_backGroundView.frame)-self.frame.size.height*0.8, 0, _giftImgView.frame.size.width, _giftImgView.frame.size.height);
            }];
            
            [self changeFont];
            
        }];
        return YES;
    }
    return NO;
    
}

#pragma mark 重新开始数字变化
- (BOOL)txtFontAgain
{
    if (_isPlaying && _isPlayingDeplay && !_isPlayingTextChanging)
    {
        if(_animateDelayTimer)
        {
            [_animateDelayTimer invalidate];
            _animateDelayTimer = nil;
        }
        
        [self changeFont];
        return YES;
    }
    return NO;
}

#pragma mark 数字由大变小
- (void)changeFont
{
    _isPlaying = YES;
    _isPlayingDeplay = NO;
    _isPlayingTextChanging = YES;
    _numLabel.hidden = NO;
    
    [_numLabel startAnimWithDuration:0.25];
}

- (void)shakeLabelAnimateFinished2
{
    _isPlayingTextChanging = NO;
    if(_animateDelayTimer)
    {
        [_animateDelayTimer invalidate];
        _animateDelayTimer = nil;
    }
    
    [self displayAfter];
}

- (void)displayAfter
{
    _isPlaying = YES;
    _isPlayingDeplay = YES;
    
    _animateDelayTimer = [NSTimer scheduledTimerWithTimeInterval:1.8 target:self selector:@selector(viewDisappearAnimate) userInfo:nil repeats:NO];
    
    if (_delegate && [_delegate respondsToSelector:@selector(giftAnimate2:)])
    {
        [_delegate giftAnimate2:self];
    }
}

#pragma mark 视图消失动画
- (void)viewDisappearAnimate
{
    _isPlaying = YES;
    _isPlayingDeplay = NO;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(self.frame.origin.x, _viewY-self.frame.size.height, self.frame.size.width, self.frame.size.height);
    } completion:^(BOOL finished) {
        
        [self recoveryViewFrame];
        
        _isPlaying = NO;
        //        self.alpha = 0.0;
        self.hidden = YES;
        
        if (_delegate && [_delegate respondsToSelector:@selector(giftAnimate2:)]) {
            [_delegate giftAnimate2:self];
        }
    }];
}

@end
