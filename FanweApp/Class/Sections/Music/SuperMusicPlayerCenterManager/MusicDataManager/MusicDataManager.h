//
//  MusicDataManager.h
//  FanweApp
//
//  Created by 岳克奎 on 16/12/16.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface MusicDataManager : NSObject

#pragma mark -life cycle ------------------------------------生 命 周 期 区 域 -----------------------------------
+ (MusicDataManager *)shareManager;
#pragma mark  ----------------------------------------------- 音 乐 数据相关区域  ---------------------------------
#pragma mark - 音乐 歌词 处理
/**
 * @brief: 音乐歌词处理
 *
 *@use： 在选择音乐后，调用，原本想传musicModel 但是考虑日后其他SDK 传入，还是传str，省心省事
 */
- (void)analysisLrcStrOfMusicLRCDataStr:(NSString *)lrcDataStr
                          musicNameStr:(NSString *)musicNameStr
                        musicSingerStr:(NSString *)musicSingerStr
                              complete:(void(^)(BOOL finished,NSMutableArray *lrcModelMArray,NSMutableArray *lrcPointTimeStrArray))block;

@end
