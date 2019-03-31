//
//  FWLivePayManager.h
//  FanweApp
//
//  Created by 丁凯 on 2017/8/16.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LivePayLeftPromptV.h"

@protocol livePayDelegate <NSObject>

//付费直播是否加载直播间视频的代理
- (void)livePayLoadVedioIsComfirm:(BOOL)isComfirm;

@end

@interface FWLivePayManager : NSObject

@property (nonatomic, strong) NetHttpsManager          *httpsManager;                      //网络请求
@property (nonatomic, strong) GlobalVariables          *fanweApp;                          //本地全局单例
@property (nonatomic, strong) TCShowLiveView           *subLiving;                         //直播间传下来的living
@property (nonatomic, strong) LivePayLeftPromptV       *hostLeftPView;                     //主播左边信息的view
@property (nonatomic, strong) LivePayLeftPromptV       *audienceLeftPView;                 //观众左边信息的view
@property (nonatomic, strong) UIView                   *shadowView;                        //直播需要收费，却没有没有钻石的覆盖的view
@property (nonatomic, strong) NSTimer                  *hostPayLiveTime;                   //主播付费倒计时
@property (nonatomic, strong) NSTimer                  *payLiveTime;                       //付费模式下的定时器
@property (nonatomic, strong) NSTimer                  *countDownTime;                     //倒计时的定时器
@property (nonatomic, strong) NSDictionary             *hostDict;                          //存储观众点击确认付费的字典
@property (nonatomic, strong) NSDictionary             *audienceDict;                      //主播存储的字典
@property (nonatomic, strong) UIButton                 *closeButton;                       //关闭直播间的按钮
@property (nonatomic, strong) UIViewController         *livController;                     //直播间的view

@property (nonatomic, assign) NSInteger                roomId;                             //直播间房间id
@property (nonatomic, assign) NSInteger                live_fee;                           //付费直播 收费多少 （在付费模式下有效）
@property (nonatomic, assign) NSInteger                live_pay_type;                      //收费类型 0按时收费，1按场次收费
@property (nonatomic, assign) NSInteger                count_down;                         //倒计时（秒）
@property (nonatomic, assign) NSInteger                timeCount;                          //定时器的count
@property (nonatomic, assign) NSInteger                hostTimeCount;                      //主播定时器的count
@property (nonatomic, assign) NSInteger                downTimeType;                       //收费倒计时的类型1IM倒计时2为get_Video接口的倒计时
@property (nonatomic, assign) NSInteger                is_mentionType;                     //提档参数 1提档，0不提档
@property (nonatomic, assign) NSInteger                liveType;                           //(等于40是按场次付费)
@property (nonatomic, assign) NSInteger                buttomFunctionType;                 //直播类型（等于40是按场次付费）
@property (nonatomic, assign) BOOL                     isEnterPayLive;                     //判断观众是否在付费直播 1是 0不是
@property (nonatomic, assign) BOOL                     is_agree;                           //是否同意收费 1为yes 0 为no
@property (nonatomic, copy) void (^block)              (NSString *string);                 //string 1代表跳转到充值页面 2代表退出直播间
@property (nonatomic, strong) MMAlertView              *myAlertView1;                      //观众进入直播间确定的弹窗提示
@property (nonatomic, strong) MMAlertView              *myAlertView2;                      //观众在付费直播间钱不够5分钟的弹窗提示
@property (nonatomic, strong) MMAlertView              *myAlertView3;                      //观众在付费直播间钱不够的弹窗提示
@property (nonatomic, weak) id<livePayDelegate>        payDelegate;                        //付费直播的代理加载视频等操作 MMAlertView


#pragma mark ===================================================主播开放方法===========================================================
/*
 1.liveView   直播间传下来的TCShowLiveView
 2.roomEngine 通过这个可知道当前的roomId，从房间传下来的
 3.dict       主播心跳或者观众get_video返回获取的字典
 4.payType    收费类型
 */
- (id)initWithLiveView:(TCShowLiveView *)liveView andRoomId:(int)roomId andhostDict:(NSDictionary *)hostDict andpayType:(NSInteger)payType;
//主播心跳接口之后走的方法
- (void)creatViewWithDict:(NSDictionary *)dict;
//提档或者切换付费按钮后的结果 count=1按时付费 count=2提档 count=3按场付费
- (void)creatPriceViewWithCount:(int)count;
//主播由于某些原因突然退出直播间，再次进入直播间还有原来的付费直播的情况
- (void)hostEnterLiveAgainWithMDict:(NSDictionary *)responseJson;

#pragma mark ====================================================观众开放方法===========================================================
/*
 1.controller 直播间的控制器
 2.liveView   直播间传下来的TCShowLiveView
 3.roomEngine 通过这个可知道当前的roomId，从房间传下来的
 4.dict       主播心跳或者观众get_video返回获取的字典
 5.closeBtn   直播间的关闭button
 */
- (id)initWithController:(UIViewController *)controller andLiveView:(TCShowLiveView *)liveView andRoomId:(int)roomId andAudienceDict:(NSDictionary *)audienceDict andButton:(UIButton *)closeBtn;
//IM推送消息后观众之后走的方法
- (void)AudienceGetVedioViewWithType:(int)typeTag;
//按场付费直播观众在主播开启付费之后进入直播间变灰
- (void)AudienceBecomeshadowView;
//进入收费直播间
- (void)enterMoneyMode;
//观众进入直播间只听声音不看画面要覆盖一层view
- (void)creatShadowView;


#pragma mark ================================================主播和观众共用开放方法=======================================================
//改变左边提示的frame  isHost是否是主播 imgView 竞拍最高价的view  bankerView游戏的view
- (void)changeLeftViewFrameWithIsHost:(BOOL)isHost andAuctionView:(UIView *)auctionView andBankerView:(UIView *)bankerView;
@end
