//
//  SHomePageVC.h
//  FanweApp
//
//  Created by 丁凯 on 2017/7/4.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "FWBaseViewController.h"

typedef NS_ENUM(NSInteger ,HomePageTableView)
{
    HPZeroSection,                 //第一段  印票贡献榜
    HPFirstSection,                //第二段  灰色阴影
    HPSecondSection,               //第三段  主页 直播或者小视频的内容
    HPTab_Count,
};


@interface SHomePageVC : FWBaseViewController

@property (nonatomic, copy) NSString       *user_id;         //用户ID
@property (nonatomic, assign) int          type;             //类型 0主页1直播
@property (nonatomic, copy) NSString       *user_nickname;   //用户名字
@property (nonatomic, copy) NSString       *user_headimg;    //用户头像

@end
