//
//  DistanceModel.h
//  FanweApp
//
//  Created by fanwe2014 on 16/10/24.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QMapKit/QMapKit.h>
#import <QMapSearchKit/QMapSearchKit.h>

@interface DistanceModel : NSObject

@property (nonatomic, strong) NSMutableArray *distanceArray;

- (NSMutableArray *)CalculateDistanceWithArray:(NSMutableArray *)DisArray andPoint:(QMapPoint )point;

@end
