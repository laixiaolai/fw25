//
//  AuctionTool.h
//  FanweApp
//
//  Created by 王珂 on 16/12/7.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TCShowLiveView.h"
#import "ReleaseViewController.h"
#import "BuyGoodsView.h"
@class AuctionItemdetailsViewController;
@protocol AuctionToolDelegate <NSObject>

- (void)pushVC:(ReleaseViewController *)vc;

- (void)getUserInfo:(UserModel *)userModel;

- (void)closeRoom;

- (void)toGoH5With:(UIViewController *)tmpController andShowSmallWindow:(BOOL)smallWindow;

- (void)changePayView:(TCShowLiveView *)showLiveView;

- (void)rechargeView:(TCShowLiveView *)showLiveView;

- (void)pushAuctionDetailVC:(AuctionItemdetailsViewController *)vc;

@end

@interface AuctionTool : NSObject
{
    __weak id<FWShowLiveRoomAble>   _liveItem;
}
@property (nonatomic, assign) int paiTime;//竞拍倒计时长;
@property (nonatomic, assign) int payTime;//付款倒计时时长;
@property(nonatomic, strong) TCShowLiveView * liveView;
@property(nonatomic, strong) UIView * view;
@property(nonatomic, weak) id<AuctionToolDelegate>delegate;
@property (nonatomic, assign) BOOL hadEnd;//直播是否已经关闭
@property (nonatomic, assign) NSInteger  paiId;//竞拍商品id
@property (nonatomic, assign) int isMyPlay; //1为推流即为主播，2为观看直播的观众，这里没有回播放
@property (nonatomic, strong) BuyGoodsView   * buyGoodsView;//观众购买商品支付成功的视图
@property(nonatomic, strong) NSTimer * goodsTimer;//商品购买成功的定时器
@property(nonatomic, strong) NSMutableArray * bigImageArr; //竞拍排序的视图数组
@property(nonatomic, strong) NSMutableArray * stateLabelArr;//竞拍的观众状态显示数组
@property(nonatomic, strong) UIImageView * addPriceView;//观众加价的锤子下面的视图
@property(nonatomic, strong) UIView * payView;//付款观众的按钮视图

- (id)initWithLiveView:(TCShowLiveView *)liveView andView:(UIView *)view  andTCController:(UIViewController *)tcController andLiveItem:(id<FWShowLiveRoomAble>)liveItem;

- (void)loadTimeData;

- (void)reloadTimeData;

- (void)addView;

- (void)onClickClose;

- (void)closeTimer;

- (void)closeAuctionAboutView;

///拍卖成功调用的方法
- (void)paiSuccessWithCustomModel:(CustomMessageModel *)customMessageModel;

///推送支付提醒调用的方法
- (void)paiTipWithCustomModel:(CustomMessageModel *)customMessageModel;

///流拍调
- (void)paiFaultWithCustomModel:(CustomMessageModel *)customMessageModel;

///加价推送调
- (void)paiAddPriceWithCustomModel:(CustomMessageModel *)customMessageModel;

///付款成功推送
- (void)paySuccessWithCustomModel:(CustomMessageModel *)customMessageModel;

///主播发起竞拍成功
- (void)paiReleaseSuccessWithCustomModel:(CustomMessageModel *)customMessageModel;


#pragma mark ————————————————————————————————购物相关——————————————————————————————————————————————————————————
//点击星店按钮
- (void)clickStarShopWithIsOTOShop:(BOOL )isOTOShop;

//主播推送商品成功
- (void)starGoodsSuccessWithCustomModel:(CustomMessageModel *)customMessageModel;

//观众购物成功
- (void)buyGoodsSuccessWithCustomModel:(CustomMessageModel *)customMessageModel;

@end
