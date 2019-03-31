//
//  SChargerVC.h
//  FanweApp
//
//  Created by 丁凯 on 2017/8/28.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SChargerVC : FWBaseViewController

{
  UIView               *_headView;
}

@property (nonatomic, strong) SegmentView *feeSegmentView;               //按时收费 按场收费
@property (nonatomic, strong) SegmentView *recordSegmentView;            //付费记录 收费记录

@property ( nonatomic, assign) int                 feeIndex;             //0按时 1按场
@property ( nonatomic, assign) int                 recordIndex;          //0付费 1收费

@end
