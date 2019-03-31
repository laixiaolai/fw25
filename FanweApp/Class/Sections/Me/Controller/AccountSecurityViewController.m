//
//  AccountSecurityViewController.m
//  FanweApp
//
//  Created by GuoMs on 16/7/18.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "AccountSecurityViewController.h"
#import "LPhoneLoginVC.h"
#import "ASTableViewCell.h"
#import "ASView.h"
#import "AccSecModel.h"

@interface AccountSecurityViewController ()

@property(nonatomic,retain)ASView *asView;
@property (strong, nonatomic) IBOutlet UITableView *AStableView;
@property (nonatomic, strong) NetHttpsManager *httpManager;
@property (nonatomic, strong) AccSecModel *model;

@end

@implementation AccountSecurityViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.leftBarButtonItem=[UIBarButtonItem itemWithTarget:self action:@selector(returnToMeVc) image:@"com_arrow_vc_back" highImage:@"com_arrow_vc_back"];
    [self getNetAccAndSecWorking];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title =@"帐号与安全";
    [self.AStableView registerNib:[UINib nibWithNibName:@"ASTableViewCell" bundle:nil] forCellReuseIdentifier:@"ASOfCell"];
    self.asView = [[[NSBundle mainBundle]loadNibNamed:@"ASView" owner:self options:nil]lastObject];
    self.asView.backgroundColor = kBackGroundColor;
    self.asView.frame = CGRectMake(0, 0, kScreenW, 140);
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW , 210)];
    [headerView addSubview:self.asView];
    self.AStableView.tableHeaderView = headerView;
    self.AStableView.separatorStyle =  UITableViewCellSeparatorStyleNone;
    self.AStableView.backgroundColor = kBackGroundColor;
    self.AStableView.scrollEnabled = NO;
    _httpManager  = [NetHttpsManager manager];
}

#pragma mark - 账户与安全网络请求
- (void)getNetAccAndSecWorking
{
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setValue:@"settings" forKey:@"ctl"];
    [dict setValue:@"security" forKey:@"act"];
    if (self.userid.length)
    {
        [dict setObject:self.userid forKey:@"to_user_id"];
    }
    [_httpManager POSTWithParameters:dict SuccessBlock:^(NSDictionary *responseJson) {
        
        self.model = [AccSecModel mj_objectWithKeyValues:responseJson];
        if ([self.model.is_security isEqualToString:@"0"])
        {
            
        }
        else
        {
            self.asView.SecutyLable.text = @"安全等级:高";
            self.asView.ShieldImageView.image = [UIImage imageNamed:@"me_shield_light"];
        }
        [self.AStableView reloadData];
        
    } FailureBlock:^(NSError *error) {
        
    }];
}

#pragma mark - 返回上一级
- (void)returnToMeVc
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45*kAppRowHScale;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ASTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ASOfCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.phoneNumber.text = self.model.mobile;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.model.is_security isEqualToString:@"0"])
    {
        LPhoneLoginVC *phoneLogin = [[LPhoneLoginVC alloc]init];
        phoneLogin.LSecBPhone = YES;
        [self.navigationController pushViewController:phoneLogin animated:YES];
    }
    else
    {
        [[FWHUDHelper sharedInstance] tipMessage:@"您已绑定手机"];
        
    }
}

@end
