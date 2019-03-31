//
//  NSData+AES.h
//  DownloadFile
//
//  Created by  on 12-1-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NSString;

@interface NSData (AES)

/**
 AES加密

 @param key 加密KEY
 @return 返回NSString值
 */
- (NSString *)AES256EncryptWithKey:(NSString *)key;

/**
 AES解密

 @param key 解密KEY
 @return 返回NSString值
 */
- (NSString *)AES256DecryptWithKey:(NSString *)key;

@end
