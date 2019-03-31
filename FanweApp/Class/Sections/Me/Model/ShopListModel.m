//
//  ShopListModel.m
//  FanweApp
//
//  Created by yy on 16/9/21.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "ShopListModel.h"

@implementation ShopListModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"ID" : @"id",
             @"descrStr": @"description"
             };
}
- (NSMutableArray *)imgs{
    if (!_imgs) {
        self.imgs= [NSMutableArray new];
    }
    return _imgs;
}
@end
