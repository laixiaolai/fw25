//
//  GameDistributionModel.h
//  FanweApp
//
//  Created by 王珂 on 17/4/8.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameUserModel :NSObject

@property (nonatomic, copy)  NSString * userID;
@property (nonatomic, copy)  NSString * nick_name;
@property (nonatomic, copy)  NSString * head_image;
@property (nonatomic, copy)  NSString * sum;
@property (nonatomic, assign) BOOL isParent;

@end

@interface PageModel : NSObject

@property (nonatomic, assign) int has_next;
@property (nonatomic, assign) int page;

@end

@interface GameDistributionModel : NSObject

@property (nonatomic, strong) GameUserModel * parent;
@property (nonatomic, strong) NSMutableArray * list;
@property (nonatomic, strong) PageModel * page;

@end
