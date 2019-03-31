//
//  AuctionResultView.h
//  FanweApp
//
//  Created by 王珂 on 16/10/26.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AuctionResultViewDelegate<NSObject>

- (void)toPay;

@end

@interface AuctionResultView : UIView

@property (nonatomic, weak) id<AuctionResultViewDelegate>delegate;

- (void)createWithType:(NSInteger )type andResult:(NSString *)result andName:(NSString *) name andPrice:(NSString *)price;
//type在竞拍成功和付款成功中区分是否为竞拍中拍人，0为不是中拍人,1为中拍人，竞拍未流拍时超时未支付的type为2，竞拍流拍时type为0和1，0为无人参拍，1为中拍者超时未付款
//result为结果,结果分为中拍，竞拍失败，付款成功

@end
