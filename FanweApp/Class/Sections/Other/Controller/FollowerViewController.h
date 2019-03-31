//
//  FollowerViewController.h
//  FanweApp
//
//  Created by fanwe2014 on 16/6/18.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FollowerViewController : FWBaseViewController

@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *type;      //type_1 关注 2：粉丝 3：黑名单

@end
