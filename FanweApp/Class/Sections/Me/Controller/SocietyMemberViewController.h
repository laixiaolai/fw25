//
//  SocietyMemberViewController.h
//  FanweApp
//
//  Created by 王珂 on 17/1/22.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SocietyMemberViewController : UIViewController

@property (nonatomic, assign) int isSocietyHeder;       //是否是公会长 1为公会长,0为公会成员
@property (nonatomic, copy) NSString * society_id;     //公会ID

@end
