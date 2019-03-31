//
//  FWMD5UTils.h
//  FanweApp
//
//  Created by xfg on 2017/1/16.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

#define FileHashDefaultChunkSizeForReadingData 1024*8 // 8K  

@interface FWMD5UTils : NSObject

//计算NSData 的MD5值
+ (NSString*)getMD5WithData:(NSData*)data;

//计算字符串的MD5值，
+ (NSString*)getmd5WithString:(NSString*)string;

//计算大文件的MD5值
+ (NSString*)getFileMD5WithPath:(NSString*)path;

@end
