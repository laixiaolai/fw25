//
//  STBaseView.m
//  FanweApp
//
//  Created by 岳克奎 on 17/4/17.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "STBaseView.h"

@implementation STBaseView
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
                                                  STBaseView *stBaseView))block{
    //①superView
    if(!superView){
        if (block) {
            block(NO,nil);
        }
        return nil;
    }
    //②remove existing View
    for (UIView *oneView in superView.subviews) {
        if([oneView isKindOfClass:[self class]]){
            [oneView removeFromSuperview];
        }
    }
    //③new
    STBaseView *newView = [[[NSBundle mainBundle]loadNibNamed:loadNibNamedStr
                                                        owner:nil
                                                      options:nil]firstObject];
    
    //④frame
    //[stBaseView setFrame:superView.frame];
    newView.frame = frameRect;
    //⑤ child
    [superView addSubview:newView];
    //⑥ record
    newView.recordSupreView = superView;
    //⑦ return、block
    if (block) {
        block(YES,newView);
    }
    return newView;
}
#pragma mark ************************ Getter *****************************
-(GlobalVariables *)globalVariables{
    if (!_globalVariables) {
        _globalVariables =  [GlobalVariables sharedInstance];
    }
    return _globalVariables;
}
@end
