//
//  CommentModel.h
//  FanweApp
//
//  Created by fanwe2014 on 2017/3/21.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentModel : NSObject
@property(nonatomic,copy)NSString *user_id;              //用户靓号ID
@property(nonatomic,copy)NSString *nick_name;            //昵称
@property(nonatomic,copy)NSString *signature;            //我的个性签名
@property(nonatomic,copy)NSString *content;              //评论
@property(nonatomic,copy)NSString *comment_id;           //评论ID
@property(nonatomic,copy)NSString *to_comment_id;        //被评论的评论ID
@property(nonatomic,copy)NSString *to_user_id;           //被评论的会员
@property(nonatomic,copy)NSString *head_image;           //用户头像
@property(nonatomic,copy)NSString *create_time;          //评论时间
@property(nonatomic,copy)NSString *left_time;            //微博数
@property(nonatomic,copy)NSString *is_to_comment;        //是否评论
@property(nonatomic,copy)NSString *to_nick_name;         //被评论的会员昵称
@property(nonatomic,copy)NSString *is_authentication;    //是否认证

@property(nonatomic,copy)NSString *cover;                 //
@property(nonatomic,copy)NSString *is_model;              //
@property(nonatomic,copy)NSString *latitude;              //
@property(nonatomic,copy)NSString *longitude;             //
@property(nonatomic,copy)NSString *orginal_url;           //
@property(nonatomic,copy)NSString *path;                  //
@property(nonatomic,copy)NSString *position;              //
@property(nonatomic,copy)NSString *url;                   //

//我的购买
@property(nonatomic,copy)NSString *type_cate_name;        //购买类型
@property(nonatomic,copy)NSString *type_cate;             //无
@property(nonatomic,copy)NSString *money;                 //价格
@property(nonatomic,copy)NSString *pay_time;              //支付时间
@property(nonatomic,copy)NSString *memo;                  //备注
@property(nonatomic,copy)NSString *from_user_info;        //买家备注
@property(nonatomic,assign)int is_pay;                    //提现转态

//会员中心-等级列表
@property(nonatomic,copy)NSString *icon;                   //等级图标
@property(nonatomic,copy)NSString *v_icon;                 //等级图标
@property(nonatomic,copy)NSString *name;                   //等级图标
@property(nonatomic,copy)NSString *level;                  //等级图标
@property(nonatomic,copy)NSString *score;                  //所需要积分
@property(nonatomic,copy)NSString *point;                  //所需信用值
@property(nonatomic,copy)NSString *commission;             //
@property(nonatomic,copy)NSString *user_level_img;         //等级图标
@end
