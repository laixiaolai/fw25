//
//  STBMKCenter.m
//  FanweApp
//
//  Created by 岳克奎 on 17/3/29.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "STBMKCenter.h"

@implementation STBMKCenter
#pragma mark **************************** Life Cycle **************************** 
static STBMKCenter *signleton = nil;
+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        signleton = [super allocWithZone:zone];
    });
    return signleton;
}

+ (STBMKCenter *)shareManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        signleton = [[self alloc] init];
    });
    return signleton;
}

+ (id)copyWithZone:(struct _NSZone *)zone
{
    return signleton;
}

+ (id)mutableCopyWithZone:(struct _NSZone *)zone
{
    return signleton;
}
#pragma mark **************************** Getter ****************************
#pragma mark --- BMKGeoCodeSearch
-(BMKGeoCodeSearch *)bmkGeoCodeSearch{
    if (!_bmkGeoCodeSearch) {
        _bmkGeoCodeSearch = [[BMKGeoCodeSearch alloc]init];
        _bmkGeoCodeSearch.delegate = self;
    }
    return _bmkGeoCodeSearch;
}
#pragma mark --- BMKLocationService 定位功能
-(BMKLocationService *)bmkLocationService{
    if (!_bmkLocationService) {
    _bmkLocationService = [[BMKLocationService alloc]init];
    _bmkLocationService.delegate = self;
    }
    return _bmkLocationService;
}
#pragma mark ---BMKPoiSearch

-(BMKPoiSearch *)bmkPoiSearch{
    if (!_bmkPoiSearch) {
        _bmkPoiSearch = [[BMKPoiSearch alloc]init];
        _bmkPoiSearch.delegate = self;
    }
    return _bmkPoiSearch;
}
#pragma mark --- BMKNearbySearchOption
-(BMKNearbySearchOption *)bmkNearbySearchOption{
    if (!_bmkNearbySearchOption) {
        _bmkNearbySearchOption = [[BMKNearbySearchOption alloc] init];
    }
    return _bmkNearbySearchOption;
}
#pragma mark **************************** Delegate ***************************
#pragma mark ----------------------- <BMKLocationServiceDelegate>
// ①②③④⑤⑥
#pragma mark ----① 将要启动定位
- (void)willStartLocatingUser{
    
}
#pragma mark ----② 停止定位
- (void)didStopLocatingUser{
    
}
#pragma mark ----③ 用户方向更新
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation {
    NSLog(@"user derection change--->heading is %@",userLocation.heading);
    return;
}
#pragma mark ----④ 处理位置坐标更新
-(void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
     NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    if(_stBMKUserLocationComplete){
        _stBMKUserLocationComplete(userLocation);
    }
       [_bmkLocationService stopUserLocationService];
}
#pragma mark ----⑤ 定位失败
- (void)didFailToLocateUserWithError:(NSError *)error{
    [_bmkLocationService stopUserLocationService];
    NSLog(@"定位失败");
    if(_stBMKUserLocationComplete) {
        _stBMKUserLocationComplete(nil);
    }
    [_bmkLocationService stopUserLocationService];
    return;
}

#pragma mark ---展示定位信息
/*
 展示定位信息的功能位于 “基础地图（Map）”这个功能模块，开发者使用时请注意选择。
 
 核心代码如下：（完整信息请参考Demo）
 
 //普通态
 //以下_mapView为BMKMapView对象
 _mapView.showsUserLocation = YES;//显示定位图层
 [_mapView updateLocationData:userLocation];
 */



#pragma mark -----------------------<BMKGeoCodeSearchDelegate>
#pragma mark --- Public method of BMKGeocodeSearch
/*
 根据地址名称获取地理信息 - (BOOL)geoCode:(BMKGeoCodeSearchOption*)geoCodeOption
 根据地理坐标获取地址信息 - (BOOL)reverseGeoCode:(BMKReverseGeoCodeOption*)reverseGeoCodeOption
 
 */

#pragma ----- Reverse Geo Code Result 返回反地理编码搜索结果
-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher
                          result:(BMKReverseGeoCodeResult *)result
                       errorCode:(BMKSearchErrorCode)error
{
    if (_stBMKReverseGeoCodeResultComplete) {
        _stBMKReverseGeoCodeResultComplete(searcher,result,error);
    }
    NSLog(@"================ %@ ==========%u",result,error);
    
    NSArray *poiArray = result.poiList.copy;
    //POI信息类
    //poi列表
    for (BMKPoiInfo *info in poiArray) {
        NSLog(@"info.name ===  %@",info.name);
        NSLog(@"info.name ===  %@",info.address);
    }
}
#pragma ----- 返回地址信息搜索结果
- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher
                    result:(BMKGeoCodeResult *)result
                 errorCode:(BMKSearchErrorCode)error{
}

#pragma mark **************************** Public ***************************
//获得经纬度
//- (void)showUserLocationServiceWithComplete:(void(^)(BMKUserLocation *bmkUserLocation))block{
//    [self bmkLocationService];
//}
- (void)showUserLocationServiceWithComplete:(STBMKUserLocationComplete)block{
    [[self bmkLocationService] startUserLocationService];
    _stBMKUserLocationComplete = [block copy];
}
//根据经纬度 获得具体地址
#pragma mark - GetAdress from userLocation
////根据经纬度 获得具体地址
- (void)showAddressWithuserLocation:(BMKUserLocation *)userLocation
                           Complete:(STBMKReverseGeoCodeResultComplete)block{
    _stBMKReverseGeoCodeResultComplete = [block copy];
   
    //发起反地理编码
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude};
    //逆向编码对象
    BMKReverseGeoCodeOption *bmkReverseGeoCodeOption = [[BMKReverseGeoCodeOption alloc]init];
    //设置需要转化的经纬度
    bmkReverseGeoCodeOption.reverseGeoPoint = pt;
    //发送逆向地理编码-根据地理坐标获取地址信息
    BOOL flag = [ [self bmkGeoCodeSearch] reverseGeoCode:bmkReverseGeoCodeOption];
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
        //关闭定位
        [self.bmkLocationService stopUserLocationService];
    }
    else
    {
        NSLog(@"反geo检索发送失败");
        //关闭定位
        [self.bmkLocationService stopUserLocationService];
    }
    
}
//- (void)showAddressWithuserLocation:(BMKUserLocation *)userLocation
//                        andComplete:(void(^)(BMKGeoCodeSearch *searcher,
//                                             BMKReverseGeoCodeResult *result,
//                                             BMKSearchErrorCode error))block{
//    [self bmkGeoCodeSearch];
//     //发起反地理编码
//      CLLocationCoordinate2D pt = (CLLocationCoordinate2D){userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude};
//     //逆向编码对象
//      BMKReverseGeoCodeOption *bmkReverseGeoCodeOption = [[BMKReverseGeoCodeOption alloc]init];
//    //设置需要转化的经纬度
//    bmkReverseGeoCodeOption.reverseGeoPoint = pt;
//    //发送逆向地理编码-根据地理坐标获取地址信息
//       BOOL flag = [_bmkGeoCodeSearch reverseGeoCode:bmkReverseGeoCodeOption];
//    if(flag)
//    {
//        NSLog(@"反geo检索发送成功");
//    }
//    else
//    {
//        NSLog(@"反geo检索发送失败");
//    }
////    if (block) {
////       // _stBMKReverseGeoCodeResultComplete = [block copy];
////        block = [_stBMKReverseGeoCodeResultComplete copy];
////    }
//}
-(void)showSearchByKeyWords:(NSString *)searchKeyWords andNearbySearchwithUserLocation:(BMKUserLocation *)userLocation
                andComplete:(STBMKPoiResultComplete)block{
    _stBMKPoiResultComplete = [block copy];
    [self bmkPoiSearch];
    [self bmkNearbySearchOption];
    _bmkNearbySearchOption.pageIndex   = 0;      //分页索引，可选，默认为0
    _bmkNearbySearchOption.pageCapacity = 50;    //页数默认为10
    _bmkNearbySearchOption.radius       = 1000;  //周边检索半径
    //检索的中心点，经纬度
    _bmkNearbySearchOption.location = userLocation.location.coordinate;
    //搜索的关键字
    _bmkNearbySearchOption.keyword = searchKeyWords;
    //根据中心点、半径和检索词发起周边检索
    BOOL flag = [self.bmkPoiSearch poiSearchNearBy:self.bmkNearbySearchOption];
    if (flag) {
        NSLog(@"搜索成功");
        //关闭定位
        [self.bmkLocationService stopUserLocationService];
    }
    else {
        
        NSLog(@"搜索失败");
        //关闭定位
        [self.bmkLocationService stopUserLocationService];
    }
}

#pragma marl--------------------- <BMKPoiSearchDelegate>
/**
 *返回POI搜索结果
 *@param searcher 搜索对象
 *@param poiResult 搜索结果列表
 *@param errorCode 错误号，@see BMKSearchErrorCode
 */
- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResult errorCode:(BMKSearchErrorCode)errorCode{
    //若搜索成功
    if (errorCode ==BMK_SEARCH_NO_ERROR) {
        
       /* if (_stBMKPoiResultComplete) {
            _stBMKPoiResultComplete(searcher,poiResult,errorCode);
        }
        //POI信息类
        //poi列表
        for (BMKPoiInfo *info in poiResult.poiInfoList) {
            NSLog(@"info.name ===  %@",info.name);
             NSLog(@"info.name ===  %@",info.address);
        }*/
    }
    if (_stBMKPoiResultComplete) {
        _stBMKPoiResultComplete(searcher,poiResult,errorCode);
    }
    

    
}

/**
 *返回POI详情搜索结果
 *@param searcher 搜索对象
 *@param poiDetailResult 详情搜索结果
 *@param errorCode 错误号，@see BMKSearchErrorCode
 */
- (void)onGetPoiDetailResult:(BMKPoiSearch*)searcher result:(BMKPoiDetailResult*)poiDetailResult errorCode:(BMKSearchErrorCode)errorCode{
}

/**
 *返回POI室内搜索结果
 *@param searcher 搜索对象
 *@param poiIndoorResult 搜索结果列表
 *@param errorCode 错误号，@see BMKSearchErrorCode
 */
- (void)onGetPoiIndoorResult:(BMKPoiSearch*)searcher result:(BMKPoiIndoorResult*)poiIndoorResult errorCode:(BMKSearchErrorCode)errorCode{
    
}








//获取 省 市 地理位置 经纬度
-(void)showAdressLatitudeLongitudeDataComplete:(void(^)(BOOL finished))block{
    //开启定位
    [[FWHUDHelper sharedInstance]syncLoading:@"定位中..."];
    __weak typeof(self)weak_Self = self;
    // 位置
    [weak_Self  showUserLocationServiceWithComplete:^(BMKUserLocation *bmkUserLocation) {
       [weak_Self showAddressWithuserLocation:bmkUserLocation
                                     Complete:^(BMKGeoCodeSearch        *search,
                                                BMKReverseGeoCodeResult *result,
                                                BMKSearchErrorCode      error) {
                                         
           weak_Self.provinceStr     = result.addressDetail.province;
           weak_Self.cityNameStr     = result.addressDetail.city;
           weak_Self.detailAdressStr = result.address;
           weak_Self.longitudeValue  = bmkUserLocation.location.coordinate.longitude;
           weak_Self.latitudeValue   = bmkUserLocation.location.coordinate.latitude;
           weak_Self.poiListMArray = result.poiList.mutableCopy;
           [[FWHUDHelper sharedInstance] syncStopLoading];
                                         if (block) {
                                             block(YES);
                                         }
       }];
    }];
    
}






//关键字搜索 返回结果
-(void)showSearchByKeyWords:(NSString *)searchKeyWords
                   latitude:(CGFloat)latitude
                  longitude:(CGFloat)longitude
                andComplete:(STBMKPoiResultComplete)block{
    _stBMKPoiResultComplete = [block copy];
    [self bmkPoiSearch];
    [self bmkNearbySearchOption];
    _bmkNearbySearchOption.pageIndex   = 0;      //分页索引，可选，默认为0
    _bmkNearbySearchOption.pageCapacity = 50;    //页数默认为10
    _bmkNearbySearchOption.radius       = 1000;  //周边检索半径
    //
    //检索的中心点，经纬度
    CLLocationCoordinate2D location;
    location.latitude = latitude;
    location.longitude = longitude;
    _bmkNearbySearchOption.location = location;
    //key words
     _bmkNearbySearchOption.keyword = searchKeyWords;
    //根据中心点、半径和检索词发起周边检索
    BOOL flag = [self.bmkPoiSearch poiSearchNearBy:self.bmkNearbySearchOption];
    if (flag) {
        NSLog(@"搜索成功1");
        //关闭定位
        [self.bmkLocationService stopUserLocationService];
    }
    else {
        NSLog(@"搜索失败2");
        //关闭定位
        [self.bmkLocationService stopUserLocationService];
    }
}

- (void)detailPlaceStr
{
    if ([self.detailAdressStr rangeOfString:self.provinceStr].location !=NSNotFound)
    {
        self.detailAdressStr = [self.detailAdressStr stringByReplacingOccurrencesOfString:self.provinceStr withString:@""];
    }
    if ([self.detailAdressStr rangeOfString:self.cityNameStr].location !=NSNotFound)
    {
        self.detailAdressStr = [self.detailAdressStr stringByReplacingOccurrencesOfString:self.cityNameStr withString:@""];
    }
}



#pragma mark**************************** Getter ********************
#pragma mark -------- provinceStr
-(NSString *)provinceStr{
    if (!_provinceStr) {
        _provinceStr = @"";
    }
    return _provinceStr;
}
#pragma mark -------- _cityNameStr
-(NSString *)cityNameStr{
    if (!_cityNameStr) {
        _cityNameStr = @"";
    }
    return _cityNameStr;
}
#pragma mark -------- detailAdressStr
-(NSString *)detailAdressStr{
    if (!_detailAdressStr) {
        _detailAdressStr = @"";
    }
    return _detailAdressStr;
}
#pragma mark -------- latitudeValue
-(CGFloat )latitudeValue{
    if (!_latitudeValue) {
        _latitudeValue = 0;
    }
    return _latitudeValue;
}
#pragma mark -------- longitudeValue
-(CGFloat)longitudeValue{
    if (!_longitudeValue) {
        _longitudeValue = 0;
    }
    return _longitudeValue;
}
#pragma mark -------- provinceStr
-(NSMutableArray *)poiListMArray{
    if (!_poiListMArray) {
        _poiListMArray = @[].mutableCopy;
    }
    return _poiListMArray;
}







@end
