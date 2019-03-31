//
//  EditSocietyViewController.h
//  FanweApp
//
//  Created by 王珂 on 17/1/22.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SocietyDesModel.h"
@interface EditSocietyViewController : FWBaseViewController
@property (nonatomic,strong) SocietyDesModel * model;
@property (nonatomic,assign) int type; //0为新建公会，1为编辑公会
@property (nonatomic,copy)  NSString *user_id;
@property (nonatomic,assign) int canEditAll;
@property (nonatomic, assign) int sociatyID; //公会ID
@property (nonatomic, copy) NSString *sociatyName; //公会名称
@property (nonatomic, copy) NSString *sociatyManifasto; // 公会宣言
@property (nonatomic, copy) NSString *sociaHead; // 公会头像
@end
