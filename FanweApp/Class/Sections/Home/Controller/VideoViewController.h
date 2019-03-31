//
//  VideoViewController.h
//  FanweApp
//
//  Created by 王珂 on 17/5/2.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoViewController : FWBaseViewController

@property (nonatomic, assign) NSInteger classified_id;
@property (nonatomic, assign) CGRect  viewFrame;
- (void)setNetworing:(int)page;

@end
