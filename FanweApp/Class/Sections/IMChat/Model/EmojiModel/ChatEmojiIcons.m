//
//  ChatEmojiIcons.m
//  FanweApp
//
//  Created by 朱庆彬 on 2017/8/15.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "ChatEmojiIcons.h"

@implementation ChatEmojiIcons

//获取表情包
+ (NSArray *)emojis
{
    static NSArray *_emojis;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 处理耗时操作的代码块...
        NSString *emojiFilePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Emoji.plist"];
        NSDictionary *emojiDic = [[NSDictionary alloc] initWithContentsOfFile:emojiFilePath];

        NSMutableArray *array = [NSMutableArray array];
        for (NSInteger i = 1; i < 105; i++)
        {
            [array addObject:[emojiDic valueForKey:[NSString stringWithFormat:@"[em_%@]", @(i)]]];
        }
        //通知主线程刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            _emojis = array;
        });
    });

    return _emojis;
}

+ (NSInteger)getEmojiPopCount
{
    return [[self class] emojis].count;
}

+ (NSString *)getEmojiNameByTag:(NSInteger)tag
{
    NSArray *emojis = [[self class] emojis];
    return emojis[tag];
}

+ (NSString *)getEmojiPopIMGNameByTag:(NSInteger)tag
{
    NSString *name = [[self class] getEmojiNameByTag:tag];
    return [[self class] imgNameWithName:name];
}

+ (NSString *)getEmojiPopNameByTag:(NSInteger)tag
{
    NSString *key = [NSString stringWithFormat:@"%@", [self getEmojiNameByTag:tag]];
    return NSLocalizedString(key, @"");
}

+ (NSString *)imgNameWithName:(NSString *)name
{
    return [NSString stringWithFormat:@"%@", name];
}

@end
