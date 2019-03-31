//
//  PersonCenterListModel.h
//  FanweApp
//
//  Created by fanwe2014 on 2017/3/15.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonCenterListModel : NSObject


@property(nonatomic,copy)NSString *weibo_id;                    //微博ID
@property(nonatomic,copy)NSString *user_id;                     //用户ID
@property(nonatomic,copy)NSString *head_image;                  //头像
@property(nonatomic,copy)NSString *nick_name;                   //用户名
@property(nonatomic,copy)NSString *content;                     //文本
@property(nonatomic,copy)NSString *red_count;                   //红包数
@property(nonatomic,copy)NSString *price;                       //售价
@property(nonatomic,copy)NSString *digg_count;                  //点赞数
@property(nonatomic,assign)int    has_digg;                     //1表示点赞过0表示没有
@property(nonatomic,copy)NSString *comment_count;               //评论数
@property(nonatomic,copy)NSString *video_count;                 //视频点击数
@property(nonatomic,copy)NSString *is_show_weibo_report;        //是否显示举报动态
@property(nonatomic,copy)NSString *is_show_user_report;         //是否显示举报用户
@property(nonatomic,copy)NSString *is_show_user_black;          //是否显示拉黑用户
@property(nonatomic,copy)NSString *is_top;                      //是否为置顶
@property(nonatomic,copy)NSString *type;                        //imagetext 图文 red_photo 红包图片 weixin 出售微信 video 视频动态 goods 商品 photo 写真'
@property(nonatomic,copy)NSString *images_count;                //写真的张数
@property(nonatomic,copy)NSString *video_url;                   //视频链接
@property(nonatomic,copy)NSString *is_show_top;                 //是否显示置顶
@property(nonatomic,copy)NSString *show_top_des;                //文字描述
@property(nonatomic,copy)NSString *is_show_deal_weibo;          //经是否显示删除动态
@property(nonatomic,copy)NSString *photo_image;                 //写真封面图片
@property(nonatomic,copy)NSString *is_authentication;           //是否认证 0指未认证 1指待审核 2指认证 3指审核不通过
@property(nonatomic,copy)NSString *left_time;                   //发的时间（按分钟发）
@property(nonatomic,copy)NSString *goods_url;                   //商品的链接
@property(nonatomic,copy)NSString *weibo_place;                 //商品的地址
@property(nonatomic,assign)int    has_black;                    //0代表未拉黑1代表拉黑
@property(nonatomic,copy) NSString *v_icon;                     //认证图标
@property(nonatomic,strong)NSMutableArray *images;              //显示的头像数组




@end
