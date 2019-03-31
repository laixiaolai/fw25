//
//  FamilyMemberViewController.h
//  FanweApp
//
//  Created by 王珂 on 16/9/24.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FamilyMemberViewController : FWBaseViewController

@property (nonatomic, assign) int isFamilyHeder;       //是否是家族族长 1为家族族长,0为家族成员
@property (nonatomic, copy) NSString * jid;            //家族ID

@end
