//
//  areaView.m
//  FanweApp
//
//  Created by fanwe2014 on 16/7/19.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "areaView.h"
#import "areaModel.h"

#define CANCLE_LABEL_TAG        11
#define CONFRM_LABEL_TAG        12

@interface areaView ()<UIPickerViewDataSource,UIPickerViewDelegate>
{
    UIPickerView *pickView;
    NetHttpsManager *_httpManager;
    NSString *_provinceId;
    NSString *_provinceString;//省份
    NSString *_cityString;//城市
    NSArray *_placeArray;
    GlobalVariables *_fanweApp;
    int _provinceCount;//省份的下标以备好加载传过来的省份
    int _cityCount;//城市的下标以备好加载传过来的城市
}

@property (nonatomic, assign) NSInteger firstCurrentIndex;//第一行当前位置
@property (nonatomic, assign) NSInteger secondCurrentIndex;//第二行当前位置

@end

@implementation areaView

- (id)initWithDelegate:(id<AreaDelegate>)delegate withCity:(NSString *)city
{
    if (self = [super init])
    {
        _provinceCount = 0;
        _cityString = 0;
        _fanweApp = [GlobalVariables sharedInstance];
        _placeArray = [city componentsSeparatedByString:@" "];
        if (_placeArray.count > 1)
        {
            _provinceString = [_placeArray firstObject];
            _cityString = [_placeArray lastObject];
        }
        _httpManager = [NetHttpsManager manager];
        self.proniceArray = [[NSMutableArray alloc]init];
        self.cityArray = [[NSMutableArray alloc]init];
        self.bigArray = [[NSMutableArray alloc]init];
        self.backgroundColor = kBackGroundColor;
        self.delegate = delegate;
        
        //存版本
        NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
        NSString *filePath = [cachePath stringByAppendingPathComponent:@"versions.plist"];
        NSMutableDictionary *dict1 = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
        NSString *versions = [dict1 objectForKey:@"versions"];
        if ([versions isEqualToString:_fanweApp.appModel.region_versions])
        {
            //获取Documents目录
            NSString *docPath2 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
            //还要指定存储文件的文件名称,仍然使用字符串拼接
            NSString *filePath2 = [docPath2 stringByAppendingPathComponent:@"Province.plist"];
            self.allArray = [NSMutableArray arrayWithContentsOfFile:filePath2];
            
            if (self.allArray && [self.allArray isKindOfClass:[NSMutableArray class]])
            {
                [self setRegionList:self.allArray];
            }else
            {
                self.allArray = [[NSMutableArray alloc]init];
                [self loadNet];
            }
        }else
        {
            self.allArray = [[NSMutableArray alloc]init];
            [self loadNet];
        }
        
    }
    return self;
}

//取数据
- (void)setRegionList:(NSMutableArray *)allDataArray{
    for (NSDictionary *dict in allDataArray)
    {
        areaModel *model = [[areaModel alloc]init];
        if ([[dict toString:@"region_level"] isEqualToString:@"2"])
        {
            model.id = [dict toString:@"id"];
            model.pid= [dict toString:@"pid"];
            model.name = [dict toString:@"name"];
            model.region_level = [dict toString:@"region_level"];
            model.modelArray = [[NSMutableArray alloc]init];
            for (NSDictionary *dict1 in allDataArray)
            {
                if ([model.id isEqualToString:[dict1 toString:@"pid"]])
                {
                    [model.modelArray addObject:[dict1 toString:@"name"]];//存城市
                }
            }
            [_bigArray addObject:model];//大数组存储省份的数据和省份对应的城市
        }
    }
    [self laodNowLocationData];//加载传过来的省份和城市
    [self createView];
}

//获取当前省份和城市的下标
-( void)laodNowLocationData
{
    for (int i = 0; i < _bigArray.count ; i ++)
    {
        areaModel *model = _bigArray[i];
        // model.modelArray = [[NSMutableArray alloc]init];
        if ([model.name isEqualToString:_provinceString])
        {
            _provinceCount = i;
            for (int j = 0; j < model.modelArray.count; j ++)
            {
                if ([model.modelArray[j] isEqualToString:_cityString])
                {
                    _cityCount = j;
                }
            }
        }
    }
}

//加载数据
- (void)loadNet
{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"user_center" forKey:@"ctl"];
    [parmDict setObject:@"region_list" forKey:@"act"];
    [_httpManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson)
     {
         if ([responseJson toInt:@"status"] == 1)
         {
             //存版本
             NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
             NSString *filePath = [cachePath stringByAppendingPathComponent:@"versions.plist"];
             NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
             [dict1 setObject:[responseJson toString:@"region_versions"] forKey:@"versions"];
             [dict1 writeToFile:filePath atomically:YES];
             
             
             NSArray *areaArray = [responseJson objectForKey:@"region_list"];
             if (areaArray)
             {
                 if (areaArray.count > 0  && [areaArray isKindOfClass:[NSArray class]])
                 {
                     //获取Documents目录
                     NSString *docPath2 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
                     //还要指定存储文件的文件名称,仍然使用字符串拼接
                     NSString *filePath2 = [docPath2 stringByAppendingPathComponent:@"Province.plist"];
                     NSLog(@"filePath2==%@",filePath2);
                     [areaArray writeToFile:filePath2 atomically:YES];
                     
                     self.allArray = [NSMutableArray arrayWithArray:areaArray];
                     [self setRegionList:self.allArray];
                 }
             }
         }
         
     } FailureBlock:^(NSError *error)
     {
         
     }];
}

//创建UI控件
- (void)createView
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 40)];
    view.backgroundColor = kBackGroundColor;
    [self addSubview:view];
    
    UILabel *cancle = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 60, 40)];
    cancle.userInteractionEnabled = YES;
    cancle.text = @"取消";
    cancle.tag = CANCLE_LABEL_TAG;
    cancle.textColor = kAppGrayColor1;
    cancle.textAlignment = NSTextAlignmentCenter;
    [self addSubview:cancle];
    UITapGestureRecognizer *canTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [cancle addGestureRecognizer:canTap];
    
    UILabel *confrm = [[UILabel alloc] initWithFrame:CGRectMake(kScreenW - 70, 0, 60, 40)];
    confrm.userInteractionEnabled = YES;
    confrm.text = @"确认";
    confrm.tag  = CONFRM_LABEL_TAG;
    confrm.textColor = kAppGrayColor1;
    confrm.textAlignment = NSTextAlignmentCenter;
    [self addSubview:confrm];
    UITapGestureRecognizer *conTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [confrm addGestureRecognizer:conTap];
    
    pickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, kScreenW, 150)];
    pickView.backgroundColor  = kWhiteColor;
    pickView.delegate = self;
    pickView.dataSource = self;
    _firstCurrentIndex = _provinceCount;
    _secondCurrentIndex = _cityCount;
    [pickView selectRow:_provinceCount inComponent:0 animated:YES];
    [pickView selectRow:_cityCount inComponent:1 animated:YES];
    [self addSubview:pickView];
}
//  一共有多少列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

//  第component列一共有多少行
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    if(component == 0)
    {
        if (_bigArray.count > 0)
        {
            return _bigArray.count;
        }else
        {
            return 0;
        }
    }else
    {
        if (_bigArray.count > 0 )
        {
            areaModel *model = _bigArray[_firstCurrentIndex];
            return model.modelArray.count;
        }else
        {
            return 0;
        }
        
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(component == 0)
    {
        _firstCurrentIndex = row;
        if (row > 0)
        {
            areaModel *model = _bigArray[row];
            _provinceString = model.name;
            _cityArray = model.modelArray;
            _cityString = model.modelArray[0];
            _secondCurrentIndex = 0;
        }else
        {
            _cityArray = nil;
            areaModel *model = _bigArray[0];
            _provinceString = model.name;
            _cityString = model.modelArray[0];
            _secondCurrentIndex = 0;
        }
        [pickView reloadAllComponents];
    }
    else if(component == 1)
    {
        areaModel *model = _bigArray[_firstCurrentIndex];
        _provinceString = model.name;
        _cityArray = model.modelArray;
        _cityString = _cityArray[row];
        _secondCurrentIndex = row;
    }
}

//自定义 当前列 当前行 要显示的内容
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, kScreenW/3 , 30)];
    myView.textAlignment = NSTextAlignmentCenter;
    myView.font = [UIFont systemFontOfSize:14];
    if(component == 0)
    {
        areaModel *model = _bigArray[row];
        myView.text = model.name;
    }
    else if (component == 1)
    {
        areaModel *model1 = _bigArray[_firstCurrentIndex];
        _cityArray = model1.modelArray;;
        myView.text = _cityArray[row];
    }
    
    return myView;
}

//第component列的宽度是多少
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return kScreenW/2 ;
}

//第component列的行高是多少
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 30;
}

//点击事件
- (void)tapClick:(UITapGestureRecognizer *)tap
{
    if (!_provinceString && !_cityString)
    {
        if (_bigArray.count)
        {
            areaModel *model = _bigArray[0];
            _provinceString = model.name;
            NSMutableArray *firstArray = model.modelArray;
            _cityString = firstArray[0];
        }
    }
    
    if(self.delegate)
    {
        NSInteger tag = tap.view.tag;
        if([self.delegate respondsToSelector:@selector(confrmCallBack:withCity:andtagIndex:)])
        {
            [self.delegate confrmCallBack:_provinceString withCity:_cityString andtagIndex:(int)tag];
        }
    }
}


@end
