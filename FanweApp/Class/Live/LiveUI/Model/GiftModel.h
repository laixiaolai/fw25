//
//  GiftModel.h
//  FanweApp
//
//  Created by xfg on 16/5/20.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GiftModel : NSObject

@property (nonatomic, assign) NSInteger     ID;
@property (nonatomic, assign) NSInteger     diamonds;
@property (nonatomic, copy) NSString        *score_fromat;  // 增加的经验值
@property (nonatomic, copy) NSString        *icon;
@property (nonatomic, assign) NSInteger     is_plus;        // 收到礼物时是否需要叠加
@property (nonatomic, assign) NSInteger     is_much;        // 这个礼物是否可以连发
@property (nonatomic, copy) NSString        *name;
@property (nonatomic, assign) float         score;
@property (nonatomic, assign) NSInteger     sort;
@property (nonatomic, assign) NSInteger     ticket;
@property (nonatomic, assign) BOOL          isSelected;     // 是否选中

@end
