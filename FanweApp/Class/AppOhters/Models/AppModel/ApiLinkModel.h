//
//  ApiLinkModel.h
//  FanweApp
//
//  Created by xfg on 16/8/3.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApiLinkModel : NSObject

@property (nonatomic, copy) NSString *ctl_act;
@property (nonatomic, copy) NSString *api;
@property (nonatomic, assign) NSInteger has_cookie;

@end
