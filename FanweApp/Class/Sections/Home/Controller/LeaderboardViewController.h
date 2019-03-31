//
//  LeaderboardViewController.h
//  FanweApp
//
//  Created by yy on 16/10/11.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SegmentView.h"

@interface LeaderboardViewController : UIViewController

@property ( nonatomic,assign) BOOL            isHiddenTabbar;        //是否隐藏tabbar
@property (nonatomic, copy) NSString          *hostLiveId;           //主播id
@property (nonatomic, strong) SegmentView     *segmentView;
@property (nonatomic, strong) SegmentView     *listSegmentView;
@property (nonatomic, copy) NSString          *user_id;

@end
