//
//  QMapLocationView.h
//  O2O
//
//  Created by xfg on 15/9/10.
//  Copyright (c) 2015年 fanwe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QMapKit/QMapKit.h>
#import <QMapSearchKit/QMapSearchKit.h>
#import "GlobalVariables.h"

@protocol QMapLocationViewDelegate <NSObject>
@optional

- (void)startLoadView;
- (void)reverseGeoCodeResult:(QMSReverseGeoCodeSearchResult *)reverseGeoCodeSearchResult;

@end

@interface QMapLocationView : UIView

@property (nonatomic, weak) id<QMapLocationViewDelegate>delegate;

@property (nonatomic, retain) GlobalVariables *fanweApp;
@property (nonatomic, assign) NSInteger locateNum;

+ (instancetype)sharedInstance;

- (void)startLocate; //开始定位
- (void)stopLocate; //停止定位
- (void)locateAgain; //重新定位

@end
