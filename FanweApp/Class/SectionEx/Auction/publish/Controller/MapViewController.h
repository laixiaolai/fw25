//
//  MapViewController.h
//  FanweApp
//
//  Created by GuoMs on 16/8/11.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@protocol MapChooseAddressControllerDelegate <NSObject>
@optional

- (void)chooseAddress:(CLLocationCoordinate2D)location address:(NSString *)address andProvinceString:(NSString *)provinceString andCityString:(NSString *)cityString andAreaString:(NSString *)areaString;

@end

@interface MapViewController : FWBaseViewController

@property (nonatomic, weak) id<MapChooseAddressControllerDelegate>delegate;

@property (nonatomic, assign) CLLocationCoordinate2D location; //经纬度
@property (nonatomic, retain) NSString *addressName; //地址名称
@property (nonatomic, assign) NSInteger fromType; //0：普通地址选择 1：收货地址地图位置选择

@end
