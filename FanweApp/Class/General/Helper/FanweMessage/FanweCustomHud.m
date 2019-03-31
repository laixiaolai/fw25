//
//  FanweCustomHud.m
//  FanweApp
//
//  Created by xfg on 2017/3/9.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "FanweCustomHud.h"

@interface FanweCustomHud()
{
    UIView *                _loadingBackground;     // 加载中的背景
    UIImageView *           _loadingImageView;      // 加载中的背景图
    UITextView *            _textView;
}

@end

@implementation FanweCustomHud

static id _instance;
+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
        [_instance initMyData];
    });
    return _instance;
}

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
        [_instance initMyData];
    });
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone
{
    return _instance;
}

- (id)mutableCopyWithZone:(NSZone *)zone
{
    return _instance;
}


- (void)initMyData
{
    if (_loadingBackground == nil)
    {
        _loadingBackground = [[UIView alloc] init];
        _loadingBackground.hidden = YES;
        _loadingBackground.backgroundColor = kClearColor;
        _loadingBackground.alpha  = 0.5;
        
        _textView = [[UITextView alloc]init];
        _textView.textAlignment = NSTextAlignmentCenter;
        _textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _textView.textColor = [UIColor blackColor];
        _textView.hidden = YES;
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
        _loadingImageView.animationImages = array;
        _loadingImageView.animationDuration = 1;
        _loadingImageView.hidden = YES;
    }
}

- (void)startLoadingInView:(UIView*)view tipMsg:(NSString *)tipMsg
{
    CGRect rect = view.frame;
    
    if (_loadingBackground)
    {
        _loadingBackground.frame = CGRectMake(0, 0, CGRectGetWidth(rect), CGRectGetHeight(rect));
        [view addSubview:_loadingBackground];
        _loadingBackground.hidden = NO;
        
        _textView.bounds = CGRectMake(0, 0, CGRectGetWidth(rect), 30);
        _textView.center = CGPointMake(CGRectGetWidth(rect) / 2, CGRectGetHeight(rect) / 2 - 30);
        [_loadingBackground addSubview:_textView];
        
        if (![FWUtils isBlankString:tipMsg])
        {
            _textView.text = tipMsg;
            _textView.hidden = NO;
        }
        else
        {
            _textView.hidden = YES;
        }
    }
    
    if (_loadingImageView)
    {
        _loadingImageView.center = CGPointMake(CGRectGetWidth(rect) / 2, CGRectGetHeight(rect) / 2);
        [view addSubview:_loadingImageView];
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

@end
