//
//  MapViewController.m
//  FanweApp
//
//  Created by GuoMs on 16/8/11.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "MapViewController.h"
#import <QMapKit/QMapKit.h>
#import <QMapSearchKit/QMapSearchKit.h>
#import "SearchAddressController.h"
#import "MBProgressHUD.h"

//#define kDefaultMargin 10 //边距
#define kSubmitBtnHeight 45 //提交等按钮的高度
#define IOS7 [[[UIDevice currentDevice]systemVersion] floatValue] >= 7.0
@interface MapViewController ()<QMapViewDelegate,QMSSearchDelegate,SelectedAdressDelegate,MBProgressHUDDelegate,UITextFieldDelegate>
{
    UIImageView *_image;
    SearchAddressController *_searchAddressController;//地图检索
    
    UITextField *_searchTF;
    UILabel *_addressLabel;
    UIButton *_rightTopBtn;
    UIButton *_submitBtn;
    
    NSString *_addressStr;
    
    MBProgressHUD *_HUD;
}

@property (nonatomic, strong) QMapView *myMapView;
@property (nonatomic, strong) QMSSearcher *mapSearcher;

@end

@implementation MapViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"选择位置";
    self.view.backgroundColor = kBackGroundColor;
    self.navigationItem.leftBarButtonItem=[UIBarButtonItem itemWithTarget:self action:@selector(returnToMeVc) image:@"com_arrow_vc_back" highImage:@"com_arrow_vc_back"];
    
    if (IOS7)
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    //1.获取主队列
    dispatch_queue_t queue=dispatch_get_main_queue();
    
    //2.把任务添加到主队列中执行
    dispatch_async(queue, ^{
        if (!_myMapView) {
            _myMapView = [[QMapView alloc]initWithFrame:CGRectMake(0, 0, kScreenW,kScreenH - 64)];
            _myMapView.delegate = self;
            [_myMapView setShowsUserLocation:YES];
            [self.view addSubview:_myMapView];
        }
        if (!_mapSearcher) {
            self.mapSearcher = [[QMSSearcher alloc] init];
            self.mapSearcher.delegate = self;
        }

        if (_location.longitude && _location.latitude) {
            CLLocationCoordinate2D pt = (CLLocationCoordinate2D){_location.latitude, _location.longitude};
            _myMapView.centerCoordinate = pt;
        }else if(_addressName && ![_addressName isEqualToString:@""]){
            [self performSelector:@selector(searchForPoint) withObject:nil afterDelay:1];
        }else if (self.fanweApp.latitude && self.fanweApp.longitude){
            CLLocationCoordinate2D pt = (CLLocationCoordinate2D){self.fanweApp.latitude, self.fanweApp.longitude};
            _myMapView.centerCoordinate = pt;
        }
        
        _image = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenW-30)/2, (kScreenH-64-30)/2-17, 30, 30)];
        [_image setImage:[UIImage imageNamed:@"com_location_1"]];
        [self.view addSubview:_image];
        
        [self initMyView];
    });
    dispatch_async(queue, ^{
        self.myMapView.zoomLevel = 15;
    });

}
#pragma mark - 返回上一级
- (void)returnToMeVc{
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)initMyView{
    
    _rightTopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightTopBtn.frame = CGRectMake(0, 0, 70, 30);
    _rightTopBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_rightTopBtn setTitleColor:kAppMainColor forState:UIControlStateNormal];
    [_rightTopBtn setTitle:@"我的位置" forState:UIControlStateNormal];
    [_rightTopBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightTopBtn];
    
    UIView *searchBottomView = [[UIView alloc]initWithFrame:CGRectMake(kDefaultMargin, kDefaultMargin, kScreenW-kDefaultMargin*2, kSubmitBtnHeight)];
    searchBottomView.backgroundColor = [UIColor whiteColor];
    searchBottomView.layer.cornerRadius = kCornerRadius;
    searchBottomView.clipsToBounds = YES;
    [self.view addSubview:searchBottomView];
    
    UIImageView *searchImgView = [[UIImageView alloc]initWithFrame:CGRectMake(kDefaultMargin/2, (kSubmitBtnHeight-20)/2, 20, 20)];
    [searchImgView setImage:[UIImage imageNamed:@"hm_search"]];
    [searchBottomView addSubview:searchImgView];
    
    _searchTF = [[UITextField alloc]initWithFrame:CGRectMake(kDefaultMargin+20, 0, kScreenW-kDefaultMargin*3-20, kSubmitBtnHeight)];
    [_searchTF addTarget:self action:@selector(textChangeAction) forControlEvents:UIControlEventEditingChanged];
    _searchTF.delegate = self;
    _searchTF.clearButtonMode = UITextFieldViewModeAlways;
    _searchTF.placeholder = @"请输入要查询的地址名称";
    _searchTF.font = [UIFont systemFontOfSize:14.0];
    [searchBottomView addSubview:_searchTF];
    
    UIView *addressBottomView = [[UIView alloc]initWithFrame:CGRectMake(kDefaultMargin, kDefaultMargin+CGRectGetMaxY(searchBottomView.frame), kScreenW-kDefaultMargin*2, kSubmitBtnHeight)];
    addressBottomView.backgroundColor = [UIColor whiteColor];
    addressBottomView.layer.cornerRadius = kCornerRadius;
    addressBottomView.clipsToBounds = YES;
    [self.view addSubview:addressBottomView];
    
    UIImageView *addressImgView = [[UIImageView alloc]initWithFrame:CGRectMake(kDefaultMargin/2+2, (kSubmitBtnHeight-20)/2, 25/2,33 / 2)];
    [addressImgView setImage:[UIImage imageNamed:@"com_location_1"]];
    [addressBottomView addSubview:addressImgView];
    
    _addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(kDefaultMargin+20, 0, kScreenW-kDefaultMargin*3-20, kSubmitBtnHeight)];
    _addressLabel.numberOfLines = 2;
    _addressLabel.textColor = myTextColor2;
    _addressLabel.backgroundColor = [UIColor whiteColor];
    _addressLabel.font = [UIFont systemFontOfSize:14.0];
    [addressBottomView addSubview:_addressLabel];
    
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenH-64-kSubmitBtnHeight-15, kScreenW, kSubmitBtnHeight+15)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    //确定 按钮
    _submitBtn = [[UIButton alloc]initWithFrame:CGRectMake(kDefaultMargin, (CGRectGetHeight(bottomView.frame)-kSubmitBtnHeight)/2, kScreenW-(2*kDefaultMargin), kSubmitBtnHeight)];
    [_submitBtn setTitle:@"确定" forState:UIControlStateNormal];
    [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    _submitBtn.backgroundColor = kAppMainColor;
    _submitBtn.layer.cornerRadius = kCornerRadius;
    _submitBtn.clipsToBounds = YES;
    _submitBtn.titleLabel.font = [UIFont systemFontOfSize: 16.0];
    _submitBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [bottomView addSubview:_submitBtn];
    [_submitBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _searchAddressController = [[SearchAddressController alloc] init];
    _searchAddressController.delegate = self;
    _searchAddressController.view.hidden = YES;
    _searchAddressController.view.frame = CGRectMake(0, CGRectGetMaxY(addressBottomView.frame),kScreenW, kScreenH-64-CGRectGetMaxY(addressBottomView.frame)-CGRectGetHeight(bottomView.frame));
    [_searchAddressController innitUI];
    [self.view addSubview:_searchAddressController.view];
    
}
- (void)btnAction:(id)sender{
    if (sender == _rightTopBtn) {
        if (self.fanweApp.latitude && self.fanweApp.longitude){
            CLLocationCoordinate2D pt = (CLLocationCoordinate2D){self.fanweApp.latitude, self.fanweApp.longitude};
            _myMapView.centerCoordinate = pt;
        }
    }else if (sender == _submitBtn){
        if (_delegate)
        {
            [_delegate chooseAddress:_location address:_addressStr andProvinceString:@"" andCityString:@"" andAreaString:@""];
        }
        if (_fromType == 0) {
            self.fanweApp.latitude = _myMapView.centerCoordinate.latitude;
            self.fanweApp.longitude = _myMapView.centerCoordinate.longitude;
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
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
        self.fanweApp.latitude = coordinate.latitude;
        self.fanweApp.longitude = coordinate.longitude;
    }
    NSLog(@"%f-------%f",self.fanweApp.latitude,self.fanweApp.longitude);
//    self.mapSearcher = [[QMSSearcher alloc]initWithDelegate:self];
//
//    //配置搜索参数
//    QMSReverseGeoCodeSearchOption *reGeoSearchOption = [[QMSReverseGeoCodeSearchOption alloc] init];
//    [reGeoSearchOption setLocationWithCenterCoordinate:mapView.centerCoordinate];
//    [reGeoSearchOption setGet_poi:YES];
//    [self.mapSearcher searchWithReverseGeoCodeSearchOption:reGeoSearchOption];
}

/*!
 *  @brief  地图区域即将改变时会调用此接口
 *
 *  @param mapView  地图view
 *  @param animated 是否采用动画
 */
- (void)mapView:(QMapView *)mapView regionWillChangeAnimated:(BOOL)animated{
    //[self showHUD];
    _location = mapView.region.center;
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){0, 0};
    if (_location.longitude != 0 && _location.latitude != 0) {
        pt = (CLLocationCoordinate2D){_location.latitude, _location.longitude};
    }
//    //配置搜索参数
//    QMSReverseGeoCodeSearchOption *reGeoSearchOption = [[QMSReverseGeoCodeSearchOption alloc] init];
//    [reGeoSearchOption setLocationWithCenterCoordinate:mapView.centerCoordinate];
//    [reGeoSearchOption setGet_poi:YES];
//    [self.mapSearcher searchWithReverseGeoCodeSearchOption:reGeoSearchOption];
}
#pragma mark 反向地理编码
- (void)searchWithReverseGeoCodeSearchOption:(QMSReverseGeoCodeSearchOption *)reverseGeoCodeSearchOption didReceiveResult:(QMSReverseGeoCodeSearchResult *)reverseGeoCodeSearchResult
{
    NSLog(@"%@",reverseGeoCodeSearchResult.ad_info);
    if (reverseGeoCodeSearchResult)
    {
        if (reverseGeoCodeSearchResult.address && ![reverseGeoCodeSearchResult.address isEqualToString:@""]){
            
            QMSReGeoCodeAdInfo *reGeoCodeAdInfo = reverseGeoCodeSearchResult.ad_info;
            self.fanweApp.locationCity = reGeoCodeAdInfo.city;
            self.fanweApp.locateName = reverseGeoCodeSearchResult.formatted_addresses.recommend;
            self.fanweApp.province = reverseGeoCodeSearchResult.ad_info.province;
            self.fanweApp.area = reverseGeoCodeSearchResult.ad_info.district;
            NSMutableDictionary *mdic = [NSMutableDictionary dictionary];

            [mdic setObject:[NSString stringWithFormat:@"%.8f",self.fanweApp.longitude] forKey:@"lng"];
            [mdic setObject:[NSString stringWithFormat:@"%.8f",self.fanweApp.latitude] forKey:@"lat"];
            if (![reverseGeoCodeSearchResult.ad_info.province isEqual:@""]&&reverseGeoCodeSearchResult.ad_info.province) {
                
                [mdic setObject:reverseGeoCodeSearchResult.ad_info.province forKey:@"province"];
            }
            if (![reverseGeoCodeSearchResult.ad_info.city isEqual:@""]&&reverseGeoCodeSearchResult.ad_info.city) {
                
                [mdic setObject:reverseGeoCodeSearchResult.ad_info.city forKey:@"city"];
            }
            if (![reverseGeoCodeSearchResult.ad_info.district isEqual:@""]&&reverseGeoCodeSearchResult.ad_info.district) {
                
                [mdic setObject:reverseGeoCodeSearchResult.ad_info.district forKey:@"area"];
            }

               self.fanweApp.addressJsonStr = [FWUtils dataTOjsonString:mdic];
            _addressStr = self.fanweApp.locateName;
//            NSLog(@"%@",reverseGeoCodeSearchResult.formatted_addresses.recommend);
            _addressLabel.text = _addressStr;
            [self hideHUD];
        }
    }
}

- (void)searchWithSuggestionSearchOption:(QMSSuggestionSearchOption *)suggestionSearchOption didReceiveResult:(QMSSuggestionResult *)suggestionSearchResult
{
    QMSSuggestionPoiData *poiData = [suggestionSearchResult.dataArray firstObject];
    CLLocationCoordinate2D coor = poiData.location;
    _myMapView.centerCoordinate = coor;
    
}
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
- (void)textChangeAction{
    
    _searchAddressController.view.hidden = NO;
    if ([_searchTF.text isEqualToString:@""]) {
        _searchAddressController.view.hidden = YES;
    }else{
        [_searchAddressController searchCityname:self.fanweApp.locationCity keyword:_searchTF.text];
    }
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    
    _searchAddressController.view.hidden = YES;
    
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    return YES;
}

#pragma marks  ------协议-----------------
- (void)SelectedAdress:(NSString *)adress withPt:(CLLocationCoordinate2D)pt andProvinceStr:(NSString *)provinceStr andCityStr:(NSString *)cityStr andAreaStr:(NSString *)areaStr {
    _location = pt;
    _addressStr = adress;
    if (_delegate)
    {
        [_delegate chooseAddress:_location address:_addressStr andProvinceString:provinceStr andCityString:cityStr andAreaString:areaStr];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)showHUD
{
    if(_HUD==nil)
    {
        _HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:_HUD];
        [self.view bringSubviewToFront:_HUD];
        _HUD.userInteractionEnabled = NO;
        _HUD.delegate = self;
        [_HUD showAnimated:YES];
    }
    else
    {
        [self.view addSubview:_HUD];
        [_HUD showAnimated:YES];
    }
}

- (void)hideHUD
{
    if(_HUD)
    {
        [_HUD hideAnimated:YES];
    }
}

- (void)searchWithSearchOption:(QMSSearchOption *)searchOption didFailWithError:(NSError*)error
{
    [self hideHUD];
    [[FWHUDHelper sharedInstance] tipMessage:[NSString stringWithFormat:@"%@",error]];
}

- (void)searchForPoint{
    //配置搜索参数
    QMSSuggestionSearchOption *suggetionOption = [[QMSSuggestionSearchOption alloc] init];
    [suggetionOption setKeyword:_addressName];
    [suggetionOption setRegion:_addressName];
    [self.mapSearcher searchWithSuggestionSearchOption:suggetionOption];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_searchTF resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
