//
//  AuctionGoodsModel.h
//  FanweApp
//
//  Created by 王珂 on 16/11/3.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AuctionGoodsModel : NSObject
@property (nonatomic, copy)  NSString * goods_id;       //竞拍商品id
@property (nonatomic, copy)  NSString * name;           //竞拍名称
@property (nonatomic, copy)  NSString * bz_diamonds;    //竞拍保证金
@property (nonatomic, copy)  NSString * qp_diamonds;    //起拍价
@property (nonatomic, copy)  NSString * jj_diamonds;    //每次加价
@property (nonatomic, copy)  NSString * pai_time;       //竞拍时长
@property (nonatomic, copy)  NSString * pai_yanshi;     //每次竞拍延时（单位分）
@property (nonatomic, copy)  NSString * max_yanshi;    //最大延时(次)
@property (nonatomic, strong) NSArray * imgs;         //图片列表
@property (nonatomic, copy)  NSString * shop_id;
@property (nonatomic, copy)  NSString * shop_name;

@end
