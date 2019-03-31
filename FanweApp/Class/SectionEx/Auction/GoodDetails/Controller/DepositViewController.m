//
//  DepositViewController.m
//  FanweApp
//
//  Created by fanwe2014 on 16/8/10.
//  Copyright © 2016年 xfg. All rights reserved.

#import "DepositViewController.h"
#import "SuctionMoneyCell.h"
#import "SuctionContactWayCell.h"
#import "SuctionDetailContactWayCell.h"
#import "ProtocolTableViewCell.h"
#import "AddressTableViewCell.h"
#import "ConfirmTableViewCell.h"
#import "PlaceTableViewCell.h"
#import "AddressViewController.h"
#import "ListModel.h"
#import "MPersonCenterVC.h"

@interface DepositViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UITextFieldDelegate>

@property (nonatomic, strong) UITableView                     *myTableView;
@property (nonatomic, strong) PlaceTableViewCell              *placeCell;
@property (nonatomic, strong) NSMutableArray                  *dataArray;                    //数据源
@property (nonatomic, strong) SuctionDetailContactWayCell     *cell;
@property (nonatomic, assign)  BOOL                           isFirst;
@property (nonatomic, assign) NSInteger                       currentDiamonds;               //当前红包的值
@property (nonatomic, assign) int                             rs_count;                      //地址的个数
@property (nonatomic, copy) NSString                          *consignee;                    //姓名
@property (nonatomic, copy) NSString                          *consignee_mobile;             //电话号码
@property (nonatomic, copy) NSString                          *province;                     //省
@property (nonatomic, copy) NSString                          *city;                         //市
@property (nonatomic, copy) NSString                          *area;                         //区
@property (nonatomic, copy) NSString                          *consignee_address;            //详细地址
@property (nonatomic, copy) NSString                          *placeUrl;                     //实物竞拍的地址链接
@property (nonatomic, strong) UILabel                         *placePLabel;                  //收获信息的提示

@end

@implementation DepositViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _dataArray = [[NSMutableArray alloc]init];
    _isFirst = YES;
    self.view.backgroundColor = kBackGroundColor;
    SUS_WINDOW.window_Tap_Ges.enabled = NO;
    SUS_WINDOW.window_Pan_Ges.enabled = NO;
    self.navigationItem.title = @"参拍交保证金";
    self.navigationItem.leftBarButtonItem=[UIBarButtonItem itemWithTarget:self action:@selector(backClick) image:@"com_arrow_vc_back" highImage:@"com_arrow_vc_back"];
    self.placePLabel = [[UILabel alloc]initWithFrame:CGRectMake(10,0, kScreenW-10, 45)];
    self.placePLabel.backgroundColor= kWhiteColor;
    self.placePLabel.font = [UIFont systemFontOfSize:14];
    self.placePLabel.textColor = kAppGrayColor1;
    self.placePLabel.text = @"为保证竞拍成功后能顺利联系到您,请填写联系方式";
    _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-64)];
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _myTableView.dataSource = self;
    _myTableView.delegate = self;
    [self.view addSubview:_myTableView];
    [_myTableView registerNib:[UINib nibWithNibName:@"SuctionMoneyCell" bundle:nil] forCellReuseIdentifier:@"SuctionMoneyCell"];
    [_myTableView registerNib:[UINib nibWithNibName:@"SuctionDetailContactWayCell" bundle:nil] forCellReuseIdentifier:@"SuctionDetailContactWayCell"];
    [_myTableView registerNib:[UINib nibWithNibName:@"PlaceTableViewCell" bundle:nil] forCellReuseIdentifier:@"PlaceTableViewCell"];
    [_myTableView registerNib:[UINib nibWithNibName:@"ConfirmTableViewCell" bundle:nil] forCellReuseIdentifier:@"ConfirmTableViewCell"];
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
//    [_myTableView addGestureRecognizer:tap];
    
    if (self.type == 1)
    {
        [self loadNet];
    }
}

- (void)loadNet
{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"address" forKey:@"ctl"];
    [parmDict setObject:@"address" forKey:@"act"];
    [parmDict setObject:@"1" forKey:@"p"];
    [parmDict setObject:@"shop" forKey:@"itype"];
    FWWeakify(self)
    [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson)
     {
         FWStrongify(self)
         [self.dataArray removeAllObjects];
         if ([responseJson toInt:@"status"] == 1)
         {
             self.rs_count = [[responseJson objectForKey:@"data"] toInt:@"rs_count"];
             self.placeUrl = [[responseJson objectForKey:@"data"] toString:@"url"];
             NSArray *array = [[responseJson objectForKey:@"data"] objectForKey:@"list"];
             if (array && [array isKindOfClass:[NSArray class]])
             {
                 if (array.count)
                 {
                     for (NSDictionary *dict in array)
                     {
                         if (dict && [dict isKindOfClass:[NSDictionary class]])
                         {
                             if (dict.count)
                             {
                                 ListModel *model = [ListModel mj_objectWithKeyValues:dict];
                                 [self.dataArray addObject:model];
                             }
                         }
                     }
                 }
             }
             [self.myTableView reloadData];
         }
     } FailureBlock:^(NSError *error)
     {
         NSLog(@"error==%@",error);
     }];
}

- (void)tap
{
    [self.cell.phoneTextFiled resignFirstResponder];
    [self.cell.personTextFiled resignFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].keyboardDistanceFromTextField = 5.0f;
    if (!self.isFirst)
    {
        [self loadNet];
        [self.myTableView reloadData];
    }
    self.isFirst = NO;
    
}

- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark -- dataSource/Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return DepositTablevCount;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == DepositOneSection)
    {
        return 1;
    }
    else
    {
        if (section == DepositTwoSection && self.rs_count)//实物竞拍
        {
            return self.dataArray.count;
            
        }else
        {
            return 1;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==DepositZoneSection)
    {
        SuctionMoneyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SuctionMoneyCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setCellWithMoney:self.bzMoney];
        return cell;
    }else if (indexPath.section == DepositOneSection)
    {
        static NSString *CellIdentifier1 = @"CellIdentifier1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell addSubview:self.placePLabel];
        }
        return cell;
    }
    else if (indexPath.section == DepositTwoSection)
    {
        if (self.type == 0)//0虚拟1实物竞拍
        {
            self.cell = [tableView dequeueReusableCellWithIdentifier:@"SuctionDetailContactWayCell"];
            self.cell.selectionStyle = UITableViewCellSelectionStyleNone;
            self.cell.phoneTextFiled.delegate = self;
            self.cell.personTextFiled.delegate = self;
            return self.cell;
        }else
        {
            self.placeCell = [tableView dequeueReusableCellWithIdentifier:@"PlaceTableViewCell"];
            self.placeCell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            if (self.rs_count)
            {
                ListModel *LModel = _dataArray[indexPath.row];
                [self.placeCell creatCellWithModel:LModel andRow:(int)indexPath.row];
                
                self.placeCell.nameLabel.hidden = NO;
                self.placeCell.placeLabel.hidden = NO;
                self.placeCell.rightImgView.hidden = NO;
                self.placeCell.addressButton.hidden = YES;
                
            }else
            {
                self.placeCell.addressButton.hidden = NO;
                self.placeCell.nameLabel.hidden = YES;
                self.placeCell.placeLabel.hidden = YES;
                self.placeCell.rightImgView.hidden = YES;

            }
            return self.placeCell;
        }
    }
    else
    {
        ConfirmTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ConfirmTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.comfirmButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.protocolButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == DepositZoneSection)
    {
        return 50;
    }
    else if (indexPath.section == DepositOneSection)
    {
        return 45;
    }
    else if (indexPath.section == DepositTwoSection)
    {
        if (self.type == 0)//0虚拟1实物竞拍
        {
            return 90;
        }else
        {
            return 70;
        }
    }
    else
    {
        return 100;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == DepositZoneSection || section == DepositTwoSection|| section == DepositThreeSection)
    {
        return 10;
    }else
    {
        return 0;
    }
}

#pragma mark 进入充值页面
- (void)chargerMoneyButton
{
    MPersonCenterVC *acountVC = [[MPersonCenterVC alloc]init];
    [[AppDelegate sharedAppDelegate] pushViewController:acountVC];
}

#pragma mark 同意并确认
- (void)buttonClick:(UIButton *)sender
{
    int index = (int)sender.tag;
    if (index == 0)//竞拍协议
    {
        FWMainWebViewController *tmpController = [FWMainWebViewController webControlerWithUrlStr:self.fanweApp.appModel.h5_url.url_auction_agreement isShowIndicator:YES isShowNavBar:YES isShowBackBtn:YES];
//        tmpController.navTitleStr = @"我的竞拍";
        [self.navigationController pushViewController:tmpController animated:YES];
        
    }else if (index == 1)//确认
    {
        int moneyCont = (int)[[IMAPlatform sharedInstance].host getDiamonds];
        
        if (moneyCont < [self.bzMoney intValue])
        {
            [[FWHUDHelper sharedInstance] tipMessage:@"账户余额不够，请您先充值"];
            return;
        }
        NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
        if (self.type == 0)//虚拟
        {
            if (self.cell.personTextFiled.text.length <1)
            {
                [[FWHUDHelper sharedInstance] tipMessage:@"请输入联系人的姓名"];
                return;
            }
            [parmDict setObject:_cell.personTextFiled.text forKey:@"consignee"];
            
            if (self.cell.phoneTextFiled.text.length != 11)
            {
                [[FWHUDHelper sharedInstance] tipMessage:@"请输入11位电话号码"];
                return;
            }
            [parmDict setObject:self.cell.phoneTextFiled.text forKey:@"consignee_mobile"];
            
        }else//实物
        {
            if (self.rs_count < 1)
            {
                [[FWHUDHelper sharedInstance] tipMessage:@"请填写收货信息"];
                return;
            }else
            {
                ListModel *LModel = self.dataArray[0];
                if (LModel.consignee.length < 1)
                {
                    [[FWHUDHelper sharedInstance] tipMessage:@"请填写联系人"];
                    return;
                }
                
                [parmDict setObject:LModel.consignee forKey:@"consignee"];
                
                if (LModel.consignee_mobile.length < 1)
                {
                    [[FWHUDHelper sharedInstance] tipMessage:@"请填写联系电话号码"];
                    return;
                }
                
                [parmDict setObject:LModel.consignee_mobile forKey:@"consignee_mobile"];
                
                if (LModel.consignee_district.province.length > 0 && LModel.consignee_district.city.length > 0 && LModel.consignee_district.area.length > 0)
                {
                    [parmDict setObject:[NSString stringWithFormat:@"{\"area\":\"%@\",\"city\":\"%@\",\"province\":\"%@\"}",LModel.consignee_district.area,LModel.consignee_district.city,LModel.consignee_district.province] forKey:@"consignee_district"];
                }
                
                if (LModel.consignee_address.length < 1)
                {
                    [[FWHUDHelper sharedInstance] tipMessage:@"请填写详细地址"];
                    return;
                }
                [parmDict setObject:LModel.consignee_address forKey:@"consignee_address"];
            }
        }
        [parmDict setObject:@"pai_user" forKey:@"ctl"];
        [parmDict setObject:@"dojoin" forKey:@"act"];
        if (self.productId)
        {
            [parmDict setObject:self.productId forKey:@"id"];
        }
        [parmDict setObject:@"shop" forKey:@"itype"];
        
        [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson)
         {
             
             if ([responseJson toInt:@"status"] == 1)
             {
                 
                 //                 [[LiveCenterManager sharedInstance] showChangeAuctionLiveScreenSOfIsSmallScreen:NO nextViewController:nil delegateWindowRCNameStr:@"FWTabBarController" complete:^(BOOL finished) {
                 //
                 //                 }];
                 [self backLiveVC];
             }
         } FailureBlock:^(NSError *error)
         {
           NSLog(@"error===%@",error);
         }];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField ==self.cell.phoneTextFiled)
    {
        
        if (self.cell.phoneTextFiled.text.length < 1)
        {
            [[FWHUDHelper sharedInstance] tipMessage:@"请输入电话号码"];
            return;
        }
        if (self.cell.phoneTextFiled.text.length != 11)
        {
            [[FWHUDHelper sharedInstance] tipMessage:@"请输入11位电话号码"];
            return;
        }
        if (![self.cell.phoneTextFiled.text isTelephone])
        {
            [[FWHUDHelper sharedInstance] tipMessage:@"请输入正确的电话号码"];
            return;
        }
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.cell.phoneTextFiled)
    {
        textField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.cell.phoneTextFiled)
    {
        if (![string isNumber])
        {
            return NO;
        }
        if (string.length == 0)
            return YES;
        
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == DepositTwoSection)
    {
        AddressViewController *addressVC = [[AddressViewController alloc]init];
        if (self.rs_count > 0)//修改地址
        {
            ListModel *model = _dataArray[0];
            addressVC.personName = model.consignee;
            addressVC.address_id = model.ID;
            addressVC.personPhone = model.consignee_mobile;
            addressVC.area = [NSString stringWithFormat:@"%@ %@ %@",model.consignee_district.province,model.consignee_district.city,model.consignee_district.area];
            addressVC.provinceStr = model.consignee_district.province;
            addressVC.cityStr = model.consignee_district.province;
            addressVC.provinceStr = model.consignee_district.city;
            addressVC.areaStr = model.consignee_district.area;
            addressVC.detailArea = model.consignee_address;
            addressVC.type = 1;
            [self.navigationController pushViewController:addressVC animated:YES];
        }else
        {
            addressVC.type = 0;
            [self.navigationController pushViewController:addressVC animated:YES];
        }
    }
}

//返回直播间
- (void)backLiveVC
{
    UIViewController *viewCtl;
    for (int i = 0; i < [self.navigationController.viewControllers count]; i ++)
    {
        viewCtl = [self.navigationController.viewControllers objectAtIndex:(i)];
        if ([viewCtl isKindOfClass:[FWTLiveController class]] || [viewCtl isKindOfClass:[FWKSYLiveController class]])
        {
            [self.navigationController popToViewController:viewCtl animated:YES];
        }
    }
}

@end
