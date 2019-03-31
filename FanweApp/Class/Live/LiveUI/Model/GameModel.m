//
//  GameModel.m
//  FanweApp
//
//  Created by GuoMs on 16/11/25.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "GameModel.h"

@implementation GameModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"game_id" : @"id"};
}
- (NSMutableArray *)list{
    if (!_list) {
        self.list = [NSMutableArray new];
    }
    return _list;
}

@end
