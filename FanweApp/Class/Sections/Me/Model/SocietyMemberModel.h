//
//  SocietyMemberModel.h
//  FanweApp
//
//  Created by 王珂 on 17/1/22.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SocietyMemberModel : NSObject

@property (nonatomic, copy) NSString *user_id; //公会成员ID
@property (nonatomic, copy) NSString *nick_name; //公会成员昵称
@property (nonatomic, copy) NSString * sex;  //公会成员性别
@property (nonatomic, copy) NSString *head_image; //公会成员头像
@property (nonatomic, assign) NSInteger user_level; //公会成员等级
@property (nonatomic, copy) NSString *v_icon; //公会成员认证图标
@property (nonatomic, assign) NSInteger v_type; //公会成员认证类型:0: 未认证;1:普通认证;2:企业认证;
@property (nonatomic, copy) NSString *signature; //
@property (nonatomic, copy) NSString *society_chieftain; //
@property (nonatomic, copy) NSString *society_settlement_type; //
@property (nonatomic, copy) NSString *status; //
@property (nonatomic, copy) NSString *deal_time; //

@end
