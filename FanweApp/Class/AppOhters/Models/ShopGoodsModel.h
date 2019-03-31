//
//  ShopGoodsModel.h
//  UIAuctionShop
//
//  Created by 王珂 on 16/9/18.
//  Copyright © 2016年 qhy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopGoodsModel : NSObject

@property (nonatomic, copy)  NSString   * goodsId;      // 商品id
@property (nonatomic, copy)  NSString   * name;         // 商品名称
@property (nonatomic, strong) NSArray   * imgs;         // 商品图片地址
@property (nonatomic, copy)  NSString   * price;        // 商品价格
@property (nonatomic, copy)  NSString   * url;          // 商品详情url地址
@property (nonatomic, copy)  NSString   * descStr;      // 商品详情
@property (nonatomic, copy)  NSString   * kd_cost;      // 商品运费
@property (nonatomic, assign) BOOL      showDes;
@property (nonatomic, assign) int       type;           // 如果是主播type为0，观众为1，无商品为2；


@end
