//
//  QMapLocationView.m
//  O2O
//
//  Created by xfg on 15/9/10.
//  Copyright (c) 2015年 fanwe. All rights reserved.
//

#import "QMapLocationView.h"

#define kStopLocationTime 60 //停止定位时间

@interface QMapLocationView()<QMapViewDelegate,QMSSearchDelegate>

@property (nonatomic, strong) QMapView *mapView; //腾讯地图
@property (nonatomic, strong) QMSSearcher *mapSearcher;

@end

@implementation QMapLocationView

static id _instance;
+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone
{
    return _instance;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return _instance;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _fanweApp = [GlobalVariables sharedInstance];
        self.mapView = [[QMapView alloc]initWithFrame:self.bounds];
        [self addSubview:self.mapView];
        self.mapView.userTrackingMode = QUserTrackingModeFollowWithHeading;
        self.mapSearcher = [[QMSSearcher alloc] init];
    }
    return self;
}

#pragma mark 开始定位
- (void)startLocate
{
    if (!self.mapView.delegate){
        self.mapView.delegate = self;
        self.mapSearcher.delegate = self;
        [self.mapView setShowsUserLocation:YES];
        [self performSelector:@selector(stopLocate) withObject:nil afterDelay:kStopLocationTime];
    }
}

#pragma mark 停止定位
- (void)stopLocate{
    if (self.mapView.delegate){
        [self.mapView setShowsUserLocation:NO];
        self.mapView.delegate = nil;
        self.mapSearcher.delegate = nil;
    }
}

#pragma mark 重新定位
- (void)locateAgain{
    self.mapView.delegate = self;
    self.mapSearcher.delegate = self;
    [self.mapView setShowsUserLocation:YES];
    _locateNum = 1;
    [self performSelector:@selector(stopLocate) withObject:nil afterDelay:kStopLocationTime];
}

/*!
 *  @brief  在地图view将要启动定位时，会调用此函数
 *
 *  @param mapView 地图view
 */
- (void)mapViewWillStartLocatingUser:(QMapView *)mapView{
    
}

/*!
 *  @brief  在地图view定位停止后，会调用此函数
 *
 *  @param mapView 地图view
 */
- (void)mapViewDidStopLocatingUser:(QMapView *)mapView{
    
}

/*!
 *  @brief  位置或者设备方向更新后，会调用此函数
 *
 *  @param mapView          地图view
 *  @param userLocation     用户定位信息(包括位置与设备方向等数据)
 *  @param updatingLocation 标示是否是location数据更新, YES:location数据更新 NO:heading数据更新
 */
- (void)mapView:(QMapView *)mapView didUpdateUserLocation:(QUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation{
    CLLocationCoordinate2D coordinate = userLocation.coordinate;
    if (coordinate.latitude && coordinate.longitude) {
        _fanweApp.latitude = coordinate.latitude;
        _fanweApp.longitude = coordinate.longitude;
        //        NSLog(@"----_fanweApp.latitude:%f",_fanweApp.latitude);
        //        NSLog(@"----_fanweApp.longitude:%f",_fanweApp.longitude);
    }
    if (_fanweApp.latitude || _fanweApp.longitude) {
        if (_delegate && [_delegate respondsToSelector:@selector(startLoadView)]) {
            [_delegate startLoadView];
        }
    }
    
//    //配置搜索参数
//    QMSReverseGeoCodeSearchOption *reGeoSearchOption = [[QMSReverseGeoCodeSearchOption alloc] init];
//    [reGeoSearchOption setLocationWithCenterCoordinate:coordinate];
//    [reGeoSearchOption setGet_poi:YES];
//    [self.mapSearcher searchWithReverseGeoCodeSearchOption:reGeoSearchOption];
}

#pragma mark 反向地理编码
- (void)searchWithReverseGeoCodeSearchOption:(QMSReverseGeoCodeSearchOption *)reverseGeoCodeSearchOption didReceiveResult:(QMSReverseGeoCodeSearchResult *)reverseGeoCodeSearchResult
{
    
    if (reverseGeoCodeSearchResult) {
        if (reverseGeoCodeSearchResult.address && ![reverseGeoCodeSearchResult.address isEqualToString:@""]){
            
            QMSReGeoCodeAdInfo *reGeoCodeAdInfo = reverseGeoCodeSearchResult.ad_info;
            if (reGeoCodeAdInfo)
            {
                _fanweApp.locationCity = reGeoCodeAdInfo.city;
                _fanweApp.province =  reverseGeoCodeSearchResult.ad_info.province;
                _fanweApp.area = reverseGeoCodeSearchResult.ad_info.district;
                _fanweApp.locateName = reverseGeoCodeSearchResult.formatted_addresses.recommend;
                NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
                //                [mdic setObject:reverseGeoCodeSearchResult.formatted_addresses.recommend forKey:@"recommend"];
                [mdic setObject:[NSString stringWithFormat:@"%.8f",_fanweApp.latitude] forKey:@"lat"];
                [mdic setObject:[NSString stringWithFormat:@"%.8f",_fanweApp.longitude]  forKey:@"lng"];
                if (![reverseGeoCodeSearchResult.ad_info.province isEqual:@""]&&reverseGeoCodeSearchResult.ad_info.province) {
                    
                    [mdic setObject:reverseGeoCodeSearchResult.ad_info.province forKey:@"province"];
                }
                if (![reverseGeoCodeSearchResult.ad_info.city isEqual:@""]&&reverseGeoCodeSearchResult.ad_info.city) {
                    
                    [mdic setObject:reverseGeoCodeSearchResult.ad_info.city forKey:@"city"];
                }
                if (![reverseGeoCodeSearchResult.ad_info.district isEqual:@""]&&reverseGeoCodeSearchResult.ad_info.district) {
                    
                    [mdic setObject:reverseGeoCodeSearchResult.ad_info.district forKey:@"area"];
                }
                
                _fanweApp.addressJsonStr = [FWUtils dataTOjsonString:mdic];
//                NSLog(@"========ssss:%@",_fanweApp.addressJsonStr);
                
                NSString *strUrl = [_fanweApp.addressJsonStr stringByReplacingOccurrencesOfString:@" " withString:@""];
//                NSLog(@"========bbbb:%@",strUrl);
                
                NSString *strUrl2 = [strUrl stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//                NSLog(@"========bbbb:%@",strUrl2);
                
                _fanweApp.addressJsonStr = strUrl2;
                
            }
            
            if (_locateNum<2) {
                if (_delegate && [_delegate respondsToSelector:@selector(reverseGeoCodeResult:)]) {
                    [_delegate reverseGeoCodeResult:reverseGeoCodeSearchResult];
                }
                _locateNum++;
            }
        }
    }
}

/*!
 *  @brief  定位失败后，会调用此函数
 *
 *  @param mapView 地图view
 *  @param error   错误号，参考CLError.h中定义的错误号
 */
#pragma mark -- 定位失败
- (void)mapView:(QMapView *)mapView didFailToLocateUserWithError:(NSError *)error {
    NSLog(@"定位失败");
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
    {
        // 用户关闭了该应用的定位权限.
        [FanweMessage alert:@"您关闭了该应用的定位权限.请在设置->隐私->定位服务->本App下选择使用期间"];
        NSLog(@"用户关闭了该应用的定位权限.");
        
    }
    
}
@end
