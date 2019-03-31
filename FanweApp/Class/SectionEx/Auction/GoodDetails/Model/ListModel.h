//
//  ListModel.h
//  FanweApp
//
//  Created by fanwe2014 on 16/10/25.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlaceModel.h"

@interface ListModel : NSObject

@property (nonatomic, copy) NSString *ID;//竞拍编号
@property (nonatomic, copy) NSString *user_id;//用户id
@property (nonatomic, copy) NSString *consignee;//联系人
@property (nonatomic, copy) NSString *consignee_mobile;//电话号码
@property (nonatomic, strong) PlaceModel *consignee_district;//省市区
@property (nonatomic, copy) NSString *consignee_address;//地址
@property (nonatomic, copy) NSString *is_default;//是否是默认
@property (nonatomic, copy) NSString *create_time;//时间

//鲜肉直播 写真 鲜肉
@property (nonatomic,copy)NSString       *weibo_id;             //微博id
@property (nonatomic,copy)NSString       *user_level;           //用户等级
@property (nonatomic,copy)NSString       *sort_num;             //动态权重
@property (nonatomic,copy)NSString       *head_image;           //头像
@property (nonatomic,copy)NSString       *nick_name;            //名字
@property (nonatomic,copy)NSString       *show_image_num;       //头像数量
@property (nonatomic,copy)NSString       *city;                 //城市
@property (nonatomic,copy)NSString       *xpoint;               //x坐标
@property (nonatomic,copy)NSString       *ypoint;               //y坐标


//视频
@property (nonatomic,copy)NSString       *video_image;          //头像
@property (nonatomic,copy)NSString       *video_url;            //视频播放地址
@property (nonatomic,copy)NSString       *vide_desc;            //视频标题
@property (nonatomic,copy)NSString       *video_count;          //视频数量

//搜索页面
@property (nonatomic,copy)NSString       *signature;            //
@property (nonatomic,copy)NSString       *sex;                  //性别
@property (nonatomic,copy)NSString       *v_icon;               //认证
@property (nonatomic,copy)NSString       *fans_count;           //粉丝数
@property (nonatomic,copy)NSString       *follow_id;            //是否关注0表示未关注 大于0表示已关注

@end
