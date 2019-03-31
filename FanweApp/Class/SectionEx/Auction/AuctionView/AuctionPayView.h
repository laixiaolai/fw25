//
//  AuctionPayView.h
//  FanweApp
//
//  Created by 王珂 on 16/10/26.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"

@protocol AuctionPayViewDelegate<NSObject>

- (void)clickRechargeAction;
- (void)clickToPay;
- (void)cancelPay;

@end

@interface AuctionPayView : UIView

@property (nonatomic, strong) UILabel * timeLabel; //倒计时
@property (nonatomic, weak) id<AuctionPayViewDelegate>delegate;

- (void)setDiamondsText:(NSString *)txt;
- (void)creatWith:(UserModel *)model withCurrentDiamonds:(NSInteger )currentDiamonds withPrice:(NSString *)priceStr;

@end
