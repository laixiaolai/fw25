//
//  EditFamilyViewController.h
//  FanweApp
//
//  Created by 王珂 on 16/9/26.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FamilyDesModel.h"

@interface EditFamilyViewController : FWBaseViewController

@property (nonatomic, strong) FamilyDesModel    * model;
@property (nonatomic, assign) int               type;       //0为新建家族，1为编辑家族
@property (nonatomic, copy)  NSString           *user_id;
@property (nonatomic, assign) int               canEditAll;

@end
