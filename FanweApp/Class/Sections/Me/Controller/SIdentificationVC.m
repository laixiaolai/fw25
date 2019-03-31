//
//  SIdentificationVC.m
//  FanweApp
//
//  Created by 丁凯 on 2017/8/4.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "SIdentificationVC.h"
#import "ThirdTableViewCell.h"
#import "FourTableViewCell.h"
#import "cuserModel.h"
#import "FWOssManager.h"
#import "RecommendTableViewCell.h"
#import "SBasicInfoCell.h"
#import "RecommendTypeModel.h"

@interface SIdentificationVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,OssUploadImageDelegate,buttonClickDelegate,sentImgviewDelegate,RecommendTableViewCellDelegate>

{
    NSData                     *_data1;
    NSData                     *_data2;
    NSData                     *_data3;
}

@property ( nonatomic, strong) UITableView              *myTableView;
@property ( nonatomic, strong) NSMutableArray           *dataArray;
@property ( nonatomic, strong) NSMutableArray           *typeArray;
@property ( nonatomic, strong) FWOssManager             *ossManager;
@property ( nonatomic, assign) int                      is_show_identify_number;    //是否显示身份证号码
@property ( nonatomic, copy)   NSString                 *identify_hold_example;     //图像图片

@property ( nonatomic, copy)   NSString                 *idTypeStr;                 //认证类型
@property ( nonatomic, copy)   NSString                 *idNameStr;                 //认证名称
@property ( nonatomic, copy)   NSString                 *idContactStr;              //联系方式
@property ( nonatomic, copy)   NSString                 *idNumStr;                  //认证的身份证号码
@property ( nonatomic, copy)   NSString                 *urlString1;                //第一张图片的url
@property ( nonatomic, copy)   NSString                 *urlString2;                //第二张图片的url
@property ( nonatomic, copy)   NSString                 *urlString3;                //第三张图片的url
@property ( nonatomic, strong) UILabel                  *promptLabel;               //头部红色提示
@property ( nonatomic, strong) UIView                   *basicInfoView;             //基本资料
@property ( nonatomic, strong) UIView                   *idNewsView;                //认证消息
@property ( nonatomic, strong) UIView                   *idAuthenView;              //身份认证
@property ( nonatomic, strong) UIView                   *recommendView;             //推荐人信息
@property ( nonatomic, strong) UIView                   *inviteCodeView;            //公会邀请码
@property ( nonatomic, strong) UITextField              *inviteCodeFiled;           //公会邀请码Filed
@property ( nonatomic, strong) UIButton                 *sumitBtn;                  //提交
@property ( nonatomic, strong) ThirdTableViewCell       *threeCell;                 //认证信息
@property ( nonatomic, strong) FourTableViewCell        *fourCell;                  //身份认证
@property ( nonatomic, strong) RecommendTableViewCell   *recommendCell;             //推荐人信息
@property ( nonatomic, strong) RecommendTypeModel       *recommendTypeModel;
@property ( nonatomic, assign) int                      authentication;
@property ( nonatomic, assign) int                      open_society_code;          //是否打开公会认证
@property ( nonatomic, copy) NSString                   *society_code;              //公会认证邀请码
@property ( nonatomic, assign) int                      invite_id;
@property ( nonatomic, assign) NSInteger                recommendType;              // 1为选择推荐人ID,2为选择推荐人手机号，初始值为0表示两者都没选
@property ( nonatomic, weak) UIActionSheet            *typeSheet;                 //选择类型
@property ( nonatomic, weak) UIActionSheet            *recommendSheet;
@property ( nonatomic, copy)   NSString                 *timeString;                //时间戳的字符串
@property ( nonatomic, assign) int                      tagCount;                   //通过这个成员变量来获取图片
@property (nonatomic, assign) CGFloat                   recommendHeight;
@property (nonatomic, assign) NSString                  *uploadFilePath;

@end

@implementation SIdentificationVC


- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)initFWUI
{
    [super initFWUI];
    if (self.fanweApp.appModel.open_sts == 1)
    {
        self.ossManager = [[FWOssManager alloc]initWithDelegate:self];
    }
    self.dataArray = [[NSMutableArray alloc]init];
    self.typeArray = [[NSMutableArray alloc]init];
    self.recommendType = 0;
    self.recommendHeight = 0;
    self.navigationItem.title = @"认证";
    self.view.backgroundColor = kBackGroundColor;
    self.navigationItem.leftBarButtonItem=[UIBarButtonItem itemWithTarget:self action:@selector(backClick) image:@"com_arrow_vc_back" highImage:@"com_arrow_vc_back"];
    
    self.promptLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 30)];
    self.promptLabel.backgroundColor = kAppRedColor;
    self.promptLabel.textAlignment = NSTextAlignmentCenter;
    self.promptLabel.text = @"带星号项为必填项,为了保证您的利益,请如实填写";
    self.promptLabel.font = [UIFont systemFontOfSize:13];
    self.promptLabel.textColor = kAppGrayColor1;
    [self.view addSubview:self.promptLabel];
    
    self.basicInfoView  = [self creatViewWithStr:@"基本资料"];
    self.idNewsView     = [self creatViewWithStr:@"认证消息"];
    self.idAuthenView   = [self creatViewWithStr:@"身份认证"];
    self.recommendView  = [self creatViewWithStr:@"推荐人信息"];
    
    self.inviteCodeView = [[UIView alloc]initWithFrame:CGRectMake(10, 0, kScreenW-10, 44)];
    self.inviteCodeView.backgroundColor = kWhiteColor;
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 90, 44)];
    label1.text = @"公会邀请码";
    label1.textColor = kAppGrayColor1;
    label1.font = [UIFont systemFontOfSize:17];
    [self.inviteCodeView addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(90, 0, 40, 44)];
    label2.text = @"(选填)";
    label2.textColor = kAppGrayColor3;
    label2.font = [UIFont systemFontOfSize:13];
    [self.inviteCodeView addSubview:label2];
    
    self.inviteCodeFiled = [[UITextField alloc]initWithFrame:CGRectMake(135, 2, kScreenW-155, 40)];
    self.inviteCodeFiled.borderStyle = UITextBorderStyleRoundedRect;
    self.inviteCodeFiled.backgroundColor = kWhiteColor;
    self.inviteCodeFiled.placeholder = @"请输入您的公会邀请码";
    self.inviteCodeFiled.font = [UIFont systemFontOfSize:15];
    self.inviteCodeFiled.textColor = kAppGrayColor1;
    self.inviteCodeFiled.delegate = self;
    [self.inviteCodeView addSubview:self.inviteCodeFiled];
    
    
    _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 30, kScreenW, kScreenH-kStatusBarHeight-kNavigationBarHeight-30) style:UITableViewStyleGrouped];
    _sumitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _sumitBtn.frame = CGRectMake(10, 10, kScreenW-20, 40);
    _sumitBtn.layer.cornerRadius = 20;
    _sumitBtn.layer.masksToBounds = YES;
    _sumitBtn.backgroundColor = kAppMainColor;
    [_sumitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [_sumitBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [_sumitBtn addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
    _myTableView.dataSource = self;
    _myTableView.delegate = self;
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_myTableView registerNib:[UINib nibWithNibName:@"SBasicInfoCell" bundle:nil] forCellReuseIdentifier:@"SBasicInfoCell"];
    [_myTableView registerNib:[UINib nibWithNibName:@"ThirdTableViewCell" bundle:nil] forCellReuseIdentifier:@"ThirdTableViewCell"];
    [_myTableView registerNib:[UINib nibWithNibName:@"FourTableViewCell" bundle:nil] forCellReuseIdentifier:@"FourTableViewCell"];
    [self.view addSubview:_myTableView];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [_myTableView addGestureRecognizer:tapGestureRecognizer];
    [FWMJRefreshManager refresh:_myTableView target:self headerRereshAction:@selector(refresherOfFocusOn) footerRereshAction:nil];
}

- (void)keyboardHide:(UITapGestureRecognizer*)tap
{
    [_threeCell.typeTextFiled resignFirstResponder];
    [_threeCell.nameTextFiled resignFirstResponder];
    [_threeCell.contactTextFiled resignFirstResponder];
    [_recommendCell.recommendField resignFirstResponder];
    [self.inviteCodeFiled resignFirstResponder];
}

- (void)backClick
{
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)initFWData
{
    [super initFWData];
    [self showMyHud];
    [self refresherOfFocusOn];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].keyboardDistanceFromTextField = 5.0f;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}

#pragma mark 加载数据和头部刷新
- (void)refresherOfFocusOn
{
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    [mDict setObject:@"user_center" forKey:@"ctl"];
    [mDict setObject:@"authent" forKey:@"act"];
    FWWeakify(self)
    [self.httpsManager POSTWithParameters:mDict SuccessBlock:^(NSDictionary *responseJson)
     {
         FWStrongify(self)
         [self hideMyHud];
         [self.typeArray removeAllObjects];
         [self.dataArray  removeAllObjects];
         if ([responseJson toInt:@"status"] == 1)
         {
             self.navigationItem.title    =  [responseJson toString:@"title"];
             self.open_society_code       =  [responseJson toInt:@"open_society_code"];
             self.society_code            = [[responseJson objectForKey:@"user"] toString:@"society_code"];
             self.identify_hold_example   =  [responseJson toString:@"identify_hold_example"];
             self.is_show_identify_number =  [responseJson toInt:@"is_show_identify_number"];
             self.idTypeStr    = [[responseJson objectForKey:@"user"]toString:@"authentication_type"];
             self.idNameStr    = [[responseJson objectForKey:@"user"]toString:@"authentication_name"];
             self.idContactStr = [[responseJson objectForKey:@"user"]toString:@"contact"];
             self.idNumStr     = [[responseJson objectForKey:@"user"]toString:@"identify_number"];
             self.urlString1   = [[responseJson objectForKey:@"user"] toString:@"identify_positive_image"];
             self.urlString2   = [[responseJson objectForKey:@"user"] toString:@"identify_nagative_image"];
             self.urlString3   = [[responseJson objectForKey:@"user"] toString:@"identify_hold_image"];
             self.recommendHeight = [responseJson toInt:@"invite_id"]> 0 ? 0 : 50;
             NSArray *array    = [responseJson objectForKey:@"authent_list"];
             if (array)
             {
                 if (array.count > 0)
                 {
                     for (NSMutableDictionary *dict in array)
                     {
                         cuserModel *model = [cuserModel mj_objectWithKeyValues:dict];
                         [_typeArray addObject:model];
                     }
                 }
             }
             _recommendTypeModel = [RecommendTypeModel mj_objectWithKeyValues:responseJson];
             _authentication = [[responseJson objectForKey:@"user"]toInt:@"is_authentication"];
             _invite_id = [responseJson toInt:@"invite_id"];
//             if (_authentication == 1 || _authentication == 2 || _authentication == 3)//1审核中 2认证通过 3审核不通过
//             {
                 self.promptLabel.text = [responseJson toString:@"investor_send_info"];//头部的提示语都通过服务端控制
//             }
         }else
         {
             [FanweMessage alertHUD:[responseJson toString:@"error"]];
         }
         [FWMJRefreshManager endRefresh:_myTableView];
         [_myTableView reloadData];
     } FailureBlock:^(NSError *error)
     {
         FWStrongify(self)
         [self hideMyHud];
         [FWMJRefreshManager endRefresh:_myTableView];
         NSLog(@"error==%@",error);
     }];
}

#pragma mark label的创建
- (UIView *)creatViewWithStr:(NSString *)str
{
    UIView *myView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 35)];
    myView.backgroundColor = kWhiteColor;
    UILabel *label  = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, kScreenW-10, 35)];
    label.font = [UIFont systemFontOfSize:17];
    label.textColor = kAppGrayColor1;
    label.text      = str;
    label.backgroundColor = kWhiteColor;
    [myView addSubview:label];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(10, 34, kScreenW-10, 1)];
    lineView.backgroundColor = kAppSpaceColor2;
    [myView addSubview:lineView];
    return myView;
}

#pragma mark -- dataSource/Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return AuthenticationTab_Count;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == AuthenticationThreeSection)
    {
        if (self.recommendTypeModel.invite_type_list.count>0 && _invite_id == 0)
        {
            if (_authentication == 1 || _authentication == 2)
            {
                return 0;
            }else
            {
                return 1;
            }
        }else
        {
            return 0;
        }
    }else if (section ==AuthenticationFourSection)
    {
        if (self.open_society_code == 1)
        {
            return 1;
        }else
        {
            return 0;
        }
    }
    else if (section ==AuthenticationFiveSection)
    {
        if (_authentication == 1 || _authentication == 2)
        {
            return 0;
        }else
        {
            return 1;
        }
    }
    else
    {
        return 1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == AuthenticationZeroSection)
    {
        return 60;
    }else if (indexPath.section == AuthenticationOneSection)
    {
        if (_is_show_identify_number == 1)
        {
            return 170;
        }else
        {
            return 130;
        }
    }else if(indexPath.section == AuthenticationTwoSection)
    {
        return kScreenW<375 ? 150+(kScreenW-20)/2 : 170+(kScreenW-20)/2;
    }else if(indexPath.section == AuthenticationThreeSection)
    {
        return self.recommendHeight;
    }else if(indexPath.section == AuthenticationFourSection)
    {
        return 44;
    }
    else
    {
        return 60;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == AuthenticationZeroSection)
    {
        SBasicInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SBasicInfoCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.myNameLabel.text = [NSString stringWithFormat:@"昵称：%@",self.nameString];
        cell.mySexLabel.text = [NSString stringWithFormat:@"性别：%@",[self.sexString intValue] == 1 ? @"男" : @"女"];
        return cell;
    }else if (indexPath.section == AuthenticationOneSection)
    {
        _threeCell = [tableView dequeueReusableCellWithIdentifier:@"ThirdTableViewCell"];
        _threeCell.delegate = self;
        _threeCell.typeTextFiled.delegate = self;
        _threeCell.nameTextFiled.delegate = self;
        _threeCell.contactTextFiled.delegate = self;
        _threeCell.identificationNumFiled.delegate = self;
        [_threeCell creatCellWithAuthentication:_authentication andIdTypeStr:self.idTypeStr andIdNameStr:self.idNameStr andIdContactStr:self.idContactStr andIdNumStr:self.idNumStr andShowIdNum:_is_show_identify_number];
        return _threeCell;
    }else if(indexPath.section == AuthenticationTwoSection)
    {
        _fourCell = [tableView dequeueReusableCellWithIdentifier:@"FourTableViewCell"];
        _fourCell.delegate = self;
        [_fourCell creatCellWithAuthentication:_authentication andHeadImgStr1:self.urlString1 andHeadImgStr2:self.urlString2 andHeadImgStr3:self.urlString3 andUrlStr:_identify_hold_example];
        return _fourCell;
    }
    else if(indexPath.section == AuthenticationThreeSection)
    {
        _recommendCell = [RecommendTableViewCell cellWithTableView:tableView];
        _recommendCell.delegate = self;
        _recommendCell.backgroundColor = kWhiteColor;
        _recommendCell.clipsToBounds = YES;
        _recommendCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return _recommendCell;
    }else if (indexPath.section == AuthenticationFourSection)
    {
        static NSString *CellIdentifier0 = @"CellIdentifier0";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier0];
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier0];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = kWhiteColor;
            [cell addSubview:self.inviteCodeView];
        }
        if (self.society_code.length)
        {
            self.inviteCodeFiled.text = self.society_code;
        }
        return cell;
    }
    else
    {
        static NSString *CellIdentifier1 = @"CellIdentifier1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell addSubview:self.sumitBtn];
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == AuthenticationFiveSection)
    {
        return 0.01;
    }else if (section == AuthenticationThreeSection)
    {
        if (self.recommendTypeModel.invite_type_list.count>0 && _invite_id == 0)
        {
            if (_authentication == 1 || _authentication == 2)
            {
                return 0.01;
            }else
            {
                return 35;
            }
        }else
        {
            return 0.01;
        }
    }else if (section == AuthenticationFourSection)
    {
        return 0.01;
        
    }
    else
    {
        return 35;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == AuthenticationZeroSection)
    {
        return self.basicInfoView;
    }else if (section == AuthenticationOneSection)
    {
        return self.idNewsView;
    }else if(section == AuthenticationTwoSection)
    {
        return self.idAuthenView;
    }else if(section == AuthenticationThreeSection)
    {
        if (self.recommendTypeModel.invite_type_list.count>0 && _invite_id == 0)
        {
            if (_authentication == 1 || _authentication == 2)
            {
                return nil;
            }else
            {
                return self.recommendView;
            }
        }else
        {
            return nil;
        }
    }
    else
    {
        return nil;
    }
}

#pragma mark ============================UITextFieldDelegate============================
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == _threeCell.contactTextFiled)
    {
        if (_threeCell.contactTextFiled.text.length < 1)
        {
            [FanweMessage alertHUD:@"请输入电话号码"];
            return;
        }
        if (_threeCell.contactTextFiled.text.length != 11)
        {
            [FanweMessage alertHUD:@"请输入11位电话号码"];
            return;
        }
        if (![_threeCell.contactTextFiled.text isTelephone])
        {
            [FanweMessage alertHUD:@"请输入正确的电话号码"];
            return;
        }
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == _threeCell.contactTextFiled)
    {
        textField.keyboardType = UIKeyboardTypeNumberPad ;
        return YES;
    }else if (textField == self.inviteCodeFiled)
    {
        if (_authentication == 1 || _authentication == 2)//审核中  认证通过
        {
            return NO;
        }else
        {
            return YES;
        }
    }else
    {
        return YES;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == _threeCell.contactTextFiled)
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

- (void)getIdentificationWithCell:(ThirdTableViewCell *)myCell
{
    if (!_typeSheet)
    {
        UIActionSheet  *typeSheet = [[UIActionSheet alloc] initWithTitle:@"认证类型" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
        for (int i=0; i < [_typeArray count]; i ++)
        {
            cuserModel *model = [_typeArray objectAtIndex:i];
            [typeSheet addButtonWithTitle:model.name];
        }
        [typeSheet addButtonWithTitle:@"取消"];
        typeSheet.cancelButtonIndex = typeSheet.numberOfButtons-1;
        typeSheet.delegate = self;
        [typeSheet showInView:[UIApplication sharedApplication].keyWindow];
        self.typeSheet = typeSheet;
    }
    [self.typeSheet showInView:[UIApplication sharedApplication].keyWindow];
}

#pragma mark 提交
- (void)submitAction
{
    if (_threeCell.typeTextFiled.text.length < 1)
    {
        [[FWHUDHelper sharedInstance] tipMessage:@"请选择认证类型"];
        return;
    }
    if (_threeCell.nameTextFiled.text.length < 1)
    {
        [[FWHUDHelper sharedInstance] tipMessage:@"请输入真实姓名"];
        return;
    }
    if (_threeCell.contactTextFiled.text.length < 1)
    {
        [[FWHUDHelper sharedInstance] tipMessage:@"请输入联系方式"];
        return;
    }
    if (_is_show_identify_number == 1)
    {
        if (_threeCell.identificationNumFiled.text.length != 18)
        {
            [[FWHUDHelper sharedInstance] tipMessage:@"请输入18位有效的身份证号码"];
            return;
        }
    }
    
    if (_urlString1.length < 1)
    {
        [[FWHUDHelper sharedInstance] tipMessage:@"请上传身份证正面照"];
        return;
    }
    if (_urlString2.length < 1)
    {
        [[FWHUDHelper sharedInstance] tipMessage:@"请上传身份证反面照"];
        return;
    }
    if (_urlString3.length < 1)
    {
        [[FWHUDHelper sharedInstance] tipMessage:@"请上传手持身份证正面照"];
        return;
    }
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    [mDict setObject:@"user_center" forKey:@"ctl"];
    [mDict setObject:@"attestation" forKey:@"act"];
    if (_threeCell.typeTextFiled.text.length > 0)
    {
        [mDict setObject:_threeCell.typeTextFiled.text forKey:@"authentication_type"];
    }
    if (_threeCell.nameTextFiled.text.length > 0)
    {
        [mDict setObject:_threeCell.nameTextFiled.text forKey:@"authentication_name"];
    }
    if (_threeCell.identificationNumFiled.text.length > 0)
    {
        if (_is_show_identify_number == 1)
        {
            [mDict setObject:_threeCell.identificationNumFiled.text forKey:@"identify_number"];
        }else
        {
            [mDict setObject:@"" forKey:@"identify_number"];
        }
    }
    if (_threeCell.contactTextFiled.text.length > 0)
    {
        [mDict setObject:_threeCell.contactTextFiled.text forKey:@"contact"];
    }
    if (_urlString1.length > 0)
    {
        [mDict setObject:_urlString1 forKey:@"identify_positive_image"];
    }
    if (_urlString2.length > 0)
    {
        [mDict setObject:_urlString2 forKey:@"identify_nagative_image"];
    }
    if (_urlString3.length > 0)
    {
        [mDict setObject:_urlString3 forKey:@"identify_hold_image"];
    }
    if (_recommendCell.recommendField.text.length>0)
    {
        [mDict setObject:@(_recommendType) forKey:@"invite_type"];
        [mDict setObject:_recommendCell.recommendField.text forKey:@"invite_input"];
    }
    if (self.open_society_code == 1)
    {
        [mDict setObject:self.inviteCodeFiled.text forKey:@"society_code"];
    }
    
    [self.httpsManager POSTWithParameters:mDict SuccessBlock:^(NSDictionary *responseJson)
     {
         if ([responseJson toInt:@"status"] == 1)
         {
             [self.navigationController popViewControllerAnimated:YES];
         }else
         {
             [[FWHUDHelper sharedInstance] tipMessage:[responseJson toString:@"error"]];
         }
         
     } FailureBlock:^(NSError *error)
     {
         NSLog(@"error===%@",error);
     }];
}

#pragma mark  图片的一些操作
- (void)getImgWithtag:(int)tag andCell:(FourTableViewCell *)myCell
{
    _tagCount = tag;
    UIActionSheet *headImgSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    [headImgSheet addButtonWithTitle:@"相机"];
    [headImgSheet addButtonWithTitle:@"从手机相册选择"];
    [headImgSheet addButtonWithTitle:@"取消"];
    headImgSheet.cancelButtonIndex = headImgSheet.numberOfButtons-1;
    headImgSheet.delegate = self;
    [headImgSheet showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet == self.typeSheet)
    {
        if (buttonIndex < self.typeSheet.numberOfButtons - 1)
        {
            cuserModel *model = [_typeArray objectAtIndex:buttonIndex];
            _threeCell.typeTextFiled.text = model.name;
            
        }
    }
    else if (actionSheet == self.recommendSheet)
    {
        if (buttonIndex < self.recommendSheet.numberOfButtons - 1)
        {
            RecommendModel *model = self.recommendTypeModel.invite_type_list[buttonIndex];
            _recommendCell.recommendTypeField.text = model.name;
            _recommendHeight = model.typeID == 1? 50 : 90;
            _recommendType = model.typeID ;
            _recommendCell.recommendField.hidden = model.typeID > 1 ? NO : YES;
            _recommendCell.recommendField.text = @"";
            if (model.typeID>1)
            {
                _recommendCell.recommendField.placeholder = [NSString stringWithFormat:@"请输入%@",model.name];
            }
            [_myTableView reloadData];
        }
    }
    else
    {
        if (buttonIndex == 0)
        {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                picker.sourceType=UIImagePickerControllerSourceTypeCamera;
                picker.delegate = self;
                picker.allowsEditing = YES;
                picker.modalTransitionStyle=UIModalTransitionStyleFlipHorizontal;
            }
            [self presentViewController:picker animated:YES completion:nil];
        }else if (buttonIndex == 1){
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum])
            {
                picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                picker.delegate = self;
                picker.allowsEditing = YES;
                picker.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            }
            [self presentViewController:picker animated:YES completion:nil];
        }
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerEditedImage];
    if (mediaType)
    {
        UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        if (!image)
        {
            image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        }
        if (self.fanweApp.appModel.open_sts == 1)
        {
            if ([_ossManager isSetRightParameter])
            {
                [self showMyHud];
                [self saveImage:image withName:@"1.png"];
                _timeString = [_ossManager getObjectKeyString];
                [_ossManager asyncPutImage:_timeString localFilePath:_uploadFilePath];
            }
        }
        else
        {
            NSData *data=UIImageJPEGRepresentation(image, 1.0);
            if (_tagCount == 0)
            {
                _data1 = data;
                [self saveImage:[UIImage imageWithData:data] withName:@"currentImage.png"];
                
            }else if (_tagCount == 1)
            {
                _data2 = data;
                [self saveImage:[UIImage imageWithData:data] withName:@"currentImage1.png"];
                
            }else if (_tagCount == 2)
            {
                _data3 = data;
                [self saveImage:[UIImage imageWithData:data] withName:@"currentImage2.png"];
            }
            [self performSelector:@selector(uploadAvatar) withObject:nil afterDelay:0.8];
        }
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    [imageData writeToFile:fullPath atomically:NO];
    _uploadFilePath = fullPath;
}

#pragma mark oss代理回调
- (void)uploadImageWithUrlStr:(NSString *)imageUrlStr withUploadStateCount:(int)stateCount
{
    [self hideMyHud];
    if (stateCount == 0)
    {
        NSString *imgString= [NSString stringWithFormat:@"%@%@",_ossManager.oss_domain,_timeString];
        if (_tagCount == 0)
        {
            _urlString1=[NSString stringWithFormat:@"./%@",_timeString];
            [_fourCell.headImgView1 sd_setImageWithURL:[NSURL URLWithString:imgString]];
        }else if (_tagCount == 1)
        {
            _urlString2 = [NSString stringWithFormat:@"./%@",_timeString];
            [_fourCell.headImgView2 sd_setImageWithURL:[NSURL URLWithString:imgString]];
            [[FWHUDHelper sharedInstance] tipMessage:@"身份证反面照片上传成功"];
        }else if (_tagCount == 2)
        {
            _urlString3 = [NSString stringWithFormat:@"./%@",_timeString];
            [_fourCell.headImgView3 sd_setImageWithURL:[NSURL URLWithString:imgString]];
            [[FWHUDHelper sharedInstance] tipMessage:@"手持身份证正面照上传成功"];
        }
    }else
    {
        [[FWHUDHelper sharedInstance] tipMessage:@"上传头像失败"];
    }
}

#pragma mark 使用流文件上传头像
- (void)uploadAvatar
{
    [self showMyHud];
    NSString *imageFile = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *photoName;
    if (_tagCount == 0)
    {
        photoName=[imageFile stringByAppendingPathComponent:@"currentImage.png"];
        
    }else if (_tagCount == 1)
    {
        photoName=[imageFile stringByAppendingPathComponent:@"currentImage1.png"];
        
    }else if (_tagCount == 2)
    {
        photoName=[imageFile stringByAppendingPathComponent:@"currentImage2.png"];
    }
    
    NSURL *fileUrl = [NSURL URLWithString:[NSString stringWithFormat:@"file:%@",photoName]];
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"avatar" forKey:@"ctl"];
    [parmDict setObject:@"uploadImage" forKey:@"act"];
    [parmDict setObject:self.user_id forKey:@"id"];
    FWWeakify(self)
    [self.httpsManager POSTWithDict:parmDict andFileUrl:fileUrl SuccessBlock:^(NSDictionary *responseJson)
     {
         FWStrongify(self)
         [self hideMyHud];
         if ([responseJson toInt:@"status"] == 1)
         {
             if (_tagCount == 0)
             {
                 _urlString1=[responseJson toString:@"path"];
                 _fourCell.headImgView1.image = [UIImage imageWithData:_data1];
             }else if (_tagCount == 1)
             {
                 _urlString2=[responseJson toString:@"path"];
                 _fourCell.headImgView2.image = [UIImage imageWithData:_data2];
             }else if (_tagCount == 2)
             {
                 _urlString3=[responseJson toString:@"path"];
                 _fourCell.headImgView3.image = [UIImage imageWithData:_data3];
             }
         }
         
     } FailureBlock:^(NSError *error)
     {
         FWStrongify(self)
         [self hideMyHud];
         [[FWHUDHelper sharedInstance] tipMessage:[NSString stringWithFormat:@"%@",error]];
     }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)choseRecommendTypeWithRecommendViewCell:(RecommendTableViewCell *)recommendViewCell
{
    if (!_recommendSheet)
    {
        UIActionSheet * recommendSheet = [[UIActionSheet alloc] initWithTitle:@"推荐人信息类型" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
        for (int i=0; i < self.recommendTypeModel.invite_type_list.count; i ++)
        {
            RecommendModel *model = self.recommendTypeModel.invite_type_list[i];
            [recommendSheet addButtonWithTitle:model.name];
        }
        [recommendSheet addButtonWithTitle:@"取消"];
        recommendSheet.cancelButtonIndex = recommendSheet.numberOfButtons-1;
        recommendSheet.delegate = self;
        
        [recommendSheet showInView:[UIApplication sharedApplication].keyWindow];
        self.recommendSheet = recommendSheet;
    }
}



@end
