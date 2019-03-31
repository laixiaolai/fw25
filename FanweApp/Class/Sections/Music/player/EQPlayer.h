//
//  EQPlayer.h
//  SuperpoweredPerformance
//
//  Created by zzl on 16/6/23.
//  Copyright © 2016年 imect. All rights reserved.
//


@interface EQPlayer : NSObject

@property (nonatomic,assign,readonly) double        mTotalTime;//歌曲总时间,,,秒 35.3544444
@property (nonatomic,assign,readonly) double        mCurrentTime;//当前播放时间,,,秒 25.3544444

@property (nonatomic, assign) int             mVolume;//当前音量值 0 ~ 12
@property (nonatomic, strong)   NSString*       mEqName;//均衡器效果名字
@property (nonatomic, assign) int             mPitch;//音调 -12 ~ +12

//重置 Vol EQ Pitch...
- (void)resetVEP;

-(int)getSampleRate;




- (BOOL)startPlay:(NSString*)filepath;
- (void)stopPlay;

//所有的EQ 配置,比如 @[ @"原声",@"悠扬",@"流行"...];
-(NSArray*)getAllEQSet;

-(int)copyOutBuffer:(char*)buffer buffersize:(int)buffersize;

- (void)changeRt;


@end
