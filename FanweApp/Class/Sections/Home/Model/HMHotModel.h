//
//  HMHotModel.h
//  FanweApp
//
//  Created by xfg on 2017/7/5.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "FWBaseModel.h"
#import "HMHotBannerModel.h"
#import "HMHotItemModel.h"

@interface HMHotModel : FWBaseModel

@property (nonatomic, strong) NSMutableArray<HMHotBannerModel *>    *banner;
@property (nonatomic, strong) NSMutableArray<HMHotItemModel *>      *list;

@property (nonatomic, assign) NSInteger     has_next;
@property (nonatomic, assign) NSInteger     page;

@end
