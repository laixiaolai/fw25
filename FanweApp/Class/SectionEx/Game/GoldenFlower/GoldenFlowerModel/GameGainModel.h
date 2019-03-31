//
//  GameGainModel.h
//  FanweApp
//
//  Created by 方维 on 2017/8/8.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "FWBaseModel.h"

@interface GameGainModel : FWBaseModel

@property (nonatomic, copy) NSString * user_diamonds;
@property (nonatomic, copy) NSString * gain;
@property (nonatomic, strong) NSMutableArray *gift_list;

@end
