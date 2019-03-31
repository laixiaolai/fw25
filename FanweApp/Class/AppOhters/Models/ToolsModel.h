//
//  ToolsModel.h
//  FanweApp
//
//  Created by 王珂 on 17/4/5.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ToolsModel : NSObject

@property (nonatomic, copy) NSString    *imageStr;
@property (nonatomic, copy) NSString    *title;
@property (nonatomic, copy) NSString    *selectedImageStr;
@property (nonatomic, assign) BOOL      isSelected;//是否被选中

@end
