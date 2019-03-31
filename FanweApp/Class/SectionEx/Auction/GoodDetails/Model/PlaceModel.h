//
//  PlaceModel.h
//  FanweApp
//
//  Created by fanwe2014 on 16/10/25.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlaceModel : NSObject

@property (nonatomic, copy) NSString *province;//省
@property (nonatomic, copy) NSString *city;//市
@property (nonatomic, copy) NSString *area;//区
@property (nonatomic, copy) NSString *zip;//邮编
@property (nonatomic, copy) NSString *lng;//经度
@property (nonatomic, copy) NSString *lat;//纬度

@end
