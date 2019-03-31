//
//  SLiveRedBagView.h
//  FanweApp
//
//  Created by 丁凯 on 2017/7/15.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "FWBaseView.h"

@class SLiveRedBagView;

@protocol RedBagViewDelegate <NSObject>
@optional
// 点击打开红包
- (void)openRedbag:(SLiveRedBagView *)redBagView;

@end

@interface SLiveRedBagView : FWBaseView<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,weak)id<RedBagViewDelegate>          rebBagDelegate;

@property (weak, nonatomic) IBOutlet UIView              *rebbagBigView;
@property (weak, nonatomic) IBOutlet UIImageView         *headBackBroundView;
@property (weak, nonatomic) IBOutlet UIImageView         *headImgView;
@property (weak, nonatomic) IBOutlet UILabel             *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel             *messageLabel;
@property (weak, nonatomic) IBOutlet UIButton            *redButton;
@property (weak, nonatomic) IBOutlet UIButton            *bottomButton;
@property (weak, nonatomic) IBOutlet UIImageView         *smallHeadBackBroundView;
@property (weak, nonatomic) IBOutlet UIImageView         *smallHeadView;
@property (weak, nonatomic) IBOutlet UILabel             *nameLabel2;
@property (weak, nonatomic) IBOutlet UILabel             *messageLabel2;
@property (weak, nonatomic) IBOutlet UIView              *lineView;
@property (weak, nonatomic) IBOutlet UITableView         *myTableView;
@property (weak, nonatomic) IBOutlet UIButton            *luckButton;
@property (weak, nonatomic) IBOutlet UIImageView         *luckImgView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint  *smallHeadViewSpaceH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint  *nameLabelSpaceH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint  *messageLabel2SpaceH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint  *messageLabelSpaceH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint  *lineViewSpaceH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint  *redButtonSpaceH;


@property (nonatomic,strong) NSMutableArray              *dataArray;
@property (nonatomic,copy)   NSString                    *user_prop_id;
@property (nonatomic,assign) NSInteger                   currentDiamonds;//当前红包的值



@property (nonatomic, strong) CustomMessageModel     *customMessageModel;

- (void)creatRedWithModel:(CustomMessageModel *)model;
//设置红包是打开过的状态
- (void)changeRedPackageView;

@end
