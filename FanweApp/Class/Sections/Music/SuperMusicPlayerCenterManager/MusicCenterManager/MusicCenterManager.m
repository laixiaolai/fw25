//
//  MusicCenterManager.m
//  FanweApp
//
//  Created by 岳克奎 on 16/12/16.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "MusicCenterManager.h"

@implementation MusicCenterManager
#pragma mark -------------------------------------life cycle -------------------------------------
#pragma mark - 音乐控制中  单利
/**
 * @brief: 音乐控制中 单利
 *
 * @discussion:我的想法是，用单利管理，这样能够通过C++的player对应的控制器来控制。播放，暂停。如果不这样，需要频繁的
 */
static MusicCenterManager *signleton = nil;
+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        signleton = [super allocWithZone:zone];
    });
    return signleton;
}
+ (MusicCenterManager *)shareManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        signleton = [[self alloc] init];
    });
    return signleton;
}
+ (id)copyWithZone:(struct _NSZone *)zone
{
    return signleton;
}

+ (id)mutableCopyWithZone:(struct _NSZone *)zone
{
    return signleton;
}

#pragma mark  ----------------------------------- 音 乐 控制 逻辑层 部 分（Logic） -----------------------------------
#pragma mark - 音乐路径处理（L）
/**
 * @brief: 音乐路径处理,获取完整的音乐文件地址str
 *
 */
- (NSString *)searchFullFilePathOfMusicFilePathStr:(NSString *)musicFilePathStr
{
    NSString *str = [NSString stringWithFormat:@"/Documents/%@/%@",@"music",musicFilePathStr];
    if (str && ![str isEqualToString:@""])
    {
        return [NSHomeDirectory() stringByAppendingString:str];
    }
    return NSHomeDirectory();
}

#pragma mark ------------------------------------------ set/get  ----------------------------------------
//musicDataManager 数据层管理中心
/**
 *  @brief:      数据层管理中心
 *
 *  @Function:   我个人认为每个模块都有自己的数据层，MVCS架构臃肿，如果要移植怎么办，还是奉行高聚合，低耦合思想比较好。
 *
 *  @discussion: 目前只是处理一部分，音乐不是一般的复杂
 */
- (MusicDataManager *)musicDataManager
{
    if (!_musicDataManager)
    {
        _musicDataManager = [MusicDataManager shareManager];
    }
    return _musicDataManager;
}

#pragma mark- 音乐的状态(暂时只监听有互动)
/***
 * @brief:音乐的状态(暂时只监听有互动，预留云音乐的合并)
 *
 * @dicussion:  1.暂时这里只处理互动  后期云音乐建议代码合并到音乐调度中心
 *              2.通过属性的变化 来改变UI的变动。这样不用我们去找UI，调度中心属性更变，跟简单控制UI层的变化
 *              3.从大的方面来讲 UI层是干什么的 只是管理生命周期+SDK方法的。逻辑层的方法 应该又 单独剥离处理啊的 逻辑层管理
 * @use：       音乐暂停  恢复
 */
- (void)setMusicPlayingState:(BOOL)musicPlayingState
{
    if (_delegate && [_delegate respondsToSelector:@selector(musicStartOrStopPlayOfPlayingState:)])
    {
        _musicPlayingState  =  [_delegate musicStartOrStopPlayOfPlayingState:musicPlayingState];
    }
    //更变 音乐控制Btn的状态
    if (_dataDelegate && [_dataDelegate respondsToSelector:@selector(changeMusicBtnOfPlayStatewWithMusicPlayState:)])
    {
        [_dataDelegate changeMusicBtnOfPlayStatewWithMusicPlayState:_musicPlayingState];
    }
    
    //多种输入输出，例如可以耳机、USB设备同时播放
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryMultiRoute error:nil];
    //iOS 10下 音乐播放必须需要加
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
}

#pragma mark - 音乐的本地沙盒路径str
/**
 * @brief:音乐的本地沙盒路径str
 *
 * @discussion:
 */
- (void)setRecordMusicFilePatnStr:(NSString *)recordMusicFilePatnStr
{
    _recordMusicFilePatnStr = recordMusicFilePatnStr;
    //当发生变化 就去播放
    [self superPlayerPlayOfSamplerateNum:44100 musicFilePathStr:_recordMusicFilePatnStr];
}

#pragma mark - music  play  音乐播放（L）（Public）
/**
 * @brief:    超级播放器播放
 *
 * @prama:      samplerateNum 采样率
 * @prama:      musicFilePathStr  音乐路径Str（不完整，需要再处理下）
 *
 * @Step:      _musicPlayingState  YES 启动音乐播放，音乐处于播放状态
 * @Step:       启动音乐播放器
 * @Step：      通过设置SDK混音代理，实现代理方法，将相应的内存里的数据 不断传入SDK混音方法里
 * @Step：      AVAudioSession  输出设置
 * @Step:       AVAudioSession   播放
 *
 * @use:        使用前提 采样率+路径
 *
 * @discussion: 1.在音乐VC初次创建的时候，会调这里
 *              2.思考：想下腾讯云，要不要把控制中心方法嫩成代理呢？
 */
- (void)superPlayerPlayOfSamplerateNum:(int)samplerateNum musicFilePathStr:(NSString *)musicFilePathStr
{
    //音乐路径不存在   最好判断这个文件存在与否！！！
    if(!musicFilePathStr)
    {
        return;
    }
    // 音乐播放
    if (_delegate &&[_delegate respondsToSelector:@selector(showMusicPlayOfMusicPathStr:ofSamplerateNum:)])
    {
        [_delegate showMusicPlayOfMusicPathStr:[self searchFullFilePathOfMusicFilePathStr:musicFilePathStr] ofSamplerateNum:samplerateNum];
    }
    //互动SDK 必须实现一些方法  主要是开启KTV 回响模式+音乐数据混音   SDK的方法放在SDK里处理
    //[self copyMusicPlayDataToSDKHD];
    if (_dataDelegate &&[_dataDelegate respondsToSelector:@selector(showMusicSDKMehodsWhenShowNewPlayer)])
    {
        [_dataDelegate showMusicSDKMehodsWhenShowNewPlayer];
    }
}

#pragma mark - 音乐的名称str
/**
 * @brief: 音乐的名称str
 *
 * @discussion:
 */
- (void)setRecordMusicNameStr:(NSString *)recordMusicNameStr
{
    _recordMusicNameStr = recordMusicNameStr;
}

#pragma mark - 音乐的歌手名Str
/**
 * @brief:音乐的歌手名Str
 *
 * @discussion:
 */
- (void)setRecordMusicSingerStr:(NSString *)recordMusicSingerStr
{
    _recordMusicSingerStr = recordMusicSingerStr;
}

#pragma mark - 当前音乐  总时间
/**
 * @brief: 当前音乐 歌词 str
 *
 * @discussion:
 */
- (void)setRecordMusicTotalDuration:(CGFloat)recordMusicTotalDuration
{
    _recordMusicTotalDuration = recordMusicTotalDuration;
    if (_dataDelegate&&[_dataDelegate respondsToSelector:@selector(sendMusicTotalDuration:musicCurrentDuration:musicPresent:)])
    {
        [_dataDelegate sendMusicTotalDuration:_recordMusicTotalDuration musicCurrentDuration:_recordMusicCurrentDuration musicPresent:_musicPresent];
    }
}

#pragma mark - 当前音乐  总时间
/**
 * @brief: 当前音乐 歌词 str
 *
 * @discussion:
 */
- (void)setRecordMusicCurrentDuration:(CGFloat)recordMusicCurrentDuration
{
    _recordMusicCurrentDuration = recordMusicCurrentDuration;
    if (_dataDelegate&&[_dataDelegate respondsToSelector:@selector(sendMusicTotalDuration:musicCurrentDuration:musicPresent:)])
    {
        [_dataDelegate sendMusicTotalDuration:_recordMusicTotalDuration musicCurrentDuration:_recordMusicCurrentDuration musicPresent:_musicPresent];
    }
}

- (void)setMusicPresent:(CGFloat)musicPresent
{
    _musicPresent = musicPresent;
    if (_dataDelegate&&[_dataDelegate respondsToSelector:@selector(sendMusicTotalDuration:musicCurrentDuration:musicPresent:)])
    {
        [_dataDelegate sendMusicTotalDuration:_recordMusicTotalDuration musicCurrentDuration:_recordMusicCurrentDuration musicPresent:_musicPresent];
    }
}

#pragma mark - 当前音乐 歌词 str
/**
 当前音乐 歌词 str
 
 1.代码为啥写在这里，还是想通过 音乐控制中心去完成 各个模块的交互??????????
 2.lrcView 看成已经集成UI，我们只需要通过音乐控制中心去调度加载就ok！
 3.只是集成 2行（上下行）模式
 
 VC或view需要显示 两行Lrc

 @param recordMusicLrcStr 歌词
 */
- (void)setRecordMusicLrcStr:(NSString *)recordMusicLrcStr
{
    _recordMusicLrcStr = recordMusicLrcStr;
    //歌词处理
    [self showMusicLRCofLRCDataStr:_recordMusicLrcStr musicNameStr:_recordMusicNameStr musicSingerStr:_recordMusicSingerStr complete:^(BOOL finished, NSMutableArray *lrcModelMArray, NSMutableArray *lrcPointTimeStrArray) {
        //将数据通过代理传走
        if(_dataDelegate && [_dataDelegate respondsToSelector:@selector(sendMusicOfLrcModelMArray:lrcPointTimeStrArray:musicNameStr:musicSingerStr:)])
        {
            [_dataDelegate sendMusicOfLrcModelMArray:lrcModelMArray lrcPointTimeStrArray:lrcPointTimeStrArray musicNameStr:_recordMusicNameStr musicSingerStr:_recordMusicSingerStr];
        }
    }];
}

#pragma mark - music  加载歌词(UI)
/**
 * @ brief:加载歌词
 *
 * @prama : lrcDataStr  歌词
 * @prama : mDic 歌词 名信息
 * @prama : block      finished   lrcModelMArray  相当于我么你的歌词数据源
 *
 * @ use  : 把歌词给管理中心，管理中心自动调给数据层解析数据，然后把数据 返回给对应的对象
 */
- (void)showMusicLRCofLRCDataStr:(NSString *)lrcDataStr musicNameStr:(NSString *)musicNameStr musicSingerStr:(NSString *)musicSingerStr complete:(void(^)(BOOL finished, NSMutableArray *lrcModelMArray, NSMutableArray *lrcPointTimeStrArray))block
{
    // 数据层处理了数据生成 lrcmode返回给控制中心
    [[MusicDataManager shareManager] analysisLrcStrOfMusicLRCDataStr:lrcDataStr musicNameStr:musicNameStr musicSingerStr:musicSingerStr complete:^(BOOL finished, NSMutableArray *lrcModelMArray, NSMutableArray *lrcPointTimeStrArray) {
        
        if (block)
        {
            block(finished, lrcModelMArray, lrcPointTimeStrArray);
        }
        
    }];
}

#pragma mark - 当前音乐 歌词 数据源 数组
/**
 * @brief: 当前音乐 歌词 数据源 数组
 *
 * @discussion:
 */
- (void)setRecordLrcDataArray:(NSArray *)recordLrcDataArray
{
    _recordLrcDataArray = recordLrcDataArray;
}

#pragma mark - 记录 音乐VC 在父视图的frame
/**
 * @brief:记录 音乐VC 在父视图的frame
 *
 * @discussion:
 */
- (void)setRecordMusicFunctionVCFrameRect:(CGRect)recordMusicFunctionVCFrameRect
{
    _recordMusicFunctionVCFrameRect = recordMusicFunctionVCFrameRect;
}

@end
