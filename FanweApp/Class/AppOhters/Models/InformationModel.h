//
//  InformationModel.h
//  FanweApp
//
//  Created by fanwe2014 on 16/5/28.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UserModel;
@class cuserModel;

@interface InformationModel : NSObject

@property (nonatomic, assign) int           has_admin;
@property (nonatomic, assign) int           has_focus;
@property (nonatomic, assign) int           show_admin;
@property (nonatomic, assign) int           show_tipoff;
@property (nonatomic, assign) int           status;
@property (nonatomic, assign) int           is_forbid;

@property (nonatomic, strong) UserModel     *user;
@property (nonatomic, strong) cuserModel    *cuser;

@end
