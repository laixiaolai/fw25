//
//  AppUrlModel.h
//  FanweApp
//
//  Created by xfg on 16/8/23.
//  Copyright © 2016年 xfg. All rights reserved.
//  h5地址

#import <Foundation/Foundation.h>

@interface AppUrlModel : NSObject

@property (nonatomic ,strong) NSString *url_my_grades;          // 我的等级
@property (nonatomic ,strong) NSString *url_about_we;           // 帮助与反馈
@property (nonatomic ,strong) NSString *url_help_feedback;      // 关于我们
@property (nonatomic ,strong) NSString *url_auction_record;     // 竞拍记录
@property (nonatomic ,strong) NSString *url_user_pai;           // 我的竞拍
@property (nonatomic ,strong) NSString *url_user_order;         // 我的订单
@property (nonatomic ,strong) NSString *url_podcast_order;      // 星店订单
@property (nonatomic ,strong) NSString *url_podcast_pai;        // 竞拍管理
@property (nonatomic ,strong) NSString *url_podcast_goods;      // 商品管理
@property (nonatomic ,strong) NSString *url_auction_agreement;  // 竞拍页面充值页面的协议
@property (nonatomic ,strong) NSString *url_shopping_cart;      // 购物车

@end
