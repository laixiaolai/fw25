//
//  HostCheckMickAlertView.h
//  FanweApp
//
//  Created by xfg on 2017/9/26.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "MMPopupView.h"
#import "UserModel.h"

typedef void (^CloseMickBlock)(UserModel *userModel);

@interface HostCheckMickAlertView : MMPopupView

- (instancetype)initAlertView:(UserModel *)userModel closeMickBlock:(CloseMickBlock)closeMickBlock;

@end
