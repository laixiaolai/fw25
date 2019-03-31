//
//  ShopGoodsModel.m
//  UIAuctionShop
//
//  Created by 王珂 on 16/9/18.
//  Copyright © 2016年 qhy. All rights reserved.
//

#import "ShopGoodsModel.h"

@implementation ShopGoodsModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"goodsId" : @"id",
             @"descStr": @"description"
             };
}

@end
