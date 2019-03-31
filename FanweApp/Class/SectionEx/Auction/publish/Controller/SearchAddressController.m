//
//  EnterAddressController.m
//  O2O
//
//  Created by fanwe2014 on 15/7/27.
//  Copyright (c) 2015年 fanwe. All rights reserved.
//

#import "SearchAddressController.h"
#import "EnterAdrssCell.h"

@interface SearchAddressController ()<UITableViewDataSource,UITableViewDelegate,QMSSearchDelegate>
{
    NSMutableArray *_searchArray;
    NSMutableArray *_poiArray;
    NSMutableArray *_descriptionArray;
    NSMutableArray *_provinceArray;
    NSMutableArray *_cityArray;
    NSMutableArray *_areaArray;
}
@property (nonatomic, strong) QMSSearcher *mapSearcher;
@end

@implementation SearchAddressController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mapSearcher = [[QMSSearcher alloc] initWithDelegate:self];
    
    [self innitUI];
    
}

- (void)searchCityname:(NSString *)cityname keyword:(NSString *)keyword
{
    _searchArray = [[ NSMutableArray alloc] init];
    _poiArray    = [[ NSMutableArray alloc] init];
    _descriptionArray = [[ NSMutableArray alloc] init];
    
    _provinceArray   = [[ NSMutableArray alloc] init];
    _cityArray       = [[ NSMutableArray alloc] init];
    _areaArray       = [[ NSMutableArray alloc] init];
    
    //配置搜索参数
    QMSSuggestionSearchOption *suggetionOption = [[QMSSuggestionSearchOption alloc] init];
    [suggetionOption setKeyword:keyword];
    [suggetionOption setRegion:cityname];
    
    [self.mapSearcher searchWithSuggestionSearchOption:suggetionOption];
    
}

//关键字的补完与提示回调接口
- (void)searchWithSuggestionSearchOption:(QMSSuggestionSearchOption *)suggestionSearchOption didReceiveResult:(QMSSuggestionResult *)suggestionSearchResult
{
    //在此处理正常结果
    for (int i=0; i<suggestionSearchResult.dataArray.count; i++)
    {
        
        QMSSuggestionPoiData *poiData = [suggestionSearchResult.dataArray objectAtIndex:i];
        CLLocationCoordinate2D coor;
        coor = poiData.location;
        NSValue *value=[NSValue valueWithBytes:&coor objCType:@encode(CLLocationCoordinate2D)];//对结构体进行封装
        
        if (poiData.location.latitude || poiData.location.longitude)
        {
            if (poiData.address.length>0)
            {
                [_searchArray addObject:poiData.address];
            }
            else
            {
                [_searchArray addObject:@""];
            }
            [_poiArray addObject:value];
            if (poiData.district)
            {
                [_descriptionArray addObject:poiData.district];
            }else{
                [_descriptionArray addObject:@" "];
            }
            
            if (poiData.province.length>0)
            {
                [_provinceArray addObject:poiData.province];
            }else
            {
               [_provinceArray addObject:@""];
            }
            
            if (poiData.city.length>0)
            {
                [_cityArray addObject:poiData.city];
            }else
            {
                [_cityArray addObject:@""];
            }
            
            if (poiData.district.length>0)
            {
                [_areaArray addObject:poiData.district];
            }else
            {
                [_areaArray addObject:@""];
            }
        }
    }
    
    [self.tableView reloadData];
}

- (void)innitUI{

    CGRect mainFrme = self.view.frame;
    mainFrme.origin.y = 0;

    self.tableView.frame = mainFrme;
    self.tableView.backgroundColor =kBackGroundColor;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
 
}


#pragma marks ==============================table协议==============================================

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 61.0f;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _searchArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EnterAdrssCell * cell = [EnterAdrssCell cellWithTableView:self.tableView];
    if (_searchArray && _descriptionArray && _searchArray.count > indexPath.row && _descriptionArray.count > indexPath.row )
    {
        NSUInteger row = [indexPath row];
        NSString *key = [_searchArray objectAtIndex:row];
        NSString *description = [_descriptionArray objectAtIndex:row];
        [cell setCellContent:key description:description];
    }
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_poiArray.count > indexPath.row)
    {
        NSValue *a = [_poiArray objectAtIndex:indexPath.row];
        CLLocationCoordinate2D coor;
        [a getValue:&coor];
        
        if ([_delegate respondsToSelector:@selector(SelectedAdress:withPt:andProvinceStr:andCityStr:andAreaStr:)])
        {
            [_delegate SelectedAdress:[_searchArray objectAtIndex:indexPath.row] withPt:coor andProvinceStr:[_provinceArray objectAtIndex:indexPath.row] andCityStr:[_cityArray objectAtIndex:indexPath.row] andAreaStr:[_areaArray objectAtIndex:indexPath.row]];
        }
    }
}

@end
