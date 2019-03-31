//
//  OtherChangeView.h
//  FanweApp
//
//  Created by 王珂 on 17/3/15.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RechargeWayView.h"
#import "AccountRechargeModel.h"

@class OtherChangeView;

@protocol OtherChangeViewDelegate <NSObject>

- (void)clickOtherRechergeWithView:(OtherChangeView *)otherView;
- (void)clickExchangeWithView:(OtherChangeView *)otherView;
@end

@interface OtherChangeView : FWBaseView

@property (nonatomic, weak) id<OtherChangeViewDelegate>     delegate;
@property (nonatomic, strong) UIButton                      *rechargeBtn; //充值按钮
@property (nonatomic, strong) UIButton                      *exchangeBtn; //兑换按钮
@property (nonatomic, strong) UIButton                      *closeBtn;    //关闭按钮
@property (nonatomic, strong) UIView                        *lineView;    //充值与兑换之间的分割线
@property (nonatomic, strong) RechargeWayView               *rechargeWayView;
@property (nonatomic, strong) NSArray                       *otherPayArr;
@property (nonatomic, assign) NSInteger                     selectIndex;
@property (nonatomic, strong) AccountRechargeModel          *model;
@property (nonatomic, strong) UILabel                       *rateLabel;//兑换比例
@property (nonatomic, strong) UITextField                   *textField;
@property (nonatomic, strong) UILabel                       *diamondsLabel;
@property (nonatomic, strong) UIButton                      *cancaleBtn; //取消按钮
@property (nonatomic, strong) UIButton                      *makeSureBtn; //确定按钮
@property (nonatomic, strong) UIView                        *separeLineView;
@property (nonatomic, strong) UIView                        *verticalLineView;
@property (nonatomic, strong) UIView                        *selectLineView; //选中的分割线
@property (nonatomic, strong) UIView                        *separateView;

- (instancetype)initWithFrame:(CGRect)frame andUIViewController:(UIViewController *)viewController;
- (void)disChangeText;

@end
