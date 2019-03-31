
//
//  STNavView.m
//  FanweApp
//
//  Created by 岳克奎 on 17/3/6.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "STNavView.h"

@implementation STNavView

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
    }
    return self;
}
-(void)awakeFromNib{
    [super awakeFromNib];
}
#pragma mark ----------------------------- setter/getter 属性的初始化区域 ---------------
-(void)setDelegate:(id<STNavViewDelegate>)delegate{
    _delegate = delegate;
}

- (IBAction)leftBtnClick:(id)sender {
    //键盘下去
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder)
                                               to:nil
                                             from:nil
                                         forEvent:nil];
    if(_delegate && [_delegate respondsToSelector:@selector(showLeftBtnEventResponseOfSTNavView:)]){
        [_delegate showLeftBtnEventResponseOfSTNavView:self];
    }
}

- (IBAction)rightBtnClick:(id)sender {
    if(_delegate && [_delegate respondsToSelector:@selector(showRightBtnEventResponseOfSTNavView:)]){
        [_delegate showRightBtnEventResponseOfSTNavView:self];
    }
}
#pragma mark *************************** Plublic ****************************
#pragma mark ------new View
/**
 * @brief:  new View "+" methods
 *
 * @attention: 1. base class declaration 2.subclass implementation、
 */
//+(STBaseView *)showSTUIBridgeViewOnSuperView:(UIView *)superView
//                                andFrameRect:(CGRect)frameRect
//                                 andComplete:(void(^)(BOOL finished,
//                                                      STBaseView *stBaseView))block{
//    if (block) {
//        block(YES,nil);
//    }
//    return nil;
//}


@end
