//
//  FWOssManager.h
//  FanweApp
//
//  Created by 丁凯 on 2017/7/31.
//  Copyright © 2017年 xfg. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <AliyunOSSiOS/OSSService.h>

@protocol OssUploadImageDelegate <NSObject>

//oss上传后的代理
- (void)uploadImageWithUrlStr:(NSString *)imageUrlStr withUploadStateCount:(int)stateCount;

@end

@interface FWOssManager : NSObject

{
    OSSClient              *_client;
    NSString               *_endPoint;
    OSSPutObjectRequest    *_putRequest;
    GlobalVariables        *_fanweApp;
    NSString               *_bucketName;
    NSString               *_AccessKeyId;
    NSString               *_AccessKeySecret;
    NSString               *_Expiration;
    NSString               *_SecurityToken;
    NSString               *_imageEndPoint;
    NSString               *_callbackAddress;
    NSString               *_bucket;
    NSString               *_objectKey;
    NetHttpsManager        *_httpsManager;

}

@property ( nonatomic,assign) int               statutCount;                            //判断oss是否上传成功，0代表成功 1代表取消 2代表失败 NSString
@property ( nonatomic,copy) NSString            *dir;
@property ( nonatomic,copy) NSString            *oss_domain;
@property ( nonatomic,weak) id                  <OssUploadImageDelegate>OssDelegate;

//初始化
- (id)initWithDelegate:(id<OssUploadImageDelegate>)delegate;

//获取ObjectKeyString
- (NSString *)getObjectKeyString;

- (void)setCallbackAddress:(NSString *)address;

- (void)asyncPutImage:(NSString *)objectKey
        localFilePath:(NSString *)filePath;

- (BOOL)isSetRightParameter;

#pragma mark --------------------------------  oss 上传
#pragma mark --- 上传照片 或视频 的 二进制数据(必须是NSData)
-(void)showUploadOfOssServiceOfDataMarray:(NSMutableArray<NSData *>*)dataArray
                   andSTDynamicSelectType:(STDynamicSelectType)stDynamicSelectType
                              andComplete:(void(^)(BOOL finished,
                                                   NSMutableArray <NSString *>*urlStrMArray))block;

@end

