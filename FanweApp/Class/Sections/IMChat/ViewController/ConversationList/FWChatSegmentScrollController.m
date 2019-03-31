//
//  FWChatSegmentScrollController.m
//  FanweApp
//
//  Created by 朱庆彬 on 2017/9/4.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "FWChatSegmentScrollController.h"

@implementation FWChatSegmentScrollController

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if (otherGestureRecognizer.state != 0) {
        return YES;
    } else {
        return NO;
    }
}

@end
