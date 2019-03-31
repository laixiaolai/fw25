//
//  FWBaseChatController.h
//  FanweApp
//
//  Created by 朱庆彬 on 2017/8/18.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "ChatBarTextView.h"
#import "ChatBottomBarView.h"
#import "ConversationModel.h"
#import <UIKit/UIKit.h>

#define MorePanH 234

@protocol FWChatVCDelegate <NSObject>
@optional
- (void)faceAndMoreKeyboardBtnClickWith:(BOOL)isFace isNotHaveBothKeyboard:(BOOL)isHave keyBoardHeight:(CGFloat)height;

@end

@interface FWBaseChatController : FWBaseViewController
{
    UITextField *_coinTextField;
}
@property (assign, nonatomic) id<FWChatVCDelegate> delegate;
@property (weak, nonatomic) UIView *mtopview;
@property (weak, nonatomic) UITableView *mtableview;
@property (nonatomic, weak) ChatBottomBarView *chatBar;
@property (nonatomic, assign) BOOL mbhalf;                  //只有一半的情况
@property (nonatomic, assign) BOOL haveLiveExist;           //当前有直播。关闭键盘中的相机
@property (nonatomic, strong) NSMutableArray *userMsgArray; //用于保存最新消息
@property (nonatomic, strong) NSDictionary *dic;            //用于保存对方id和头像
@property (strong, nonatomic) UIButton *maskBtn;
@property (nonatomic, strong) NSString *userID;

//下面的东西用于继承者用...
//消息数据
#pragma mark 注意消息顺序
//整个代码 所有消息顺序都是 按照时间排序 0---> 9
//这玩意一般不要去动,,,,
@property (nonatomic, strong) NSMutableArray *mmsgdata;
//顶部的显示
@property (strong, nonatomic) UILabel *mtoptitle;
//不要一进入界面就自动加载
@property (nonatomic, assign) BOOL mDontAutoLoadFrist; //默认 NO ,就是要加载的意思
//加载之前的消息
- (void)headerStartRefresh;

//加载之后的消息
- (void)footerStartRefresh;

- (void)clickedtophead:(UIButton *)sender;

#pragma mark 继承主要看这里开始

@property (nonatomic, strong) UIView *mGiftView; //234的高度

@property (nonatomic, assign) BOOL mCannotLoadHistoryMsg; //不能加载历史消息,就没有顶部的刷新,
@property (nonatomic, assign) BOOL mCannotLoadNewestMsg;  //不能加载最新消息,就是没有底部的刷新,

//获取 msg 之前的消息,,,子类实现
- (void)getMsgBefor:(ConversationModel *)msg block:(void (^)(NSArray *all))block;

//获取 msg 之后的消息,,子类实现
- (void)getMsgAfter:(ConversationModel *)msg block:(void (^)(NSArray *all))block;

//这几个 will 函数,自己实现了,,发送消息 ..异步发送开始就 addOneMsg ,,,然后 异步发送动作完成就 didSendThisMsg 调用这个

//将要发送一个文字了,,,,..子类实现了
- (void)willSendThisText:(NSString *)txt;

//将要发送图片 ,,,,..子类实现了
- (void)willSendThisImg:(UIImage *)img;

//将要发送一个语音...,,
- (void)willSendThisVoice:(NSURL *)voicepath duration:(NSTimeInterval)duration;

//发送完成,,当异步发送完成之后,调用该函数
- (void)didSendThisMsg:(ConversationModel *)msg;

//重新发送
- (void)willReSendThisMsg:(ConversationModel *)msg;

//添加条消息到后面
- (void)addOneMsg:(ConversationModel *)sendMsg;

//删除一条消息
- (void)delOneMsg:(ConversationModel *)delMsg;

//更新一条消息
- (void)updateOneMsg:(ConversationModel *)updMsg;

//想要填充消息数据,比如,语音下载,图片下载,这种需要子类自己管理下载数据的问题
//如果不实现 会自动调用 [msg fetchMsgData],,,子类如果继承了 ZWMsgObj 也可以实现 ZWMsgObj fetchMsgData,,
- (void)wantFetchMsg:(ConversationModel *)msg block:(void (^)(NSString *errmsg, ConversationModel *msg))block;

//失败按钮点击了
- (void)failedIconTouched:(NSIndexPath *)indexPath iconhiden:(BOOL)iconhiden;

//消息点击了
- (void)msgClicked:(ConversationModel *)msgobj;

//赠送金币
- (void)sendCoin;

- (void)sendDiamonds;

- (void)clickedfacemore:(BOOL)bface;

#pragma mark 继承主要看这里结束

@end
