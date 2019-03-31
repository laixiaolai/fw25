//
//  SocietyDesViewController.m
//  FanweApp
//
//  Created by 王珂 on 17/1/22.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "SocietyDesViewController.h"
#import "GetHeadImgViewController.h"
#import "EditSocietyViewController.h"
#import "SocietyDesModel.h"
#import "SocietyMemberViewController.h"
#import "SocietyListModel.h"
@interface SocietyDesViewController ()<UITextViewDelegate>

@property (nonatomic, strong) UIView * view1;
@property (nonatomic, strong) UIView * view2;
@property (nonatomic, strong) UIView * view3;
@property (nonatomic, strong) UIView * view4;
@property (nonatomic, strong) UIView * view5;
@property (nonatomic, strong) UIButton * headBtn;
@property (nonatomic, strong) UILabel * societyLabel;
@property (nonatomic, strong) UITextView * nameTextView;//公会名称
@property (nonatomic, strong) UITextView * desTextView;//公会宣言
@property (nonatomic, strong) UIButton * editBtn;    //编辑按钮
@property (nonatomic, strong) UIButton  * managerBtn; //成员管理
@property (nonatomic, strong) UIButton  * memberBtn;  //公会成员
@property (nonatomic, strong) UIButton  * leaveBtn;   //退出公会
@property (nonatomic, strong) UIButton  * applyBtn;   //申请加入公会
@property (nonatomic, strong) SocietyDesModel * model;  //公会信息Model;
@property (nonatomic, strong) UILabel  * societyHeaderName; //公会会长名
@property (nonatomic, strong) UILabel  * numberLable;  //公会人数
@property (nonatomic, assign) int canEditAll;

@end

@implementation SocietyDesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createView];
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadData];
}


- (void)createView
{
    self.navigationItem.title = @"公会详情";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(comeBack) image:@"com_arrow_vc_back" highImage:@"com_arrow_vc_back"];
    self.view.backgroundColor = kFamilyBackGroundColor;
    _view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, (kScreenH-64)*375/1200)];
    [self.view addSubview:_view1];
    _view2 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_view1.frame), kScreenW, (kScreenH-64)*115/1200)];
    [self.view addSubview:_view2];
    _view3 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_view2.frame), kScreenW, (kScreenH-64)*115/1200)];
    [self.view addSubview:_view3];
    _view4 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_view3.frame), kScreenW, (kScreenH-64)*115/1200)];
    [self.view addSubview:_view4];
    _view5 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_view4.frame), kScreenW, (kScreenH-64)*490/1200)];
    [self.view addSubview:_view5];
    _nameTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, (kScreenH-64)*95/1200)];
    _nameTextView.backgroundColor = [UIColor whiteColor];
    _nameTextView.textAlignment = NSTextAlignmentCenter;
    _nameTextView.font = [UIFont systemFontOfSize:15];
    _nameTextView.editable = NO;
    [_view2 addSubview:_nameTextView];
    _societyHeaderName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenW, (kScreenH-64)*95/1200)];
    _societyHeaderName.backgroundColor = [UIColor whiteColor];
    _societyHeaderName.font = [UIFont systemFontOfSize:15];
    _societyHeaderName.textAlignment = NSTextAlignmentCenter;
    [_view3 addSubview:_societyHeaderName];
    
    _numberLable= [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenW, (kScreenH-64)*95/1200)];
    _numberLable.backgroundColor = [UIColor whiteColor];
    _numberLable.font = [UIFont systemFontOfSize:15];
    _numberLable.textAlignment = NSTextAlignmentCenter;
    //    _numberLable.text = @"公会人数";
    [_view4 addSubview:_numberLable];
    
    _desTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, (kScreenH-64)*310/1200)];
    _desTextView.backgroundColor = [UIColor whiteColor];
    //    _desTextView.text = @"公会详情描述";
    _desTextView.editable = NO;
    _desTextView.font = [UIFont systemFontOfSize:15];
    [_view5 addSubview:_desTextView];
    [self createBtn];
}

- (void)createBtn
{
    //如果是公会会长
    if (_isSocietyHeder==1) {
        
        _headBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _headBtn.frame = CGRectMake((kScreenW-90)/2, (CGRectGetHeight(_view1.frame)-117)/2, 90, 90);
        _headBtn.backgroundColor = [UIColor whiteColor];
        _headBtn.layer.cornerRadius = 45;
        _headBtn.layer.masksToBounds = YES;
        [_headBtn addTarget:self action:@selector(clickHeadImage) forControlEvents:UIControlEventTouchUpInside];
        [_view1 addSubview:_headBtn];
        _societyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_headBtn.frame)+10, kScreenW, 17)];
        _societyLabel.text = @"编辑公会头像";
        _societyLabel.textAlignment =  NSTextAlignmentCenter;
        _societyLabel.font = [UIFont systemFontOfSize:17];
        _societyLabel.textColor = kAppGrayColor2;
        [_view1 addSubview:_societyLabel];
        
        _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _editBtn.frame = CGRectMake(25, 25+CGRectGetMaxY(_desTextView.frame), (kScreenW-75)/2, 40 );
        _editBtn.backgroundColor = kAppMainColor;
        _editBtn.layer.cornerRadius = 20;
        _editBtn.layer.masksToBounds = YES;
        [_editBtn setTitle:@"编辑资料" forState:UIControlStateNormal];
        [_editBtn addTarget:self action:@selector(clickEditBtn) forControlEvents:UIControlEventTouchUpInside];
        [_view5 addSubview:_editBtn];
        _managerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _managerBtn.frame = CGRectMake(50+(kScreenW-75)/2, 25+CGRectGetMaxY(_desTextView.frame), (kScreenW-75)/2, 40);
        _managerBtn.backgroundColor = kAppFamilyBtnColor;
        _managerBtn.layer.cornerRadius = 20;
        _managerBtn.layer.masksToBounds = YES;
        [_managerBtn setTitle:@"成员管理" forState:UIControlStateNormal];
        [_managerBtn addTarget:self action:@selector(clickManagerBtn) forControlEvents:UIControlEventTouchUpInside];
        [_view5 addSubview:_managerBtn];
    }
    else
    {
        _headBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _headBtn.frame = CGRectMake((kScreenW-90)/2, (CGRectGetHeight(_view1.frame)-90)/2, 90, 90);
        _headBtn.backgroundColor = [UIColor whiteColor];
        _headBtn.layer.cornerRadius = 45;
        _headBtn.layer.masksToBounds = YES;
        _headBtn.userInteractionEnabled = NO;
        [_view1 addSubview:_headBtn];
        if (_isSocietyHeder==0) {
            _memberBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _memberBtn.frame = CGRectMake(25, 25+CGRectGetMaxY(_desTextView.frame), (kScreenW-75)/2, 40);
            _memberBtn.backgroundColor = kAppMainColor;
            _memberBtn.layer.cornerRadius = 20;
            _memberBtn.layer.masksToBounds = YES;
            [_memberBtn setTitle:@"公会成员" forState:UIControlStateNormal];
            [_memberBtn addTarget:self action:@selector(clickMemberBtn) forControlEvents:UIControlEventTouchUpInside];
            [_view5 addSubview:_memberBtn];
            _leaveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _leaveBtn.frame = CGRectMake(50+(kScreenW-75)/2, 25+CGRectGetMaxY(_desTextView.frame), (kScreenW-75)/2, 40);
            _leaveBtn.backgroundColor = kAppFamilyBtnColor;
            _leaveBtn.layer.cornerRadius = 20;
            _leaveBtn.layer.masksToBounds = YES;
            [_leaveBtn setTitle:@"退出公会" forState:UIControlStateNormal];
            [_leaveBtn addTarget:self action:@selector(clickLeaveBtn) forControlEvents:UIControlEventTouchUpInside];
            [_view5 addSubview:_leaveBtn];
        }
        else if (_isSocietyHeder ==2)
        {
            _applyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _applyBtn.frame = CGRectMake(25, 25+CGRectGetMaxY(_desTextView.frame), kScreenW-50, 40);
            _applyBtn.layer.cornerRadius = 20;
            _applyBtn.layer.masksToBounds = YES;
            [_headBtn sd_setImageWithURL:[NSURL URLWithString:_listModel.logo] forState:UIControlStateNormal placeholderImage:kDefaultPreloadHeadImg];
            _nameTextView.text = _listModel.name;
            //            _desTextView.text =_model.family_manifesto;
            _societyHeaderName.text = [NSString stringWithFormat:@"公会会长 : %@",_listModel.nick_name];
            _numberLable.text = [NSString stringWithFormat:@"公会人数 : %@人",_listModel.user_count];
            if([_is_apply isEqualToString:@"0"])
            {
                _applyBtn.backgroundColor = kAppMainColor;
                [_applyBtn setTitle:@"加入公会" forState:UIControlStateNormal];
                [_applyBtn addTarget:self action:@selector(clickApplyBtn) forControlEvents:UIControlEventTouchUpInside];
            }
            else if ([_is_apply isEqualToString:@"1"])
            {
                _applyBtn.backgroundColor = kAppGrayColor3;
                [_applyBtn setTitle:@"申请中" forState:UIControlStateNormal];
                _applyBtn.enabled = NO;
            }
            else if ([_is_apply isEqualToString:@"2"])
            {
                _applyBtn.backgroundColor = kAppGrayColor3;
                [_applyBtn setTitle:@"已加入" forState:UIControlStateNormal];
                _applyBtn.enabled = NO;
            }
            [_view5 addSubview:_applyBtn];
        }
    }
}

//点击编辑资料按钮
- (void)clickEditBtn
{
    EditSocietyViewController * editSocietyVC = [[EditSocietyViewController alloc] init];
    editSocietyVC.type = 1;
    editSocietyVC.model = self.model;
    editSocietyVC.user_id = self.user_id;
    editSocietyVC.canEditAll = self.canEditAll;
    [self.navigationController pushViewController:editSocietyVC animated:YES];
}

//点击成员管理按钮
- (void)clickManagerBtn
{
    SocietyMemberViewController * societyMemberVC = [[SocietyMemberViewController alloc] init];
    societyMemberVC.isSocietyHeder = 1;
    societyMemberVC.society_id = self.model.society_id;
    [self.navigationController pushViewController:societyMemberVC animated:YES];
}

//点击公会成员按钮
- (void)clickMemberBtn
{
    SocietyMemberViewController * societyMemberVC = [[SocietyMemberViewController alloc] init];
    societyMemberVC.isSocietyHeder = 0;
    societyMemberVC.society_id = self.model.society_id;
    [self.navigationController pushViewController:societyMemberVC animated:YES];
}

//点击编辑家族头像
- (void)clickHeadImage
{
    EditSocietyViewController * editSocietyVC = [[EditSocietyViewController alloc] init];
    editSocietyVC.type = 1;
    editSocietyVC.model = self.model;
    editSocietyVC.user_id = self.user_id;
    [self.navigationController pushViewController:editSocietyVC animated:YES];
}

//点击退出公会
- (void)clickLeaveBtn
{
    FWWeakify(self)
    [FanweMessage alert:@"提示" message:@"是否退出该公会" destructiveAction:^{
        
        FWStrongify(self)
        NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
        [parmDict setObject:@"society_user" forKey:@"ctl"];
        [parmDict setObject:@"logout" forKey:@"act"];
        [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
            
        } FailureBlock:^(NSError *error) {
            
        }];
        
    } cancelAction:^{
        
    }];
}

//申请加入公会
- (void)clickApplyBtn
{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"society_user" forKey:@"ctl"];
    [parmDict setObject:@"join" forKey:@"act"];
    [parmDict setObject:_society_id forKey:@"society_id"];
    [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
        
        if ([responseJson toInt:@"status"]==1)
        {
            [[FWHUDHelper sharedInstance] tipMessage:@"申请已提交"];
            _applyBtn.backgroundColor = kAppGrayColor3;
            [_applyBtn setTitle:@"申请中" forState:UIControlStateNormal];
            _applyBtn.enabled = NO;
        }
        
    } FailureBlock:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}


//点击返回按钮
- (void)comeBack
{
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)loadData
{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"society" forKey:@"ctl"];
    [parmDict setObject:@"index" forKey:@"act"];
    [parmDict setObject:_society_id forKey:@"society_id"];
    [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
        
        NSDictionary * dic = [responseJson objectForKey:@"society_info"];
        if (dic && [dic isKindOfClass:[NSDictionary class]])
        {
            _model = [SocietyDesModel mj_objectWithKeyValues:dic];
            [_headBtn sd_setImageWithURL:[NSURL URLWithString:_model.logo] forState:UIControlStateNormal placeholderImage:kDefaultPreloadHeadImg];
            _nameTextView.text = _model.name;
            _desTextView.text =_model.manifesto;
            _societyHeaderName.text = [NSString stringWithFormat:@"公会会长 : %@",_model.nick_name];
            _numberLable.text = [NSString stringWithFormat:@"公会人数 : %@人",_model.user_count];
        }
        if ([dic toInt:@"status"]==1)
        {
            if (_isSocietyHeder==1)
            {
                _headBtn.userInteractionEnabled = YES;
                _editBtn.userInteractionEnabled = YES;
                _editBtn.backgroundColor = kAppMainColor;
                _managerBtn.userInteractionEnabled = YES;
                _managerBtn.backgroundColor = kAppFamilyBtnColor;
                _canEditAll = 0;
            }
            if (_isSocietyHeder==0)
            {
                _memberBtn.userInteractionEnabled = YES;
                _memberBtn.backgroundColor = kAppMainColor;
            }
        }
        else if ([dic toInt:@"status"]==0) // 申请正在审核
        {
            if (_isSocietyHeder==1)
            {
                _headBtn.userInteractionEnabled = NO;
                _editBtn.userInteractionEnabled = NO;
                _editBtn.backgroundColor = kAppGrayColor3;
                _managerBtn.userInteractionEnabled = NO;
                _managerBtn.backgroundColor = kAppGrayColor3;
            }
            else if (_isSocietyHeder==0)
            {
                _memberBtn.userInteractionEnabled = NO;
                _memberBtn.backgroundColor = kAppGrayColor3;
            }
        }
        
        else if ([dic toInt:@"status"]==2) // 审核未通过
        {
            if (_isSocietyHeder==1)
            {
                _headBtn.userInteractionEnabled = YES;
                _editBtn.userInteractionEnabled = YES;
                _editBtn.backgroundColor = kAppMainColor;
                _managerBtn.userInteractionEnabled = NO;
                _managerBtn.backgroundColor = kAppGrayColor3;
                _canEditAll = 1;
            }
            if (_isSocietyHeder==0)
            {
                _memberBtn.userInteractionEnabled = NO;
                _memberBtn.backgroundColor = kAppGrayColor3;
            }
        }
        
    } FailureBlock:^(NSError *error) {
        
    }];
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    [UIMenuController sharedMenuController].menuVisible = NO;  //donot display the menu
    [_desTextView resignFirstResponder];                     //do not allow the user to selected anything
    [_nameTextView resignFirstResponder];
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
