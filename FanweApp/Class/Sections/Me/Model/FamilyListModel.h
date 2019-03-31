//
//  FamilyListModel.h
//  FanweApp
//
//  Created by 王珂 on 16/9/27.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FamilyListModel : NSObject

@property (nonatomic, copy) NSString * family_id;                    //家族ID
@property (nonatomic, copy) NSString * family_logo;              //家族logo
@property (nonatomic, copy) NSString * family_name;             //家族名称
@property (nonatomic, copy) NSString * user_id;             //家族长ID
@property (nonatomic, copy) NSString * nick_name;          //家族长昵称
@property (nonatomic, copy) NSString * create_time;       //创建时间
@property (nonatomic, copy) NSString * user_count;       //家族成员数量
@property (nonatomic, copy) NSString * is_apply;         //是否已经提交申请，1：已提交、0：未提交

@end
