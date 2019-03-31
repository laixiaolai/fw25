//
//  CustomMessageModel.h
//  FanweApp
//
//  Created by xfg on 16/5/27.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SenderModel.h"
#import "AnimateConfigModel.h"
#import "cuserModel.h"
#import "GoodsModel.h"
#import "MLEmojiLabel.h"
#import "GameDataModel.h"
#import "GameBankerModel.h"

@class CustomMessageModel;

@protocol CustomMessageModelDelegate <NSObject>
@optional

- (void)redPackageDisappear:(CustomMessageModel *)customMessageModel;

@end

@interface CustomMessageModel : NSObject<AVIMMsgAble>

@property (nonatomic, weak) id<CustomMessageModelDelegate> delegate;

/*
 *  //0:普通消息;1:礼物;2:弹幕消息;3:主播退出;4:禁言;5:观众进入房间；6：观众退出房间；7:直播结束；8：红包；9：直播消息；10：主播离开；11：主播回来；12：点亮；13：申请连麦；14：接收连麦；15：拒绝连麦；16：断开连麦；。。。
 */
@property (nonatomic, assign) int               type;
@property (nonatomic, assign) int               data_type;          // 结合type来使用

@property (nonatomic, assign) CGSize            avimMsgShowSize;    // 显示高度

// ==============直播================

// 普通文字消息
@property (nonatomic, copy) NSString            *text;              // 发送的消息

// 礼物相关
@property (nonatomic, assign) int               num;                // 数量
@property (nonatomic, assign) int               is_plus;            // 收到礼物时是否需要叠加
@property (nonatomic, assign) int               is_much;            // 这个礼物是否可以连发
@property (nonatomic, copy) NSString            *prop_id;           // 礼物ID
@property (nonatomic, copy) NSString            *animated_url;      // 礼物动画url
@property (nonatomic, copy) NSString            *icon;              // 礼物图标
@property (nonatomic, copy) NSString            *user_prop_id;      // 红包时用到，抢红包的id
@property (nonatomic, copy) NSString            *to_user_id;        // 礼物接收人（主播）
@property (nonatomic, copy) NSString            *fonts_color;       // 字体颜色
@property (nonatomic, copy) NSString            *desc;              // 普通群员收到的提示内容
@property (nonatomic, copy) NSString            *desc2;             // 礼物接收人（主播）收到的提示内容
@property (nonatomic, assign) NSInteger         total_ticket;       // 印票总数
@property (nonatomic, assign) NSInteger         is_animated;        // 0：无动画 1：gif动画  2：真实动画
@property (nonatomic, strong) NSMutableArray    *anim_cfg;          // 动画配置  cuserModel
@property (nonatomic, strong) NSDictionary      *data;              // 观众列表

// 礼物自定义参数
@property (nonatomic, assign) BOOL              isTaked;            // 是否被播放过了
@property (nonatomic, assign) int               showNum;            // 需要展示的数字
@property (nonatomic, strong) UIImage           *iconImage;         // 消息列表中的单项消息后面跟着的礼物图标
@property (nonatomic, copy) NSString            *anim_type;         // 礼物真实动画的类型
@property (nonatomic, copy) NSString            *top_title;         // 送礼物的描述

// 点亮
@property (nonatomic, copy) NSString            *imageName;         // 星星名字
@property (nonatomic, assign) BOOL              isShowLightMessage; // 是否显示点亮了
@property (nonatomic, assign) NSInteger         showMsg;            // 1：显示在消息列表中 0：不显示

// 红包自定义参数
@property (nonatomic, assign) BOOL              isRedPackageTaked;  // 红包是否被打开过了
@property (nonatomic, copy) NSString *          redPackageTip;      // 红包的提示语

@property (nonatomic, copy) NSString            *chatGroupID;       // 聊天组ID

// 消息发送者的信息
@property (nonatomic, strong) SenderModel       *sender;
@property (nonatomic, strong) cuserModel        *user;
@property (nonatomic, copy) NSString            *user_id;           // 用户ID
@property (nonatomic, copy) NSString            *nick_name;         // 昵称
@property (nonatomic, copy) NSString            *head_image;        // 头像
@property (nonatomic, copy) NSString            *sex;               // 性别
@property (nonatomic, assign) NSInteger         diamonds;           // 砖石数量

// 连麦
@property (nonatomic, copy) NSString            *push_rtmp2;        // 腾讯云直播的小主播的 push_rtmp 推流地址(由大主播传给小主播)
@property (nonatomic, copy) NSString            *play_rtmp_acc;     // 腾讯云直播的大主播的 rtmp_acc 播放地址(由大主播传给小主播)
@property (nonatomic, copy) NSString            *play_rtmp2_acc;    // 腾讯云直播的小主播的 rtmp_acc 播放地址(大主播拉流)

// ==============竞拍相关================
// 观众结束页面
@property (nonatomic, copy) NSString            *show_num;          // 主播主动退出直播，观众结束页面显示的观看人数

// 竞拍结束页面
@property (nonatomic, strong) NSArray           *buyer;

// 主播发起竞拍推送
@property (nonatomic, copy) NSString            *pai_id;            // 拍卖的项目ID
@property (nonatomic, copy) NSString            *podcast_id;        // 直播ID
@property (nonatomic, copy) NSString            *goods_id;          // 商品ID，虚拟为0
@property (nonatomic, copy) NSString            *bz_diamonds;       // 竞拍保证金
@property (nonatomic, copy) NSString            *qp_diamonds;       // 起拍价
@property (nonatomic, copy) NSString            *jj_diamonds;       // 每次加价

// 出价推送
@property (nonatomic, copy) NSString            *pai_sort;          // 出价次数
@property (nonatomic, copy) NSString            *pai_diamonds;      // 出价金额
@property (nonatomic, copy) NSString            *pai_left_time;     // 竞拍剩余时间
@property (nonatomic, copy) NSString            *yanshi;            // 本次出价是否触发延时算法 ，1表示触发
// 流拍类型
@property (nonatomic, copy) NSString            *out_type;

// 直播商品信息
@property (nonatomic, strong) GoodsModel        *goods;             // 商品model
@property (nonatomic, copy) NSString            *is_self;           // 是否买给自己，0表示送主播、1表示送自己
@property (nonatomic, copy) NSString            *score;             // 经验

// ==============游戏相关推送================
// 游戏公用部分
@property (nonatomic, copy) NSString            *time;              // 剩余时间
@property (nonatomic, copy) NSString            *game_id;           // 游戏id（种类）
@property (nonatomic, copy) NSString            *game_status;       // 游戏状态，1：游戏开始，2：游戏结束

// 游戏下注推送
@property (nonatomic, strong) GameDataModel     *game_data;         // 游戏数据(投注状态)

// 游戏开始推送
@property (nonatomic, copy) NSString            *game_log_id;       // 游戏id（轮数）
@property (nonatomic, strong) NSArray           *option;            // 投注选项
@property (nonatomic, strong) NSArray           *bet_option;        // 投注金额选项

// 主播游戏收益推送
@property (nonatomic, copy) NSString            *podcast_income;    // 主播单轮收益

// 游戏操作，不同游戏略有不同：开始：start；下注：bet；停止：stop；结算：open；翻拍：flop；
// 游戏操作，不同游戏略有不同：【开始：1；下注：2；停止：3；结算：4；翻牌：5】；（用于推送）
@property (nonatomic, copy) NSString            *game_action;       // 主播单轮收益
@property (nonatomic, strong) GameBankerModel   *banker;            // 玩家上庄数据
@property (nonatomic, strong) NSArray           *banker_list;
@property (nonatomic, copy) NSString            *banker_status;     // 上庄状态
@property (nonatomic, copy) NSString            *action;            // 上庄模块推送操作号，1：开启上庄，2：申请上庄，3：选择庄家，4：下庄
@property (nonatomic, copy) NSString            *room_id;           // 房间号
@property (nonatomic, copy) NSString            *timestamp;         // 游戏推送时间戳
@property (nonatomic, assign) NSInteger         auto_start;    //0手动发牌，1自动发牌

// ==============私聊================
@property (nonatomic, copy) NSString            *msg;               // 消息


// ==============方法================
// 红包何时消失的定时器
- (void)startRedPackageTimer;
- (void)stopRedPackageTimer;
- (BOOL)isEquals:(CustomMessageModel *)customMessageModel;

@end
