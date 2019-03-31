//
//  dateModel.h
//  YiZanService
//
//  Created by zzl on 15/3/19.
//  Copyright (c) 2015年 zywl. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GiftModel.h"

@interface dataModel : NSObject

@end

@interface SAutoEx : NSObject

- (id)initWithObj:(NSDictionary*)obj;

- (void)fetchIt:(NSDictionary*)obj;

@end


//返回通用数据,,,
@interface SResBase : SAutoEx

+(SResBase*)shareClient;

@property (nonatomic, assign) int        msuccess;//是否成功了
@property (nonatomic, assign) int        mcode;  //错误码
@property (nonatomic, strong) NSString*  mmsg;   //客户端需要显示的提示信息,正确,失败,根据msuccess判断显示错误还是提示,
@property (nonatomic, strong) NSString*  mdebug;
@property (nonatomic, strong) id         mdata;

@property (nonatomic, strong) void(^mg_pay_block)(SResBase*resb);

+(SResBase*)infoWithOKString:(NSString*)msg;

+(SResBase*)infoWithString:(NSString*)error;

+ (void)postReq:(NSString*)method ctl:(NSString*)ctl parm:(NSDictionary*)param block:(void(^)(SResBase* resb))block;

+ (NSDictionary*)postReqSync:(NSString*)method ctl:(NSString*)ctl parm:(NSDictionary*)param;

@end


@interface czModel: SAutoEx

@property (nonatomic, assign) int    mId;//"id": "3",
@property (nonatomic, strong) NSString*      mName;//": "钻石980",
@property (nonatomic, assign) float  mMoney;//": "98.00",
@property (nonatomic, assign) float    mDiamonds;//": "990"
@property (nonatomic, assign) BOOL   mBI;//输入的那种,,,
@property (nonatomic, strong) NSString *mgift_coins_dec;

+ (void)getCZInfo:(void(^)(SResBase* resb,int yue,int rate,NSArray* czItems, NSArray* payItmes))block;

@end


@interface payMethodModel : SAutoEx

@property (nonatomic, assign) int        mId;
@property (nonatomic, strong) NSString*  mName;
@property (nonatomic, strong) NSString*  mLogo;
@property (nonatomic, strong) NSString*  mClass_name;

- (void)payIt:(czModel*)mode block:(void(^)(SResBase* resb))block;

@end


@class musiceModel;

@protocol musicDownloadDelegate <NSObject>

@optional

- (void)musicDownloading:(musiceModel*)obj context:(id)context needstop:(BOOL*)needstop;

@end


@interface musiceModel : SAutoEx

@property (nonatomic, strong) NSString  *mAudio_id;
@property (nonatomic, strong) NSString *mAudio_link;///音乐下载地址
@property (nonatomic, strong) NSString *mLrc_content;//,//内容
@property (nonatomic, strong) NSString *mAudio_name;//歌曲名
@property (nonatomic, strong) NSString *mArtist_name;//,//演唱者
@property (nonatomic, assign) int       mTime_len;
@property (nonatomic, strong) NSString *mFilePath;
@property (nonatomic, copy) NSString *has_next;//是否有下一页

- (NSString *)getFullFilePath;

//下面的不需要保存
@property (nonatomic, assign) int             mmFileStatus;//0 没有下载,1 已经下载,2下载中...
@property (nonatomic, assign) int             mmPecent;//下载进度 00--100
@property (nonatomic, strong) NSString*       mmDownloadInfo;

@property (nonatomic, weak)      id<musicDownloadDelegate>   mmDelegate;
@property (nonatomic, weak)      UITableViewCell*    mmUIRef;

- (void)startDonwLoad:(id)context;

- (NSString *)getTimeLongStr;

@property (nonatomic, strong) NSIndexPath*    mmRefUICellIndexPath;

//从我的歌曲列表里面删除这个
- (void)delThis:(void(^)(SResBase* resb))block;

//清除本地歌曲缓存,不会删除列表,情理缓存的时候使用
+ (BOOL)clearLocalSave;

//返回本地文件的总大小,,in byte
+ (int)getLocatDataSize;

//获取搜索历史记录
+ (NSArray*)getSearchHistory;

//删除历史记录
+ (void)deleteHistory:(NSInteger )indexPath;

//搜索歌曲
+ (void)searchMuisc:(NSString*)keywords page:(int)page block:(void(^)(SResBase* resb, NSArray* all ))block;

//获取我的音乐列表
+ (void)getMyMusicList:(int)page block:(void(^)(SResBase* resb, NSArray* all ))block;

//获取本地音乐
+ (void)getLocalMusic:(int)page block:(void(^)(SResBase* resb, NSArray* all ))block;

//添加歌曲到列表
- (void)addThisToMyList:(void(^)(SResBase* resb))block;

@end


