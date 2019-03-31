//
//  STBMKCenter.h
//  FanweApp
//
//  Created by 岳克奎 on 17/3/29.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^STBMKUserLocationComplete)(BMKUserLocation *bmkUserLocation);
typedef void(^STBMKReverseGeoCodeResultComplete)(BMKGeoCodeSearch *search,BMKReverseGeoCodeResult *result,BMKSearchErrorCode error);
typedef void(^STBMKPoiResultComplete)(BMKPoiSearch *search,BMKPoiResult *poiResult,BMKSearchErrorCode error);
@interface STBMKCenter : NSObject <BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,BMKPoiSearchDelegate>
//定位成功的回调 包含海拔 经纬度信息
//@property(nonatomic,strong) void(^stBMKUserLocationComplete)(BMKUserLocation *bmkUserLocation);
//实际的位置信息 省 市
//@property(nonatomic,strong) void(^stBMKReverseGeoCodeResultComplete)(BMKGeoCodeSearch *search,BMKReverseGeoCodeResult *result,BMKSearchErrorCode error);
@property(nonatomic,strong) BMKLocationService                *bmkLocationService;
@property(nonatomic,strong) BMKGeoCodeSearch                  *bmkGeoCodeSearch;     //地理代码搜索
@property(nonatomic,strong) BMKPoiSearch                      *bmkPoiSearch;         //搜索服务
@property(nonatomic,strong) BMKNearbySearchOption             *bmkNearbySearchOption;
@property(nonatomic,strong) STBMKUserLocationComplete         stBMKUserLocationComplete;
@property(nonatomic,strong) STBMKReverseGeoCodeResultComplete stBMKReverseGeoCodeResultComplete;
@property(nonatomic,strong) STBMKPoiResultComplete            stBMKPoiResultComplete;
//// 获取 省 市 地理位置 经纬度
@property(nonatomic,strong)NSString                           *provinceStr;
@property(nonatomic,strong)NSString                           *cityNameStr;
@property(nonatomic,strong)NSString                           *detailAdressStr;
@property(nonatomic,strong)NSString                           *districtStr;     //区域地址用于显示
@property(nonatomic,assign)CGFloat                            latitudeValue;
@property(nonatomic,assign)CGFloat                            longitudeValue;
@property(nonatomic,strong)NSMutableArray                     *poiListMArray;
//获取 省 市 地理位置 经纬度
-(void)showAdressLatitudeLongitudeDataComplete:(void(^)(BOOL finished))block;

+ (STBMKCenter *)shareManager;
//获得经纬度
- (void)showUserLocationServiceWithComplete:(STBMKUserLocationComplete)block;
////根据经纬度 获得具体地址
- (void)showAddressWithuserLocation:(BMKUserLocation *)userLocation
                           Complete:(STBMKReverseGeoCodeResultComplete)block;
//关键字搜索 返回结果
-(void)showSearchByKeyWords:(NSString *)searchKeyWords
                   latitude:(CGFloat)latitude
                  longitude:(CGFloat)longitude
                andComplete:(STBMKPoiResultComplete)block;

//地理位置显示的处理
- (void)detailPlaceStr;


@end
