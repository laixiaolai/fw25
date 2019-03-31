//
//  FamilyDesViewController.h
//  FanweApp
//
//  Created by 王珂 on 16/9/26.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FamilyListModel;

@interface FamilyDesViewController : FWBaseViewController

@property (nonatomic, assign) int isFamilyHeder;       //是否是家族族长 //1是家族族长，0是家族成员,2是陌生人
@property (nonatomic, copy) NSString * jid;            //家族ID
@property (nonatomic, copy) NSString * user_id;
@property (nonatomic, copy) NSString * is_apply;       //是否已经提交申请
@property(nonatomic, strong) FamilyListModel * listModel; //家族列表中的家族信息

@end
