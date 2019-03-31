//
//  GiftView.h
//  FanweApp
//
//  Created by xfg on 16/5/20.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GiftModel.h"
#import "UICountingLabel.h"

@class GiftView;
@protocol GiftViewDelegate <NSObject>
@required

/**
 显示充值

 @param giftView self
 */
- (void)showRechargeView:(GiftView *)giftView;

/**
 发送礼物

 @param giftView self
 @param giftModel 礼物Model
 */
- (void)senGift:(GiftView *)giftView AndGiftModel:(GiftModel *)giftModel;

@end

@interface GiftView : FWBaseView

@property (nonatomic, weak) id<GiftViewDelegate>delegate;
@property (nonatomic, strong) UIView            *continueContainerView; //连发按钮容器视图
@property (nonatomic, strong) UIButton          *sendBtn;               //发送按钮
@property (nonatomic, strong) UICountingLabel   *decTimeCLabel;         //连发倒计时
@property (nonatomic, assign) NSInteger         selectedGiftTime;       //连发时，下一次点击时先判断上一次连发剩余的倒计时

- (void)setDiamondsLabelTxt:(NSString *)txt;
- (void)setGiftView:(NSMutableArray *)giftMArray;

@end
