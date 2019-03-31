//
//  SendGiftAnimateView.h
//  FanweApp
//
//  Created by xfg on 16/5/23.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomMessageModel.h"
#import "ShakeLabel.h"

@class SendGiftAnimateView;

@protocol SendGiftAnimateViewDelegate <NSObject>
@required

- (void)giftAnimate:(SendGiftAnimateView *)sendGiftAnimateView;

@end

@interface SendGiftAnimateView : UIView

@property (nonatomic, weak) id<SendGiftAnimateViewDelegate> delegate;

@property (nonatomic, assign) NSInteger             viewState;              // 1:显示视图，视图从左往右 2：数字从大到小 3：延迟状态 4：动画结束，隐藏界面
@property (nonatomic, strong) MenuButton            *headImgView;
@property (nonatomic, strong) UILabel               *titleNameLabel;
@property (nonatomic, strong) UIImageView           *giftImgView;
@property (nonatomic, strong) UILabel               *giftNameLabel;
@property (nonatomic, strong) ShakeLabel            *numLabel;
@property (nonatomic, assign) BOOL                  isPlaying;              // 是否正在播放动画
@property (nonatomic, assign) BOOL                  isPlayingDeplay;        // 是否动画停滞阶段
@property (nonatomic, assign) BOOL                  isPlayingTextChanging;  // 是否正在播放文字缩小动画

@property (nonatomic, strong) CustomMessageModel    *customMessageModel;

- (void)setContent:(CustomMessageModel *)           customMessageModel;

- (BOOL)showGiftAnimate;    // 开始整个动画
- (BOOL)txtFontAgain;       // 个数变化的动画

@end
