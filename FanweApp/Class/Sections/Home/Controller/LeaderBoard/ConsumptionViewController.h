//
//  ConsumptionViewController.h
//  FanweApp
//
//  Created by yy on 16/10/18.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListDayViewController.h"

@interface ConsumptionViewController : UIViewController

@property (nonatomic,strong) SegmentView *listSegmentView;
@property ( nonatomic,assign) BOOL                      isHiddenTabbar;              //是否有tabbar控制view的高度
@property (nonatomic,strong)ListDayViewController       *listDayViewController;      //日榜
@property (nonatomic,strong)ListDayViewController       *listMonthViewController;    //月榜
@property (nonatomic,strong)ListDayViewController       *listTotalViewController;    //总榜

@end
