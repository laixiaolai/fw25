//
//  KSYKitDemoVC.h
//  KSYGPUStreamerDemo
//
//  Created by yiqian on 6/23/16.
//  Copyright © 2016 ksyun. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class AgoraRtcStats;

typedef void (^RTCVideoDataBlock2)(CVPixelBufferRef pixelBuffer);
typedef void (^RTCAudioDataBlock2)(void* buffer,int sampleRate,int samples,int bytesPerSample,int channels);


@interface KSYAgoraClient:NSObject

- (instancetype)initWithAppId:(NSString *)appId;

@property (assign, nonatomic) BOOL isMuted;

/*
 @abstract 加入通道
 */
- (void)joinChannel:(NSString *)channelName;

@property (nonatomic, copy) void(^joinChannelBlock)(NSString* channel, NSUInteger uid, NSInteger elapsed);

/*
 @abstract 离开通道
 */
- (void)leaveChannel;

@property (nonatomic, copy) void(^leaveChannelBlock)(AgoraRtcStats* stat);

/*
 @abstract 发送视频数据到云端
 */
- (void)ProcessVideo:(CVPixelBufferRef)buf
           timeInfo:(CMTime)pts;

/*
 @abstract 远端视频数据回调
 */
@property (nonatomic, copy)RTCVideoDataBlock2  videoDataCallback;

/*
  @abstract 远端音频数据回调
 */
@property (nonatomic, copy)RTCAudioDataBlock2 audioDataCallback;


@end
