//
//  ChatBarTextView.h
//  FanweApp
//
//  Created by 朱庆彬 on 2017/8/23.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatBarTextView : UITextView

- (void)appendFace:(NSInteger)faceIndex;

- (NSString *)getSendTextStr;

@end

@interface ZWNSTextAttachment : NSTextAttachment

@property (nonatomic, assign) CGFloat mFontH;
@property (nonatomic, strong) UIImage *mFaceImg;
@property (nonatomic, strong) NSString *mFaceNmae;

@end
