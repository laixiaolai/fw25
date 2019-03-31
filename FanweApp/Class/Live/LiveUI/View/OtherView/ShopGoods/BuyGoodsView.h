//
//  BuyGoodsView.h
//  FanweApp
//
//  Created by 王珂 on 16/10/28.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomMessageModel.h"

@interface BuyGoodsView : UIView

@property (nonatomic, strong) UILabel * giveLabel; //送给主播
@property (nonatomic, strong) UILabel * addExpLabel;//增加的商品经验

- (void)addDataWithDesMoel:(CustomMessageModel *)model andIsHost:(BOOL )isHost;

@end
