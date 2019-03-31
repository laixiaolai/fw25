//
//  PublishLiveView.m
//  FanweApp
//
//  Created by xgh on 2017/8/24.
//  Copyright © 2017年 xfg. All rights reserved.
//


#import <AVFoundation/AVFoundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <CoreVideo/CoreVideo.h>
#import <CoreMedia/CoreMedia.h>
#import "PublishLiveView.h"

@interface PublishLiveView()<AVCaptureVideoDataOutputSampleBufferDelegate, UITextViewDelegate>
{
    AVCaptureSession *_captureSession;
    AVCaptureVideoPreviewLayer *_customLayer;//自定义layer展示层
    
}
@property (nonatomic, retain) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *customLayer;

@end

@implementation PublishLiveView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.topView = [[PublishLiveTopView alloc]initWithFrame:CGRectMake(0, 0, self.width, 60)];
        self.topView.delegate = self;
//        [self initCapture];
        [self backGroundImageview];
         [self addSubview:self.topView];
        self.textView =[[UITextView alloc] initWithFrame:CGRectMake(20, 120, self.width - 40,100)];
        self.textView.backgroundColor =[UIColor clearColor];
        self.textView.keyboardType =UIKeyboardTypeDefault;
        self.textView.layoutManager.allowsNonContiguousLayout =NO;
        self.textView.textAlignment =NSTextAlignmentCenter;
        self.textView.textColor =[UIColor whiteColor];
        self.textView.font =[UIFont systemFontOfSize:20];
        self.textView.text = @"给直播写个标题吧";
        self.textView.delegate = self;
        self.autoresizingMask =UIViewAutoresizingFlexibleHeight;
        [self addSubview:self.textView];
        self.selectedImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.width / 2 - 65, 230, 130, 130)];
        self.selectedImageView.image = [UIImage imageNamed:@"pl_publishlive_cover"];
        [self addSubview:self.selectedImageView];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = self.selectedImageView.bounds;
        [button addTarget:self action:@selector(selectedImageViewAction:) forControlEvents:UIControlEventTouchUpInside];
        self.selectedImageView.userInteractionEnabled = YES;
        [self.selectedImageView addSubview:button];
        
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(self.width / 2  - 50, 370, 100, 20)];
        lab.text = @"修改封面";
        lab.textColor = kWhiteColor;
        lab.font = [UIFont systemFontOfSize:15];
        lab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:lab];
        self.startButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.startButton.frame = CGRectMake(10, self.height - 120, self.width - 20, 45);
        CAShapeLayer *layer = [[CAShapeLayer alloc]init];
        layer.frame = self.startButton.bounds;
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.startButton.bounds cornerRadius:22.5];
        layer.path = path.CGPath;
        layer.fillColor = kClearColor.CGColor;
        layer.strokeColor = kWhiteColor.CGColor;
        [self.startButton.layer addSublayer:layer];
        [self.startButton addTarget:self action:@selector(startbuttonAction) forControlEvents:UIControlEventTouchUpInside];
        [self.startButton setTitle:@"开始直播" forState:UIControlStateNormal];
        [self.startButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
        [self addSubview:self.startButton];
        
        
        
       
        
    }
    return self;
}


- (void)selectedTheClassirmAction
{
    //选择分类
}

- (void)startbuttonAction
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(startThePublishLiveDelegate)]) {
        [self.delegate startThePublishLiveDelegate];
    }
}

- (void)closeThePublishLive:(PublishLiveTopView *)topView
{
    //关闭开始直播界面
    if(self.delegate && [self.delegate respondsToSelector:@selector(closeThestartLiveViewDelegate)]) {
        [self.delegate closeThestartLiveViewDelegate];
    }
}

- (void)ispracychangeActionDelegate:(BOOL)ispraicy
{
    self.shareView.hidden = ispraicy;
}
- (UIImageView *)backGroundImageview {
    if (_backGroundImageview == nil) {
        _backGroundImageview = [[UIImageView alloc]initWithFrame:self.bounds];
        [self addSubview:_backGroundImageview];
        UIBlurEffect *beffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *view = [[UIVisualEffectView alloc]initWithEffect:beffect];
        view.frame = _backGroundImageview.bounds;
        [_backGroundImageview addSubview:view];
        [_backGroundImageview sd_setImageWithURL:[NSURL URLWithString:[[IMAPlatform sharedInstance].host imUserIconUrl]]];
    }
    return _backGroundImageview;
}

/**
 初始化摄像头
 */
- (void) initCapture
{
    self.captureSession = [[AVCaptureSession alloc] init];
    for (AVCaptureDevice *d in [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo]) {
        if ([d position] == AVCaptureDevicePositionFront) {
            [self.captureSession beginConfiguration];
            AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:d error:nil];
            for (AVCaptureInput *oldInput in self.captureSession.inputs) {
                [self.captureSession removeInput:oldInput];
            }
            [self.captureSession addInput:input];
            [self.captureSession commitConfiguration];
            break;
        }
    }
  
    [self.captureSession startRunning];
    self.customLayer = [AVCaptureVideoPreviewLayer layerWithSession: self.captureSession];;
    CGRect frame = self.bounds;
   
    self.customLayer.frame = frame;
  
    self.customLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.layer addSublayer:self.customLayer];
    
}

- (void)selectedImageViewAction:(UIButton *)sender
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(selectedTheImageDelegate)]) {
        [self.delegate selectedTheImageDelegate];
    }
}

- (void)classifyButtonActionDelegate {
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectedTheClassifyDelegate)]) {
        [self.delegate selectedTheClassifyDelegate];
    }
}

#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([self.textView.text isEqualToString:@"给直播写个标题吧"]) {
        self.textView.text = @"";
    }
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if ([self.textView.text isEqualToString:@""]) {
        self.textView.text = @"给直播写个标题吧";
    }
    return YES;
}

@end
