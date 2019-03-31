//
//  TLiveMickLayoutParamModel.h
//  FanweApp
//
//  Created by xfg on 2017/4/21.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TLiveMickLayoutParamModel : NSObject

@property (nonatomic, assign) float     location_x;          // 连麦小窗口的x坐标 = 宽度 * location_x
@property (nonatomic, assign) float     location_y;          // 连麦小窗口的y坐标 = 高度 * location_y
@property (nonatomic, assign) float     image_width;         // 连麦小窗口的宽 = 宽度 * image_width
@property (nonatomic, assign) float     image_height;        // 连麦小窗口的高 = 高度 * image_height

@end
