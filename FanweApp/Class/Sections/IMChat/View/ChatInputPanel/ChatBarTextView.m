//
//  ChatBarTextView.m
//  FanweApp
//
//  Created by 朱庆彬 on 2017/8/23.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "ChatBarTextView.h"

@implementation ZWNSTextAttachment

- (nullable UIImage *)imageForBounds:(CGRect)imageBounds textContainer:(nullable NSTextContainer *)textContainer characterIndex:(NSUInteger)charIndex
{
    return self.mFaceImg;
}

- (CGRect)attachmentBoundsForTextContainer:(nullable NSTextContainer *)textContainer proposedLineFragment:(CGRect)lineFrag glyphPosition:(CGPoint)position characterIndex:(NSUInteger)charIndex
{
    CGRect fff = CGRectMake(position.x, 0 - (self.mFontH / 3.34f), self.mFontH, self.mFontH);
    return fff;
}

@end

@implementation ChatBarTextView

- (void)paste:(id)sender
{
    [super paste:sender];

    NSString *text = self.attributedText.string;

    NSRange searchFrom;
    searchFrom.length = text.length;
    searchFrom.location = 0;

    NSMutableArray *findarr = NSMutableArray.new;
    do
    {
        NSRange find = [text rangeOfString:@"\\[[a-z]+[0-9]+\\]" options:NSRegularExpressionSearch range:searchFrom];
        if (find.location == NSNotFound)
        { //最好一次么有找到..
            break;
        }
        //找到了
        [findarr addObject:@{ @"l": @(find.location),
                              @"s": @(find.length),
                              @"yy": [text substringWithRange:find] }];

        searchFrom.location = find.location + find.length;
        searchFrom.length = text.length - searchFrom.location;

    } while (searchFrom.location < text.length);

    NSMutableAttributedString *finalstr = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];

    NSInteger fix = 0;

    for (NSDictionary *one in findarr)
    {
        NSRange r;
        r.location = [[one objectForKey:@"l"] integerValue] - fix;
        r.length = [[one objectForKey:@"s"] integerValue];
        fix += r.length - 1;

        NSString *facename = [one objectForKey:@"yy"];

        NSString *facenamepng = [facename substringWithRange:NSMakeRange(1, facename.length - 2)];
        facenamepng = [facename stringByReplacingOccurrencesOfString:@"[" withString:@""];
        facenamepng = [facenamepng stringByReplacingOccurrencesOfString:@"]" withString:@""];
        facenamepng = [facenamepng stringByAppendingString:@".png"];

        ZWNSTextAttachment *faceattachment = [[ZWNSTextAttachment alloc] initWithData:nil ofType:nil];
        faceattachment.mFontH = self.font.lineHeight;

        faceattachment.mFaceImg = [UIImage imageNamed:facenamepng];
        faceattachment.mFaceNmae = facename;

        NSAttributedString *faceattr = [NSAttributedString attributedStringWithAttachment:faceattachment];

        [finalstr replaceCharactersInRange:r withAttributedString:faceattr];
    }

    [finalstr addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, finalstr.length)];

    self.attributedText = finalstr;
}

// 这个要把attribstr 反过来解释处理
- (NSString *)getSendTextStr
{
    NSAttributedString *nowattr = self.attributedText;

    NSMutableString *retstr = [[NSMutableString alloc] initWithString:nowattr.string];

    NSMutableArray *tttt = NSMutableArray.new;

    for (int j = 0; j < nowattr.length; j++)
    {
        NSRange itrang;
        NSDictionary *one = [nowattr attributesAtIndex:j effectiveRange:&itrang];

        ZWNSTextAttachment *zwattchement = [one objectForKey:@"NSAttachment"];
        if (zwattchement)
        {
            //[retstr replaceCharactersInRange:itrang withString:zwattchement.mFaceNmae];
            [tttt addObject:@{ @"l": @(itrang.location),
                               @"s": @(itrang.length),
                               @"yy": zwattchement.mFaceNmae }];
        }
    }

    NSInteger fix = 0;

    for (NSDictionary *one in tttt)
    {
        NSRange r;
        r.location = [[one objectForKey:@"l"] integerValue];
        r.length = [[one objectForKey:@"s"] integerValue] + fix;
        fix += r.length - 1;

        NSString *sss = [one objectForKey:@"yy"];
        NSRange sssrr = [retstr rangeOfString:@"\U0000fffc"];
        [retstr replaceCharactersInRange:sssrr withString:sss];
    }
    return retstr;
}

- (void)appendFace:(NSInteger)faceIndex
{
    NSAttributedString *nowattrstr = self.attributedText;
    NSMutableAttributedString *finalstr = nil;

    if (nowattrstr)
        finalstr = [[NSMutableAttributedString alloc] initWithAttributedString:nowattrstr];
    else
        finalstr = NSMutableAttributedString.new;

    ZWNSTextAttachment *faceattachment = [[ZWNSTextAttachment alloc] initWithData:nil ofType:nil];
    faceattachment.mFontH = self.font.lineHeight;

    NSString *facePicname = [NSString stringWithFormat:@"face%ld.png", faceIndex];
    faceattachment.mFaceImg = [UIImage imageNamed:facePicname];
    faceattachment.mFaceNmae = [NSString stringWithFormat:@"[face%ld]", faceIndex];

    NSAttributedString *faceattr = [NSAttributedString attributedStringWithAttachment:faceattachment];
    [finalstr appendAttributedString:faceattr];

    [finalstr addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, finalstr.length)];

    self.attributedText = finalstr;
}

@end
