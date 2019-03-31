//
//  PrivateChatViewController.h
//  FanweApp
//
//  Created by fanwe2014 on 16/6/27.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PrivateChatViewController : UIViewController

@property (nonatomic, copy) NSString *receiverId;//是群聊还是私聊
@property (nonatomic, copy) NSString *ITMString;//TIM_C2C是单聊,TIM_GROUP是群聊

@end
