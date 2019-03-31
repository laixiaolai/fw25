//
//  ShopListModel.h
//  FanweApp
//
//  Created by yy on 16/9/21.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopListModel : NSObject

@property (nonatomic, strong) NSMutableArray              * imgs;             //商品图片地址
@property (nonatomic, copy)  NSString              * name;             //商品名称
@property (nonatomic, copy)  NSString              * price;            //商品价格
@property (nonatomic, copy)  NSString              * url;              //商品详情url地址
@property (nonatomic, copy)  NSString              * ID;               //商品id
@property (nonatomic, copy)  NSString              * descrStr;         //描述
@property (nonatomic, copy)  NSString              * kd_cost;          //运费
@property (nonatomic, assign) BOOL                showDes;          //是否显示商品详情

@end
