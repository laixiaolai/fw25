//
//  SocietyDesModel.h
//  FanweApp
//
//  Created by 王珂 on 17/1/22.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SocietyDesModel : NSObject

@property (nonatomic, copy) NSString * society_id;               //公会ID
@property (nonatomic, copy) NSString * logo;                   //公会logo
@property (nonatomic, copy) NSString * name;                 //公会名称
@property (nonatomic, copy) NSString * create_time;         //创建时间
@property (nonatomic, copy) NSString * manifesto;          //公会宣言
@property (nonatomic, copy) NSString * memo;               //备注
@property (nonatomic, copy) NSString * status;             //审核状态
@property (nonatomic, copy) NSString * nick_name;          //公会长昵称
@property (nonatomic, copy) NSString * user_count;        //公会人数

@end
