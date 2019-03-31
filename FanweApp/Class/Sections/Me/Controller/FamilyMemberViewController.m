//
//  FamilyMemberViewController.m
//  FanweApp
//
//  Created by 王珂 on 16/9/24.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "FamilyMemberViewController.h"
#import "FamilyListCell.h"
#import "SenderModel.h"
#import "SHomePageVC.h"
#import "MemberApplyCell.h"
#import "FamilyMemberModel.h"

@interface FamilyMemberViewController ()<UITableViewDelegate,UITableViewDataSource,FamilyListCellDelegate,MemberApplyCellDelegate>

@property (nonatomic, strong) UIButton * familyMemberBtn;//家族成员
@property (nonatomic, strong) UIButton * memberApplyBtn;//成员申请
@property (nonatomic, strong) UIView * displayView;
@property (nonatomic, strong) UIView * slideLineView;
@property (nonatomic, strong) NSMutableArray *userDataArray;
@property (nonatomic, strong) UITableView *displayTabel;
@property (nonatomic, assign) int has_next;
@property (nonatomic, assign) int currentPage;;
@property (nonatomic, assign) int state;;
@property (nonatomic, copy) NSString *searchType;
@property (nonatomic, assign) int familyNumber;
@property (nonatomic, assign) int applyNumber;

@end

@implementation FamilyMemberViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title= @"成员列表";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(comeBack) image:@"com_arrow_vc_back" highImage:@"com_arrow_vc_back"];
    self.searchType = @"1";
    self.view.backgroundColor = kBackGroundColor;
    _userDataArray = [NSMutableArray array];
    _currentPage = 1;
    [self creatTabelView];
}

#pragma mark 家族成员button和成员申请button
- (void)selectButton
{
    _displayView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 40)];
    [self.view addSubview:_displayView];
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 39, kScreenW, 1)];
    lineView.backgroundColor = myTextColorLine5;
    [_displayView addSubview:lineView];
    //家族成员
    _familyMemberBtn= [[UIButton alloc]initWithFrame:CGRectMake(0,0, kScreenW/2, 38)];
    [_familyMemberBtn setTitleColor:kAppMainColor forState:UIControlStateNormal];
    [_familyMemberBtn addTarget:self action:@selector(familyMemberBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    //    NSString * familyMemberStr = [NSString stringWithFormat:@"家族成员(%d)",125];
    //    [_familyMemberBtn setTitle:familyMemberStr  forState:UIControlStateNormal];
    _familyMemberBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_displayView addSubview:_familyMemberBtn];
    //滑动的滚动条
    _slideLineView = [[UIView alloc]init];
    _slideLineView.backgroundColor = kAppMainColor;
    _slideLineView.frame =CGRectMake(0, 38, kScreenW/2, 2);
    [_displayView addSubview:_slideLineView];
    //成员申请
    _memberApplyBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenW/2,0, kScreenW/2, 39)];
    [_memberApplyBtn addTarget:self action:@selector(memberApplyBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_memberApplyBtn setTitleColor:kAppGrayColor2 forState:UIControlStateNormal];
    _memberApplyBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    //    NSString * memberApplyStr = [NSString stringWithFormat:@"成员申请(%d)",21];
    //    [_memberApplyBtn setTitle:@"成员申请(?人)" forState:UIControlStateNormal];
    [_displayView addSubview:_memberApplyBtn];
}

#pragma mark 点击家族成员或成员申请的执行
- (void)familyMemberBtnAction:(UIButton *)sender
{
    self.searchType = @"1";
    [sender setTitleColor:kAppMainColor forState:UIControlStateNormal];
    [_memberApplyBtn setTitleColor:kAppGrayColor2 forState:UIControlStateNormal];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.1];
    _slideLineView.frame =CGRectMake(0, 38, kScreenW/2, 2);
    [UIView commitAnimations];
    [self headerReresh];
}
- (void)memberApplyBtnAction:(UIButton *)sender
{
    self.searchType = @"2";
    [sender setTitleColor:kAppMainColor forState:UIControlStateNormal];
    [_familyMemberBtn setTitleColor:kAppGrayColor2 forState:UIControlStateNormal];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.1];
    _slideLineView.frame =CGRectMake(kScreenW/2, 38, kScreenW/2, 2);
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
    if (self.isFamilyHeder == 1) {
        [self selectButton];
        _displayTabel.frame = CGRectMake(0,40,kScreenW, kScreenH-104);
    }
    else if (self.isFamilyHeder == 0)
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
    [parmDict setObject:self.jid forKey:@"family_id"];
    if ([_searchType isEqualToString:@"1"])//1代表家族成员
    {
        [parmDict setObject:@"family_user" forKey:@"ctl"];
        [parmDict setObject:@"user_list" forKey:@"act"];
    }else if ([_searchType isEqualToString:@"2"])//代表成员申请
    {
        [parmDict setObject:@"family_user" forKey:@"ctl"];
        [parmDict setObject:@"r_user_list" forKey:@"act"];
    }
    [parmDict setObject:[NSString stringWithFormat:@"%d",page] forKey:@"page"];
    [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
        
        _state = [responseJson toInt:@"status"];
        [responseJson objectForKey:@"rs_count"];
        if (_state == 1)
        {
            //如果是家族族长并且选中的是家族成员
            if (_isFamilyHeder == 1&& [_searchType isEqualToString:@"1"]) {
                NSString * familyMemberStr = [NSString stringWithFormat:@"家族成员(%@)",[responseJson objectForKey:@"rs_count"]];
                _familyNumber = [responseJson toInt:@"rs_count"];
                [_familyMemberBtn setTitle:familyMemberStr  forState:UIControlStateNormal];
                NSString * memberApplyStr = [NSString stringWithFormat:@"成员申请(%@)",[responseJson objectForKey:@"apply_count"]];
                _applyNumber = [responseJson toInt:@"apply_count"];
                [_memberApplyBtn setTitle:memberApplyStr forState:UIControlStateNormal];
            }
            //如果是家族族长并且选中的是成员申请
            else if (_isFamilyHeder == 1&& [_searchType isEqualToString:@"2"])
            {
                NSString * familyMemberStr = [NSString stringWithFormat:@"家族成员(%@)",[responseJson objectForKey:@"rs_count"]];
                _familyNumber = [responseJson toInt:@"rs_count"];
                [_familyMemberBtn setTitle:familyMemberStr  forState:UIControlStateNormal];
                NSString * memberApplyStr = [NSString stringWithFormat:@"成员申请(%@)",[responseJson objectForKey:@"apply_count"]];
                _applyNumber = [responseJson toInt:@"apply_count"];
                [_memberApplyBtn setTitle:memberApplyStr forState:UIControlStateNormal];
            }
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
                    SenderModel *sModel = [SenderModel mj_objectWithKeyValues:dict];
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
        FamilyListCell * cell = [FamilyListCell cellWithTableView:tableView];
        SenderModel *model = _userDataArray[indexPath.row];
        cell.isFamilyHeader = _isFamilyHeder;
        [cell creatCellWithModel:model WithRow:(int)indexPath.row];
        CGRect rect = cell.lineView.frame;
        rect.origin.x = 10;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.lineView.frame = rect;
        //        cell.isFamilyHeader = _isFamilyHeder;
        cell.delegate = self;
        return cell;
        
    }else
    {
        MemberApplyCell *cell = [MemberApplyCell cellWithTableView:tableView];
        SenderModel *model = _userDataArray[indexPath.row];
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
        SenderModel *sModel = _userDataArray[indexPath.row];
        SHomePageVC *homeVC = [[SHomePageVC alloc]init];
        homeVC.user_id = sModel.user_id;
        homeVC.user_nickname =sModel.nick_name;
        homeVC.type = 0;
        [self.navigationController pushViewController:homeVC animated:YES];
    }
    
}

//踢出家族
- (void)kickOutWithFamilyListCell:(FamilyListCell *)cell
{
    FWWeakify(self)
    [FanweMessage alert:nil message:@"是否踢出该成员" destructiveAction:^{
        
        FWStrongify(self)
        
        NSIndexPath * indexPath = [_displayTabel indexPathForCell:cell];
        SenderModel * model = _userDataArray[indexPath.row];
        NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
        [parmDict setObject:@"family_user" forKey:@"ctl"];
        [parmDict setObject:@"user_del" forKey:@"act"];
        [parmDict setObject:model.user_id forKey:@"r_user_id"];
        [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
            
            if ([responseJson toInt:@"status"]==1)
            {
                [self.userDataArray removeObjectAtIndex:indexPath.row];
                [self.displayTabel deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                self.familyNumber--;
                NSString * familyMemberStr = [NSString stringWithFormat:@"家族成员(%d)",self.familyNumber];
                [self.familyMemberBtn setTitle:familyMemberStr  forState:UIControlStateNormal];
            }
            
        } FailureBlock:^(NSError *error) {
            
        }];
        
    } cancelAction:^{
        
    }];
}

//同意申请
- (void)agreeWithMemberApplyCell:(MemberApplyCell *)cell
{
    FWWeakify(self)
    [FanweMessage alert:nil message:@"是否同意该成员加入家族" destructiveAction:^{
        
        FWStrongify(self)
        
        NSIndexPath * indexPath = [_displayTabel indexPathForCell:cell];
        SenderModel * model = _userDataArray[indexPath.row];
        NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
        [parmDict setObject:@"family_user" forKey:@"ctl"];
        [parmDict setObject:@"confirm" forKey:@"act"];
        [parmDict setObject:model.user_id forKey:@"r_user_id"];
        [parmDict setObject:@"1" forKey:@"is_agree"];
        [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
            
            if ([responseJson toInt:@"status"]==1)
            {
                [self.userDataArray removeObjectAtIndex:indexPath.row];
                [self.displayTabel deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                self.applyNumber--;
                NSString * memberApplyStr = [NSString stringWithFormat:@"成员申请(%d)",self.applyNumber];
                [self.memberApplyBtn setTitle:memberApplyStr forState:UIControlStateNormal];
                self.familyNumber++;
                NSString * familyMemberStr = [NSString stringWithFormat:@"家族成员(%d)",self.familyNumber];
                [self.familyMemberBtn setTitle:familyMemberStr  forState:UIControlStateNormal];
            }
            
        } FailureBlock:^(NSError *error) {
            
        }];
        
    } cancelAction:^{
        
    }];
}

//拒绝申请
- (void)refuseWithMemberApplyCell:(MemberApplyCell *)cell
{
    FWWeakify(self)
    [FanweMessage alert:nil message:@"是否拒绝该成员加入家族" destructiveAction:^{
        
        FWStrongify(self)
        
        NSIndexPath * indexPath = [_displayTabel indexPathForCell:cell];
        SenderModel * model = _userDataArray[indexPath.row];
        NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
        [parmDict setObject:@"family_user" forKey:@"ctl"];
        [parmDict setObject:@"confirm" forKey:@"act"];
        [parmDict setObject:model.user_id forKey:@"r_user_id"];
        [parmDict setObject:@"2" forKey:@"is_agree"];
        [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
            
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

@end
