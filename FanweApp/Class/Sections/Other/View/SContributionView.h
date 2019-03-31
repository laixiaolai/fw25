//
//  SContributionView.h
//  FanweApp
//
//  Created by 丁凯 on 2017/9/5.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "FWBaseView.h"
#import "SLeaderHeadView.h"

@protocol ContriButionDeleGate <NSObject>

- (void)goToHomeWithModel:(UserModel *)model;

@end

@interface SContributionView : FWBaseView<UITableViewDelegate,UITableViewDataSource>

@property ( nonatomic, strong) UITableView                *myTableview;
@property ( nonatomic, strong) NSMutableArray             *dataArray;
@property ( nonatomic, strong) NSMutableArray             *userArray;
@property ( nonatomic, assign) int                        currentPage;
@property ( nonatomic, assign) int                        dataType;                //1代表当天排行  1代表累计排行
@property ( nonatomic, assign) int                        has_next;
@property ( nonatomic,copy) NSString                      *user_id;                //用户id
@property ( nonatomic,copy) NSString                      *liveRoom_id;            //房间id
@property ( nonatomic, assign) int                        total_num;               //总的印票数
@property ( nonatomic, strong) SLeaderHeadView            *LeaderHeadV;            //头部

@property ( nonatomic,strong) UIView                      *headView;               //头部view
@property ( nonatomic,strong) UIView                      *SHeadView;              //头部子view
@property ( nonatomic,strong) UIImageView                 *headImgView;            //头部ImgView
@property ( nonatomic,strong) UILabel                     *headLabel;              //头部Label
@property ( nonatomic,weak)  id<ContriButionDeleGate>     CDelegate;               //代理


- (id)initWithFrame:(CGRect)frame andDataType:(int)dataType andUserId:(NSString *)userId andLiveRoomId:(NSString *)liveRoomId;

@end
