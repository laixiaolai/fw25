//
//  SocietyHomePageVC.h
//  FanweApp
//
//  Created by 杨仁伟 on 2017/8/21.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "FWBaseViewController.h"
#import "SociatyListModel.h"

@protocol SocietyHomePageVCDelegate <NSObject>

/**
 跳转到公会详情

 @param listModel model
 */
- (void)pushSocietyDetail:(SociatyListModel *)listModel;

@end

@interface SocietyHomePageVC : FWBaseViewController

@property (nonatomic, weak) id <SocietyHomePageVCDelegate> delegate;
@property (nonatomic, assign) CGRect societyFrame;

- (void)loadDataWithPage:(int)page;

@end
