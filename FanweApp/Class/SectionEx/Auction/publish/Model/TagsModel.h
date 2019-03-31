//
//  TagsModel.h
//  FanweApp
//
//  Created by GuoMs on 16/8/10.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TagsModel : NSObject

@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *sort;
@property (nonatomic, assign) BOOL isSelected;

@end
