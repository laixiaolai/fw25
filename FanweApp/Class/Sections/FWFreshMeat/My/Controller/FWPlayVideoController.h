//
//  FWPlayVideoController.h
//  FanweApp
//
//  Created by fanwe2014 on 2017/4/10.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FWPlayVideoController : FWBaseViewController
@property (nonatomic,copy)NSString *playUrl;     //播放的链接
@property (nonatomic,assign)float  playTime;    //播放的时长
@end
