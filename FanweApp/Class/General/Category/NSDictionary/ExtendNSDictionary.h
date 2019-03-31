//
//  ExtendNSDictionary.h
//  Futuan
//
//  Created by 陈 福权 on 11-12-4.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary(util)

/**
 获取对应key的value，并转为NSString类型

 @param aKey 用来获取该value的key
 @return NSString
 */
- (NSString *)toString:(NSString *)aKey;

/**
 获取对应key的value，并转为int类型

 @param aKey 用来获取该value的key
 @return int
 */
- (int)toInt:(NSString *)aKey;

/**
 获取对应key的value，并转为float类型

 @param aKey 用来获取该value的key
 @return float
 */
- (float)toFloat:(NSString *)aKey;	

@end
