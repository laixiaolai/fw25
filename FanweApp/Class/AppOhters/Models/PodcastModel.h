//
//  PodcastModel.h
//  FanweApp
//
//  Created by xfg on 16/6/1.
//  Copyright © 2016年 xfg. All rights reserved.
//  主播信息

#import <Foundation/Foundation.h>
#import "UserModel.h"

@interface PodcastModel : NSObject

@property (nonatomic, assign) NSInteger show_tipoff;
@property (nonatomic, assign) NSInteger show_admin;
@property (nonatomic, assign) NSInteger has_focus;
@property (nonatomic, assign) NSInteger has_admin;

@property (nonatomic, strong) UserModel *user;

@end
