//
//  FWBaseViewModel.m
//  FanweApp
//
//  Created by xfg on 2017/5/3.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "FWBaseViewModel.h"

@implementation FWBaseViewModel

- (NetHttpsManager *)httpsManager
{
    if (!_httpsManager)
    {
        _httpsManager = [NetHttpsManager manager];
    }
    return _httpsManager;
}

- (GlobalVariables *)fanweApp
{
    if (!_fanweApp)
    {
        _fanweApp = [GlobalVariables sharedInstance];
    }
    return _fanweApp;
}

@end
