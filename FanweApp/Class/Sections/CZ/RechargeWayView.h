//
//  RechargeWayView.h
//  FanweApp
//
//  Created by 王珂 on 17/3/13.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountRechargeModel.h"
#import "RechargeWayCell.h"

@protocol  RechargeWayViewDelegate <NSObject>

@optional
- (void)choseRechargeWayWithIndex:(NSInteger) index;
- (void)choseRechargeWayWithWayName:(NSString *) wayName;

@end

@interface RechargeWayView : UIView<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,RechargeWayCellDelegate>

@property (nonatomic, weak) id<RechargeWayViewDelegate> delegate;
@property (nonatomic, strong) NSArray           *rechargeWayArr; //pay_list字段对应的数组
@property (nonatomic, assign) NSInteger         selectIndex;
@property (nonatomic, assign) NSInteger         nowIndex;
@property (nonatomic, strong) UICollectionView  *collectionView;

@end
