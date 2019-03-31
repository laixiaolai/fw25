//
//  PublishLiveTopView.h
//  FanweApp
//
//  Created by xgh on 2017/8/24.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "FWBaseView.h"
@class PublishLiveTopView;
@protocol PublishLiveTopDelegate <NSObject>

- (void)selectedTheClassirmAction;

- (void)closeThePublishLive:(PublishLiveTopView *)topView;

- (void)ispracychangeActionDelegate:(BOOL)ispraicy;

- (void)classifyButtonActionDelegate;
@end


@interface PublishLiveTopView : FWBaseView
@property (nonatomic, assign)BOOL isCanLocation;

@property (nonatomic, assign)BOOL pravicy;

@property (nonatomic, weak) id<PublishLiveTopDelegate>delegate;

@property (nonatomic, strong)UIButton *locationBtn;

@property (nonatomic, strong)UIButton *pravicyBtn;

@property (nonatomic, strong)UIButton *classifyBtn;

@property (nonatomic, strong)UIButton *closeBtn;

@property (nonatomic, copy)NSString *locationCityString;
@property (nonatomic, copy)NSString *provinceSrting;



@end
