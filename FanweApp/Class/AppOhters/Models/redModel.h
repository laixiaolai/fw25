//
//  redModel.h
//  FanweApp
//
//  Created by fanwe2014 on 16/6/2.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface redModel : NSObject

@property(nonatomic,retain)NSString     *head_image;// 头像
@property(nonatomic,retain)NSString     *nick_name; // 名字
@property (nonatomic, assign) int       sex;        // 性别
@property (nonatomic, assign) int       diamonds;   // 抢到的金额
@property (nonatomic, assign) int       user_id;    // 用户的Id

@end
