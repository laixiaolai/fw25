//
//  FWEditInfoController.m
//  FanweApp
//
//  Created by 丁凯 on 2017/6/12.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "FWEditInfoController.h"
#import "FWEditTCell.h"
#import "UserModel.h"
#import "GetHeadImgViewController.h"
#import "ChangeNameViewController.h"
#import "SexViewController.h"
#import "emotionView.h"
#import "birthdayView.h"
#import "areaView.h"
#import "BDView.h"

@interface FWEditInfoController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,changeNameDelegate,changeSexDelegate,changeEmotionStatuDelegate,LZDateDelegate,AreaDelegate>

{
   UIButton                     *_rightButton;             //保存
   UITableView                  *_tableView;
   NSMutableArray               *_dataArray;
   
   FWEditTCell                  *_TXCell;
   FWEditTCell                  *_NCCell;
   FWEditTCell                  *_ZHCell;
   FWEditTCell                  *_XBCell;
   FWEditTCell                  *_GXQMCell;
   FWEditTCell                  *_RZCell;
   FWEditTCell                  *_SRCell;
   FWEditTCell                  *_QGZTCell;
   FWEditTCell                  *_JXCell;
   FWEditTCell                  *_ZYCell;
   int                          _isNeedLoad;
   UserModel                    *_model;
   NSString                     *_sexString;              //性别的字符串
   emotionView                  *_emotionViewVC;          //情感的view
   areaView                     *_areaViewVC;             //地区的view
   BDView                       *_datePicker;
   NSString                     *_provinceString;         //省份
   NSString                     *_cityString;             //城市
   UIView                       *_halfClearView;          //底部透明的view
   NSString                     *_nick_info;
}

@end

@implementation FWEditInfoController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_isNeedLoad)
    {
        [self loadNetData];
    }
}

- (void)initFWUI
{
    [super initFWUI];
    _dataArray = [[NSMutableArray alloc]init];
    self.navigationItem.leftBarButtonItem=[UIBarButtonItem itemWithTarget:self action:@selector(backClick) image:@"com_arrow_vc_back" highImage:@"com_arrow_vc_back"];
    self.navigationItem.title = @"编辑资料";
    _rightButton = [[UIButton alloc]initWithFrame:CGRectMake(kScreenW-40, 5, 40, 30)];
    [_rightButton setTitle:@"保存" forState:UIControlStateNormal];
    [_rightButton setTitleColor:kAppGrayColor1 forState:UIControlStateNormal];
    _rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_rightButton addTarget:self action:@selector(saveEditButton) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-kStatusBarHeight-kNavigationBarHeight)];
    _tableView.backgroundColor = kBackGroundColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = NO;
    [_tableView registerNib:[UINib nibWithNibName:@"FWEditTCell" bundle:nil] forCellReuseIdentifier:@"FWEditTCell"];
    [self.view addSubview:_tableView];
   dispatch_async(dispatch_get_global_queue(0, 0), ^{
       if (![[self getVersionsNum] isEqualToString:self.fanweApp.appModel.region_versions] || ![[self getMyAreaDataArr] count])
       {
         [self loadMyAreaData];
       }
   });
}

#pragma mark 创建或者销毁halfClearView
- (void)isCreatHaldClearViewWithCount:(int)count
{
    if (count == 1)//创建_halfClearView
    {
        if (!_halfClearView)
        {
            _halfClearView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
            _halfClearView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
            [[UIApplication sharedApplication].keyWindow addSubview:_halfClearView];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
            tap.delegate = self;
            [_halfClearView addGestureRecognizer:tap];
        }
    }else//销毁_halfClearView
    {
        [_halfClearView removeFromSuperview];
        _halfClearView = nil;
        _emotionViewVC = nil;
        _areaViewVC    = nil;
        _datePicker    = nil;
    }
}

- (void)tap:(UITapGestureRecognizer *)tap
{
    [self isCreatHaldClearViewWithCount:0];
}

#pragma mark comeBack
- (void)backClick
{
    [[AppDelegate sharedAppDelegate]popViewController];
}

- (void)initFWData
{
    [super initFWData];
    [self showMyHud];
    [self loadNetData];
}
#pragma mark 网络加载
- (void)loadNetData
{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"user_center" forKey:@"ctl"];
    [parmDict setObject:@"user_edit" forKey:@"act"];
    FWWeakify(self)
    [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson)
     {
         FWStrongify(self)
         [self hideMyHud];
         if ([responseJson toInt:@"status"] == 1)
         {
             _model = [UserModel mj_objectWithKeyValues:[responseJson objectForKey:@"user"]];
             _nick_info = [responseJson toString:@"nick_info"];
             _sexString = _model.sex;
             [_tableView reloadData];
         }else
         {
             [FWHUDHelper alert:[responseJson toString:@"error"]];
         }
     } FailureBlock:^(NSError *error)
     {
         FWStrongify(self)
         [self hideMyHud];
     }];
}
#pragma mark -- dataSource/Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return ETab_Count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == ERZSection)
    {
        return 0;
    }else
    {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == ERZSection)
    {
        return 0;
    }else
    {
        return 45*kAppRowHScale;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == ETXSection || section == ENCSection || section == ESRSection)
    {
        return 10*kAppRowHScale;
    }else
    {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == ETXSection)
    {
        _TXCell = [tableView dequeueReusableCellWithIdentifier:@"FWEditTCell" forIndexPath:indexPath];
        [_TXCell creatCellWithStr:_model.head_image andSection:(int)indexPath.section];
        return _TXCell;
    }else if (indexPath.section == ENCSection)
    {
        _NCCell = [tableView dequeueReusableCellWithIdentifier:@"FWEditTCell" forIndexPath:indexPath];
        [_NCCell creatCellWithStr:_model.nick_name andSection:(int)indexPath.section];
        return _NCCell;
    }
    else if (indexPath.section == EZHSection)
    {
        _ZHCell = [tableView dequeueReusableCellWithIdentifier:@"FWEditTCell" forIndexPath:indexPath];
        [_ZHCell creatCellWithStr:_model.user_id andSection:(int)indexPath.section];
        return _ZHCell;
    }
    else if (indexPath.section == EXBSection)
    {
        _XBCell = [tableView dequeueReusableCellWithIdentifier:@"FWEditTCell" forIndexPath:indexPath];
        [_XBCell creatCellWithStr:_model.sex andSection:(int)indexPath.section];
        return _XBCell;
    }
    else if (indexPath.section == EGXQMSection)
    {
        _GXQMCell = [tableView dequeueReusableCellWithIdentifier:@"FWEditTCell" forIndexPath:indexPath];
        [_GXQMCell creatCellWithStr:_model.signature andSection:(int)indexPath.section];
        return _GXQMCell;
    }
    else if (indexPath.section == ERZSection)
    {
        _RZCell = [tableView dequeueReusableCellWithIdentifier:@"FWEditTCell" forIndexPath:indexPath];
        return _RZCell;
    }
    else if (indexPath.section == ESRSection)
    {
        _SRCell = [tableView dequeueReusableCellWithIdentifier:@"FWEditTCell" forIndexPath:indexPath];
        [_SRCell creatCellWithStr:_model.birthday andSection:(int)indexPath.section];
        return _SRCell;
        
    }else if (indexPath.section == EQGZTSection)
    {
        _QGZTCell = [tableView dequeueReusableCellWithIdentifier:@"FWEditTCell" forIndexPath:indexPath];
        [_QGZTCell creatCellWithStr:_model.emotional_state andSection:(int)indexPath.section];
        return _QGZTCell;
    }
    else if (indexPath.section == EJXSection)
    {
        _JXCell = [tableView dequeueReusableCellWithIdentifier:@"FWEditTCell" forIndexPath:indexPath];
        if (!_model.city.length)
        {
            _model.city = @"火星";
        }
        [_JXCell creatCellWithStr:_model.city andSection:(int)indexPath.section];
        return _JXCell;
    }
    else
    {
        _ZYCell = [tableView dequeueReusableCellWithIdentifier:@"FWEditTCell" forIndexPath:indexPath];
        [_ZYCell creatCellWithStr:_model.job andSection:(int)indexPath.section];
        _ZYCell.lineView.hidden = YES;
        return _ZYCell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case 0:
        {
            _isNeedLoad = YES;
            GetHeadImgViewController *headVC =[[GetHeadImgViewController alloc]init];
            headVC.headImgString =_model.head_image;
            headVC.userId = _model.user_id;
            [[AppDelegate sharedAppDelegate]pushViewController:headVC];
        }
            break;
        case 1:
        {
            [self pushToChangeNameViewWithType:1 andStr:_model.nick_name];
        
        }
            break;
        case 2:
        {
            UIPasteboard *pasteboard=[UIPasteboard generalPasteboard];
            pasteboard.string = _model.user_id;
            [[FWHUDHelper sharedInstance] tipMessage:@"复制成功"];
        }
            break;
        case 3:
        {
            _isNeedLoad = NO;
            if ([_model.is_edit_sex intValue] == 0)
            {
                [[FWHUDHelper sharedInstance] tipMessage:@"性别不可编辑"];
                return;
            }
            SexViewController *sexVC = [[SexViewController alloc]init];
            sexVC.sexType = _sexString;
            sexVC.delgate = self;
            [self.navigationController pushViewController:sexVC animated:YES];
        }
            break;
        case 4:
        {
            [self pushToChangeNameViewWithType:2 andStr:_model.signature];
        }
            break;
        case 5:
        {
           //to do
        }
            break;
        case 6:
        {
            NSLog(@"1111111");
            [self isCreatHaldClearViewWithCount:1];
            if (!_datePicker)//生日
            {
                _datePicker = [[[NSBundle mainBundle]loadNibNamed:@"BDView" owner:self options:nil]lastObject];
                _datePicker.frame = CGRectMake(0,kScreenH ,kScreenW,260);
                if(_model.birthday.length>0)
                {
                    [_datePicker creatMinTime:_model.birthday];
                }
                [_halfClearView addSubview:_datePicker];
                [UIView animateWithDuration:0.5 animations:^{
                    CGRect rect = _datePicker.frame;
                    rect.origin.y = kScreenH - 260;
                    _datePicker.frame = rect;
                }];
                FWWeakify(self)
              [_datePicker setBDViewBlock:^(int tagIndex){
                  FWStrongify(self)
                  if (tagIndex == 0)
                  {
                      [self isCreatHaldClearViewWithCount:0];
                  }else if (tagIndex == 1)
                  {
                      [self handleToSelectTime];
                  }
              }];
            }
        }
            break;
        case 7:
        {
            [self isCreatHaldClearViewWithCount:1];
            if (!_emotionViewVC)//情感状态
            {
                _emotionViewVC = [[emotionView alloc]initWithFrame:CGRectMake(0, kScreenH, kScreenW, 160) withName:_model.emotional_state];
                _emotionViewVC.delegate = self;
                [_halfClearView addSubview:_emotionViewVC];
                [UIView animateWithDuration:0.5 animations:^{
                    CGRect rect = _emotionViewVC.frame;
                    rect.origin.y = kScreenH-160;
                    _emotionViewVC.frame = rect;
                }];
            }
        }
            break;
        case 8:
        {
            [self isCreatHaldClearViewWithCount:1];
            if (!_areaViewVC)//家乡
            {
                _areaViewVC = [[areaView alloc]initWithDelegate:self withCity:_model.city];
                _areaViewVC.frame = CGRectMake(0, kScreenH, kScreenW, 190);
                [_halfClearView addSubview:_areaViewVC];
                [UIView animateWithDuration:0.5 animations:^{
                    CGRect rect = _areaViewVC.frame;
                    rect.origin.y = kScreenH-190;
                    _areaViewVC.frame = rect;
                }];
            }
        }
            break;
        case 9:
        {
            [self pushToChangeNameViewWithType:3 andStr:_model.job];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark -- 日历确定按钮点击事件
- (void)handleToSelectTime
{
    _SRCell.rightLabel.text = _datePicker.timeLabel.text;
    [UIView animateWithDuration:0.5 animations:^{
    } completion:^(BOOL finished) {
       [self isCreatHaldClearViewWithCount:0];
    }];
}

#pragma mark 修改情感状态
- (void)changeEmotionStatuWithString:(NSString *)emoyionString
{
    _model.emotional_state = _QGZTCell.rightLabel.text = emoyionString;
    [self isCreatHaldClearViewWithCount:0];
}

#pragma mark 修改性别
- (void)changeSexWithString:(NSString *)sexString
{
    _sexString = sexString;
    if ([sexString isEqualToString:@"1"])
    {
      _XBCell.sexImgView.image = [UIImage imageNamed:@"com_male_selected"];
    }else if ([sexString isEqualToString:@"2"])
    {
      _XBCell.sexImgView.image = [UIImage imageNamed:@"com_female_selected"];
    }
}

#pragma mark 修改生日
- (void)confrmCallBack:(NSInteger)Year month:(NSInteger)month day:(NSInteger)day andtag:(int)tagIndex
{
    if (tagIndex == 12)
    {
       _SRCell.rightLabel.text = [NSString stringWithFormat:@"%d-%d-%d",(int)Year,(int)month,(int)day];
    }
    [self isCreatHaldClearViewWithCount:0];
}

#pragma mark 地区的代理
- (void)confrmCallBack:(NSString *)provice withCity:(NSString *)city andtagIndex:(int)tagIndex
{
    if (tagIndex == 12)
    {
        _provinceString = provice;
        _cityString = city;
        if (city.length < 1 || provice.length < 1)
        {
            _JXCell.rightLabel.text = @"";
        }else
        {
          _model.city = _JXCell.rightLabel.text = [NSString stringWithFormat:@"%@ %@",provice,city];
        }
    }
    [self isCreatHaldClearViewWithCount:0];
}

#pragma mark 修改昵称之类的
- (void)pushToChangeNameViewWithType:(int)type andStr:(NSString *)str
{
    _isNeedLoad = NO;
    ChangeNameViewController *nameVC =[[ChangeNameViewController alloc]init];
    if (type == 1)
    {
        nameVC.nickInfo = _nick_info;
    }
    nameVC.textFiledName = str;
    nameVC.viewType = [NSString stringWithFormat:@"%d",type];
    nameVC.delegate = self;
    [self.navigationController pushViewController:nameVC animated:YES];
}

- (void)changeNameWithString:(NSString *)name withType:(NSString *)type
{
    if ([type isEqualToString:@"1"])
    {
        _NCCell.rightLabel.text = name;
    }else if ([type isEqualToString:@"2"])
    {
        _GXQMCell.rightLabel.text = name;
    }else if ([type isEqualToString:@"3"])
    {
        _ZYCell.rightLabel.text = name;
    }
}

#pragma mark 保存的按钮
- (void)saveEditButton
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:@"user_center" forKey:@"ctl"];
    [dict setObject:@"user_save" forKey:@"act"];
    if (_NCCell.rightLabel.text.length > 0)//名字
    {
        [dict setObject:_NCCell.rightLabel.text forKey:@"nick_name"];
    }
    if (_sexString.length > 0)//性别
    {
        [dict setObject:_sexString forKey:@"sex"];
    }
    if (_GXQMCell.rightLabel.text.length > 0)//个性签名
    {
        [dict setObject:_GXQMCell.rightLabel.text forKey:@"signature"];
    }
    if (_SRCell.rightLabel.text.length > 0)//生日
    {
        [dict setObject:_SRCell.rightLabel.text forKey:@"birthday"];
    }
    if (_QGZTCell.rightLabel.text.length > 0)//情感状态
    {
        [dict setObject:_QGZTCell.rightLabel.text forKey:@"emotional_state"];
    }
    if (_provinceString.length > 0)//省份
    {
        [dict setObject:_provinceString forKey:@"province"];
    }
    if (_cityString.length > 0)//城市
    {
        [dict setObject:_cityString forKey:@"city"];
    }
    if (_ZYCell.rightLabel.text.length > 0)//工作
    {
        [dict setObject:_ZYCell.rightLabel.text forKey:@"job"];
    }
    FWWeakify(self)
    [self showMyHud];
    [self.httpsManager POSTWithParameters:dict SuccessBlock:^(NSDictionary *responseJson)
     {
         FWStrongify(self)
         [self hideMyHud];
         if ([responseJson toInt:@"status"] == 1)
         {
             [FWHUDHelper alert:@"编辑成功"];
             [self.navigationController popViewControllerAnimated:YES];
         }else
         {
             [FWHUDHelper alert:[responseJson toString:@"error"]];
         }
         
     } FailureBlock:^(NSError *error)
     {
         FWStrongify(self)
         [self hideMyHud];
     }];
}

#pragma mark  =============================================家乡数据的获取和存储============================================================
- (NSString *)getVersionsNum
{
    NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath = [cachePath stringByAppendingPathComponent:@"versions.plist"];
    NSMutableDictionary *dict1 = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
    return [dict1 objectForKey:@"versions"];
}

- (NSMutableArray *)getMyAreaDataArr
{
    //获取Documents目录
    NSString *docPath2 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    //还要指定存储文件的文件名称,仍然使用字符串拼接
    NSString *filePath2 = [docPath2 stringByAppendingPathComponent:@"Province.plist"];
    return [NSMutableArray arrayWithContentsOfFile:filePath2];
}

- (void)loadMyAreaData
{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"user_center" forKey:@"ctl"];
    [parmDict setObject:@"region_list" forKey:@"act"];
    [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson)
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
                 }
             }
         }
     } FailureBlock:^(NSError *error)
     {
         
     }];
}

@end
