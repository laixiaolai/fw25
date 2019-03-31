//
//  EmojiTextAttachment.m
//  FanweApp
//
//  Created by 朱庆彬 on 2017/8/15.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "EmojiTextAttachment.h"

@implementation EmojiTextAttachment

- (CGRect)attachmentBoundsForTextContainer:(NSTextContainer *)textContainer proposedLineFragment:(CGRect)lineFrag glyphPosition:(CGPoint)position characterIndex:(NSUInteger)charIndex
{

    return CGRectMake(0, self.Top, lineFrag.size.height * self.Scale, lineFrag.size.height * self.Scale);
}

- (instancetype)initWithData:(NSData *)contentData ofType:(NSString *)uti
{
    self = [super initWithData:contentData ofType:uti];
    if (self)
    {
        self.Scale = 1.0f;
        self.Top = 0.0f;
        if (self.image == nil)
        {
            self.image = [UIImage imageWithData:contentData];
        }
    }
    return self;
}

@end
