//
//  KSYKitDemoVC.h
//  KSYGPUStreamerDemo
//
//  Created by yiqian on 6/23/16.
//  Copyright © 2016 ksyun. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreFoundation/CoreFoundation.h>
#import "KSYAgoraClient.h"
#import <AgoraRtcEngineKit/AgoraRtcEngineKit.h>
#import <AgoraRtcEngineKit//IAgoraRtcEngine.h>
#import <AgoraRtcEngineKit/IAgoraMediaEngine.h>
#import <videoprp/AgoraVideoSourceObjc.h>
#import <CoreVideo/CVPixelBuffer.h>
#include "libyuv.h"


@interface KSYAgoraClient()<AgoraRtcEngineDelegate>{
    unsigned char *_videoBuffer;
    int32_t _videoBufferSize;
    BOOL _joined;
}

@property (strong, nonatomic) AgoraRtcEngineKit *rtcEngine;
@property (strong, nonatomic) NSString * appId;
@property (strong, nonatomic) AgoraVideoSource *videoSource;
@property (nonatomic, copy) void(^internJoinChannelBlock)(NSString* channel, NSUInteger uid, NSInteger elapsed);


- (void)processRemoteVideoWithYbuffer:(void* )ybuffer
                             Ubuffer:(void* )ubuffer
                             Vbuffer:(void* )vbuffer
                             YStride:(int)yStride
                             UStride:(int)uStride
                             VStride:(int)vStride
                              Height:(int)height
                               Width:(int)width;
@end

class AgoraAudioFrameObserver : public agora::media::IAudioFrameObserver
{
public:
    AgoraAudioFrameObserver(KSYAgoraClient* kit):_kit(kit)
    {
        
    };
    virtual bool onRecordAudioFrame(AudioFrame& audioFrame) override
    {
        return true;
    }
    virtual bool onPlaybackAudioFrame(AudioFrame& audioFrame) override
    {
        _kit.audioDataCallback(audioFrame.buffer,audioFrame.samplesPerSec,audioFrame.samples*audioFrame.bytesPerSample,audioFrame.bytesPerSample,audioFrame.channels);
        return true;
    }
    virtual bool onPlaybackAudioFrameBeforeMixing(unsigned int uid, AudioFrame& audioFrame) override
    {
        return true;
    }
private:
    KSYAgoraClient* _kit;
};

class AgoraVideoFrameObserver : public agora::media::IVideoFrameObserver
{
public:
    AgoraVideoFrameObserver(KSYAgoraClient* kit):_kit(kit)
    {
        
    };
    virtual bool onCaptureVideoFrame(VideoFrame& videoFrame) override
    {
        return true;
    }
    virtual bool onRenderVideoFrame(unsigned int uid, VideoFrame& videoFrame) override
    {
        [_kit processRemoteVideoWithYbuffer:videoFrame.yBuffer Ubuffer:videoFrame.uBuffer Vbuffer:videoFrame.vBuffer YStride:videoFrame.yStride UStride:videoFrame.uStride VStride:videoFrame.vStride Height:videoFrame.height Width:videoFrame.width];
        return true;
    }
private:
    KSYAgoraClient* _kit;
};

@interface KSYAgoraClient()<AgoraRtcEngineDelegate>{
    AgoraAudioFrameObserver* _audioFrameObserver;
    AgoraVideoFrameObserver* _videoFrameObserver;
}
@end

@implementation KSYAgoraClient

- (instancetype)init {
    return [self initWithAppId:nil];
}

- (instancetype)initWithAppId:(NSString *)appId{
    self = [super init];
    if (self) {
        _appId = appId;
        _joinChannelBlock = nil;
        _leaveChannelBlock = nil;
        _joined = NO;
        _isMuted = NO;
        _videoBufferSize = 1920 * 1088 * 3 / 2;
        _videoBuffer = (unsigned char *)malloc(_videoBufferSize);
        _videoDataCallback = nil;
    
    }

    return self;
}

- (void)joinChannel:(NSString *)channelName
{
    __weak KSYAgoraClient* weak_kit = self;
    _internJoinChannelBlock=^(NSString* channel, NSUInteger uid, NSInteger elapsed){
        _joined = YES;
        NSLog(@"join channel success");
        if(weak_kit.joinChannelBlock)
            weak_kit.joinChannelBlock(channel,uid,elapsed);
    };
    //init rtcengine
    __weak KSYAgoraClient* weak_self = self;
    _rtcEngine = [AgoraRtcEngineKit sharedEngineWithAppId:_appId delegate:weak_self];
    NSLog(@"version is %@",[AgoraRtcEngineKit getSdkVersion]);
    if(!_rtcEngine){
        NSLog(@"rtc engine init fail");
        return;
    }
    [_rtcEngine enableVideo];
    
    //register rtcengine
    _audioFrameObserver = new AgoraAudioFrameObserver(weak_self);
    _videoFrameObserver = new AgoraVideoFrameObserver(weak_self);
    [self registerVideoPreprocessing:_rtcEngine];
    
    //init videoSource
    _videoSource = [[AgoraVideoSource alloc]init];
    
    //attach videoSource
    [_videoSource Attach];
    
    //        //设置video profile
    //[_rtcEngine setVideoProfile:AgoraRtc_VideoProfile_360P_4];
    [_rtcEngine joinChannelByKey:nil channelName:channelName info:nil uid:0 joinSuccess:_internJoinChannelBlock];
    
}

- (void)leaveChannel
{
    if(_joined)
    {
        [_rtcEngine leaveChannel:_leaveChannelBlock];
        _joined = NO;
    }
    
    //clear local resource
    if(_videoSource)
    {
        [_videoSource Detach];
        _videoSource = nil;
    }
    
    if(_rtcEngine)
    {
        [self deregisterVideoPreprocessing:_rtcEngine];
        _rtcEngine = nil;
    }
    
    if(_audioFrameObserver)
    {
        delete _audioFrameObserver;
        _audioFrameObserver =nil;
    }
    
    if(_videoFrameObserver)
    {
        delete _videoFrameObserver;
        _videoFrameObserver = nil;
    }
}

- (void)dealloc{
    NSLog(@"ksyAgoraClient dealloc");
    if(_videoBuffer)
    {
        free(_videoBuffer);
        _videoBuffer = nil;
    }
}

- (int) registerVideoPreprocessing: (AgoraRtcEngineKit*) kit
{
    agora::rtc::IRtcEngine* rtc_engine = (agora::rtc::IRtcEngine*)kit.getNativeHandle;
    agora::util::AutoPtr<agora::media::IMediaEngine> mediaEngine;
    mediaEngine.queryInterface(*rtc_engine, agora::rtc::AGORA_IID_MEDIA_ENGINE);
    if (mediaEngine)
    {
        mediaEngine->registerAudioFrameObserver(_audioFrameObserver);
        mediaEngine->registerVideoFrameObserver(_videoFrameObserver);
    }
    return 0;
}

- (int) deregisterVideoPreprocessing: (AgoraRtcEngineKit*) kit
{
    agora::rtc::IRtcEngine* rtc_engine = (agora::rtc::IRtcEngine*)kit.getNativeHandle;
    agora::util::AutoPtr<agora::media::IMediaEngine> mediaEngine;
    mediaEngine.queryInterface(*rtc_engine, agora::rtc::AGORA_IID_MEDIA_ENGINE);
    if (mediaEngine)
    {
        mediaEngine->registerAudioFrameObserver(NULL);
        mediaEngine->registerVideoFrameObserver(NULL);
    }
    return 0;
}

- (void)ProcessVideo:(CVPixelBufferRef)pixelBuffer
           timeInfo:(CMTime)pts
{
    if(!_joined)
        return;
    
    int width = (int)CVPixelBufferGetWidth(pixelBuffer);
    int height = (int)CVPixelBufferGetHeight(pixelBuffer);
    
    CVPixelBufferRef y420= [self BGRAToI420:pixelBuffer];
    
    [self fillVideoBuf:y420];
    
    [_videoSource DeliverFrame:_videoBuffer width:width height:height cropLeft:0 cropTop:0 cropRight:0 cropBottom:0 rotation:0 timeStamp:pts.value format:1];
}

- (void)setIsMuted:(BOOL)isMuted {
    _isMuted = isMuted;
    [_rtcEngine muteLocalAudioStream:isMuted];
}

void AgoraNV21ToI420(const unsigned char *nv21,
                     int width,
                     int height,
                     unsigned char *i420
                     )
{
    if(width <= 0 || height <= 0)
        return;
    
    const unsigned char *yIn = nv21;
    unsigned char *y = i420;
    const unsigned char *uvIn = yIn + width * height;
    unsigned char *u = y + width * height;
    unsigned char *v = u + width * height / 4;
    
    // y
    memcpy(y, yIn, width * height);
    
    // uv
    int i;
    int cheight = height / 2;
    int cwidth = width / 2;
    for(i=0; i<cheight; i++)
    {
        int j;
        // ASSERT(cwidth & 1 == 0);
        for(j=0; j<cwidth/2; j++)
        {
            unsigned int iv = *(unsigned int *)uvIn; // 32-bit cpu
            uvIn += 4;
            *u++ = iv & 0xFF;
            *v++ = (iv >> 8) & 0xFF;
            *u++ = (iv >> 16) & 0xFF;
            *v++ = (iv >> 24) & 0xFF;
        }
        uvIn += width - cwidth * 2;
        u += cwidth - cwidth;
        v += cwidth - cwidth;
    }
}

- (void)processRemoteVideoWithYbuffer:(void* )ybuffer
                             Ubuffer:(void* )ubuffer
                             Vbuffer:(void* )vbuffer
                             YStride:(int)yStride
                             UStride:(int)uStride
                             VStride:(int)vStride
                              Height:(int)height
                               Width:(int)width
{
    CVPixelBufferRef y420 = [self makeUpYUV420Ybuffer:ybuffer Ubuffer:ubuffer Vbuffer:vbuffer YStride:yStride UStride:uStride VStride:vStride Height:height Width:width];
    if(!y420)
    {
        NSLog(@"makeUpYUV420Ybuffer fail");
        CFRelease(y420);
        return;
    }
    
    CVPixelBufferRef nv12 = [self convertToNV12:y420];
    if(!nv12)
    {
      NSLog(@"makeUpYUV420Ybuffer fail");
      CFRelease(nv12);
      return;
    }
    
    if(_videoDataCallback && nv12)
        _videoDataCallback(nv12);

    CFRelease(nv12);
    CFRelease(y420);
    
}

-(CVPixelBufferRef) makeUpYUV420Ybuffer:(void* )ybuffer
                                Ubuffer:(void* )ubuffer
                                Vbuffer:(void* )vbuffer
                                YStride:(int)yStride
                                UStride:(int)uStride
                                VStride:(int)vStride
                                 Height:(int)height
                                  Width:(int)width
{
    NSDictionary* pixelBufferOptions = @{ (NSString*) kCVPixelBufferPixelFormatTypeKey :
                                              @(kCVPixelFormatType_420YpCbCr8Planar),
                                          (NSString*) kCVPixelBufferWidthKey : @(width),
                                          (NSString*) kCVPixelBufferHeightKey : @(height),
                                          (NSString*) kCVPixelBufferOpenGLESCompatibilityKey : @YES,
                                          (NSString*) kCVPixelBufferIOSurfacePropertiesKey : @{}};
    CVPixelBufferRef pixelBuffer;
    CVReturn ret = CVPixelBufferCreate(kCFAllocatorDefault,
                                       width,height,
                                       kCVPixelFormatType_420YpCbCr8Planar,
                                       (__bridge CFDictionaryRef)pixelBufferOptions,
                                       &pixelBuffer);
    if(ret != kCVReturnSuccess)
    {
        NSLog(@"CVPixelBufferCreate fail,ret:%d",ret);
        return nil;
    }
    CVPixelBufferLockBaseAddress(pixelBuffer, 0);
    uint8_t * dstY      = (uint8_t *)CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 0);
    size_t hgtY     = CVPixelBufferGetHeightOfPlane(pixelBuffer, 0);
    size_t wdtY     = CVPixelBufferGetBytesPerRowOfPlane(pixelBuffer, 0);
    
    uint8_t * dstU     = (uint8_t *)CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 1);
    size_t hgtU     = CVPixelBufferGetHeightOfPlane(pixelBuffer, 1);
    size_t wdtU     = CVPixelBufferGetBytesPerRowOfPlane(pixelBuffer, 1);
    
    uint8_t * dstV     = (uint8_t *)CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 2);
    size_t hgtV     = CVPixelBufferGetHeightOfPlane(pixelBuffer, 2);
    size_t wdtV     = CVPixelBufferGetBytesPerRowOfPlane(pixelBuffer, 2);
    uint8_t * srcY =  (uint8_t *)ybuffer;
    for (int i = 0; i < hgtY; ++i) {
        memcpy(dstY,  srcY, wdtY );
        dstY += wdtY;
        srcY += yStride;
    }
    uint8_t * srcU =  (uint8_t *)ubuffer;
    for (int i = 0; i < hgtU; ++i) {
        memcpy(dstU,  srcU, wdtU );
        dstU += wdtU;
        srcU += uStride;
    }
    uint8_t * srcV =  (uint8_t *)vbuffer;
    for (int i = 0; i < hgtV; ++i) {
        memcpy(dstV,  srcV, wdtV );
        dstV += wdtV;
        srcV += vStride;
    }
    CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
    
    return pixelBuffer;
}


-(CVPixelBufferRef) convertToNV12:(CVPixelBufferRef)src
{
    int width = (int)CVPixelBufferGetWidth(src);
    int height = (int)CVPixelBufferGetHeight(src);
    
    NSDictionary* pixelBufferOptions = @{ (NSString*) kCVPixelBufferPixelFormatTypeKey :
                                              @(kCVPixelFormatType_420YpCbCr8Planar),
                                          (NSString*) kCVPixelBufferWidthKey : @(width),
                                          (NSString*) kCVPixelBufferHeightKey : @(height),
                                          (NSString*) kCVPixelBufferOpenGLESCompatibilityKey : @YES,
                                          (NSString*) kCVPixelBufferIOSurfacePropertiesKey : @{}};
    
    CVPixelBufferRef dst;
    CVPixelBufferCreate(kCFAllocatorDefault,
                        width, height,
                        kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange,
                        (__bridge CFDictionaryRef)pixelBufferOptions,
                        &dst);
    CVPixelBufferLockBaseAddress(dst, 0);
    CVPixelBufferLockBaseAddress(src, 0);
    
    void* pSrcY      = CVPixelBufferGetBaseAddressOfPlane(src, 0);
    void* pSrcU      = CVPixelBufferGetBaseAddressOfPlane(src, 1);
    void* pSrcV      = CVPixelBufferGetBaseAddressOfPlane(src, 2);
    size_t srcStrideY  = CVPixelBufferGetBytesPerRowOfPlane(src, 0);
    size_t srcStrideU = CVPixelBufferGetBytesPerRowOfPlane(src, 1);
    size_t srcStrideV = CVPixelBufferGetBytesPerRowOfPlane(src, 2);
    
    void* pDstY      = CVPixelBufferGetBaseAddressOfPlane(dst, 0);
    void* pDstUV      = CVPixelBufferGetBaseAddressOfPlane(dst, 1);
    size_t dstStrideY  = CVPixelBufferGetBytesPerRowOfPlane(dst, 0);
    size_t dstStrideUV = CVPixelBufferGetBytesPerRowOfPlane(dst, 1);
    
    int ret = libyuv::I420ToNV12((const uint8*)pSrcY, (int)srcStrideY,
                                 (const uint8*)pSrcU, (int)srcStrideU,
                                 (const uint8*)pSrcV, (int)srcStrideV,
                                 (uint8*)pDstY,  (int)dstStrideY,
                                 (uint8*)pDstUV, (int)dstStrideUV,
                                 (int)width,  (int)height);
    if(ret != 0)
    {
        NSLog(@"I420ToNV12 failed,error is:%d",ret);
        CVPixelBufferUnlockBaseAddress(src, 0);
        CVPixelBufferUnlockBaseAddress(dst, 0);
        CFRelease(dst);
        return nil;
    }
    CVPixelBufferUnlockBaseAddress(src, 0);
    CVPixelBufferUnlockBaseAddress(dst, 0);
    
    return dst;
}

-(CVPixelBufferRef) BGRAToI420:(CVPixelBufferRef)src
{
    int wdt = (int)CVPixelBufferGetWidth(src);
    int hgt = (int)CVPixelBufferGetHeight(src);
    
    CVPixelBufferRef dst;
    CVPixelBufferCreate(kCFAllocatorDefault,
                        wdt, hgt,
                        kCVPixelFormatType_420YpCbCr8Planar,
                        nil,
                        &dst);
    CVPixelBufferLockBaseAddress(dst, 0);
    CVPixelBufferLockBaseAddress(src, 0);
    
    uint8* src_frame      = (uint8*)CVPixelBufferGetBaseAddressOfPlane(src, 0);
    int src_stride_frame  = (int)CVPixelBufferGetBytesPerRowOfPlane(src, 0);
    
    void* dst_y      = CVPixelBufferGetBaseAddressOfPlane(dst, 0);
    int dst_stride_y  = (int)CVPixelBufferGetBytesPerRowOfPlane(dst, 0);
    void* dst_u      = CVPixelBufferGetBaseAddressOfPlane(dst, 1);
    int dst_stride_u  = (int)CVPixelBufferGetBytesPerRowOfPlane(dst, 1);
    void* dst_v      = CVPixelBufferGetBaseAddressOfPlane(dst, 2);
    int dst_stride_v  = (int)CVPixelBufferGetBytesPerRowOfPlane(dst, 2);
    
    libyuv::ARGBToI420( src_frame, src_stride_frame,
                       ( uint8*)dst_y, dst_stride_y,
                       ( uint8*)dst_u, dst_stride_u,
                       ( uint8*)dst_v, dst_stride_v,
                       wdt,hgt);
    
    CVPixelBufferUnlockBaseAddress(src, 0);
    CVPixelBufferUnlockBaseAddress(dst, 0);
    return dst;
}

- (void) fillVideoBuf:(CVPixelBufferRef)pixelBuffer
{
    CVPixelBufferLockBaseAddress(pixelBuffer, 0);
    
    uint8_t * srcY      = (uint8_t *)CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 0);
    size_t hgtY     = CVPixelBufferGetHeightOfPlane(pixelBuffer, 0);
    size_t widthY     = CVPixelBufferGetWidthOfPlane(pixelBuffer,0);
    size_t strideY  = CVPixelBufferGetBytesPerRowOfPlane(pixelBuffer, 0);
    
    uint8_t * srcU     = (uint8_t *)CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 1);
    size_t hgtU     = CVPixelBufferGetHeightOfPlane(pixelBuffer, 1);
    size_t widthU     = CVPixelBufferGetWidthOfPlane(pixelBuffer,1);
    size_t strideU  = CVPixelBufferGetBytesPerRowOfPlane(pixelBuffer, 1);
    
    uint8_t * srcV     = (uint8_t *)CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 2);
    size_t hgtV     = CVPixelBufferGetHeightOfPlane(pixelBuffer, 2);
    size_t widthV     = CVPixelBufferGetWidthOfPlane(pixelBuffer,2);
    size_t strideV  = CVPixelBufferGetBytesPerRowOfPlane(pixelBuffer, 2);
    
    memset(_videoBuffer,0,_videoBufferSize);
    uint8_t* data = _videoBuffer;
    for (int ii = 0 ; ii < hgtY; ++ii) {
        memcpy( data,  srcY, widthY ); srcY+= strideY;  data += widthY;
    }
    
    for (int ii = 0 ; ii < hgtU; ++ii) {
        memcpy(  data,  srcU, widthU ); srcU+= strideU;  data += widthU;
    }
    
    for (int ii = 0 ; ii < hgtV; ++ii) {
        memcpy(  data,  srcV, widthV ); srcV+= strideV;  data += widthV;
    }
    CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
    CFRelease(pixelBuffer);
}

@end
