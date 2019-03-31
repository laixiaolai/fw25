//
//  MusicCenterManager.h
//  FanweApp
//
//  Created by 岳克奎 on 16/12/16.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MusicSuperPlayer.h"
#import "MusicDataManager.h"
@class MusicCenterManager;


@protocol MusicCenterManagerLrcDataDelegate <NSObject>
@optional
//因为single  写一个 主要是为了嫩出来个方法，其余参数直接single 传
- (void)sendMusicOfLrcModelMArray:(NSMutableArray *)lrcModelMArray
            lrcPointTimeStrArray:(NSMutableArray *)lrcPointTimeStrArray
                    musicNameStr:(NSString *)musicNameStr
                  musicSingerStr:(NSString *)musicSingerStr;
//歌曲进度  时间
- (void)sendMusicTotalDuration:(CGFloat)musicTotalDuration musicCurrentDuration:(CGFloat)musicCurrentDuration musicPresent:(CGFloat)musicPresent;
//展示要显示 的音乐功能界面  具体实现放在相应SDK下的ViewController里去实现
//- (UIViewController *)showMusicFunctionViewControllerOfMusicCenterManager:(MusicCenterManager *)musicCM;
- (void)changeMusicBtnOfPlayStatewWithMusicPlayState:(BOOL)musicPlaySate;
- (void)showMusicSDKMehodsWhenShowNewPlayer;
@end
//音乐调度中心的代理
@protocol MusicCenterManagerDelegate <NSObject>
@optional
//音乐加载
- (BOOL)showMusicPlayOfMusicPathStr:(NSString *)musicPathStr ofSamplerateNum:(int)samplerateNum;
//音乐播放 //音乐暂停
- (BOOL)musicStartOrStopPlayOfPlayingState:(BOOL)isPlayingState;

//互动音乐  暂停  需要关闭 KTV回响   （暂时是互动）
- (void)closeEnableLoopBackFunction;
// 歌词处理后 给对应的SDK 下的VC
- (void)sendMusicLrcModelDataMArray:(NSMutableArray *)lrcModelMArray lrcPointTimeStrArray:(NSMutableArray *)lrcPointTimeStrArray;
@end
@interface MusicCenterManager : NSObject
@property (nonatomic, strong) MusicSuperPlayer    *superPlayer;                  //C++播放器控制中心
@property (nonatomic, strong) MusicDataManager    *musicDataManager;             //音乐数据处理中心
@property (nonatomic, strong) UIViewController    *recordMusicViewController;    //记录 音乐功能UI VC（预留）
@property (nonatomic, assign) BOOL                musicPlayingState;             //音乐的状态
@property (nonatomic, strong) NSString            *recordMusicFilePatnStr;       //音乐的本地沙盒路径str
@property (nonatomic, strong) NSString            *recordMusicNameStr;           //音乐的名称str
@property (nonatomic, strong) NSString            *recordMusicSingerStr;         //音乐的歌手名Str
@property (nonatomic, assign) CGFloat             recordMusicTotalDuration;      //当前音乐的总时长
@property (nonatomic, assign) CGFloat             recordMusicCurrentDuration;
@property (nonatomic, assign) CGFloat             musicPresent;
@property (nonatomic, strong) NSString            *recordMusicLrcStr;             //当前音乐 歌词 str
@property (nonatomic, strong) NSArray             *recordLrcDataArray;            //当前音乐 歌词 数据源 数组
@property (nonatomic, strong) UIViewController    *recordSuperViewController;     //记录 音乐要添加到的父视图
@property (nonatomic, assign) CGRect              recordMusicFunctionVCFrameRect; //记录 音乐VC 在父视图的frame
@property (nonatomic, weak) id<MusicCenterManagerDelegate>delegate;               //代理 --》VC方向
@property (nonatomic, weak) id<MusicCenterManagerLrcDataDelegate>dataDelegate;    //代理--》播放器方向
#pragma mark --life cycle
+ (MusicCenterManager *)shareManager;
#pragma mark  音 乐 UI层 部 分 （UI）
#pragma mark - music  加载歌词（LRC）（Data）
/**
 * @ brief:加载歌词
 *
 * @prama : lrcDataStr  歌词
 * @prama : mDic 歌词 名信息
 * @prama : block      finished   lrcModelMArray  相当于我么你的歌词数据源
 *
 * @ use  : 把歌词给管理中心，管理中心自动调给数据层解析数据，然后把数据 返回给对应的对象
 */
- (void)showMusicLRCofLRCDataStr:(NSString *)lrcDataStr
                   musicNameStr:(NSString *)musicNameStr
                 musicSingerStr:(NSString *)musicSingerStr
                       complete:(void(^)(BOOL finished,NSMutableArray *lrcModelMArray,NSMutableArray *lrcPointTimeStrArray))block;


@end
