//
//  STBaseView.h
//  FanweApp
//
//  Created by 岳克奎 on 17/4/17.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STBaseView : UIView
@property (nonatomic ,strong)UIView           *recordSupreView;
@property (nonatomic ,strong)UIViewController *recordSupreViewC;
@property (nonatomic,strong) GlobalVariables  *globalVariables;
#pragma mark *************************** Plublic ****************************
#pragma mark ------new View
/**
 * @brief:  new View "+" methods
 *
 * @attention: 1. base class declaration 2.subclass implementation、
 */
+(STBaseView *)showSTBaseViewOnSuperView:(UIView *)superView
                            loadNibNamedStr:(NSString *)loadNibNamedStr
                            andFrameRect:(CGRect)frameRect
                             andComplete:(void(^)(BOOL finished,
                                                  STBaseView *stBaseView))block;
@end
