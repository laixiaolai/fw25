//
//  SendGiftAnimateView2.h
//  FanweApp
//
//  Created by xfg on 16/5/23.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomMessageModel.h"
#import "ShakeLabel2.h"

@class SendGiftAnimateView2;

@protocol SendGiftAnimateViewDelegate2 <NSObject>
@required

- (void)giftAnimate2:(SendGiftAnimateView2 *)sendGiftAnimateView;

@end

@interface SendGiftAnimateView2 : UIView

@property (nonatomic, weak) id<SendGiftAnimateViewDelegate2> delegate;

@property (nonatomic, assign) NSInteger         viewState;              // 1:显示视图，视图从左往右 2：数字从大到小 3：延迟状态 4：动画结束，隐藏界面
@property (nonatomic, strong) MenuButton        *headImgView;
@property (nonatomic, strong) UILabel           *titleNameLabel;
@property (nonatomic, strong) UIImageView       *giftImgView;
@property (nonatomic, strong) UILabel           *giftNameLabel;
@property (nonatomic, strong) ShakeLabel2       *numLabel;
@property (nonatomic, assign) BOOL              isPlaying;              // 是否正在播放动画
@property (nonatomic, assign) BOOL              isPlayingDeplay;        // 是否动画停滞阶段
@property (nonatomic, assign) BOOL              isPlayingTextChanging;  // 是否正在播放文字缩小动画

@property (nonatomic, strong) CustomMessageModel *customMessageModel;

- (void)setContent:(CustomMessageModel *)customMessageModel;

- (BOOL)showGiftAnimate;    // 开始整个动画
- (BOOL)txtFontAgain;       // 个数变化的动画

@end
