//
//  ChangeNameViewController.h
//  FanweApp
//
//  Created by fanwe2014 on 16/7/19.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol changeNameDelegate <NSObject>

//修改名称的代理
- (void)changeNameWithString:(NSString *)name withType:(NSString *)type;

@end

@interface ChangeNameViewController : FWBaseViewController

@property (nonatomic, weak) id<changeNameDelegate>  delegate;
@property (nonatomic, copy) NSString                *viewType;//1昵称 2个性签名 3职业
@property (nonatomic, copy) NSString                *textFiledName;
@property (nonatomic, copy) NSString                *nickInfo;

@end
