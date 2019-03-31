//
//  FileSetItemModel.h
//  FanweApp
//
//  Created by xfg on 16/7/30.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlaySetModel : NSObject

@property (nonatomic, assign) NSInteger definition;
@property (nonatomic, copy) NSString *url;

@end

@interface FileSetItemModel : NSObject

@property (nonatomic, assign) NSInteger     duration;
@property (nonatomic, copy) NSString        *fileId;
@property (nonatomic, copy) NSString        *fileName;
@property (nonatomic, copy) NSString        *image_url;
@property (nonatomic, assign) NSInteger     status;
@property (nonatomic, copy) NSString        *vid;

@property (nonatomic, strong) NSMutableArray *playSet;

@end
