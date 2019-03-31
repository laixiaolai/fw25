//
//  emotionView.h
//  FanweApp
//
//  Created by fanwe2014 on 16/7/19.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol changeEmotionStatuDelegate <NSObject>
//修改情感状态的代理
- (void)changeEmotionStatuWithString:(NSString *)emoyionString;

@end

@interface emotionView : UIView

@property (nonatomic, assign)int arrayCount;
@property (nonatomic, weak) id<changeEmotionStatuDelegate>delegate;
@property (nonatomic, strong) NSArray *titleArray;
- (instancetype)initWithFrame:(CGRect)frame withName:(NSString *)name;

@end
