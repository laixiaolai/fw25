//
//  GiftListManager.h
//  FanweApp
//
//  Created by xfg on 16/5/20.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GiftListManager : NSObject

// 单例模式
FanweSingletonH(Instance);

@property (nonatomic, assign) double expiry_after; //过期时间
@property (nonatomic, strong) NSArray *giftMArray; //礼物列表

/**
 保存礼物列表

 @param dict 数据
 */
- (void)saveGiftList:(NSDictionary *)dict;

/**
 重新加载礼物列表
 */
- (void)reloadGiftList;

@end
