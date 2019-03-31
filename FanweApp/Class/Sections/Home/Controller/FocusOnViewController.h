//
//  FocusOnViewController.h
//  FanweApp
//
//  Created by GuoMs on 16/7/4.
//  Copyright © 2016年 xfg. All rights reserved.
//

@protocol handleMainDelegate <NSObject>

// 跳转主页
- (void)goToMainPage:(NSString *)userID;

- (void)goToNewestView;

@end

@interface FocusOnViewController : FWBaseViewController

@property (nonatomic, weak) id<handleMainDelegate>delegate;
@property (nonatomic, assign) CGRect tableViewFrame;

- (void)requestNetWorking;

@end
