//
//  PublishLiveView.h
//  FanweApp
//
//  Created by xgh on 2017/8/24.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "FWBaseView.h"
#import "PublishLiveTopView.h"
#import "PublishLiveShareView.h"

@protocol publishViewDelegate <NSObject>
- (void)selectedTheImageDelegate;

- (void)closeThestartLiveViewDelegate;

- (void)startThePublishLiveDelegate;

- (void)selectedTheClassifyDelegate;

@end





@interface PublishLiveView : FWBaseView<PublishLiveTopDelegate>
@property (nonatomic, strong)PublishLiveTopView *topView;
@property (nonatomic, strong)UITextView *textView;
@property (nonatomic, strong) UIImageView *backGroundImageview;
@property (nonatomic, strong) UIImageView *selectedImageView;
@property (nonatomic, weak) id<publishViewDelegate>delegate;
@property (nonatomic, strong) UIButton *startButton;
@property (nonatomic, weak)PublishLiveShareView *shareView;

@end
