//
//  FWEditInfoController.h
//  FanweApp
//
//  Created by 丁凯 on 2017/6/12.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "FWBaseViewController.h"

typedef NS_ENUM(NSInteger ,EditTableView)
{
    ETXSection,                               //头像
    ENCSection,                               //昵称
    EZHSection,                               //账号
    EXBSection,                               //性别
    EGXQMSection,                             //个性签名
    ERZSection,                               //认证
    ESRSection,                               //生日
    EQGZTSection,                             //情感状态
    EJXSection,                               //家乡
    EZYSection,                               //职业
    ETab_Count,
};

@interface FWEditInfoController : FWBaseViewController

@end
