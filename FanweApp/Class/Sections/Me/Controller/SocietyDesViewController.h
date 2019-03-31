//
//  SocietyDesViewController.h
//  FanweApp
//
//  Created by 王珂 on 17/1/22.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SocietyListModel;

@interface SocietyDesViewController : FWBaseViewController

@property (nonatomic, assign) int isSocietyHeder;       //是否是公会长 //1是公会长，0是公会成员,2是陌生人
@property (nonatomic, copy) NSString * society_id;     //公会ID
@property (nonatomic, copy) NSString * user_id;
@property (nonatomic, copy) NSString * is_apply;       //是否已经提交申请
@property(nonatomic, strong) SocietyListModel * listModel; //公会列表中的公会信息

@end
