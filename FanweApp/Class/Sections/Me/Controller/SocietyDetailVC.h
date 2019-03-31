//
//  SocietyDetailVC.h
//  FanweApp
//
//  Created by 杨仁伟 on 2017/8/21.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "FWBaseViewController.h"

@interface SocietyDetailVC : FWBaseViewController

@property (nonatomic, assign) int mySocietyID; //公会ID
@property (nonatomic, assign) int type; //公会类型
@property (nonatomic, assign) int mygh_status;// 公会审核状态
@property (nonatomic, copy)   NSString *flagStr;//从哪个界面跳转

@end
