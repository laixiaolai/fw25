//
//  GoldenModel.h
//  FanweApp
//
//  Created by GuoMs on 16/11/24.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoldenModel : NSObject

@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *room_id;
@property (nonatomic, copy) NSString *pai_id;
@property (nonatomic, copy) NSString *post_id;
@property (nonatomic, copy) NSString *desc;
@property(nonatomic,retain)NSMutableArray *data;
@property(nonatomic,retain)NSMutableArray *game_data;

@end
