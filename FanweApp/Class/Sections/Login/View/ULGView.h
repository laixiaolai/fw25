//
//  ULGView.h
//  FanweApp
//
//  Created by fanwe2014 on 2016/12/10.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NLgDelegate <NSObject>

//通过带count的代理来判断哪种登入
- (void)enterLoginWithCount:(int)count;

@end

@interface ULGView : UIView

@property (nonatomic, weak) id<NLgDelegate>LDelegate;
//初始化
- (id)initWithFrame:(CGRect)frame Array:(NSArray *)array;

//页面的排布
- (void)creatViewWithArray:(NSArray *)array;
@end
