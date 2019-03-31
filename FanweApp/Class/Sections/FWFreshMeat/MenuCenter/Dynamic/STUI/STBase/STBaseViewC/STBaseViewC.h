//
//  STBaseViewC.h
//  FanweApp
//
//  Created by 岳克奎 on 17/4/17.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IQKeyboardManager.h"
#import "STRefresh.h"
#pragma mark - Transition Type
/*
typedef NS_ENUM(NSUInteger, STViewCTransitionType) {
    STViewCTransitionTypeOfPush       = 0,  // psuh
    STViewCTransitionTypeOfModal      = 1,  // Model
    STViewCTransitionOfChild          = 2,  // addSubView/aadChildViewC
};*/
@interface STBaseViewC : UIViewController
@property(nonatomic,strong)  UIViewController           *recordSuperViewC;
@property (nonatomic, strong)UITabBarController         *recordTabBarC;
@property(nonatomic,assign)  STViewCTransitionType      stViewCTransitionType;
@property (nonatomic,assign) BOOL                       isOpenIQKeyboardManager;
@property (nonatomic,strong) GlobalVariables            *globalVariables;
#pragma *************************** Plublic公有方法****************************
#pragma mark --- newViewC < STBaseViewC *>
/**
 * @brief:  new ViewC methods
 *
 * @attention: 1. base class declaration 2.subclass implementation、
 */
+(STBaseViewC *)showSTBaseViewCOnSuperViewC:(UIViewController *)superViewC
                               andFrameRect:(CGRect)frameRect
                   andSTViewCTransitionType:(STViewCTransitionType)stViewCTransitionType
                                andComplete:(void(^)(BOOL finished,STBaseViewC *stBaseViewC))block;

@end
