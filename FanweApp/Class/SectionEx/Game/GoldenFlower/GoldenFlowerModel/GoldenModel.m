//
//  GoldenModel.m
//  FanweApp
//
//  Created by GuoMs on 16/11/24.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "GoldenModel.h"

@implementation GoldenModel
- (NSMutableArray *)data{
    if (!_data) {
        self.data = [NSMutableArray new];
    }
    return _data;
}
- (NSMutableArray *)game_data{
    if (!_game_data) {
        self.game_data = [NSMutableArray new];
    }
    return _game_data;
}
@end
