//
//  GifImageView.m
//  iChatView
//
//  Created by zzl on 16/6/3.
//  Copyright © 2016年 ldh. All rights reserved.
//

#import "GifImageView.h"
#import "UIImageView+WebCache.h"

@interface GifImageView ()
{
    CGFloat _top;
}

@property (nonatomic, weak)IBOutlet FLAnimatedImageView *gifImage;
@property (nonatomic, weak)IBOutlet UILabel             *nickLabel;
@property (nonatomic, assign) NSUInteger                currentLoopIndex;   // 当前循环的次数
@property (nonatomic, copy) NSString                    *senderName;

@end

@implementation GifImageView

- (id)initWithModel:(AnimateConfigModel*)gift inView:(UIView*)superView andSenderName:(NSString *)senderName
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"GifImageView" owner:self options:nil] lastObject];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        _nickLabel.hidden = YES;
        [superView addSubview:self];
        [superView sendSubviewToBack:self];
        
        _senderName = senderName;
        
        [self cfgWithGift:gift andTop:0];
    }
    return self;
}

- (void)cfgWithGift:(AnimateConfigModel*)gift andTop:(CGFloat)top
{
    _giftItem = gift;
    _top = top;
    
    __weak typeof(self) ws = self;
    
    [self.gifImage sd_setImageWithURL:[NSURL URLWithString:gift.url] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
        //图片下载完成  在这里进行相关操作，如加到数组里 或者显示在imageView上
        if (ws.giftItem.delay_time)
        {
            ws.hidden = YES;
            [ws performSelector:@selector(setUpView:) withObject:gift afterDelay:_giftItem.delay_time/1000];
        }
        else
        {
            [ws setUpView:gift];
        }
        
    }];
}

- (void)setUpView:(AnimateConfigModel*)gift
{
    self.hidden = NO;
    
    [self setUserInteractionEnabled:NO];
    
    CGRect pRect = self.superview.frame; //superview的frame
    CGRect vRect = self.gifImage.frame; //gifImage的frame
    CGSize size = self.gifImage.currentFrame.size; //图片的size
    CGFloat imageScale = size.width/size.height; //图片宽高比
    
    CGFloat w = size.width;
    CGFloat h = size.height;
    
    /**
     gif_gift_show_style：
     0：按像素显示模式（当某条边超出手机屏幕时该条边贴边），配合位置参数使用；
     1、全屏显示模式（gif图片四个角顶住手机屏幕的四个角）；
     2、至少两条边贴边模式（按比例缩放到手机屏幕边界的最大尺寸），配合位置参数使用；
     */
    if (gift.gif_gift_show_style == 0)
    {
        if ((size.width-pRect.size.width) > 0 && (size.height-pRect.size.height) > 0)
        { //如果图片的宽、高都超过的屏幕宽、高
            if ((size.width-pRect.size.width) > (size.height-pRect.size.height))
            {
                w = pRect.size.width;
                h = w / imageScale;
            }
            else
            {
                h = pRect.size.height;
                w = h * imageScale;
            }
        }
        else if ((size.width-pRect.size.width) > 0 && (size.height-pRect.size.height) < 0)
        { //如果图片的宽超过的屏幕宽，但是高小于屏幕的高
            w = pRect.size.width;
            h = w / imageScale;
        }
        else if ((size.width-pRect.size.width) < 0 && (size.height-pRect.size.height) > 0)
        { //如果图片的高超过的屏幕高，但是宽小于屏幕的宽
            h = pRect.size.height;
            w = h * imageScale;
        }
        vRect.size = CGSizeMake(w, h);
        self.gifImage.frame = vRect;
        size = vRect.size;
    }
    else if (gift.gif_gift_show_style == 1)
    {
        if (_giftItem.show_user == 0)
        {
            _nickLabel.hidden = YES;
            _nickLabel.text = @"";
            vRect = CGRectMake(0, 0, pRect.size.width, pRect.size.height);
        }
        else
        {
            _nickLabel.hidden = NO;
            vRect.size = CGSizeMake(pRect.size.width, pRect.size.height-_nickLabel.frame.size.height);
        }
        
        self.gifImage.frame = vRect;
        size = vRect.size;
    }
    else if (gift.gif_gift_show_style == 2)
    {
        if ((size.width-pRect.size.width) > 0 && (size.height-pRect.size.height) > 0)
        { //如果图片的宽、高都超过的屏幕宽、高
            if ((size.width-pRect.size.width) > (size.height-pRect.size.height))
            {
                w = pRect.size.width;
                h = w / imageScale;
            }
            else
            {
                h = pRect.size.height;
                w = h * imageScale;
            }
        }
        else if ((size.width-pRect.size.width) > 0 && (size.height-pRect.size.height) < 0)
        { //如果图片的宽超过的屏幕宽，但是高小于屏幕的高
            w = pRect.size.width;
            h = w / imageScale;
        }
        else if ((size.width-pRect.size.width) < 0 && (size.height-pRect.size.height) > 0)
        { //如果图片的高超过的屏幕高，但是宽小于屏幕的宽
            h = pRect.size.height;
            w = h * imageScale;
        }
        else if ((size.width-pRect.size.width) < 0 && (size.height-pRect.size.height) < 0)
        { //如果图片的宽、高都小于屏幕的宽
            if ((size.width-pRect.size.width) > (size.height-pRect.size.height))
            {
                w = pRect.size.width;
                h = w / imageScale;
            }
            else
            {
                h = pRect.size.height;
                w = h * imageScale;
            }
        }
        
        vRect.size = CGSizeMake(w, h);
        self.gifImage.frame = vRect;
        size = vRect.size;
    }
    
    if (_giftItem.show_user == 0)
    {
        _nickLabel.hidden = YES;
        _nickLabel.text = @"";
        self.labelHeight.constant = 0;
    }
    else
    {
        _nickLabel.hidden = NO;
        [self bringSubviewToFront:_nickLabel];
        _nickLabel.text = _senderName;
        
        if (size.height - _nickLabel.frame.size.height <= pRect.size.height)
        {
            size.height += _nickLabel.frame.size.height;
        }
        self.labelHeight.constant = 21;
    }
    
    CGRect rect = CGRectMake((pRect.size.width-size.width)/2, _top, size.width, size.height);
    
    //0：使用path路径；1：屏幕上部；2：屏幕中间；3：屏幕底部
    if (_giftItem.type == 0)
    {
        rect.origin.y = 0;
    }
    else if(_giftItem.type == 1)
    {
        rect.origin.y = 0;
    }
    else if(_giftItem.type == 2)
    {
        rect.origin.y = (pRect.size.height - size.height)/2;
    }
    else if(_giftItem.type == 3)
    {
        rect.origin.y = pRect.size.height - size.height;
    }
    self.frame = rect;
    [self layoutIfNeeded];
    
    __weak typeof(self) ws = self;
    self.gifImage.loopCompletionBlock = ^(NSUInteger loopCountRemaining){
        
        ws.currentLoopIndex ++;
        
        if (ws.giftItem.play_count)
        {
            if (ws.giftItem.play_count == ws.currentLoopIndex)
            {
                [ws dismissSelf];
            }
        }
        else
        {
             [ws performSelector:@selector(dismissSelf) withObject:gift afterDelay:_giftItem.duration/1000];
        }
        
    };
}

- (void)dismissSelf
{
    FWWeakify(self)
    [UIView animateWithDuration:0.01 animations:^{
        FWStrongify(self)
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        
        FWStrongify(self)
        [self removeFromSuperview];
        if (self.delegate && [self.delegate respondsToSelector:@selector(gifImageViewFinish:andSenderName:)])
        {
            self.giftItem.isFinishAnimate = YES;
            [self.delegate gifImageViewFinish:self.giftItem andSenderName:self.senderName];
        }
        
    }];
}

@end
