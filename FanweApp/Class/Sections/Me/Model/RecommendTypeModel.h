//
//  RecommendTypeModel.h
//  FanweApp
//
//  Created by 王珂 on 17/4/10.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecommendModel : NSObject

@property (nonatomic, assign) NSInteger typeID;
@property (nonatomic, copy) NSString * name;

@end

@interface RecommendTypeModel : NSObject

@property(nonatomic, strong) NSMutableArray * invite_type_list;

@end
