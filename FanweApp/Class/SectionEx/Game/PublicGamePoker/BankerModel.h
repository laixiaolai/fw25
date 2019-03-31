//
//  BankerModel.h
//  FanweApp
//
//  Created by yy on 17/2/22.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BankerModel : NSObject

@property (nonatomic, assign) NSInteger     banker_log_id;  //上庄id
@property (nonatomic, copy)   NSString      *banker_name;   //申请上庄玩家昵称
@property (nonatomic, copy)   NSString      *banker_img;    //申请上庄玩家头像
@property (nonatomic, copy)   NSString      *coin;          //申请上庄底金
@property (nonatomic, assign) BOOL          *isSelect;

@end
