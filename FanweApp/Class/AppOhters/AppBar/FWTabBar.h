//
//  FWTabBar.h
//  FanweApp
//
//  Created by xfg on 2017/6/26.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FWTabBar : UITabBar

/**
 中间按钮点击回调
 */
@property (nonatomic, copy) void(^centerBtnClickBlock)();

@end
