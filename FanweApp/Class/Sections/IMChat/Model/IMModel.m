//
//  IMModel.m
//  FanweApp
//
//  Created by yy on 16/8/18.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "IMModel.h"

@implementation IMModel

- (CGFloat)getHeight:(NSString *)content
{
    self.contentHeight = [self boundingRectWithSize:self.content];

    CGFloat height = self.contentHeight + 43.3;

    return height;
}

//计算文本高度
- (CGFloat)boundingRectWithSize:(NSString *)str
{
    //文本框的长kScreenW-99
    CGRect rect = [str boundingRectWithSize:CGSizeMake(kScreenW - 99, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName: kAppMiddleTextFont } context:nil];
    CGFloat height = rect.size.height;

    return height;
}

@end
