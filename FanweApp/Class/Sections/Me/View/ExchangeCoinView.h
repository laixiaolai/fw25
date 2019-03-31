//
//  ExchangeCoinView.h
//  FanweApp
//
//  Created by yy on 17/2/16.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FreshAcountModel.h"
@class ExchangeCoinView;
@protocol ExchangeCoinViewDelegate <NSObject>

@optional
- (void)exchangeViewDownWithExchangeCoinView:(ExchangeCoinView *)exchangeCoinView;

- (void)comfirmClickWithExchangeCoinView:(ExchangeCoinView *)exchangeCoinView;

@end

@interface ExchangeCoinView : FWBaseView<UITextFieldDelegate>
{
    NetHttpsManager *_httpManager;
    GlobalVariables *_fanweApp;
    NSString        *ratio;             //兑换比例
    NSInteger       _rat;
}

@property (nonatomic, weak) id<ExchangeCoinViewDelegate>delegate;

@property (weak, nonatomic) IBOutlet UIView         *displayView;
@property (weak, nonatomic) IBOutlet UILabel        *exchangeTitle;
@property (weak, nonatomic) IBOutlet UILabel        *diamondLabel;          
@property (weak, nonatomic) IBOutlet UILabel        *scaleLabel;            //比例
@property (weak, nonatomic) IBOutlet UITextField    *diamondLeftTextfield;
@property (weak, nonatomic) IBOutlet UIView         *titleBgView;
@property (weak, nonatomic) IBOutlet UIButton       *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton       *confirmButton;
@property (weak, nonatomic) IBOutlet UIView         *textfieldBgView;
@property (weak, nonatomic) IBOutlet UILabel        *coinLabel;             //余额
@property (weak, nonatomic) IBOutlet UILabel        *horizonLine;           //横线
@property (weak, nonatomic) IBOutlet UILabel        *verticalLine;          //竖线
@property (nonatomic, copy) NSString                *ticket;
@property (nonatomic, assign) NSInteger             exchangeType;           //1.兑换游戏币 2.兑换钻石 3.赠送游戏币

+ (instancetype)EditNibFromXib;

- (void)createSomething;

//获取兑换游戏币比例
- (void)obtainCoinProportion;

//获取兑换钻石比例
- (void)requetRatio;

@end
