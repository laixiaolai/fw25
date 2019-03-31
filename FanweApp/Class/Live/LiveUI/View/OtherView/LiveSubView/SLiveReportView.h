//
//  SLiveReportView.h
//  FanweApp
//
//  Created by 丁凯 on 2017/7/14.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "FWBaseView.h"

@class SLiveReportView;
@protocol liveReportViewDelegate <NSObject>

// 0取消 1确认 2删除整个页面
- (void)clickWithReportId:(NSString *)reportId andBtnIndex:(int)btnIndex andView:(SLiveReportView *)reportView;

@end

@interface SLiveReportView : FWBaseView<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>

@property(nonatomic,weak) id<liveReportViewDelegate> reportDelegate;

@property ( nonatomic,strong) UIView              *bottomView;
@property ( nonatomic,strong) UILabel             *reportType;
@property ( nonatomic,strong) UITableView         *reportTableView;
@property ( nonatomic,strong) UIView              *lineView2;
@property ( nonatomic,strong) UIButton            *confirmButton;
@property ( nonatomic,strong) UIView              *VLineView;
@property ( nonatomic,strong) UIButton            *cancelButton;

@property (strong, nonatomic) NSMutableArray      *dataArray;
@property (assign, nonatomic) NSUInteger          paymentTag; // 举报的tag
@property (copy, nonatomic) NSString              *reportId;



@end
