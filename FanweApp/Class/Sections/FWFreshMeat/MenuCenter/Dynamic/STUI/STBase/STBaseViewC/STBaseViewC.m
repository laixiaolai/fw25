//
//  STBaseViewC.m
//  FanweApp
//
//  Created by 岳克奎 on 17/4/17.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "STBaseViewC.h"

@interface STBaseViewC ()

@end

@implementation STBaseViewC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
                                andComplete:(void(^)(BOOL finished,STBaseViewC *stBaseViewC))block{
    if (stViewCTransitionType == STViewCTransitionOfChild) {
        //① superViewC
        if (!superViewC) {
            if (block) {
                block(NO,nil);
            }
        }
        //② remove from superViewC
        for (UIViewController *oneViewC in superViewC.childViewControllers) {
            if ([oneViewC isKindOfClass:[self class]]) {
                [oneViewC removeFromParentViewController];
                [oneViewC.view removeFromSuperview];
            }
        }
    }
    //③ newViewC
    STBaseViewC *newViewC = [[self alloc]initWithNibName:NSStringFromClass([self class])
                                                  bundle:nil];
    NSLog(@"=======11===== %@",NSStringFromClass([self class]));
    //④ add child for superViewC
    if (stViewCTransitionType == STViewCTransitionOfChild) {
        //ViewC
        [newViewC.view setFrame:superViewC.view.frame];
        newViewC.view.frame = frameRect;
        //child
        [superViewC addChildViewController:newViewC];
        [superViewC.view addSubview:newViewC.view];
    }else{
            newViewC.view.frame = frameRect;
    }
    //⑤ record
    newViewC.recordSuperViewC = superViewC;
    //⑥ block
    if (block) {
        block(YES,newViewC);
    }
    //⑦ return
    
    return newViewC;
}
#pragma mark -----IQKeyboardManager
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!_isOpenIQKeyboardManager) {
        return;
    }
    [IQKeyboardManager sharedManager].enable = YES; //YES == Open IQKeyboard
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].keyboardDistanceFromTextField = 100.0f;
    
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (!_isOpenIQKeyboardManager) {
        return;
    }
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}
#pragma mark ************************ Getter *****************************
-(GlobalVariables *)globalVariables{
    if (!_globalVariables) {
        _globalVariables =  [GlobalVariables sharedInstance];
    }
    return _globalVariables;
}
@end



















