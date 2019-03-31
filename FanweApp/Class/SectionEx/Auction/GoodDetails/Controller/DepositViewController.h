//
//  DepositViewController.h
//  FanweApp
//
//  Created by fanwe2014 on 16/8/10.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DepositTableView)
{
    DepositZoneSection,                         //托管金额
    DepositOneSection,                          //联系方式的提示
    DepositTwoSection,                          //联系方式
    DepositThreeSection,                        //约会信息的cell
    DepositTablevCount
};

@interface DepositViewController : FWBaseViewController

@property (nonatomic, assign) int        type;            //0代表虚拟竞拍，1代表实物竞拍
@property (nonatomic, copy) NSString     *productId;      //产品的id
@property (nonatomic, copy) NSString     *bzMoney;        //保证金

@end
