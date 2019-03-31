//
//  SexViewController.h
//  FanweApp
//
//  Created by fanwe2014 on 16/7/19.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol changeSexDelegate <NSObject>

//修改性别的代理
- (void)changeSexWithString:(NSString *)sexString;

@end

@interface SexViewController : FWBaseViewController

@property (nonatomic, copy) NSString *sexType;
@property (nonatomic, weak) id<changeSexDelegate>delgate;


@end
