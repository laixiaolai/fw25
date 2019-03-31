//
//  TLiveMickListModel.h
//  FanweApp
//
//  Created by xfg on 2017/4/21.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TLiveMickModel.h"

@interface TLiveMickListModel : NSObject

@property (nonatomic, copy) NSString            *play_rtmp_acc;     // 主播的acc播放地址
@property (nonatomic, strong) NSMutableArray    *list_lianmai;      // 连麦观众列表

@end
