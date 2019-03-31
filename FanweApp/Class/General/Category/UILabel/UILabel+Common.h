//
//  UILabel+UILabel_Common.h
//  CommonLibrary
//
//  Created by AlexiChen on 14-1-18.
//  Copyright (c) 2014年 CommonLibrary. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Common)

+ (instancetype)label;

+ (instancetype)labelWithTitle:(NSString *)title;

// 已知区域重新调整
- (CGSize)contentSize;

// 不知区域，通过其设置区域
- (CGSize)textSizeIn:(CGSize)size;

//得到富文本的高度
- (CGFloat)takeLblHeight:(NSString *)content withTextFontSize:(CGFloat)mFontSize lineSpaceing:(NSInteger)lineSpaceing size:(CGSize)size;

- (void)lblHeight:(CGFloat)lblHeight;

//- (void)layoutInContent;

@end


@interface InsetLabel : UILabel

@property (nonatomic, assign) UIEdgeInsets contentInset;

@end
