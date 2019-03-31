//
//  PublishLiveViewModel.h
//  FanweApp
//
//  Created by xfg on 2017/6/8.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "FWBaseViewModel.h"

@interface PublishLiveViewModel : FWBaseViewModel

/**
 开始直播

 @param dict 开播参数
 @param vc 需要dismiss的VC，如果不需要做dismiss操作，传nil就可以了
 */
+ (void)beginLive:(NSMutableDictionary *)dict vc:(UIViewController *)vc block:(AppCommonBlock)block;

@end
