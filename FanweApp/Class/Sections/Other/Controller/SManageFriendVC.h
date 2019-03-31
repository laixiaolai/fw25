//
//  SManageFriendVC.h
//  FanweApp
//
//  Created by 丁凯 on 2017/9/11.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "FWBaseViewController.h"

@interface SManageFriendVC : FWBaseViewController

@property (nonatomic, assign) int        type;//0表示删除人；1表示添加好友
@property (nonatomic, copy) NSString     *liveAVRoomId;
@property (nonatomic, copy) NSString     *chatAVRoomId;

@end
