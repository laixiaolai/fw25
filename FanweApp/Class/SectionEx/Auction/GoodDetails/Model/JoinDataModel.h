//
//  JoinDataModel.h
//  FanweApp
//
//  Created by fanwe2014 on 16/8/9.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JoinDataModel : NSObject

@property (nonatomic, copy) NSString *bz_diamonds;//保证金金额
@property (nonatomic, copy) NSString *consignee;//收货人姓名
@property (nonatomic, copy) NSString *consignee_address;//收货人地址
@property (nonatomic, strong) NSMutableDictionary *consignee_district;// 收货人所在地行政地区信息,json格式
@property (nonatomic, copy) NSString *consignee_mobile;//收货人手机号
@property (nonatomic, copy) NSString *create_date;//参与时间-yyyy-mm-dd hh:ii:ss GMT+8
@property (nonatomic, copy) NSString *pai_time;
@property (nonatomic, copy) NSString *pai_time_d;//参与时间 dd GMT+8
@property (nonatomic, copy) NSString *pai_time_m;//参与时间 mm GMT+8
@property (nonatomic, copy) NSString *pai_time_ms;
@property (nonatomic, copy) NSString *create_time;//参与时间-utf0
@property (nonatomic, copy) NSString *create_time_y;//参与时间 yyyy GMT+8
@property (nonatomic, copy) NSString *create_time_ymd;//参与时间 yyyy-mm-dd GMT+8
@property (nonatomic, copy) NSString *ID;//参与编号
@property (nonatomic, copy) NSString *order_id;//订单id
@property (nonatomic, copy) NSString *order_status;//订单状态
@property (nonatomic, copy) NSString *order_time;//订单时间
@property (nonatomic, copy) NSString *pai_diamonds;//终出价
@property (nonatomic, copy) NSString *pai_id;//竞拍商品id
@property (nonatomic, copy) NSString *pai_left_start_time;
@property (nonatomic, copy) NSString *pai_status;//0 出局 1待付款 2排队中 3超时出局
@property (nonatomic, copy) NSString *status;//0未处理 1已返还 2已扣除
@property (nonatomic, copy) NSString *user_id;//参与人
@property (nonatomic, copy) NSString *pai_number;//出价几次


@end
