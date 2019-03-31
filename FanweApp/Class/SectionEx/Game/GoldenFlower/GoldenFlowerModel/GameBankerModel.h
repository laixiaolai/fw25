//
//  GameBankerModel.h
//  FanweApp
//
//  Created by 王珂 on 17/2/23.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameBankerModel : NSObject

@property (nonatomic, copy)  NSString * banker_log_id;         //上庄id
@property (nonatomic, copy)  NSString * banker_name;           //申请上庄玩家昵称
@property (nonatomic, copy)  NSString * banker_img;            //申请上庄玩家头像
@property (nonatomic, copy)  NSString * coin;                  //申请上庄底金
@property (nonatomic, copy)  NSString * max_bet;               //申请上庄底金
@property (nonatomic, copy)  NSString * banker_id;             //上庄玩家用户id
@property (nonatomic, assign) BOOL   isSelect;

@end
