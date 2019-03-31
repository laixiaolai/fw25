//
//  EmojiButton.m
//  FanweApp
//
//  Created by 朱庆彬 on 2017/8/15.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "EmojiButton.h"
#import "EmojiObj.h"

@implementation EmojiButton

- (void)setEmojiIcon:(EmojiObj *)emojiIcon
{
    _emojiIcon = emojiIcon;
    [self setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", emojiIcon.emojiImgName]] forState:UIControlStateNormal];
}

@end
