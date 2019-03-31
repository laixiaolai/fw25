//
//  ShopGoodsView.h
//  FanweApp
//
//  Created by 王珂 on 16/10/31.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsModel.h"

@protocol ShopGoodsDelegate<NSObject>

- (void)toGoods;

@end

@interface ShopGoodsView : UIView

@property (nonatomic, strong) GoodsModel            *model;
@property (nonatomic, assign) int                   type;//1为观众，0为主播
@property (nonatomic, weak) id<ShopGoodsDelegate>   delegate;

@end
