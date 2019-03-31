//
//  EnterAddressController.h
//  O2O
//
//  Created by fanwe2014 on 15/7/27.
//  Copyright (c) 2015年 fanwe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QMapKit/QMapKit.h>
#import <QMapSearchKit/QMapSearchKit.h>

@class SearchAddressController;
@protocol SelectedAdressDelegate<NSObject>

- (void)SelectedAdress:(NSString *)adress withPt:(CLLocationCoordinate2D)pt andProvinceStr:(NSString *)provinceStr andCityStr:(NSString *)cityStr andAreaStr:(NSString *)areaStr;

@end

@interface SearchAddressController : UIViewController

@property (nonatomic, weak) id<SelectedAdressDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (void)innitUI;
- (void)searchCityname:(NSString *)cityname keyword:(NSString *)keyword;

@end
