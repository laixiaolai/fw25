//
//  PersonCenterModel.h
//  FanweApp
//
//  Created by 丁凯 on 2017/7/20.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "FWBaseModel.h"
#import "PersonCenterUserModel.h"
#import "PersonCenterListModel.h"
#import "userPageModel.h"

@class userPageModel,MPCHeadView;

@interface PersonCenterModel : FWBaseModel<ExchangeCoinViewDelegate>

@property(nonatomic,assign) int     is_admin;                   //是否是管理员 0 表示是其他会员 1表示是本人
@property(nonatomic,assign) int     is_edit_weixin;             //是否显示编辑微信 0 表示显示加我微信 1表示编辑微信 2表示隐藏
@property(nonatomic,assign) int     is_show_focus;              //是否显示 关注按钮 0 表示隐藏 1表示显示
@property(nonatomic,assign) int     is_focus;                   //是否关注按钮 0表示未关注 1表示已关注
@property(nonatomic,assign) int     is_show_money;              //是否显示总收入 和 今日收入
@property(nonatomic,assign) int     is_show_talk;               //是否显示聊聊 按钮
@property(nonatomic,assign) int     is_show_ds;                 //是否显示打赏按钮
@property(nonatomic,assign) int     has_next;                   //是否还有下一页
@property(nonatomic,assign) int     page;                       //页数

@property(nonatomic,assign) int     is_reply_but;               //是否可以评论动态
@property(nonatomic,assign) int     is_reply_comment_but;       //是否可以回复评论
@property(nonatomic,assign) int     is_show_weibo_report;       //是否显示举报动态
@property(nonatomic,assign) int     is_show_user_report;        //是否显示举报用户
@property(nonatomic,assign) int     is_show_user_black;         //是否显示拉黑用户
@property(nonatomic,assign) int     is_show_top;                //是否显示置顶
@property(nonatomic,assign) int     is_show_deal_weibo;         //是否显示删除动态
@property(nonatomic,assign) int     user_id;                    //观看的会员ID，未登陆则为0


@property(nonatomic,strong) PersonCenterUserModel  *user;       //用户信息模型1
@property(nonatomic,strong) PersonCenterListModel  *info;       //用户信息模型2



@property (nonatomic,strong)GlobalVariables    *fanweApp;
@property (nonatomic,strong)userPageModel      *userModel;

/*
 兑换游戏币
 */
@property ( nonatomic,strong) ExchangeCoinView       *exchangeView;
@property ( nonatomic,strong) UIWindow               *bgWindow;
@property ( nonatomic,strong) UIView                 *exchangeBgView;
@property ( nonatomic,strong) UIViewController       *myVC;

/*
 家族相关
 */
@property (nonatomic, strong) UIView     *backgroundView;    //大的背景遮罩
@property (nonatomic, strong) UIView     *backView;          //小的背景遮罩
@property (nonatomic, strong) UIView     *bigView;           //背景图
@property (nonatomic, strong) UIButton   *addFamilyBtn;      //加入家族按钮
@property (nonatomic, strong) UIButton   *createBtn;         //创建家族按钮
@property (nonatomic, strong) UIButton   *bigButton;

/*
 公会相关
 */
@property (nonatomic, strong) UIView      *backgroundViewTwo;      //大的背景遮罩
@property (nonatomic, strong) UIView      *backViewTwo;            //小的背景遮罩
@property (nonatomic, strong) UIView      *bigViewTwo;             //背景图
@property (nonatomic, strong) UIButton    *addSocietyBtn;          //加入公会按钮
@property (nonatomic, strong) UIButton    *createSocietyBtn;       //创建家族按钮
@property (nonatomic, strong) UIButton    *bigBtn;

//MPersonCenterVC 的UI处理
- (void)creatUIWithModel:(userPageModel *)userModel andMArr:(NSMutableArray *)detailArray andMyView:(UIView *)myView;
-(void)didSelectWithModel:(userPageModel *)userModel andSection:(int)section;

//兑换游戏币
- (void)createExchangeCoinViewWithVC:(UIViewController *)myVC;
- (void)exchangeGaomeCoinsWithModel:(userPageModel *)userModel;

//我的家族
- (void)createFamilyViewWithVC:(UIViewController *)myVC andModel:(userPageModel *)userModel;
- (void)goToFamilyDesVCWithModel:(userPageModel *)userModel;

//我的公会
- (void)createSocietyViewWithVC:(UIViewController *)myVC andModel:(userPageModel *)userModel;
- (void)goToSocietyDesVCWithModel:(userPageModel *)userModel;
- (void)clickCreateSocietyBtn;

//IM消息数量的通知
- (void)loadBadageDataWithView:(MPCHeadView *)headV;


/**
 返回tableView的高度

 @param myUserModel 模型
 @param myFanweApp 全局变量
 @param type 类型 1代表row或者section的高度 2代表row或者section头部的高度
 @return 高度
 */
- (CGFloat)getMyHeightWithModel:(userPageModel *)myUserModel andFanweApp:(GlobalVariables *)myFanweApp andSection:(int)section andType:(int)type;


@end
