//
//  FWRecommendController.h
//  FanweApp
//
//  Created by fanwe2014 on 2017/3/5.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FWRecommendController : FWBaseViewController
@property (nonatomic,assign)int                    tableViewType;                //类型 1我的动态详情 0推荐
@property (nonatomic,strong)NSMutableArray         *payArray;                    //支付的数组
@end
