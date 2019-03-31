//
//  FWBaseView.m
//  FanweApp
//
//  Created by xfg on 2017/6/17.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "FWBaseView.h"
#import "FWNoContentView.h"

@implementation FWBaseView

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

#pragma mark - HUD
- (MBProgressHUD *)proHud
{
    if (!_proHud)
    {
        _proHud = [MBProgressHUD showHUDAddedTo:self animated:YES];
        _proHud.mode = MBProgressHUDModeIndeterminate;
    }
    return _proHud;
}

- (void)hideMyHud
{
    if (_proHud)
    {
        [_proHud hideAnimated:YES];
        _proHud = nil;
    }
}

- (void)showMyHud
{
    [self.proHud showAnimated:YES];
}


- (void)showNoContentViewOnView:(UIView *)view
{
    if (!self.noContentView)
    {
     self.noContentView = [FWNoContentView noContentWithFrame:CGRectMake(0, 0, 150, 175)];
    }
    self.noContentView.center = CGPointMake(view.frame.size.width/2,view.frame.size.height/2);
    [view addSubview:self.noContentView];
}


- (void)hideNoContentViewOnView:(UIView *)view
{
   [self.noContentView removeFromSuperview];
    self.noContentView = nil;
}

@end
