//
//  AddressViewController.m
//  FanweApp
//
//  Created by fanwe2014 on 16/10/19.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "AddressViewController.h"
#import "EditAddressCell.h"
#import "MapViewController.h"

@interface AddressViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,pushToMapDelegate,MapChooseAddressControllerDelegate>

@property (nonatomic, strong) UITableView            *myTableView;
@property (nonatomic, strong) EditAddressCell        *cell;
@property (nonatomic, assign)  BOOL                  isFirst;               //是否第一次加载
@property (nonatomic, copy) NSString                 *keyWordStr;

@end

@implementation AddressViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _isFirst = YES;
    if (!self.provinceStr.length)
    {
      self.provinceStr = self.fanweApp.province;
    }
    if (!self.cityStr.length)
    {
      self.cityStr = self.fanweApp.locationCity;
    }
    if (!self.areaStr.length)
    {
     self.areaStr = self.fanweApp.area;
    }
    
    [self creatView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].keyboardDistanceFromTextField = 5.0f;
    
    if (!_isFirst)
    {
        [_myTableView reloadData];
    }
    _isFirst = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}

- (void)creatView{
    
    self.navigationItem.leftBarButtonItem=[UIBarButtonItem itemWithTarget:self action:@selector(backClick) image:@"com_arrow_vc_back" highImage:@"com_arrow_vc_back"];
    
    UIButton *savebutton = [UIButton buttonWithType:UIButtonTypeCustom];
    savebutton.frame = CGRectMake(kScreenW-40, 5, 40, 40);
    
    [savebutton setTitleColor:kAppGrayColor1 forState:UIControlStateNormal];
    savebutton.userInteractionEnabled = YES;
    savebutton.titleLabel.font = [UIFont systemFontOfSize:15];
    [savebutton addTarget:self action:@selector(saveEditButton:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:savebutton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    if (self.type == 0)
    {
        self.title = @"新增地址";
        [savebutton setTitle:@"保存" forState:UIControlStateNormal];
    }else if (self.type == 1)
    {
        self.title = @"修改地址";
        [savebutton setTitle:@"修改" forState:UIControlStateNormal];
    }
    
    self.myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-kStatusBarHeight-kNavigationBarHeight)];
    [self.myTableView registerNib:[UINib nibWithNibName:@"EditAddressCell" bundle:nil] forCellReuseIdentifier:@"EditAddressCell"];
    self.myTableView.backgroundColor = kBackGroundColor;
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.myTableView];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [_myTableView addGestureRecognizer:tapGestureRecognizer];
}

- (void)keyboardHide
{
    [_cell.personFiled resignFirstResponder];
    [_cell.phoneFiled resignFirstResponder];
    [_cell.cityFiled resignFirstResponder];
    [_cell.smallAddressFiled resignFirstResponder];
    [_cell.defaultFiled resignFirstResponder];
}

#pragma mark -- dataSource/Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    _cell = [tableView dequeueReusableCellWithIdentifier:@"EditAddressCell"];
    _cell.phoneFiled.delegate = self;
    _cell.personFiled.delegate = self;
    _cell.cityFiled.delegate = self;
    _cell.cityFiled.enabled = NO;
    _cell.smallAddressFiled.delegate = self;
    _cell.backgroundColor = kWhiteColor;
    _cell.selectionStyle = UITableViewCellSelectionStyleNone;
    _cell.delegate = self;
    if (self.personName.length)
    {
        _cell.personFiled.text = self.personName;
    }
    if (self.personPhone.length)
    {
        _cell.phoneFiled.text = self.personPhone;
    }
    if (self.area.length > 0)
    {
        _cell.cityFiled.text = self.area;
    }else
    {
        if (self.provinceStr || self.cityStr || self.areaStr)
        {
          _cell.cityFiled.text = [NSString stringWithFormat:@"%@ %@ %@",self.provinceStr,self.cityStr,self.areaStr];
        }
        
    }
    if (self.detailArea.length)
    {
        if (self.fanweApp.area.length > 0)
        {
            if ([self.detailArea hasPrefix:self.fanweApp.area])
            {
                self.detailArea = [self.detailArea stringByReplacingOccurrencesOfString:self.fanweApp.area withString:@""];
            }
        }
        _cell.smallAddressFiled.text = self.detailArea;
    }else
    {
        if ([self.fanweApp.locateName hasPrefix:self.fanweApp.area])
        {
            self.fanweApp.locateName = [self.fanweApp.locateName stringByReplacingOccurrencesOfString:self.fanweApp.area withString:@""];
        }
        _cell.smallAddressFiled.text = self.fanweApp.locateName;
    }
    return _cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 260;
}


#pragma mark 后退
- (void)backClick
{
    [self keyboardHide];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 保存
- (void)saveEditButton:(UIButton *)btn
{
    btn.userInteractionEnabled = NO;
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"address" forKey:@"ctl"];
    if (self.type == 0)
    {
        [parmDict setObject:@"addaddress" forKey:@"act"];
    }else if(self.type == 1)
    {
        [parmDict setObject:@"editaddress" forKey:@"act"];
    }
    
    if (_cell.personFiled.text.length < 1)
    {
        [[FWHUDHelper sharedInstance] tipMessage:@"请输入收货人姓名"];
        btn.userInteractionEnabled = YES;
        return;
    }
    [parmDict setObject:_cell.personFiled.text forKey:@"consignee"];
    if (_cell.phoneFiled.text.length < 1)
    {
        [[FWHUDHelper sharedInstance] tipMessage:@"请输入收货手机号"];
         btn.userInteractionEnabled = YES;
        return;
    }
    [parmDict setObject:_cell.phoneFiled.text forKey:@"consignee_mobile"];
    if (_cell.cityFiled.text.length < 1)
    {
        [[FWHUDHelper sharedInstance] tipMessage:@"请输入行政地区信息"];
         btn.userInteractionEnabled = YES;
        return;
    }
    [parmDict setObject:[NSString stringWithFormat:@"{\"area\":\"%@\",\"city\":\"%@\",\"province\":\"%@\"}",self.areaStr,self.cityStr,self.provinceStr] forKey:@"consignee_district"];
    if (_cell.smallAddressFiled.text.length < 1)
    {
        [[FWHUDHelper sharedInstance] tipMessage:@"请输入详细地址"];
        btn.userInteractionEnabled = YES;
        return;
    }
    
    [parmDict setObject:_cell.smallAddressFiled.text forKey:@"consignee_address"];
    if (self.type == 0)
    {
        [parmDict setObject:@"0" forKey:@"id"];
    }else
    {
        [parmDict setObject:self.address_id forKey:@"id"];
    }
    
    [parmDict setObject:@"1" forKey:@"is_default"];
    [self keyboardHide];
    [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson)
     {
         btn.userInteractionEnabled = YES;
         if ([responseJson toInt:@"status"] == 1)
         {
             [[FWHUDHelper sharedInstance] tipMessage:@"收货地址保存成功"];
             [self.navigationController popViewControllerAnimated:YES];
         }else
         {
             [[FWHUDHelper sharedInstance] tipMessage:@"收货地址保存不成功"];
         }
     } FailureBlock:^(NSError *error)
     {
         btn.userInteractionEnabled = YES;
     }];
}

- (void)pushToMapController
{
    //腾讯地图
    MapViewController *mapVc = [[MapViewController alloc]init];
    mapVc.hidesBottomBarWhenPushed = YES;
    mapVc.fromType = 0;
    mapVc.delegate = self;
    [self.navigationController pushViewController:mapVc animated:YES];
}

- (void)chooseAddress:(CLLocationCoordinate2D)location address:(NSString *)address andProvinceString:(NSString *)provinceString andCityString:(NSString *)cityString andAreaString:(NSString *)areaString{
    
    self.provinceStr = provinceString;
    self.cityStr     = cityString;
    self.areaStr     = areaString;
    if ([provinceString isEqualToString:cityString])
    {
        self.area = [NSString stringWithFormat:@"%@ %@",provinceString,areaString];
        self.detailArea = [address stringByReplacingOccurrencesOfString:provinceString withString:@""];
        self.detailArea = [self.detailArea stringByReplacingOccurrencesOfString:areaString withString:@""];
    }else
    {
        self.area = [NSString stringWithFormat:@"%@ %@ %@",provinceString,cityString,areaString];
        self.detailArea = [address stringByReplacingOccurrencesOfString:provinceString withString:@""];
        self.detailArea = [self.detailArea stringByReplacingOccurrencesOfString:cityString withString:@""];
        self.detailArea = [self.detailArea stringByReplacingOccurrencesOfString:areaString withString:@""];
    }
    
    [_myTableView reloadData];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField==_cell.phoneFiled)
    {
        
        if (_cell.phoneFiled.text.length < 1)
        {
            [[FWHUDHelper sharedInstance] tipMessage:@"请输入电话号码"];
            return;
        }
        if (_cell.phoneFiled.text.length != 11)
        {
            [[FWHUDHelper sharedInstance] tipMessage:@"请输入11位电话号码"];
            return;
        }
        if (![_cell.phoneFiled.text isTelephone])
        {
            [[FWHUDHelper sharedInstance] tipMessage:@"请输入正确的电话号码"];
            return;
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == _cell.phoneFiled)
    {
        if (![string isNumber])
        {
            return NO;
        }
        if (string.length == 0)  return YES;
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 11)
        {
            return NO;
        }
    }
    return YES;
}






@end
