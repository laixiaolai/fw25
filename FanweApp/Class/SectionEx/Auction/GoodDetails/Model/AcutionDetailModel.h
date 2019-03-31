//
//  AcutionDetailModel.h
//  FanweApp
//
//  Created by fanwe2014 on 16/8/9.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InfoModel.h"
#import "AcutionDetailModel.h"
#import "JoinDataModel.h"

@interface AcutionDetailModel : NSObject

@property (nonatomic, copy) NSString *has_join; //是否参与竞拍
@property (nonatomic, strong) InfoModel *info;
@property (nonatomic, strong) JoinDataModel *join_data;
@property (nonatomic, copy) NSString *error;
@property (nonatomic, copy) NSString *status;

@end
