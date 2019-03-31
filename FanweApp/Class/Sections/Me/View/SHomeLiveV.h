//
//  SHomeLiveV.h
//  FanweApp
//
//  Created by 丁凯 on 2017/8/26.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SHomeLiveV;
@protocol LiveDeleGate <NSObject>

- (void)goToLiveRoomWithModel:(UserModel *)model andView:(SHomeLiveV *)homeLiveView;

@end

@interface SHomeLiveV : FWBaseView<UITableViewDelegate,UITableViewDataSource>

@property ( nonatomic, strong) UIView               *newestOrHotView;              //最新 最热的view
@property ( nonatomic, strong) UILabel              *newHotLabel;                  //newHotLabel
@property ( nonatomic, strong) NSMutableArray       *hotArray;                     //最热的数据
@property ( nonatomic, strong) NSMutableArray       *newestArray;                  //最新的数据
@property ( nonatomic, strong) UITableView          *liveTableView;                //tableView
@property ( nonatomic, copy) NSString               *user_id;                      //用户id
@property ( nonatomic, assign) int                  currentPage;                   //当前页
@property ( nonatomic, assign) int                  has_next;                      //是否还有下一页
@property ( nonatomic, assign) int                  newOrHotType;                  //最新或者最热 0最新 1最热
@property ( nonatomic, assign) BOOL                 isCouldLiveData;               //是否可以加载tableView
@property ( nonatomic, weak) id <LiveDeleGate>      LDelegate;                     //代理

- (instancetype)initWithFrame:(CGRect)frame andUserId:(NSString *)userId;

@end
