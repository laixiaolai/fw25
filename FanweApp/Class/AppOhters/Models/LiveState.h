//
//  LiveState.h
//  FanweLive
//
//  Created by xfg on 16/11/28.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LiveState : NSObject

@property (nonatomic, copy) NSString    *roomId;                    // 直播间ID
@property (nonatomic, copy) NSString    *liveHostId;                // 主播ID
@property (nonatomic, assign) BOOL      isLiveHost;                 // 是否主播
@property (nonatomic, assign) BOOL      isInPubViewController;      // 是否在PubViewController:0不是 1是

@end
