//
//  InfoModel.h
//  FanweApp
//
//  Created by fanwe2014 on 16/8/9.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InfoModel : NSObject

@property (nonatomic, copy) NSString *bz_diamonds;//竞拍保证金
@property (nonatomic, copy) NSString *contact;//联系人[虚拟]
@property (nonatomic, copy) NSString *create_date;// 添加时间-yyyy-mm-dd hh:ii:ss GMT+8
@property (nonatomic, copy) NSString *create_time;//添加时间-utf0
@property (nonatomic, copy) NSString *create_time_d;//添加时间 dd GMT+8
@property (nonatomic, copy) NSString *create_time_m;//添加时间 mm GMT+8
@property (nonatomic, copy) NSString *create_time_y;//添加时间 yyyy GMT+8
@property (nonatomic, copy) NSString *create_time_ymd;//添加时间 yyyy-mm-dd GMT+8
@property (nonatomic, copy) NSString *date_time;//约会时间[虚拟]
@property (nonatomic, copy) NSString *Description;//商品的详情
@property (nonatomic, copy) NSString *goods_id;//普通商品id is_true=1 时存在
@property (nonatomic, copy) NSString *ID;//竞拍商品id
@property (nonatomic, copy) NSString *is_true;//0虚拟 1普通商品
@property (nonatomic, copy) NSString *jj_diamonds;//每次加价
@property (nonatomic, copy) NSString *last_pai_diamonds;//最后出价金额
@property (nonatomic, copy) NSString *last_user_id;//最后竞拍用户id
@property (nonatomic, copy) NSString *last_user_name;//最后出价竞拍用户名称
@property (nonatomic, copy) NSString *max_yanshi;//最大的延迟时间
@property (nonatomic, copy) NSString *mobile;//联系电话[虚拟]
@property (nonatomic, copy) NSString *name;//竞拍名称
@property (nonatomic, copy) NSString *order_id;//下单后的id
@property (nonatomic, copy) NSString *order_status;//订单状态
@property (nonatomic, copy) NSString *pai_nums;//竞拍次数
@property (nonatomic, copy) NSString *pai_time;//竞拍时长（小时）
@property (nonatomic, copy) NSString *pai_yanshi; //每次竞拍延时（分钟）
@property (nonatomic, copy) NSString *now_yanshi; //已延时(次)
@property (nonatomic, copy) NSString *place;//约会地点[虚拟]
@property (nonatomic, copy) NSString *podcast_id;//主播id
@property (nonatomic, copy) NSString *podcast_name; //主播name
@property (nonatomic, copy) NSString *qp_diamonds; //起拍价
@property (nonatomic, copy) NSString *status;//0竞拍中 1竞拍成功 2流拍
@property (nonatomic, copy) NSString *tags; //竞拍的类型
@property (nonatomic, copy) NSString *user_id;//拍到的人的id
@property (nonatomic, copy) NSString *user_name;//拍到的人的名称
@property (nonatomic, copy) NSString *pai_left_time;//竞拍剩余时间(秒)
@property (nonatomic, strong) NSMutableDictionary *imgs;//图片列表


@end
