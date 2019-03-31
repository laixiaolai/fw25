//
//  TLiveMickModel.h
//  FanweApp
//
//  Created by xfg on 2017/4/21.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TLiveMickLayoutParamModel.h"

@interface TLiveMickModel : NSObject

@property (nonatomic, copy) NSString            *user_id;          // 小主播ID
@property (nonatomic, copy) NSString            *push_rtmp2;       // 小主播的 push_rtmp 推流地址
@property (nonatomic, copy) NSString            *play_rtmp_acc;    // 大主播的 rtmp_acc 播放地址，这个服务端下发在这个结构的外层
@property (nonatomic, copy) NSString            *play_rtmp2_acc;   // 小主播的 rtmp_acc 播放地址

@property (nonatomic, strong) TLiveMickLayoutParamModel    *layout_params;    // 小主播画面大小，位置

@end
