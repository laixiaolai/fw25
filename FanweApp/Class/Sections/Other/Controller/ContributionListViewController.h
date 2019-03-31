//
//  ContributionListViewController.h
//  FanweApp
//
//  Created by fanwe2014 on 16/6/7.
//  Copyright © 2016年 xfg. All rights reserved.

#import <UIKit/UIKit.h>
#import "SegmentView.h"

@interface ContributionListViewController : FWBaseViewController

@property (nonatomic, copy) NSString           *type;              //1当天排行 2累计排行
@property (nonatomic, copy) NSString           *user_id;
//@property (nonatomic, copy) NSString           *fromType;
@property (nonatomic, copy) NSString           *webViewString;     //mainWebViewController是否传东西下来
@property (nonatomic, copy) NSString           *liveAVRoomId;      //当前房间ID
@property (nonatomic, copy) NSString           *liveHost_id;       //主播id

@property (nonatomic, strong) SegmentView      *listSegmentView;

@end
