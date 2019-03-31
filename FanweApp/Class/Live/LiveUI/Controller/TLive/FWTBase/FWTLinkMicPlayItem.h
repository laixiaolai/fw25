//
//  FWTLinkMicPlayItem.h
//  FanweApp
//
//  Created by xfg on 2017/1/20.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TCLivePlayListenerImpl;

@interface FWTLinkMicPlayItem : NSObject
{
    UIView*                 _loadingBackground;
    UITextView *            _loadingTextView;
    UIImageView *           _loadingImageView;
}

@property (nonatomic, assign) BOOL                      pending;
@property (nonatomic, assign) BOOL                      isWorking;
@property (nonatomic, strong) NSString*                 userID;
@property (nonatomic, strong) NSString*                 playUrl;
@property (nonatomic, retain) TCLivePlayListenerImpl*   livePlayListener;
@property (nonatomic, retain) TXLivePlayer *            livePlayer;
@property (nonatomic, strong) UIView*                   videoView;
@property (nonatomic, strong) UIButton*                 btnKickout;
@property (nonatomic, assign) NSInteger                 itemIndex;
@property (nonatomic, assign) NSInteger                 reStartTimes;   // 重试次数

- (void)emptyPlayInfo;
- (void)setLoadingText:(NSString*)text;
- (void)initLoadingView:(UIView*)view;
- (void)startLoading;
- (void)stopLoading;
- (void)startPlay:(NSString*)playUrl;
- (void)reStartPlay;
- (void)stopPlay;

@end
