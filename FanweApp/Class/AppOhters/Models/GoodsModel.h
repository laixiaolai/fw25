//
//  GoodsModel.h
//  FanweApp
//
//  Created by 王珂 on 16/9/18.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsModel : NSObject
@property (nonatomic, copy)  NSString * name;           //商品名称
@property (nonatomic, copy)  NSString * imgs;           //商品图片
@property (nonatomic, copy)  NSString * price;          //价格
@property (nonatomic, copy)  NSString * url;            //商品详细
@property (nonatomic, copy)  NSString * descStr;        //描述
@property (nonatomic, copy)  NSString * kd_cost;        //运费

@property (nonatomic, copy)  NSString * goods_id;       //商品ID
//商品购买成功推送的字段
@property (nonatomic, copy)  NSString * goods_logo;     //图片
@property (nonatomic, copy)  NSString * quantity;       //数量
@property (nonatomic, copy)  NSString * goods_name;     //名称
@property (nonatomic, assign) NSInteger  type;          //为1表示小店推送，0表示星店商品推送

@end
