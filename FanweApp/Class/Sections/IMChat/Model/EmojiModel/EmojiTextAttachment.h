//
//  EmojiTextAttachment.h
//  FanweApp
//
//  Created by 朱庆彬 on 2017/8/15.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmojiTextAttachment : NSTextAttachment

@property (nonatomic, copy) NSString *emoName;
@property (nonatomic, assign) float Scale;
@property (nonatomic, assign) CGFloat Top;

@end
