//
//  AcutionHistoryModel.h
//  FanweApp
//
//  Created by fanwe2014 on 16/8/9.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AcutionHistoryModel : NSObject

@property (nonatomic, copy) NSString *bz_diamonds;//竞拍保证金
@property (nonatomic, copy) NSString *ID;//竞拍编号
@property (nonatomic, copy) NSString *zb_id;//主播ID
@property (nonatomic, copy) NSString *jj_diamonds;//每次加价
@property (nonatomic, copy) NSString *pai_date;//竞拍时间-yyyy-mm-dd hh:ii:ss GMT+8
@property (nonatomic, copy) NSString *pai_date_format;
@property (nonatomic, copy) NSString *pai_id;//竞拍商品
@property (nonatomic, copy) NSString *pai_sort;//第几次出价
@property (nonatomic, copy) NSString *pai_time;//竞拍时间-utf0
@property (nonatomic, copy) NSString *pai_time_d;//竞拍时间 dd GMT+8
@property (nonatomic, copy) NSString *pai_time_m;//竞拍时间 mm GMT+8
@property (nonatomic, copy) NSString *pai_time_ms;//竞拍时间-毫秒
@property (nonatomic, copy) NSString *pai_time_y;//竞拍时间 yyyy GMT+8
@property (nonatomic, copy) NSString *pai_time_ymd;//竞拍时间 yyyy-mm-dd GMT+8
@property (nonatomic, copy) NSString *podcast_id;
@property (nonatomic, copy) NSString *qp_diamonds;//起拍价
@property (nonatomic, copy) NSString *pai_diamonds;//出价
@property (nonatomic, copy) NSString *pai_status;//领先/出局
@property (nonatomic, copy) NSString *status_format;//未支付/已支付/已流拍
@property (nonatomic, copy) NSString *user_id;//观众ID
@property (nonatomic, copy) NSString *user_name;//观众名称
@property (nonatomic, copy) NSString *head_image;//观众头像

@property (nonatomic, assign) int image_height;//头像高度
@property (nonatomic, assign) int image_width;//头像宽度
@property (nonatomic, copy) NSString *image_url;//头像url

@end
