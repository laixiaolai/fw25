//
//  FamilyMemberModel.h
//  FanweApp
//
//  Created by 王珂 on 16/9/27.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FamilyMemberModel : NSObject

@property (nonatomic, copy) NSString *user_id; //家族成员ID
@property (nonatomic, copy) NSString *nick_name; //家族成员昵称
@property (nonatomic, copy) NSString * sex;  //家族成员性别
@property (nonatomic, copy) NSString *head_image; //家族成员头像
@property (nonatomic, assign) NSInteger user_level; //等级
@property (nonatomic, copy) NSString *v_icon; //家族成员认证图标
@property (nonatomic, assign) NSInteger v_type; //家族成员认证类型:0: 未认证;1:普通认证;2:企业认证;
@property (nonatomic, copy) NSString *signature; //

@end
