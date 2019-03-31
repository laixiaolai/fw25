//
//  AppBlockModel.h
//  FanweApp
//
//  Created by xfg on 2017/6/7.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "FWBaseModel.h"

@interface AppBlockModel : FWBaseModel

+ (instancetype)manager;

@property (nonatomic, strong) NSDictionary *retDict;

@end
