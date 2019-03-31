//
//  FWLiveBaseViewModel.h
//  FanweApp
//
//  Created by xfg on 2017/8/14.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "FWBaseViewModel.h"

@interface FWLiveBaseViewModel : FWBaseViewModel

/**
 开始直播，供子类重写
 */
- (void)startLive;

/**
 暂停直播，供子类重写
 */
- (void)pauseLive;

/**
 重新开始直播，供子类重写
 */
- (void)resumeLive;

/**
 结束直播，供子类重写
 */
- (void)endLive;

@end
