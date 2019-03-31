//
//  NSString+guoMS.h
//  微博微微
//
//  Created by GuoMS on 14-6-16.
//  Copyright (c) 2014年 MAC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (guoMS)

- (NSString*)fileAppend:(NSString*)append;

- (NSString*)deleteCharacters;

- (NSInteger)countOccurencesOfString:(NSString*)searchString;

@end
