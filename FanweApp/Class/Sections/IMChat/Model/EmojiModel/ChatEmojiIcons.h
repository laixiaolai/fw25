//
//  ChatEmojiIcons.h
//  FanweApp
//
//  Created by 朱庆彬 on 2017/8/15.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatEmojiIcons : NSObject

//获取表情集
+ (NSArray *)emojis;

//获取表情数量
+ (NSInteger)getEmojiPopCount;

//根据表情tag获取表情图片
+ (NSString *)getEmojiNameByTag:(NSInteger)tag;

+ (NSString *)getEmojiPopNameByTag:(NSInteger)tag;

+ (NSString *)getEmojiPopIMGNameByTag:(NSInteger)tag;

@end
