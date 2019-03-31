//
//  ShopGoodsUIView.h
//  UIAuctionShop
//
//  Created by 王珂 on 16/9/18.
//  Copyright © 2016年 qhy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShopGoodsViewDelegate<NSObject>

- (void)closeShopGoodsViewWithDic:(NSDictionary *)dic andIsOTOShop:(BOOL)isOTOShop;

@end

@interface ShopGoodsUIView : FWBaseView

@property (nonatomic, weak) id<ShopGoodsViewDelegate>   delegate;
@property (nonatomic, assign) int                       type;//如果是主播type为0，观众为1，无商品为2；
@property (nonatomic, copy)  NSString                   *hostID;//主播用户ID
@property (nonatomic, assign) BOOL                      isOTOShop;//是否是OTO的我的小店

- (void)loadDataWithPage:(int)page;

@end
