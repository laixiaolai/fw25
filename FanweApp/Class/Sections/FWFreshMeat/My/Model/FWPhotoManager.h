//
//  FWPhotoManager.h
//  FanweApp
//
//  Created by 丁凯 on 2017/8/4.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IDMPhotoBrowser.h"

@class PersonCenterListModel,CommentModel;

@interface FWPhotoManager : NSObject

- (void)goToPhotoWithVC:(UIViewController *)myVC withTag:(int)itemTag withModel:(PersonCenterListModel *)itemModel;

- (void)goToPhotoWithVC:(UIViewController *)myVC withMyTag:(int)MyTag withModel:(CommentModel *)commentModel withMArr:(NSMutableArray *)MArr;

- (void)goToPhotoWithVC:(UIViewController *)myVC withMyTag:(int)MyTag withMArr:(NSMutableArray *)MArr withDelegate:(id<IDMPhotoBrowserDelegate>)deleagte;

@end
