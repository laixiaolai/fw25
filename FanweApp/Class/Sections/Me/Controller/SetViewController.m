//
//  SetViewController.m
//  FanweApp
//
//  Created by GuoMs on 16/7/18.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "SetViewController.h"
#import "SetTableViewCell.h"
#import "AccountSecurityViewController.h"
#import "FollowerViewController.h"
#import "LoginViewController.h"
#import "LoginOutModel.h"
#import "PushManageViewController.h"
#import "RecommendedPersonViewController.h"

@interface SetViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *setTableView;

@end

@implementation SetViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"设置";
    [self initSetTableView];
    [self backBtnWithBlock];
}

- (void)initSetTableView
{
    self.setTableView.scrollEnabled = NO;
    [self.setTableView registerNib:[UINib nibWithNibName:@"SetTableViewCell" bundle:nil] forCellReuseIdentifier:@"setCell"];
    self.setTableView.separatorColor = kAppSpaceColor4;
    self.setTableView.backgroundColor = kAppSpaceColor2;
}

- (void)backBtnWithBlock
{
    // 返回按钮
    [self setupBackBtnWithBlock:nil];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

#pragma mark -- 返回区头的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 10)];
    headView.backgroundColor = kAppSpaceColor2;
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45*kAppRowHScale;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
        {
            return 1;
        }
            break;
        case 1:
        {
            if ([self.fanweApp.appModel.distribution_module integerValue] == 1)
            {
                return 3;
            }
            else
                return 2;
        }
            break;
        case 2:
        {
            if (kIsEqualCheckingVersion)
            {
                return 2;
            }
            else
            {
                return 3;
            }
        }
            break;
        case 3:
        {
            if (kSupportH5Shopping == 1) return 0;
            return 1;
        }
            break;
            
        default:
            break;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"setCell" forIndexPath:indexPath];
    
    [cell configurationCellWithSection:indexPath.section row:indexPath.row distribution_module:self.fanweApp.appModel.distribution_module];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        //账户安全点击事件
        AccountSecurityViewController *acVC = [[AccountSecurityViewController alloc]init];
        acVC.userid = self.userID;
        [self.navigationController pushViewController:acVC animated:YES];
    }
    else if (indexPath.section == 1)
    {
        switch (indexPath.row)
        {
            case 0:
            {
                // 黑名单点击事件
                FollowerViewController *followVC = [[FollowerViewController alloc]init];
                followVC.type = @"3";
                followVC.user_id = self.userID;
                [self.navigationController pushViewController:followVC animated:YES];
            }
                break;
            case 1:
            {
                // 推送管理点击事件
                PushManageViewController *pushManageVC = [[PushManageViewController alloc]init];
                pushManageVC.userId = self.userID;
                [self.navigationController pushViewController:pushManageVC animated:YES];
            }
                break;
            case 2:
            {
                // 推荐人ID
                RecommendedPersonViewController *recommendPersonVC = [[RecommendedPersonViewController alloc]init];
                recommendPersonVC.userID = self.userID;
                recommendPersonVC.view.backgroundColor = [UIColor whiteColor];
                [self.navigationController pushViewController:recommendPersonVC animated:YES];
            }
                break;
                
            default:
                break;
        }
    }
    else if (indexPath.section == 2)
    {
        if (indexPath.row == 0)
        {
            // 帮助与反馈点击事件
            FWMainWebViewController *tmpController = [FWMainWebViewController webControlerWithUrlStr:self.fanweApp.appModel.h5_url.url_help_feedback isShowIndicator:YES isShowNavBar:YES isShowBackBtn:YES isShowCloseBtn:YES];
            tmpController.navTitleStr = @"帮助与反馈";
            [self.navigationController pushViewController:tmpController animated:YES];
        }
        else if (indexPath.row == 1)
        {
            if ([VersionNum isEqualToString:self.fanweApp.appModel.ios_check_version] )
            {
                // 关于我们
                FWMainWebViewController *tmpController = [FWMainWebViewController webControlerWithUrlStr:self.fanweApp.appModel.h5_url.url_about_we isShowIndicator:YES isShowNavBar:YES isShowBackBtn:YES isShowCloseBtn:YES];
                tmpController.navTitleStr = @"关于我们";
                [self.navigationController pushViewController:tmpController animated:YES];
            }
            else
            {
                // 检查更新
                if (self.fanweApp.appModel.version.has_upgrade == 1)
                {
                    self.fanweApp.ios_down_url = self.fanweApp.appModel.version.ios_down_url;
                    
                    // 强制升级:forced_upgrade ; 0:非强制升级，可取消; 1:强制升级
                    if (self.fanweApp.appModel.version.forced_upgrade == 1)
                    {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.fanweApp.ios_down_url]];
                    }
                    else
                    {
                        FWWeakify(self)
                        [FanweMessage alert:@"提示" message:@"发现新版本，需要升级吗？" destructiveAction:^{
                            
                            FWStrongify(self)
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.fanweApp.ios_down_url]];
                            
                        } cancelAction:^{
                            
                        }];
                    }
                }
                else
                {
                    [FanweMessage alertTWMessage:@"当前已是最新版本！"];
                }
                
                if (!self.fanweApp.appModel.short_name || [self.fanweApp.appModel.short_name isEqualToString:@""])
                {
                    self.fanweApp.appModel.short_name = ShortNameStr;
                }
                if (!self.fanweApp.appModel.ticket_name || [self.fanweApp.appModel.ticket_name isEqualToString:@""])
                {
                    self.fanweApp.appModel.ticket_name = TicketNameStr;
                }
            }
        }
        else if(indexPath.row == 2)
        {
            // 关于我们
            FWMainWebViewController *tmpController = [FWMainWebViewController webControlerWithUrlStr:self.fanweApp.appModel.h5_url.url_about_we isShowIndicator:YES isShowNavBar:YES isShowBackBtn:YES isShowCloseBtn:YES];
            tmpController.navTitleStr = @"关于我们";
            [self.navigationController pushViewController:tmpController animated:YES];
        }
    }
    else if(indexPath.section == 3)
    {
        // 退出登录
        NSString*appDomain = [[NSBundle mainBundle]bundleIdentifier];
        [[NSUserDefaults standardUserDefaults]removePersistentDomainForName:appDomain];
        [self setNetworing];
    }
}

#pragma mark -- 退出登录
- (void)setNetworing
{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"login" forKey:@"ctl"];
    [parmDict setObject:@"loginout" forKey:@"act"];
    if (self.userID.length > 0)
    {
        [parmDict setObject:self.userID forKey:@"to_user_id"];
    }
    
    FWWeakify(self)
    [self.httpsManager POSTWithParameters:parmDict  SuccessBlock:^(NSDictionary *responseJson) {
        if ([responseJson toInt:@"status"] == 1)
        {
            FWStrongify(self)
            [self.setTableView reloadData];
            [self.navigationController popViewControllerAnimated:YES];
            [[IMAPlatform sharedInstance] logout:^{
                [[AppDelegate sharedAppDelegate] enterLoginUI];
            } fail:^(int code, NSString *msg) {
                [[AppDelegate sharedAppDelegate] enterLoginUI];
            }];
            
            [AppViewModel loadInit];
        }else
        {
            [FanweMessage alertHUD:[responseJson toString:@"error"]];
        }
    } FailureBlock:^(NSError *error) {
        
    }];
}

@end
