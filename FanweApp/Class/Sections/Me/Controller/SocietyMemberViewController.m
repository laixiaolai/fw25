//
//  SocietyMemberViewController.m
//  FanweApp
//
//  Created by 王珂 on 17/1/22.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "SocietyMemberViewController.h"
#import "SocietyMemberCell.h"
#import "SenderModel.h"
#import "SHomePageVC.h"
#import "SocietyMemberApplyCell.h"
#import "SocietyLeaveApplyCell.h"
#import "SocietyMemberModel.h"

@interface SocietyMemberViewController ()<UITableViewDelegate,UITableViewDataSource,SocietyMemberApplyCellDelegate,SocietyMemberCellDelegate,SocietyLeaveApplyCellDelegate>
@property (nonatomic, strong) UIButton * societyMemberBtn;//公会成员
@property (nonatomic, strong) UIButton * memberApplyBtn;//成员申请
@property (nonatomic, strong) UIButton * leaveApplyBtn;//退出申请
@property (nonatomic, strong) UIView * displayView;
@property (nonatomic, strong) UIView * slideLineView;
@property (nonatomic, strong) NSMutableArray *userDataArray;
@property (nonatomic, strong) NetHttpsManager * httpManager;
@property (nonatomic, strong) UITableView *displayTabel;
@property (nonatomic, assign) int has_next;
@property (nonatomic, assign) int currentPage;;
@property (nonatomic, assign) int state;;
@property (nonatomic, copy) NSString *searchType;
@property (nonatomic, assign) int societyNumber;
@property (nonatomic, assign) int applyNumber;
@property (nonatomic, assign) int quitApplyNumber;

@end

@implementation SocietyMemberViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title= @"成员列表";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(comeBack) image:@"com_arrow_vc_back" highImage:@"com_arrow_vc_back"];
    self.searchType = @"1";
    self.view.backgroundColor = kBackGroundColor;
    _userDataArray = [NSMutableArray array];
    _httpManager = [NetHttpsManager manager];
    _currentPage = 1;
    [self creatTabelView];
}

#pragma mark 公会成员button和成员申请button
- (void)selectButton
{
    _displayView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 40)];
    [self.view addSubview:_displayView];
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 39, kScreenW, 1)];
    lineView.backgroundColor = myTextColorLine5;
    [_displayView addSubview:lineView];
    //公会成员
    _societyMemberBtn= [[UIButton alloc]initWithFrame:CGRectMake(0,0, kScreenW/3, 38)];
    [_societyMemberBtn setTitleColor:kAppMainColor forState:UIControlStateNormal];
    [_societyMemberBtn addTarget:self action:@selector(societyMemberBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    _societyMemberBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_displayView addSubview:_societyMemberBtn];
    //滑动的滚动条
    _slideLineView = [[UIView alloc]init];
    _slideLineView.backgroundColor = kAppMainColor;
    _slideLineView.frame =CGRectMake(0, 38, kScreenW/3, 2);
    [_displayView addSubview:_slideLineView];
    //成员申请
    _memberApplyBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenW/3,0, kScreenW/3, 39)];
    [_memberApplyBtn addTarget:self action:@selector(memberApplyBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_memberApplyBtn setTitleColor:kAppGrayColor2 forState:UIControlStateNormal];
    _memberApplyBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    //    NSString * memberApplyStr = [NSString stringWithFormat:@"成员申请(%d)",21];
    //    [_memberApplyBtn setTitle:@"成员申请(?人)" forState:UIControlStateNormal];
    [_displayView addSubview:_memberApplyBtn];
    _leaveApplyBtn = [[UIButton alloc]initWithFrame:CGRectMake(2*kScreenW/3,0, kScreenW/3, 39)];
    [_leaveApplyBtn addTarget:self action:@selector(leaveApplyBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_leaveApplyBtn setTitleColor:kAppGrayColor2 forState:UIControlStateNormal];
    _leaveApplyBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_leaveApplyBtn setTitle:@"退出申请" forState:UIControlStateNormal];
    //    NSString * memberApplyStr = [NSString stringWithFormat:@"成员申请(%d)",21];
    //    [_memberApplyBtn setTitle:@"成员申请(?人)" forState:UIControlStateNormal];
    [_displayView addSubview:_leaveApplyBtn];
}

#pragma mark 点击公会成员或成员申请的执行
- (void)societyMemberBtnAction:(UIButton *)sender
{
    self.searchType = @"1";
    [sender setTitleColor:kAppMainColor forState:UIControlStateNormal];
    [_memberApplyBtn setTitleColor:kAppGrayColor2 forState:UIControlStateNormal];
    [_leaveApplyBtn setTitleColor:kAppGrayColor2 forState:UIControlStateNormal];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.1];
    _slideLineView.frame =CGRectMake(0, 38, kScreenW/3, 2);
    [UIView commitAnimations];
    [self headerReresh];
}

- (void)memberApplyBtnAction:(UIButton *)sender
{
    self.searchType = @"2";
    [sender setTitleColor:kAppMainColor forState:UIControlStateNormal];
    [_societyMemberBtn setTitleColor:kAppGrayColor2 forState:UIControlStateNormal];
    [_leaveApplyBtn setTitleColor:kAppGrayColor2 forState:UIControlStateNormal];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.1];
    _slideLineView.frame =CGRectMake(kScreenW/3, 38, kScreenW/3, 2);
    [UIView commitAnimations];
    [self headerReresh];
}

- (void)leaveApplyBtnAction:(UIButton *)sender
{
    self.searchType = @"3";
    [sender setTitleColor:kAppMainColor forState:UIControlStateNormal];
    [_societyMemberBtn setTitleColor:kAppGrayColor2 forState:UIControlStateNormal];
    [_memberApplyBtn setTitleColor:kAppGrayColor2 forState:UIControlStateNormal];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.1];
    _slideLineView.frame =CGRectMake(2*kScreenW/3, 38, kScreenW/3, 2);
    [UIView commitAnimations];
    [self headerReresh];
}

- (void)comeBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma mark展示数据的表格创建
- (void)creatTabelView
{
    _displayTabel = [[UITableView alloc]init];
    if (self.isSocietyHeder == 1)
    {
        [self selectButton];
        _displayTabel.frame = CGRectMake(0,40,kScreenW, kScreenH-104);
    }
    else if (self.isSocietyHeder == 0)
    {
        _displayTabel.frame = CGRectMake(0, 0,kScreenW, kScreenH-64);
    }
    _displayTabel.delegate =self;
    _displayTabel.dataSource =self;
    _displayTabel.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_displayTabel];
    
    [FWMJRefreshManager refresh:_displayTabel target:self headerRereshAction:@selector(headerReresh) footerRereshAction:@selector(footerReresh)];
}

- (void)headerReresh
{
    [self loadNetDataWithPage:1];
}

- (void)footerReresh
{
    if (_has_next == 1)
    {
        _currentPage ++;
        [self loadNetDataWithPage:_currentPage];
    }
    else
    {
        [FWMJRefreshManager endRefresh:_displayTabel];
    }
}

#pragma mark 请求数据
- (void)loadNetDataWithPage:(int)page
{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"society_user" forKey:@"ctl"];
    [parmDict setObject:@"user_list" forKey:@"act"];
    if (_isSocietyHeder == 0) {
        [parmDict setObject:self.society_id forKey:@"society_id"];
    }
    else
    {
        if ([_searchType isEqualToString:@"1"]) {
            [parmDict setObject:@"1" forKey:@"status"];
        }
        else if ([_searchType isEqualToString:@"2"])
        {
            [parmDict setObject:@"0" forKey:@"status"];
        }
        else if ([_searchType isEqualToString:@"3"])
        {
            [parmDict setObject:@"3" forKey:@"status"];
        }
    }
    //    if ([_searchType isEqualToString:@"1"])//1代表家族成员
    //    {
    //        [parmDict setObject:@"family_user" forKey:@"ctl"];
    //        [parmDict setObject:@"user_list" forKey:@"act"];
    //    }else if ([_searchType isEqualToString:@"2"])//代表成员申请
    //    {
    //        [parmDict setObject:@"family_user" forKey:@"ctl"];
    //        [parmDict setObject:@"r_user_list" forKey:@"act"];
    //    }
    [parmDict setObject:[NSString stringWithFormat:@"%d",page] forKey:@"page"];
    [_httpManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson)
     {
         _state = [responseJson toInt:@"status"];
         [responseJson objectForKey:@"rs_count"];
         if (_state == 1)
         {
             if (_isSocietyHeder == 1) {
                 NSString * societyMemberStr = [NSString stringWithFormat:@"公会成员(%@)",[responseJson objectForKey:@"rs_count"]];
                 _societyNumber = [responseJson toInt:@"rs_count"];
                 [_societyMemberBtn setTitle:societyMemberStr  forState:UIControlStateNormal];
                 NSString * memberApplyStr = [NSString stringWithFormat:@"成员申请(%@)",[responseJson objectForKey:@"apply_count"]];
                 _applyNumber = [responseJson toInt:@"apply_count"];
                 [_memberApplyBtn setTitle:memberApplyStr forState:UIControlStateNormal];
                 NSString * quitApplyStr = [NSString stringWithFormat:@"退出申请(%@)",[responseJson objectForKey:@"quit_count"]];
                 _quitApplyNumber = [responseJson toInt:@"quit_count"];
                 [_leaveApplyBtn setTitle:quitApplyStr forState:UIControlStateNormal];
             }
             //             //如果是公会会长并且选中的是公会成员
             //             if (_isSocietyHeder == 1&& [_searchType isEqualToString:@"1"]) {
             //                 NSString * societyMemberStr = [NSString stringWithFormat:@"公会成员(%@)",[responseJson objectForKey:@"rs_count"]];
             //                 _societyNumber = [responseJson toInt:@"rs_count"];
             //                 [_societyMemberBtn setTitle:societyMemberStr  forState:UIControlStateNormal];
             //                 NSString * memberApplyStr = [NSString stringWithFormat:@"成员申请(%@)",[responseJson objectForKey:@"apply_count"]];
             //                 _applyNumber = [responseJson toInt:@"apply_count"];
             //                 [_memberApplyBtn setTitle:memberApplyStr forState:UIControlStateNormal];
             //                 NSString * quitApplyStr = [NSString stringWithFormat:@"退出申请(%@)",[responseJson objectForKey:@"quit_count"]];
             //                 _quitApplyNumber = [responseJson toInt:@"quit_count"];
             //                 [_leaveApplyBtn setTitle:quitApplyStr forState:UIControlStateNormal];
             //             }
             //             //如果是公会会长并且选中的是成员申请
             //             else if (_isSocietyHeder == 1&& [_searchType isEqualToString:@"2"])
             //             {
             //                 NSString * societyMemberStr = [NSString stringWithFormat:@"公会成员(%@)",[responseJson objectForKey:@"rs_count"]];
             //                 _societyNumber = [responseJson toInt:@"rs_count"];
             //                 [_societyMemberBtn setTitle:societyMemberStr  forState:UIControlStateNormal];
             //                 NSString * memberApplyStr = [NSString stringWithFormat:@"成员申请(%@)",[responseJson objectForKey:@"apply_count"]];
             //                 _applyNumber = [responseJson toInt:@"apply_count"];
             //                 [_memberApplyBtn setTitle:memberApplyStr forState:UIControlStateNormal];
             //             }
             //             //如果是公会会长并且选中的是退出申请
             //             else if (_isSocietyHeder == 1&& [_searchType isEqualToString:@"3"])
             //             {
             //                 NSString * societyMemberStr = [NSString stringWithFormat:@"公会成员(%@)",[responseJson objectForKey:@"rs_count"]];
             //                 _societyNumber = [responseJson toInt:@"rs_count"];
             //                 [_societyMemberBtn setTitle:societyMemberStr  forState:UIControlStateNormal];
             //                 NSString * memberApplyStr = [NSString stringWithFormat:@"成员申请(%@)",[responseJson objectForKey:@"apply_count"]];
             //                 _applyNumber = [responseJson toInt:@"apply_count"];
             //                 [_memberApplyBtn setTitle:memberApplyStr forState:UIControlStateNormal];
             //             }
             NSDictionary * dic = [responseJson objectForKey:@"page"];
             if (dic && [dic isKindOfClass:[NSDictionary class]]) {
                 _currentPage = [dic toInt:@"page"];
                 if (_currentPage == 1 || _currentPage == 0)
                 {
                     [_userDataArray removeAllObjects];
                 }
                 _has_next = [dic toInt:@"has_next"];
             }
             NSArray *listArray = [responseJson objectForKey:@"list"];
             if (listArray && [listArray isKindOfClass:[NSArray class]]&& listArray.count>0) {
                 for (NSDictionary *dict in listArray)
                 {
                     SocietyMemberModel *sModel = [SocietyMemberModel mj_objectWithKeyValues:dict];
                     [_userDataArray addObject:sModel];
                 }
             }
         }
         [_displayTabel reloadData];
         
         [FWMJRefreshManager endRefresh:_displayTabel];
         
     } FailureBlock:^(NSError *error)
     {
         [FWMJRefreshManager endRefresh:_displayTabel];
     }];
}


#pragma mark ----tabelView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_userDataArray.count > 0)
    {
        return _userDataArray.count;
    }
    else
        return 0;
}
#pragma mark ----设置cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([self.searchType isEqualToString:@"1"])
    {
        SocietyMemberCell * cell = [SocietyMemberCell cellWithTableView:tableView];
        SocietyMemberModel *model = _userDataArray[indexPath.row];
        cell.isSocietyHeader = _isSocietyHeder;
        [cell creatCellWithModel:model WithRow:(int)indexPath.row];
        CGRect rect = cell.lineView.frame;
        rect.origin.x = 10;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.lineView.frame = rect;
        //        cell.isFamilyHeader = _isFamilyHeder;
        cell.delegate = self;
        return cell;
        
    }
    else if([self.searchType isEqualToString:@"2"])
    {
        SocietyMemberApplyCell *cell = [SocietyMemberApplyCell cellWithTableView:tableView];
        SocietyMemberModel *model = _userDataArray[indexPath.row];
        [cell creatCellWithModel:model WithRow:(int)indexPath.row];
        CGRect rect = cell.lineView.frame;
        rect.origin.x = 10;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.lineView.frame = rect;
        cell.delegate = self;
        return cell;
    }
    else
    {
        SocietyLeaveApplyCell *cell = [SocietyLeaveApplyCell cellWithTableView:tableView];
        SocietyMemberModel *model = _userDataArray[indexPath.row];
        [cell creatCellWithModel:model WithRow:(int)indexPath.row];
        CGRect rect = cell.lineView.frame;
        rect.origin.x = 10;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.lineView.frame = rect;
        cell.delegate = self;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_userDataArray.count > 0 && indexPath.row < _userDataArray.count)
    {
        SocietyMemberModel *sModel = _userDataArray[indexPath.row];
        SHomePageVC *homeVC = [[SHomePageVC alloc]init];
        homeVC.user_id = sModel.user_id;
        homeVC.user_nickname =sModel.nick_name;
        homeVC.type = 0;
        [[AppDelegate sharedAppDelegate]pushViewController:homeVC];
    }
    
}

//踢出
- (void)kickOutWithSocietyMemberCell:(SocietyMemberCell *)cell
{
    FWWeakify(self)
    [FanweMessage alert:@"提示" message:@"是否踢出该成员" destructiveAction:^{
        
        FWStrongify(self)
        
        NSIndexPath * indexPath = [_displayTabel indexPathForCell:cell];
        SocietyMemberModel * model = _userDataArray[indexPath.row];
        NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
        [parmDict setObject:@"society" forKey:@"ctl"];
        [parmDict setObject:@"user_del" forKey:@"act"];
        [parmDict setObject:model.user_id forKey:@"r_user_id"];
        [self.httpManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
            
            if ([responseJson toInt:@"status"]==1)
            {
                [self.userDataArray removeObjectAtIndex:indexPath.row];
                [self.displayTabel deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                self.societyNumber--;
                NSString * societyMemberStr = [NSString stringWithFormat:@"公会成员(%d)",self.societyNumber];
                [self.societyMemberBtn setTitle:societyMemberStr  forState:UIControlStateNormal];
            }
            
        } FailureBlock:^(NSError *error) {
            
        }];
        
    } cancelAction:^{
        
    }];
}

//同意申请
- (void)agreeWithSocietyMemberApplyCell:(SocietyMemberApplyCell *)cell
{
    FWWeakify(self)
    [FanweMessage alert:@"提示" message:@"是否同意该成员加入家族" destructiveAction:^{
        
        FWStrongify(self)
        
        NSIndexPath * indexPath = [_displayTabel indexPathForCell:cell];
        SocietyMemberModel * model = _userDataArray[indexPath.row];
        NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
        [parmDict setObject:@"society" forKey:@"ctl"];
        [parmDict setObject:@"confirm" forKey:@"act"];
        [parmDict setObject:model.user_id forKey:@"r_user_id"];
        [parmDict setObject:@"1" forKey:@"is_agree"];
        [self.httpManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
            
            if ([responseJson toInt:@"status"]==1)
            {
                [self.userDataArray removeObjectAtIndex:indexPath.row];
                [self.displayTabel deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                self.applyNumber--;
                NSString * memberApplyStr = [NSString stringWithFormat:@"成员申请(%d)",self.applyNumber];
                [self.memberApplyBtn setTitle:memberApplyStr forState:UIControlStateNormal];
                self.societyNumber++;
                NSString * societyMemberStr = [NSString stringWithFormat:@"公会成员(%d)",self.societyNumber];
                [self.societyMemberBtn setTitle:societyMemberStr  forState:UIControlStateNormal];
            }
            
        } FailureBlock:^(NSError *error) {
            
        }];
        
    } cancelAction:^{
        
    }];
}

//拒绝申请
- (void)refuseWithSocietyMemberApplyCell:(SocietyMemberApplyCell *)cell
{
    FWWeakify(self)
    [FanweMessage alert:@"提示" message:@"是否拒绝该成员加入公会" destructiveAction:^{
        
        FWStrongify(self)
        
        NSIndexPath * indexPath = [_displayTabel indexPathForCell:cell];
        SenderModel * model = _userDataArray[indexPath.row];
        NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
        [parmDict setObject:@"society" forKey:@"ctl"];
        [parmDict setObject:@"confirm" forKey:@"act"];
        [parmDict setObject:model.user_id forKey:@"r_user_id"];
        [parmDict setObject:@"2" forKey:@"is_agree"];
        [self.httpManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
            
            if ([responseJson toInt:@"status"]==1)
            {
                [self.userDataArray removeObjectAtIndex:indexPath.row];
                [self.displayTabel deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                self.applyNumber--;
                NSString * memberApplyStr = [NSString stringWithFormat:@"成员申请(%d)",self.applyNumber];
                [self.memberApplyBtn setTitle:memberApplyStr forState:UIControlStateNormal];
            }
            
        } FailureBlock:^(NSError *error) {
            
        }];
        
    } cancelAction:^{
        
    }];
}

//同意退出申请
- (void)agreeQuitWithSocietyLeaveApplyCell:(SocietyLeaveApplyCell *)cell
{
    FWWeakify(self)
    [FanweMessage alert:@"提示" message:@"是否同意该成员退出公会" destructiveAction:^{
        
        FWStrongify(self)
        
        NSIndexPath * indexPath = [_displayTabel indexPathForCell:cell];
        SocietyMemberModel * model = _userDataArray[indexPath.row];
        NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
        [parmDict setObject:@"society" forKey:@"ctl"];
        [parmDict setObject:@"logout_confirm" forKey:@"act"];
        [parmDict setObject:model.user_id forKey:@"r_user_id"];
        [parmDict setObject:@"1" forKey:@"is_agree"];
        [self.httpManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
            
            if ([responseJson toInt:@"status"]==1)
            {
                [self.userDataArray removeObjectAtIndex:indexPath.row];
                [self.displayTabel deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                self.quitApplyNumber--;
                NSString * quitApplyStr = [NSString stringWithFormat:@"退出申请(%d)",self.quitApplyNumber];
                [self.leaveApplyBtn setTitle:quitApplyStr forState:UIControlStateNormal];
                self.societyNumber--;
                NSString * societyMemberStr = [NSString stringWithFormat:@"公会成员(%d)",self.societyNumber];
                [self.societyMemberBtn setTitle:societyMemberStr  forState:UIControlStateNormal];
            }
            
        } FailureBlock:^(NSError *error) {
            
        }];
        
    } cancelAction:^{
        
    }];
}

//拒绝退出申请
- (void)refuseQuitWithSocietyLeaveApplyCell:(SocietyLeaveApplyCell *)cell
{
    FWWeakify(self)
    [FanweMessage alert:@"提示" message:@"是否拒绝该成员退出公会" destructiveAction:^{
        
        FWStrongify(self)
        
        NSIndexPath * indexPath = [_displayTabel indexPathForCell:cell];
        SenderModel * model = _userDataArray[indexPath.row];
        NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
        [parmDict setObject:@"society" forKey:@"ctl"];
        [parmDict setObject:@"logout_confirm" forKey:@"act"];
        [parmDict setObject:model.user_id forKey:@"r_user_id"];
        [parmDict setObject:@"2" forKey:@"is_agree"];
        [self.httpManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
            
            if ([responseJson toInt:@"status"]==1)
            {
                [self.userDataArray removeObjectAtIndex:indexPath.row];
                [self.displayTabel deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                self.quitApplyNumber--;
                NSString * quitApplyStr = [NSString stringWithFormat:@"退出申请(%d)",self.quitApplyNumber];
                [self.leaveApplyBtn setTitle:quitApplyStr forState:UIControlStateNormal];
            }
            
        } FailureBlock:^(NSError *error) {
            
        }];
        
    } cancelAction:^{
        
    }];
}

@end
