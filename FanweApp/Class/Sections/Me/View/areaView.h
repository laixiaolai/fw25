//
//  areaView.h
//  FanweApp
//
//  Created by fanwe2014 on 16/7/19.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol AreaDelegate <NSObject>

- (void)confrmCallBack:(NSString *)provice withCity:(NSString *)city andtagIndex:(int)tagIndex;

@end

@interface areaView : UIView

@property (nonatomic, strong) NSMutableArray *allArray; // 存放没有组装前的所有数据
@property (nonatomic, strong) NSMutableArray *bigArray;
@property (nonatomic, strong) NSMutableArray *proniceArray;
@property (nonatomic, strong) NSMutableArray *cityArray;

@property (nonatomic, weak) id<AreaDelegate> delegate;

- (id)initWithDelegate:(id<AreaDelegate>)delegate withCity:(NSString *)city;

@end
