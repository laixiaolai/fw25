//
//  EmojiObj.h
//  FanweApp
//
//  Created by 朱庆彬 on 2017/8/15.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "ChatEmojiIcons.h"
#import <UIKit/UIKit.h>

#define EmojiIMG_Width_Hight 28.0f //表情图片宽高
#define EmojiView_Border 14.0f     //边框
#define EmojiIMG_Space 18.0f       //表情间距
#define EmojiIMG_Space_UP 11.0f    //表情上下间距
#define EmojiIMG_Lines 4           //表情行数

@interface EmojiObj : NSObject

@property (nonatomic, copy) NSString *emojiName;    //表情名称
@property (nonatomic, copy) NSString *emojiImgName; //表情图片名称
@property (nonatomic, copy) NSString *emojiString;  //表情码文

+ (NSInteger)countInOneLine; //一行多少图片
+ (NSInteger)onePageCount;
+ (NSInteger)pageCountIsSupport; //支持几页
+ (NSArray *)emojiObjsWithPage:(NSInteger)page;
+ (EmojiObj *)del_Obj;

@end
