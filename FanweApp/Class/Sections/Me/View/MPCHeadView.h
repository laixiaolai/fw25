//
//  MPCHeadView.h
//  FanweApp
//
//  Created by 丁凯 on 2017/8/24.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
@class userPageModel;

@interface MPCHeadView : FWBaseView

@property ( nonatomic,strong) UIImageView          *clearImgView;               //底部透明图
@property ( nonatomic,strong) UIView               *clearView;                  //名字的view
@property ( nonatomic,strong) UIButton             *backButton;                 //后退透明的button
@property ( nonatomic,strong) UILabel              *outLabel;                   //送出
@property ( nonatomic,strong) UIButton             *messageBtn;                 //消息或者直播中
@property ( nonatomic,strong) UIImageView          *headImgView;                //头像imgview
@property ( nonatomic,strong) UIButton             *headImgBtn;                 //头像
@property ( nonatomic,strong) UIImageView          *vImgView;                   //认证图标
@property ( nonatomic,strong) UIView               *nameView;                   //名字的view
@property ( nonatomic,strong) UILabel              *nameLabel;                  //名字
@property ( nonatomic,strong) UIImageView           *vipImgView;                //编辑的点击事件
@property ( nonatomic,strong) UIImageView          *sexImgView;                 //性别
@property ( nonatomic,strong) UIImageView          *rankImgView;                //等级
@property ( nonatomic,strong) UIButton             *editBtn;                    //编辑
@property ( nonatomic,strong) UILabel              *signatureLabel;             //签名
@property ( nonatomic,strong) UILabel              *accountLabel;               //账号label
@property ( nonatomic,strong) UIView               *certificateView;            //认证的的view
@property ( nonatomic,strong) UIImageView          *certificateImgView;         //认证的图
@property ( nonatomic,strong) UILabel              *certificateLabel;           //认证

@property ( nonatomic,strong) UIView               *itemView;                   //送出 关注 粉丝或者直播 小视频 关注 粉丝
@property ( nonatomic,strong) UIView               *bottomView;                 //底部view
@property ( nonatomic,strong) JSBadgeView          *badge;                      //消息角标

@property ( nonatomic,copy) void             (^headViewBlock) (int btnIndex);

/**
 个人中心或者他人主页的头部view

 @param frame frame
 @param headType 类型 1代表我的主页 2代表其他人的主页
 @return self
 */
- (instancetype)initWithFrame:(CGRect)frame andHeadType:(int)headType;

//SHomePageVC控制器初始化
- (void)setViewWithModel:(UserModel *)model withUserId:(NSString *)userId;
- (void)setUIWithDict:(NSDictionary *)dict;

//MPersonCenterVC控制器
- (void)setCellWithModel:(userPageModel *)userInfoM;

@end
