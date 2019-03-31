//
//  FamilyDesViewController.m
//  FanweApp
//
//  Created by 王珂 on 16/9/26.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "FamilyDesViewController.h"
#import "GetHeadImgViewController.h"
#import "EditFamilyViewController.h"
#import "FamilyDesModel.h"
#import "FamilyMemberViewController.h"
#import "FamilyListModel.h"

@interface FamilyDesViewController ()<UITextViewDelegate>

@property (nonatomic, strong) UIView * view1;
@property (nonatomic, strong) UIView * view2;
@property (nonatomic, strong) UIView * view3;
@property (nonatomic, strong) UIView * view4;
@property (nonatomic, strong) UIView * view5;
@property (nonatomic, strong) UIButton * headBtn;
@property (nonatomic, strong) UILabel * familyLabel;
@property (nonatomic, strong) UITextView * nameTextView;//家族名称
@property (nonatomic, strong) UITextView * desTextView;//家族宣言
@property (nonatomic, strong) UIButton * editBtn;    //编辑按钮
@property (nonatomic, strong) UIButton  * managerBtn; //成员管理
@property (nonatomic, strong) UIButton  * memberBtn;  //家族成员
@property (nonatomic, strong) UIButton  * leaveBtn;   //退出家族
@property (nonatomic, strong) UIButton  * applyBtn;   //申请加入家族
@property (nonatomic, strong) FamilyDesModel * model;  //家族信息Model;
@property (nonatomic, strong) UILabel  * familyHeaderName; //家族族长名
@property (nonatomic, strong) UILabel  * numberLable;  //家族人数
@property (nonatomic, assign) int canEditAll;

@end

@implementation FamilyDesViewController

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
    self.navigationItem.title = @"家族详情";
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
    //    _nameTextView.text =@"道道道非常道";
    _nameTextView.font = [UIFont systemFontOfSize:15];
    _nameTextView.editable = NO;
    [_view2 addSubview:_nameTextView];
    _familyHeaderName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenW, (kScreenH-64)*95/1200)];
    _familyHeaderName.backgroundColor = [UIColor whiteColor];
    _familyHeaderName.font = [UIFont systemFontOfSize:15];
    _familyHeaderName.textAlignment = NSTextAlignmentCenter;
    //    _familyHeaderName.text = @"家族族长";
    [_view3 addSubview:_familyHeaderName];
    
    _numberLable= [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenW, (kScreenH-64)*95/1200)];
    _numberLable.backgroundColor = [UIColor whiteColor];
    _numberLable.font = [UIFont systemFontOfSize:15];
    _numberLable.textAlignment = NSTextAlignmentCenter;
    //    _numberLable.text = @"家族人数";
    [_view4 addSubview:_numberLable];
    
    _desTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, (kScreenH-64)*310/1200)];
    _desTextView.backgroundColor = [UIColor whiteColor];
    //    _desTextView.text = @"家族详情描述";
    _desTextView.editable = NO;
    _desTextView.font = [UIFont systemFontOfSize:15];
    [_view5 addSubview:_desTextView];
    [self createBtn];
}

- (void)createBtn
{
    //如果是家族族长
    if (_isFamilyHeder==1)
    {
        _headBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _headBtn.frame = CGRectMake((kScreenW-90)/2, (CGRectGetHeight(_view1.frame)-117)/2, 90, 90);
        _headBtn.backgroundColor = [UIColor whiteColor];
        _headBtn.layer.cornerRadius = 45;
        _headBtn.layer.masksToBounds = YES;
        [_headBtn addTarget:self action:@selector(clickHeadImage) forControlEvents:UIControlEventTouchUpInside];
        [_view1 addSubview:_headBtn];
        _familyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_headBtn.frame)+10, kScreenW, 17)];
        _familyLabel.text = @"编辑家族头像";
        _familyLabel.textAlignment =  NSTextAlignmentCenter;
        _familyLabel.font = [UIFont systemFontOfSize:17];
        _familyLabel.textColor = kAppGrayColor2;
        [_view1 addSubview:_familyLabel];
        
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
        if (_isFamilyHeder==0)
        {
            _memberBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _memberBtn.frame = CGRectMake(25, 25+CGRectGetMaxY(_desTextView.frame), (kScreenW-75)/2, 40);
            _memberBtn.backgroundColor = kAppMainColor;
            _memberBtn.layer.cornerRadius = 20;
            _memberBtn.layer.masksToBounds = YES;
            [_memberBtn setTitle:@"家族成员" forState:UIControlStateNormal];
            [_memberBtn addTarget:self action:@selector(clickMemberBtn) forControlEvents:UIControlEventTouchUpInside];
            [_view5 addSubview:_memberBtn];
            _leaveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _leaveBtn.frame = CGRectMake(50+(kScreenW-75)/2, 25+CGRectGetMaxY(_desTextView.frame), (kScreenW-75)/2, 40);
            _leaveBtn.backgroundColor = kAppFamilyBtnColor;
            _leaveBtn.layer.cornerRadius = 20;
            _leaveBtn.layer.masksToBounds = YES;
            [_leaveBtn setTitle:@"退出家族" forState:UIControlStateNormal];
            [_leaveBtn addTarget:self action:@selector(clickLeaveBtn) forControlEvents:UIControlEventTouchUpInside];
            [_view5 addSubview:_leaveBtn];
        }
        else if (_isFamilyHeder ==2)
        {
            _applyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _applyBtn.frame = CGRectMake(25, 25+CGRectGetMaxY(_desTextView.frame), kScreenW-50, 40);
            _applyBtn.layer.cornerRadius = 20;
            _applyBtn.layer.masksToBounds = YES;
            [_headBtn sd_setImageWithURL:[NSURL URLWithString:_listModel.family_logo] forState:UIControlStateNormal placeholderImage:kDefaultPreloadHeadImg];
            _nameTextView.text = _listModel.family_name;
            //            _desTextView.text =_model.family_manifesto;
            _familyHeaderName.text = [NSString stringWithFormat:@"家族族长 : %@",_listModel.nick_name];
            _numberLable.text = [NSString stringWithFormat:@"家族人数 : %@人",_listModel.user_count];
            if([_is_apply isEqualToString:@"0"])
            {
                _applyBtn.backgroundColor = kAppMainColor;
                [_applyBtn setTitle:@"加入家族" forState:UIControlStateNormal];
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
    EditFamilyViewController * editFamilyVC = [[EditFamilyViewController alloc] init];
    editFamilyVC.type = 1;
    editFamilyVC.model = self.model;
    editFamilyVC.user_id = self.user_id;
    editFamilyVC.canEditAll = self.canEditAll;
    [self.navigationController pushViewController:editFamilyVC animated:YES];
}

//点击成员管理按钮
- (void)clickManagerBtn
{
    FamilyMemberViewController * familyMemberVC = [[FamilyMemberViewController alloc] init];
    familyMemberVC.isFamilyHeder = 1;
    familyMemberVC.jid = self.model.family_id;
    [self.navigationController pushViewController:familyMemberVC animated:YES];
}

//点击家族成员按钮
- (void)clickMemberBtn
{
    FamilyMemberViewController * familyMemberVC = [[FamilyMemberViewController alloc] init];
    familyMemberVC.isFamilyHeder = 0;
    familyMemberVC.jid = self.model.family_id;
    [self.navigationController pushViewController:familyMemberVC animated:YES];
}

//点击编辑家族头像
- (void)clickHeadImage
{
    EditFamilyViewController * editFamilyVC = [[EditFamilyViewController alloc] init];
    editFamilyVC.type = 1;
    editFamilyVC.model = self.model;
    editFamilyVC.user_id = self.user_id;
    [self.navigationController pushViewController:editFamilyVC animated:YES];
}

//点击退出家族
- (void)clickLeaveBtn
{
    FWWeakify(self)
    [FanweMessage alert:nil message:@"是否退出该家族" destructiveAction:^{
        
        FWStrongify(self)
        NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
        [parmDict setObject:@"family_user" forKey:@"ctl"];
        [parmDict setObject:@"logout" forKey:@"act"];
        [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
            
            if ([responseJson toInt:@"status"]==1)
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
            
        } FailureBlock:^(NSError *error) {
            
        }];
        
    } cancelAction:^{
        
    }];
}

//申请加入家族
- (void)clickApplyBtn
{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"family_user" forKey:@"ctl"];
    [parmDict setObject:@"user_join" forKey:@"act"];
    [parmDict setObject:_jid forKey:@"family_id"];
    
    FWWeakify(self)
    [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
        
        FWStrongify(self)
        if ([responseJson toInt:@"status"]==1)
        {
            [[FWHUDHelper sharedInstance] tipMessage:@"申请已提交"];
            self.applyBtn.backgroundColor = kAppGrayColor3;
            [self.applyBtn setTitle:@"申请中" forState:UIControlStateNormal];
            self.applyBtn.enabled = NO;
        }
        
    } FailureBlock:^(NSError *error) {
        
    }];
}


//点击返回按钮
- (void)comeBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadData
{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"family" forKey:@"ctl"];
    [parmDict setObject:@"index" forKey:@"act"];
    [parmDict setObject:_jid forKey:@"family_id"];
    
    __weak typeof(self) ws = self;
    [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
        
        NSDictionary * dic = [responseJson objectForKey:@"family_info"];
        if (dic && [dic isKindOfClass:[NSDictionary class]])
        {
            _model = [FamilyDesModel mj_objectWithKeyValues:dic];
            [_headBtn sd_setImageWithURL:[NSURL URLWithString:_model.family_logo] forState:UIControlStateNormal placeholderImage:kDefaultPreloadHeadImg];
            _nameTextView.text = _model.family_name;
            _desTextView.text =_model.family_manifesto;
            _familyHeaderName.text = [NSString stringWithFormat:@"家族族长 : %@",_model.nick_name];
            _numberLable.text = [NSString stringWithFormat:@"家族人数 : %@人",_model.user_count];
        }
        if ([responseJson toInt:@"status"]==1)
        {
            if (_isFamilyHeder==1)
            {
                _headBtn.userInteractionEnabled = YES;
                _editBtn.userInteractionEnabled = YES;
                _editBtn.backgroundColor = kAppMainColor;
                _managerBtn.userInteractionEnabled = YES;
                _managerBtn.backgroundColor = kAppFamilyBtnColor;
                _canEditAll = 0;
            }
            if (_isFamilyHeder==0)
            {
                _memberBtn.userInteractionEnabled = YES;
                _memberBtn.backgroundColor = kAppMainColor;
            }
        }
        else if ([responseJson toInt:@"status"] ==0 ) // 申请正在审核
        {
            if (_isFamilyHeder==1) {
                _headBtn.userInteractionEnabled = NO;
                _editBtn.userInteractionEnabled = NO;
                _editBtn.backgroundColor = kAppGrayColor3;
                _managerBtn.userInteractionEnabled = NO;
                _managerBtn.backgroundColor = kAppGrayColor3;
            }
            else if (_isFamilyHeder==0)
            {
                _memberBtn.userInteractionEnabled = NO;
                _memberBtn.backgroundColor = kAppGrayColor3;
            }
        }
        else if ([responseJson toInt:@"status"]==2) // 审核未通过
        {
            if (_isFamilyHeder==1)
            {
                [[FWHUDHelper sharedInstance] tipMessage:@"您的家族未通过审核"];
                _headBtn.userInteractionEnabled = YES;
                _editBtn.userInteractionEnabled = YES;
                _editBtn.backgroundColor = kAppMainColor;
                _managerBtn.userInteractionEnabled = NO;
                _managerBtn.backgroundColor = kAppGrayColor3;
                _canEditAll = 1;
            }
            if (_isFamilyHeder==0)
            {
                _memberBtn.userInteractionEnabled = NO;
                _memberBtn.backgroundColor = kAppGrayColor3;
            }
        }
        
        else if ([responseJson toInt:@"status"] == 3) // 家族已解散
        {
            [[FWHUDHelper sharedInstance] tipMessage:@"您的家族已解散"];
            [ws.navigationController popViewControllerAnimated:YES];
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

@end
