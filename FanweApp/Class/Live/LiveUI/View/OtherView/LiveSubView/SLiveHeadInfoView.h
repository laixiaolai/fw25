//
//  SLiveHeadInfoView.h
//  FanweApp
//
//  Created by 丁凯 on 2017/7/10.
//  Copyright © 2017年 xfg. All rights reserved.

#import "FWBaseView.h"

@class SLiveHeadInfoView;

@protocol SLiveHeadInfoViewDelegate <NSObject>

//viewType 1删除view  2个人主页  3管理列表  4@某个用户(回复)  5显示举报   6进入IM消息
- (void)operationHeadView:(SLiveHeadInfoView *)headView andUserId:(NSString *)userId andNameStr:(NSString *)nameStr andUserImgUrl:(NSString *)userImgUrl andIs_robot:(BOOL)is_robot andViewType:(int)viewType;

@end

@interface SLiveHeadInfoView : FWBaseView<UIActionSheetDelegate,UIGestureRecognizerDelegate>

@property (weak, nonatomic) id<SLiveHeadInfoViewDelegate> infoDelegate;
@property (weak, nonatomic) IBOutlet UIView            *bigBottomView;               //底部view
@property (weak, nonatomic) IBOutlet UIButton          *reportBtn;                   //举报
@property (weak, nonatomic) IBOutlet UIButton          *deleteBtn;                   //x
@property (weak, nonatomic) IBOutlet UIButton          *imgViewBtn;                  //大的头像都点击事件
@property (weak, nonatomic) IBOutlet UIButton          *followBtn;                   //关注
@property (weak, nonatomic) IBOutlet UIButton          *privateLetterBtn;            //私信
@property (weak, nonatomic) IBOutlet UIButton          *replyBtn;                    //回复
@property (weak, nonatomic) IBOutlet UIButton          *mainViewBtn;                 //主页
@property (weak, nonatomic) IBOutlet UIImageView       *sHeadImgView;                //小的头像
@property (weak, nonatomic) IBOutlet UIImageView       *bHeadImgView;                //大的头像
@property (weak, nonatomic) IBOutlet UIImageView       *iconImgView;                 //认证的头像
@property (weak, nonatomic) IBOutlet UIView            *nameBottomView;              //名字底部view
@property (weak, nonatomic) IBOutlet UILabel           *nameLabel;                   //名字
@property (weak, nonatomic) IBOutlet UIImageView       *sexImgView;                  //性别
@property (weak, nonatomic) IBOutlet UIImageView       *rankImgView;                 //排名
@property (weak, nonatomic) IBOutlet UIView            *accountBottomView;           //账号底部view
@property (weak, nonatomic) IBOutlet UILabel           *accountLabel;                //账号
@property (weak, nonatomic) IBOutlet UILabel           *placeLabel;                  //地址
@property (weak, nonatomic) IBOutlet UIView            *identifitionView;            //认证底部的view
@property (weak, nonatomic) IBOutlet UIImageView       *identifitionImgView;         //认证的imgview
@property (weak, nonatomic) IBOutlet UILabel           *identifitionLabel;           //认证的label

@property (weak, nonatomic) IBOutlet UILabel           *siginLabel;                  //签名

@property (weak, nonatomic) IBOutlet UIView            *cfBottomView;                //关注和粉丝底部view
@property (weak, nonatomic) IBOutlet UIView            *otBottomView;                //送出和印票底部view
@property (weak, nonatomic) IBOutlet UILabel           *concernLabel;                //关注

@property (weak, nonatomic) IBOutlet UILabel           *followLabel;                 //粉丝
@property (weak, nonatomic) IBOutlet UILabel           *outPutLabel;                 //送出
@property (weak, nonatomic) IBOutlet UILabel           *ticketLabel;                 //印票
@property (weak, nonatomic) IBOutlet UIView            *VlineView1;                  //竖线1
@property (weak, nonatomic) IBOutlet UIView            *VlineView2;                  //竖线2
@property (weak, nonatomic) IBOutlet UIView            *HlineView;                   //横线1
@property (weak, nonatomic) IBOutlet UIButton          *mainViewBtn2;                //主页
@property (weak, nonatomic) IBOutlet UIView            *bBottomView;                 //主页,私信，回复，关注底部的view

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bHeadImgViewSpaceH;          //大头像距顶部高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *identifitionBottomViewHeight;//认证底部view的高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameBottomViewSpaceH;        //名字距大头像的高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *identifitionViewSpaceH;      //认证距账号的高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *signLabelSpaceH;             //签名距认证的高度

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cfBottomViewSpaceH;          //关注和粉丝距签名的高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *HLineViewSpaceH;             //横线距送出和印票距离的高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bigBottomViewHeight;         //bigBottomView的高度

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameBottomViewWidth;         //nameBottomView的宽度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *placeLabelWidth;             //placeLabel的宽度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *accountBottomViewWidth;      //accountBottomView的宽度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *identifitionBottomViewWidth; //identifitionBottomView的宽度

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bHeadImgViewHeight;          //大头像高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameBottomViewHeight;        //名字高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *accountBottomViewHeight;     //账号高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *signBottomViewHeight;        //签名高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *CfBottomViewHight;           //关注和粉丝的高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *OtBottomViewHeight;          //送出和印票的高度




@property (nonatomic,copy) NSString  *headImgViewStr;                                 //头像url
@property (nonatomic,copy) NSString  *nick_name;                                      //名字
@property (nonatomic,copy) NSString  *user_id;                                        //用户id
@property (nonatomic,assign) BOOL    is_robot;                                        //
@property (nonatomic,assign) int     show_admin;                                      //管理按钮 12显示 0不显示 （1管理员：举报 禁言 取消 2主播：设置／取消管理员，管理员列表，禁言，取消）
@property (nonatomic,assign) int     show_tipoff;                                     //举报 1显示 0不显示
@property (nonatomic,assign) int     has_focus;                                       //0未关注 1已关注
@property (nonatomic,assign) int     has_admin;                                       //0非管理员 1管理员
@property (nonatomic,assign) int     is_forbid;                                       //是否被禁言
@property (nonatomic, strong) id<FWShowLiveRoomAble> myRoom;


- (void)updateUIWithModel:(UserModel *)model withRoom:(id<FWShowLiveRoomAble>)room;

@end
