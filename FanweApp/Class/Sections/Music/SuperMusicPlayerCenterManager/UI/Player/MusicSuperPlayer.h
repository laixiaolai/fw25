//
//  MusicSuperPlayer.h
//  FanweApp
//
//  Created by 岳克奎 on 16/12/6.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface MusicSuperPlayer : NSObject
{
@public
            uint64_t                                             maxUnitsPerSecond;                   //预留  这个库这一块我还没看懂呢
            uint64_t                                             avgUnitsPerSecond;                  //预留   后期扩展
}
@property (nonatomic, assign) int                                   samplerate;                         //采样率    这个更多的只是作为记录使用，便于重复播放
@property (nonatomic, assign) BOOL                                  superPlayerPlaying;                 //记录 是否在播放
@property (nonatomic, strong) NSString                              *musicFilePathStr;                  //音乐路径 这个更多的只是作为记录使用
@property (nonatomic, assign) CGFloat                              accompanyValue;                     //C++播放器的音量（0-1.0f）
@property (nonatomic, assign) NSInteger                            pitchValue;                         //C++播放器的音调（-12-12）
@property (nonatomic, assign) NSInteger                            selectEffectTag;                    //C++播放器的 音效效果
@property (nonatomic, assign) int                                   recordCurrent;
#pragma mark -left cyle ---------------------------------------生 命 周 期 管 控 区 域 ---------------------------------------
+ (MusicSuperPlayer *)shareManager;
#pragma mark -public  methods ---------------------------------- 公 有 方 法 区 域 ------------------------------------------

//copy 缓冲数据，推送至服务器
-(int)copyOutBuffer:(char*)buffer buffersize:(int)buffersize;
@end
