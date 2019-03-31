//
//  managerModel.h
//  FanweApp
//
//  Created by fanwe2014 on 16/5/31.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface managerModel : NSObject

@property (nonatomic, assign) int       user_id;
@property (nonatomic, assign) int       id;
@property (nonatomic, copy) NSString    *nick_name;
@property (nonatomic, copy) NSString    *head_image;
@property (nonatomic, assign) int       sex;
@property (nonatomic, assign) int       user_level;

@end
