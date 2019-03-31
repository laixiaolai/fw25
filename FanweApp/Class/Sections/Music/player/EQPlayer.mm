//
//  EQPlayer.m
//  SuperpoweredPerformance
//
//  Created by zzl on 16/6/23.
//  Copyright © 2016年 imect. All rights reserved.
//

#import "EQPlayer.h"
#import "SuperpoweredAdvancedAudioPlayer.h"
#import "SuperpoweredReverb.h"
#import "SuperpoweredFilter.h"
#import "Superpowered3BandEQ.h"
#import "SuperpoweredEcho.h"
#import "SuperpoweredRoll.h"
#import "SuperpoweredFlanger.h"
#import "SuperpoweredSimple.h"
#import "SuperpoweredIOSAudioIO.h"
#import "Superpowered3BandEQ.h"
#import <mach/mach_time.h>
#import <libkern/OSAtomic.h>
#include <AudioToolbox/AudioConverter.h>
#import "superpowed/SuperpoweredIOSAudioIO.h"

//M1
#define NUMFXUNITS 8
#define TIMEPITCHINDEX 0
#define PITCHSHIFTINDEX 1
#define ROLLINDEX 2
#define FILTERINDEX 3
#define EQINDEX 4
#define FLANGERINDEX 5
#define DELAYINDEX 6
#define REVERBINDEX 7

@interface EQPlayer ()<SuperpoweredIOSAudioIODelegate>

@end
SuperpoweredIOSAudioIO *                g_output;

@implementation EQPlayer
{
    float *                             _stereoBuffer;
    char *                              _tempBuffer;
    
    SuperpoweredAdvancedAudioPlayer*    _player;
    Superpowered3BandEQ*                _bandEQ;
    
    
    NSString*                           _filePath;
    
    NSArray*                            _allEqNames;
    NSArray*                            _allEqData;//@[ @[ l ] , @[ m ] ,@[ h ] .....       ]
    NSUInteger                          _selectEQ;
    unsigned int                        _lastSamplerate;

    
    char*                               _outDataBuffer;
    __volatile int                      _outBufferPushInOffset;
    __volatile int                      _outBufferCopyOutOffset;
    __volatile int                      _outBufferNowSize;//当前有多少
    int                                 _outBufferSize;
    
    OSSpinLock                          _outBufferSpinlock;
    //M2
    SuperpoweredFX                      *effects[NUMFXUNITS];
    
}

- (void)interruptionStarted {
    
    //NSLog(@"interruptionStartedbefor fuck paly:%d",_player->playing);
    if( _player->playing )
        _player->togglePlayback();
    
    //NSLog(@"interruptionStartedatfer fuck paly:%d",_player->playing);
    
}

- (void)recordPermissionRefused {
    
}
- (void)mapChannels:(multiOutputChannelMap *)outputMap inputMap:(multiInputChannelMap *)inputMap externalAudioDeviceName:(NSString *)externalAudioDeviceName outputsAndInputs:(NSString *)outputsAndInputs {

}

- (void)interruptionEnded {
    
    //NSLog(@"interruptionEnded befor fuck paly:%d",_player->playing);
    
    if( !_player->playing )
        _player->togglePlayback();
    
    //NSLog(@"interruptionEnded after fuck paly:%d",_player->playing);
    
    _player->onMediaserverInterrupt(); // If the player plays Apple Lossless audio files, then we need this. Otherwise unnecessary.
    
    //[_output onRouteChange:nil];
    
}

- (void)resetVEP
{
    self.mVolume = 6;
    self.mEqName = _allEqNames[0];
    self.mPitch = 0;
    
}

-(int)getSampleRate
{
    return _lastSamplerate;
}

-(double)mCurrentTime
{
    return _player->positionMs/1000.0f;
}
-(double)mTotalTime
{
    if( _player->positionPercent <= 0.0f )
        return _player->positionMs+ 1000.0f;
    
    return ( self.mCurrentTime / _player->positionPercent);
}

- (void)setMPitch:(int)mPitch
{
    if( mPitch >= -12 && mPitch <= 12 )
    {
        _mPitch = mPitch;
        if( _player != NULL )
            _player->setPitchShift(_mPitch);
    }
}
- (void)setMEqName:(NSString *)mEqName
{
    NSUInteger index = [_allEqNames indexOfObject:mEqName];
    if( index != NSNotFound )
    {
        _selectEQ = index;
        _mEqName = mEqName;
        [self updateEqEffect:_selectEQ];
    }
}
- (void)updateEqEffect:(NSUInteger)index
{
    if( _bandEQ == NULL || index >= _allEqData.count )
    {
        return;
    }

        NSArray* t = _allEqData[ index ];
        
        _bandEQ->bands[0] = [t[0] floatValue];
        _bandEQ->bands[1] = [t[1] floatValue];
        _bandEQ->bands[2] = [t[2] floatValue];
   
}

- (void)setMVolume:(int)mVolume
{
    if( mVolume >=0 && mVolume <= 12 )
    {
        _mVolume = mVolume;
     }
}

- (void)cfgEqEffectParam
{
    _allEqNames = @[ @"原声",
                     @"悠扬",
                     @"圆润",
                     @"流行",
                     @"轻松",
                     @"空灵" ];
    _allEqData = @[ @[ @1.0f, @1.0f,@1.0f ],// Low/mid/high gain
                    @[ @1.0f, @1.5f,@1.5f ],
                    @[ @1.5f, @1.5f,@1.0f ],
                    @[ @1.1f, @1.3f,@1.0f ],
                    @[ @1.0f, @0.8f,@0.3f ],
                    @[ @1.0f, @1.5f,@1.5f ],
                    ];
    
}

- (BOOL)cfgPlayer
{
    _outBufferSpinlock = OS_SPINLOCK_INIT;
    
    _outBufferPushInOffset = 0;
    _outBufferCopyOutOffset = 0;
    
    [self cfgEqEffectParam];
    
    _mPitch = 0;
    _selectEQ = 0;
    _mEqName = @"原声";
    _mVolume = 6;
    
    //SuperpoweredFFTTest();
    
    if (posix_memalign((void **)&_stereoBuffer, 16, 4096 + 128) != 0)
    {
        NSLog(@"posix_memalign failed");
        //abort()
        return false;
    } // Allocating memory, aligned to 16.
    
    
    //3840 是 48000 的 20ms的数据量, 8倍完全够了
    //M3
    _outBufferSize = 1024 *4*10;
    //_outBufferSize = 4096 * 8;
    if (posix_memalign((void **)&_outDataBuffer, 16, _outBufferSize ) != 0 )
    {
        NSLog(@"_outDataBuffer failed");
        //abort()
        return false;
    } // Allocating memory, aligned to 16.
    
    if (posix_memalign((void **)&_tempBuffer, 16,_outBufferSize) != 0 )
    {
        NSLog(@"_tempBuffer failed");
        //abort()
        return false;
    } // Allocating memory, aligned to 16.
    
    
    
    _lastSamplerate = 44100;
    
    //创建一个播放器
    //M4
    if (!_player) {
        _player = new SuperpoweredAdvancedAudioPlayer(NULL, NULL, 44100, 0);

    }
    _player->open( [_filePath fileSystemRepresentation]);
    _player->setBpm(124.0f);
    _player->setTempo(1.0f, true);
    //M5
    _player->setFirstBeatMs(40);
    _player->setPosition(_player->firstBeatMs, false, false);
    //M6  超滤共振低通
    SuperpoweredFilter *filter = new SuperpoweredFilter(SuperpoweredFilter_Resonant_Lowpass, 44100);
    filter->setResonantParameters(1000.0f, 0.1f);
    effects[FILTERINDEX] = filter;
    
    effects[ROLLINDEX] = new SuperpoweredRoll(44100);
    effects[FLANGERINDEX] = new SuperpoweredFlanger(44100);
    
    SuperpoweredReverb *reverb = new SuperpoweredReverb(44100);
    reverb->setRoomSize(0.8f);
    reverb->setMix(0.5f);
    effects[REVERBINDEX] = reverb;

    
    _bandEQ = new Superpowered3BandEQ(44100);
    _bandEQ->enable(true);
    
    if( g_output == nil )
    {
        g_output = [[SuperpoweredIOSAudioIO alloc] initWithDelegate:(id<SuperpoweredIOSAudioIODelegate>)self
                                                preferredBufferSize:12 preferredMinimumSamplerate:44100
                                               audioSessionCategory:AVAudioSessionCategoryPlayAndRecord
                                                           channels:2];
    }
    
    return YES;
}
- (BOOL)startPlay:(NSString*)filepath
{
    
    _filePath = filepath;
    if( ![self cfgPlayer] )
    {
        NSLog(@"cfg player failed");
        return NO;
    }
    
    //重置音效
    //[self resetVEP];
    
    //开始播放
    _player->play(false);
    
    //设置代理
    [g_output setdelg:self];
    if( !_player->playing )
    {
        _player->togglePlayback();
    }
    
    if( ![g_output getRuning] )
        
        [g_output start];
    
    return YES;
}



// This is where the Superpowered magic happens.
- (bool)audioProcessingCallback:(float **)buffers inputChannels:(unsigned int)inputChannels outputChannels:(unsigned int)outputChannels numberOfSamples:(unsigned int)numberOfSamples samplerate:(unsigned int)samplerate hostTime:(UInt64)hostTime {
  
    if( !_player->playing )
    {
        NSLog(@"not palying");
        return false;
    }
    
    uint64_t startTime = mach_absolute_time();
    
    if (samplerate != _lastSamplerate) { // Has samplerate changed?
        //采样率变化了,就更新
        _lastSamplerate = samplerate;
        _player->setSamplerate(samplerate);
        _bandEQ->setSamplerate( samplerate );
        
    };
    
    // We're keeping our Superpowered time-based effects in sync with the player... with one line of code. Not bad, eh?
    //((SuperpoweredRoll *)effects[ROLLINDEX])->bpm = ((SuperpoweredFlanger *)effects[FLANGERINDEX])->bpm = ((SuperpoweredEcho *)effects[DELAYINDEX])->bpm = player->currentBpm;

    
    /*
     Let's process some audio.
     If you'd like to change connections or tap into something, no abstract connection handling and no callbacks required!
     */
    
    
    float fff = _mVolume / 12.0f;
    
    bool silence = !_player->process(_stereoBuffer, false, numberOfSamples, fff, 0.0f, -1.0);
    _bandEQ->process(_stereoBuffer, _stereoBuffer, numberOfSamples);

    /*
     暂时不要其他效果
    if (effects[ROLLINDEX]->process(silence ? NULL : stereoBuffer, stereoBuffer, numberOfSamples)) silence = false;
    effects[FILTERINDEX]->process(stereoBuffer, stereoBuffer, numberOfSamples);
    effects[EQINDEX]->process(stereoBuffer, stereoBuffer, numberOfSamples);
    effects[FLANGERINDEX]->process(stereoBuffer, stereoBuffer, numberOfSamples);
    if (effects[DELAYINDEX]->process(silence ? NULL : stereoBuffer, stereoBuffer, numberOfSamples)) silence = false;
    if (effects[REVERBINDEX]->process(silence ? NULL : stereoBuffer, stereoBuffer, numberOfSamples)) silence = false;
    */
    
    /*
     
     时间计算处理
    // CPU measurement code to show some nice numbers for the business guys.
    uint64_t elapsedUnits = mach_absolute_time() - startTime;
    if (elapsedUnits > maxTime) maxTime = elapsedUnits;
    timeUnitsProcessed += elapsedUnits;
    samplesProcessed += numberOfSamples;
    if (samplesProcessed >= samplerate) {
        avgUnitsPerSecond = timeUnitsProcessed;
        maxUnitsPerSecond = (double(samplerate) / double(numberOfSamples)) * maxTime;
        samplesProcessed = timeUnitsProcessed = maxTime = 0;
    };
    */
    
    if (!silence) SuperpoweredDeInterleave(_stereoBuffer, buffers[0], buffers[1], numberOfSamples); // The stereoBuffer is ready now, let's put the finished audio into the requested buffers.
    
   // _bandConvert->process( _stereoBuffer, _tempBuffer, numberOfSamples);
    //M7
    memset( _tempBuffer, 0,  1024 *4*10);
    
    SuperpoweredFloatToShortInt(_stereoBuffer, (short int*)_tempBuffer, numberOfSamples);

    
//    for ( int j = 8192*4-1; j >=0; j--) {
//        if( _tempBuffer[ j ] != 0 )
//        {
//            NSLog(@"thiscopyleng:%d",j);
//            break;
//        }
//    }
    
    
    [self pushBuffer:_tempBuffer size: numberOfSamples *4 ];
    
   // if (!silence) SuperpoweredDeInterleave(_tempBuffer, buffers[0], buffers[1], numberOfSamples); // The stereoBuffer is ready now, let's put the finished audio into the requested buffers.

    /*
    memset(_tempBuffer, 0, 4096 + 128 );
    
    if (!silence) SuperpoweredDeInterleave(_stereoBuffer, buffers[0], buffers[1], numberOfSamples); // The stereoBuffer is ready now, let's put the finished audio into the requested buffers.
    */
    
    return !silence;
}

- (void)changeRt
{
    //M8
    _player->setSamplerate(44100);
    
}

- (void)stopPlay
{
    if( _player->playing )
    {
        //暂停
        _player->togglePlayback();
        [g_output setdelg:nil];
    }
}


//所有的EQ 配置,比如 @[ @"原声",@"悠扬",@"流行"...];
-(NSArray*)getAllEQSet
{
    return _allEqNames;
}

- (void)pushBuffer:(char*)inbuffer size:(int)buffersize
{
    OSSpinLockLock(&_outBufferSpinlock);
    
    if( _outBufferPushInOffset + buffersize > _outBufferSize )
    {
        memcpy( &_outDataBuffer[ _outBufferPushInOffset ] , inbuffer, _outBufferSize - _outBufferPushInOffset );
        memcpy( &_outDataBuffer[ 0 ] , &inbuffer [ _outBufferSize - _outBufferPushInOffset ] , buffersize -        (_outBufferSize - _outBufferPushInOffset) );
        _outBufferPushInOffset = buffersize -  (_outBufferSize - _outBufferPushInOffset);
    }
    else
    {
        memcpy( &_outDataBuffer[ _outBufferPushInOffset ] , inbuffer, buffersize );
        _outBufferPushInOffset += buffersize;
    }
    
    _outBufferNowSize += buffersize;
    if( _outBufferNowSize > _outBufferSize )
    {
        NSLog(@"mem full...");
    }
    //NSLog(@"_outBufferNowSize:%d",_outBufferNowSize);
    OSSpinLockUnlock(&_outBufferSpinlock);
    
}

//如果没有足够的 buffersize 长度数据,就不拷贝 返回0 ,等着下次,
-(int)copyOutBuffer:(char*)buffer buffersize:(int)buffersize
{
    
    OSSpinLockLock(&_outBufferSpinlock);
    
    if( _outBufferNowSize < buffersize )
    {
        OSSpinLockUnlock(&_outBufferSpinlock);
        return 0;
    }
    
    if( _outBufferCopyOutOffset + buffersize > _outBufferSize )
    {
        memcpy( buffer  , &_outDataBuffer[ _outBufferCopyOutOffset ], _outBufferSize - _outBufferCopyOutOffset );
        memcpy( &buffer[ _outBufferSize - _outBufferCopyOutOffset ]  , &_outDataBuffer[ 0 ], buffersize -         (_outBufferSize - _outBufferCopyOutOffset) );
        _outBufferCopyOutOffset = buffersize -         (_outBufferSize - _outBufferCopyOutOffset);
    }
    else
    {
        memcpy( buffer  , &_outDataBuffer[ _outBufferCopyOutOffset ], buffersize );
        _outBufferCopyOutOffset += buffersize;
    }
    
    _outBufferNowSize -= buffersize;
    
    OSSpinLockUnlock(&_outBufferSpinlock);
    return  buffersize;
}



- (void)dealloc
{
    if( _outDataBuffer )
        free( _outDataBuffer );
    
    if( _stereoBuffer )
        free( _stereoBuffer );
    
    if( _tempBuffer)
        free( _tempBuffer );
    //M8
   // if( g_output )
   // {                    //这里不能 主动删除，，否则 点击 关闭，，再点歌，，，对方听不见。。无效
    //   [g_output stop];
   //   //  g_output = nil;
   // }
    //M9
  //  delete _player;
    //M10
   // for (int n = 2; n < NUMFXUNITS; n++) delete effects[n];
   // free(_stereoBuffer);
    //M11
    
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
